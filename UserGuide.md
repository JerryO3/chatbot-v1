# User Guide

Read this document to

1. Familiarise yourself with the UI

2. Get and apply suggested configurations beyond the defaults supplied by PrivateGPT

## Using Chatbot-v1

## Editing Configurations

Chatbot-v1 uses 3 different git projects together that may be still under active development at this time of reading. Specifically for Private-GPT, I decided to build the chatbot around pulling the latest version of PrivateGPT. This implies cloning the repo on setup which sets configurations to their defaults, which means that these configurations need to be changed every time you clone the repo.

### Changing the Model

1. Navigate to ``

### Changing the Context Window

1. Navigate to `chatbot-v1/private-gpt/private_gpt/server/ingest/ingest_service.py` 

### Changing the Number of References