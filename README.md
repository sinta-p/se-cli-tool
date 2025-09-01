# Gemini CLI + MCP Server Guide

This guide is intended for Datadog Sales Engineers to set up and use Gemini CLI (or other agent CLI) with MCP Servers, including Datadog MCP, Google Workspace MCP, and Atlassian MCP. It covers installation, configuration, troubleshooting, and practical workflows for sales engineering.

## Quick Start

1. Clone this git repo
    ```bash
    git clone https://github.com/nuttea/se-ai-agent-mcp-examples.git
    ```
2. Run ```setup.sh```
    ```bash
    ./setup.sh
    ```
3. Update ```.env``` file
   ex. copy pre-filled from [this page](https://datadoghq.atlassian.net/wiki/x/L4JiRAE)
4. Run ```gemini``` or start Copilot in VSCode with Agent mode
    ```bash
    gemini
    ```
5. Test with example SE Activities Summary prompt
    ```bash
    GWS_EMAIL="<YOUR-GWS-EMAIL>"
    gemini --yolo -i "$(cat <<EOF
    You are my Sales Engineer assistant. My google workspace email is ${GWS_EMAIL}.
    Help me write a summary of my current week sales engineer activities, includings Discovery Calls, Demo Sessions, POV support session, etc.

    Make it concise and use data from workspace-mcp MCP Server, includings Google Calendar, Google Drive Activities, and other data that you see fits.

    Group summary by Customer Name and sort by date.

    Additional rules:
    - searching for all of my calendar events
    - includes Google Drive Files with my recent access or activities in the time periods
    EOF
    )"
    ```

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

### TLDR;

- Run ```./setup.sh``` to install gemini cli, datadog mcp cli, uvx, npx
- Run a command to create ```.env``` file from [this page](https://datadoghq.atlassian.net/wiki/x/L4JiRAE)
- Run ```gemini```
  ```bash
  gemini
  ```

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

- **Datadog MCP**:
  From "Remote Datadog MCP Server Preview", there is Remote Datadog MCP Server Available. Example remote MCP Server:
  ```json
  ```

- **Google Workspace MCP**: Authenticate with Google Workspace and grant necessary permissions.
  Google Workspace MCP Server from https://github.com/taylorwilsdon/google_workspace_mcp
  This MCP support OAuth 2.1 for multi-users. I've setup Google OAuth credentials in datadog GCP project, you can find it [here](https://datadoghq.atlassian.net/wiki/spaces/~712020036112df689a4cd7808db39dca576b4c/pages/5442273839/AI+Agent+MCP+Servers#Credentials)

  Pre-requisites:
  - python3
  - Get [Google OAuth credentials](https://datadoghq.atlassian.net/wiki/spaces/~712020036112df689a4cd7808db39dca576b4c/pages/5442273839/AI+Agent+MCP+Servers#Credentials), and save to .env file (GOOGLE_OAUTH_CLIENT_ID and GOOGLE_OAUTH_CLIENT_SECRET)
  - install uv and uvx to run mcp server (auto-run from settings.json mcp config file, mcp type = command). https://docs.astral.sh/uv/getting-started/installation/
    ```bash
    curl -LsSf https://astral.sh/uv/install.sh | sh
    ```

    Test quick-start with uvx
    ```bash
    uvx workspace-mcp
    ```

- **Atlassian MCP**: Connect to Jira/Confluence with API tokens or OAuth.
  Atlassian MCP setup guide: https://support.atlassian.com/rovo/docs/getting-started-with-the-atlassian-remote-mcp-server/


For reference, `.gemini/settings.json` is provided as an example configuration file for MCP servers. You can use it to specify server endpoints, authentication details, and integration options for Datadog, Google Workspace, and Atlassian MCP.

### 4. Run GEMINI CLI

You can just run ```gemini```, Gemini CLI automatic load .env, .gemini/settings.json, and GEMINI.md file for setting and credentials.

```bash
gemini
```

References:
- https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/configuration.md#available-settings-in-settingsjson

## Troubleshooting Common Setup Issues

- **API Key Errors**: Double-check that your API keys are correct and have the necessary permissions.
- **Network Issues**: Ensure your machine can reach MCP server endpoints (check VPN/firewall settings).
- **Authentication Problems**: Re-authenticate if tokens expire or permissions change.
- **CLI Errors**: Run with verbose/debug flags to get more detailed error messages.
- **Integration Failures**: Confirm that MCP servers are running and accessible.

## Example Workflows for Sales Engineers

### SE Activities Summary

```bash
export USER_GOOGLE_EMAIL="<YOUR-GWS-EMAIL>"
export FILE_1="$(cat templates/se_activities_report.md)"

gemini --yolo -i "$(cat <<EOF
Generate a sales engineer activity report for me for the current full week from Monday to Friday.

INSTRUCTIONS:
- Include all customer-facing events from my Google Calendar, Google Tasks, such as Discovery Calls, Demos, and POC sessions. If you see any calendar events with Company Name, consider as engagement activities.
- Try to derive my activities from my recent access to Google Drive Files or recent modified files during this period. 
- Write the reports with human readable and easy to understand format. You may focus on what happened?, what already done, pending tasks that need to do, or any risks to be raised to internal team.
- The report should be grouped by customer name, with activities sorted chronologically.
- Don't use GoogleSearch.
- Save the report as a markdown file in the temp directory. file naming could be <first_name>_<week_dates>_activities_report.md

<REPORT_EXAMPLE>
${FILE_1}
</REPORT_EXAMPLE>
EOF
)"
```

### Customer Onboarding

Ex1. customer implement DBM for SQL Server, and would like to have suggestion for Monitoring setup

```bash
gemini --yolo -i "$(cat <<EOF
Help me research and find recommends Monitor setup for Datadog DBM for SQL Server.

You can use data source for research from atlassian-mcp, datadog-mcp ask_docs, or GoogleSearch Tool.
EOF
)"
```

Ex2. General Datadog feature questions

```bash
gemini --yolo -i "$(cat <<EOF
with Datadog LLM Observability, I have my custom allm model typhoon-2, how can I define my model tokens price?
EOF
)"
```

### RFP Verification

1. Work on RFP requirements.
2. Use Datadog MCP `ask_docs` to verify answers and generate reference links.
3. Compile responses and supporting documentation for submission.

Example scenario, Customer shared RFP for Infra and Web App Monitoring project in google sheet https://docs.google.com/spreadsheets/d/13MY894dwjBECiVM4P_8bgP4U5YdTo3NBXc_EybFcrVY/edit?usp=sharing

```bash
export GWS_EMAIL="<YOUR-GWS-EMAIL>"
export SHEET_ID="13MY894dwjBECiVM4P_8bgP4U5YdTo3NBXc_EybFcrVY"

gemini --yolo -i "$(cat <<EOF
My google workspace email is ${GWS_EMAIL}.

You are a Sales Engineer expert. Help me read a RFP from google sheet id ${SHEET_ID}.

You will be tasked for:
- Analyse all RFP requirements and use Datadog MCP Server ask_docs to help building answers comply statement for Datadog Solutions and Product. Also provide source reference in columns "Comply Statement" and "Reference / Grounding Source".
- After finish building the answers, you must do fact-check and verdict to make sure all statements are correct and be true for Datadog Solutions. You can use Google Search or Grounding with Google Search to help with this task, and pus results in "Fact-Check and Verdict" column.

EOF
)"
```

### Customer Onboarding

1. Receive customer requirements (PDF, screencapture, or document).
2. Use Gemini CLI to extract and summarize requirements.
3. Draft POV Success Criteria documents and save to Google Sheets via Google Workspace MCP.

### Demo Scenarios

1. Discover customer environment (system, OS, app framework, database version).
2. Use Gemini CLI with Datadog MCP to generate installation steps and commands for each component.
3. Present automated documentation to the customer.

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



https://github.com/taylorwilsdon/google_workspace_mcp
https://workspacemcp.com/


https://support.atlassian.com/rovo/docs/getting-started-with-the-atlassian-remote-mcp-server/
