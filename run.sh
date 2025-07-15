#!/usr/bin/env bash

set -euo pipefail

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "uv is not installed. Please install it first."
    exit 1
fi

# Check if the OPENROUTER_API_KEY environment variable is set
if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "OPENROUTER_API_KEY is not set. Please set it before running this script."
    exit 1
fi


uv run oai2ollama --api-key "$OPENROUTER_API_KEY" --base-url https://openrouter.ai/api/v1 &
OAI2OLLAMA_PID=$!
echo "Started oai2ollama with PID $OAI2OLLAMA_PID"

# Forward signals and cleanup
cleanup() {
    echo "\nStopping background processes..."
    kill $OAI2OLLAMA_PID 2>/dev/null
    wait $OAI2OLLAMA_PID 2>/dev/null
    exit 0
}
trap cleanup SIGINT SIGTERM

# Wait for both background processes
wait $OAI2OLLAMA_PID