#!/bin/bash

# Install python uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install datadog mcp cli
curl -sSL https://coterm.datadoghq.com/mcp-cli/install.sh | bash
chmod 755 ~/.local/bin/datadog_mcp_cli

datadog_mcp_cli login