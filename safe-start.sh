#!/bin/bash

# Function to be executed upon receiving SIGINT
cleanup() {
    echo "Caught SIGINT. Cleaning up..."

    echo "$server_pid1"
    echo "Shutting down Private-GPT processes:"
    echo $(pgrep -P $server_pid1)
    kill $(pgrep -P $server_pid1)

    echo "$server_pid2"
    echo "Shutting down FastAPI processes:"
    echo $(pgrep -P $server_pid2)
    kill $(pgrep -P $server_pid2)

    echo "$server_pid3"
    echo "Shutting down vite:"
    kill $server_pid3
    echo $(pgrep -P $server_pid3)

    exit
}

# Set up the trap
trap cleanup SIGINT

# Initialize environment
conda activate Private-GPT
pip install pymupdf4llm

# Start PGPT in the background
PRIVATEGPTDIR=./private-gpt
if [ -d "$PRIVATEGPTDIR" ];
then
    echo "$PRIVATEGPTDIR directory exists."
    cd private-gpt && make run &
    server_pid1=$!  # Get the process ID of the last backgrounded command
else
	echo "$PRIVATEGPTDIR directory does not exist."
fi


# Start the router in the background
PROXYSERVERDIR=./chatbot-proxy-server
if [ -d "$PROXYSERVERDIR" ];
then
    echo "$PROXYSERVERDIR directory exists."
    cd chatbot-proxy-server && fastapi dev main.py &
    server_pid2=$!  # Get the process ID of the last backgrounded command
else
	echo "$PROXYSERVERDIR directory does not exist."
fi


# Start the npm server in the background
CHATBOTDIR=./my-ai-chatbot-frontend
if [ -d "$CHATBOTDIR" ];
then
    echo "$CHATBOTDIR directory exists."
    cd my-ai-chatbot-frontend && npm run dev &
    server_pid3=$!  # Get the process ID of the last backgrounded command
else
	echo "$CHATBOTDIR directory does not exist."
fi

conda deactivate

# Wait indefinitely. The cleanup function will handle interruption and cleanup.
wait
