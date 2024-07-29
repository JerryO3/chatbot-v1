#!/usr/bin/bash
PRIVATEGPTDIR=./private-gpt
if [ -d "$PRIVATEGPTDIR" ];
then
    echo "$PRIVATEGPTDIR directory exists."
else
	echo "$PRIVATEGPTDIR directory does not exist."
	git clone https://github.com/zylon-ai/private-gpt.git
fi

PROXYSERVERDIR=./chatbot-proxy-server
if [ -d "$PROXYSERVERDIR" ];
then
    echo "$PROXYSERVERDIR directory exists."
else
	echo "$PROXYSERVERDIR directory does not exist."
	git clone https://github.com/JerryO3/chatbot-proxy-server.git
fi

CHATBOTDIR=./my-ai-chatbot-frontend
if [ -d "$CHATBOTDIR" ];
then
    echo "$CHATBOTDIR directory exists."
else
	echo "$CHATBOTDIR directory does not exist."
	git clone https://github.com/JerryO3/my-ai-chatbot-frontend.git
	cd my-ai-chatbot-frontend
	npm install vite
	cd ..
fi


if ! { ollama -v | grep 'ollama version is'; } >/dev/null 2>&1; then
	curl -fsSL https://ollama.com/install.sh | sh
fi

ollama serve &

if ! { ollama list | grep 'mistral'; } >/dev/null 2>&1; then
	echo "Download default model: Mistral"
	ollama pull mistral 
fi

if ! { ollama list | grep 'nomic'; } >/dev/null 2>&1; then
	echo "Download default embedding model: Nomic"
	ollama pull nomic-embed-text
fi

conda activate

if ! { conda env list | grep 'Private-GPT'; } >/dev/null 2>&1; then
	conda create --name Private-GPT python=3.11.9 -y
fi

conda activate Private-GPT
curl -sSL https://install.python-poetry.org | python3 -

cd private-gpt
export PATH="$HOME/.local/bin:$PATH"

pip install -r ../requirements.txt
poetry install --extras "ui llms-ollama embeddings-ollama vector-stores-qdrant"

cd ..
