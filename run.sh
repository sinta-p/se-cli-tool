#!/bin/bash

# Script to check access token validity and export as AUTH_TOKEN
# Usage: source ./check_token.sh

# Source .env file if it exists
if [ -f ".env" ]; then
    echo "Loading environment variables from .env file..."
    source .env
else
    echo "No .env file found, continuing without it..."
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Run gemini command
echo -e "${GREEN}Running gemini command...${NC}"
gemini
