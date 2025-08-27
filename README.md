# Gemini CLI + MCP Server Guide

This guide is intended for Datadog Sales Engineers to set up and use Gemini CLI (or other agent CLI) with MCP Servers, including Datadog MCP, Google Workspace MCP, and Atlassian MCP. It covers installation, configuration, troubleshooting, and practical workflows for sales engineering.

## Overview of Gemini CLI and MCP Architecture

Gemini CLI is a command-line interface that acts as an agent, connecting to Model Context Protocol (MCP) servers. MCP servers serve as bridges to external platforms, enabling automation, document processing, and workflow integration. The architecture allows users to:

- Interact with multiple backend services (Datadog, Google Workspace, Atlassian) from a single CLI.
- Automate repetitive tasks and document workflows.
- Integrate AI-powered document analysis and generation into sales engineering processes.

## Supported MCP Integrations and Their Benefits

- **Datadog MCP**: Automate monitoring, query Datadog documentation, verify RFP answers, and generate reference links.
- **Google Workspace MCP**: Create and update Google Docs, Sheets, and Drive files; automate document workflows and reporting.
- **Atlassian MCP**: Integrate with Jira and Confluence for project management, documentation, and collaboration.

Benefits include:
- Centralized automation for sales engineering tasks.
- Improved accuracy and speed in responding to customer requirements.
- Seamless integration with existing enterprise tools.

## Setup Instructions

### 1. Install Gemini CLI

- Download Gemini CLI from the official repository or package manager.
  Ex. Install globally with Homebrew (macOS/Linux)
  ```bash
  brew install gemini-cli
  ```
- Follow installation instructions for your operating system (Windows, macOS, Linux).
- Verify installation by running `gemini --version`.

### 2. Obtain GEMINI API Key

- Visit [aistudio.google.com](https://aistudio.google.com).
- Sign in with your Google account.
- Navigate to the API Keys section and generate a new key.
- Copy `.env.example` to `.env` and add your API key to the `GEMINI_API_KEY` variable.

### 3. Configure MCP Servers

- **Datadog MCP**: Provide Datadog API credentials and endpoint.
- **Google Workspace MCP**: Authenticate with Google Workspace and grant necessary permissions.
- **Atlassian MCP**: Connect to Jira/Confluence with API tokens or OAuth.

For reference, `.gemini/settings.json` is provided as an example configuration file for MCP servers. You can use it to specify server endpoints, authentication details, and integration options for Datadog, Google Workspace, and Atlassian MCP.

## Troubleshooting Common Setup Issues

- **API Key Errors**: Double-check that your API keys are correct and have the necessary permissions.
- **Network Issues**: Ensure your machine can reach MCP server endpoints (check VPN/firewall settings).
- **Authentication Problems**: Re-authenticate if tokens expire or permissions change.
- **CLI Errors**: Run with verbose/debug flags to get more detailed error messages.
- **Integration Failures**: Confirm that MCP servers are running and accessible.

## Example Workflows for Sales Engineers

### Customer Onboarding

1. Receive customer requirements (PDF, screencapture, or document).
2. Use Gemini CLI to extract and summarize requirements.
3. Draft POV Success Criteria documents and save to Google Sheets via Google Workspace MCP.

### Demo Scenarios

1. Discover customer environment (system, OS, app framework, database version).
2. Use Gemini CLI with Datadog MCP to generate installation steps and commands for each component.
3. Present automated documentation to the customer.

### RFP Verification

1. Work on RFP requirements.
2. Use Datadog MCP `ask_docs` to verify answers and generate reference links.
3. Compile responses and supporting documentation for submission.

## Tips for Customizing Agent Prompts and Automations

- Edit prompt templates to tailor responses for specific customer scenarios.
- Use CLI flags and configuration files to adjust automation behavior (e.g., output format, verbosity).
- Integrate custom scripts or plugins for advanced workflows.
- Schedule automated tasks using system cron or task scheduler.

## FAQ

**Q: Where do I get the Gemini API key?**
A: From [aistudio.google.com](https://aistudio.google.com) under your account’s API Keys section.

**Q: What if the CLI cannot connect to an MCP server?**
A: Check your credentials, network connectivity, and server status. Try re-authenticating or restarting the CLI.

**Q: How do I add a new MCP integration?**
A: Refer to the official documentation for integration steps or contact internal support.

**Q: Can I automate document generation for multiple customers?**
A: Yes, use batch processing features in Gemini CLI and configure MCP integrations for each customer.

## Links to Official Documentation and Support

- [Gemini CLI Documentation](https://github.com/google/gemini-cli)
- [Datadog MCP Docs](https://docs.datadoghq.com)
- [Google Workspace MCP Docs](https://workspace.google.com)
- [Atlassian MCP Docs](https://atlassian.com)
- Internal support: #sales-engineer Slack channel
References:
https://github.com/google-gemini/gemini-cli/blob/main/docs/tos-privacy.md
https://ai.google.dev/gemini-api/docs/rate-limits


Install uv
https://docs.astral.sh/uv/getting-started/installation/#installation-methods

UV venv
https://docs.astral.sh/uv/pip/environments/

notes
sudo chown nuttee.jirattivongvibul /Users/nuttee.jirattivongvibul/.local/share


https://github.com/taylorwilsdon/google_workspace_mcp
https://workspacemcp.com/


https://support.atlassian.com/rovo/docs/getting-started-with-the-atlassian-remote-mcp-server/
