# Gemini CLI + MCP Server Guide

This guide is intended for Sales Engineers to set up and use Gemini CLI (or other agent CLI) with MCP Servers, including Datadog MCP, Google Workspace MCP, and Atlassian MCP. It covers installation, configuration, troubleshooting, and practical workflows for sales engineering.

- [Gemini CLI + MCP Server Guide](#gemini-cli--mcp-server-guide)
  - [Quick Start](#quick-start)
  - [Overview of Gemini CLI and MCP Architecture](#overview-of-gemini-cli-and-mcp-architecture)
  - [Supported MCP Integrations and Their Benefits](#supported-mcp-integrations-and-their-benefits)
  - [Setup Instructions](#setup-instructions)
    - [1. Install Gemini CLI](#1-install-gemini-cli)
    - [2. Obtain GEMINI API Key](#2-obtain-gemini-api-key)
    - [3. Configure MCP Servers](#3-configure-mcp-servers)
    - [4. Run GEMINI CLI](#4-run-gemini-cli)
  - [Troubleshooting Common Setup Issues](#troubleshooting-common-setup-issues)
  - [Example Workflows for Sales Engineers](#example-workflows-for-sales-engineers)
    - [SE Activities Summary](#se-activities-summary)
    - [Customer Onboarding](#customer-onboarding)
    - [RFP Verification](#rfp-verification)
    - [Demo Scenarios](#demo-scenarios)
  - [Tips for Customizing Agent Prompts and Automations](#tips-for-customizing-agent-prompts-and-automations)
  - [FAQ](#faq)
  - [References](#references)


## Quick Start

1. Clone this git repo
    ```bash
    git clone https://github.com/sinta-p/se-cli-tool.git
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
  brew link --overwrite gemini-cli
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

  for Gemini CLI (.gemini/settings.json) (use npx mcp-remote connecting to Datadog Remote MCP Server)
  ```json
  {
      "mcpServers": {
          "datadog-mcp": {
              "command": "npx",
                  "args": [
                      "mcp-remote",
                      "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp"
                  ]
          }
      }
  }
  ```

  for Copilot (.vscode/mcp.json)
  ```json
  {
	"servers": {
      "datadog-mcp": {
          "url": "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp",
          "type": "http"
      }
    }
  }
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

1. Receive customer requirements (PDF, screencapture, or document).
2. Use Gemini CLI to extract and summarize requirements.
3. Draft POV Success Criteria documents and save to Google Sheets via Google Workspace MCP.

Ex1. Customer share requirements Diagram Board.

```bash
gemini --yolo -i "$(cat <<EOF
You are the Datadog Sales Engineer expert. Supporting a customer evaluate Datadog products.

Read imgage @assets/example_requirements_image.png which is a diagram from my customer asking for DevSecOps evaluation with Datadog team. Customer's requirements are in BLUE boxes

Your tasks:
1. Read and make understanding and analysis of the requirements 
2. Expand to the requirements and functionality and write out for details features and functionalities required on each item.
3. Use Datadog MCP ask_docs to research for building the answers Datadog Security Products that meet the requirements. Write to details Datadog capability and also provide reference links from ask_docs. 4. Re-check all answers for accuracy, you may use Google Search to help verify and give verdicts.
5. Re-analyze overall information that you have built so far, and give a suggestion for any improvements before we can share this response to the customer.
6. Implement final improvements that you suggest and write the documents out to temp directory in Markdown format. You can suggest the filename.
7. Create a Google Sheet with final output information.

EOF
)"
```

Ex2. customer implement DBM for SQL Server, and would like to have suggestion for Monitoring setup

```bash
gemini --yolo -i "$(cat <<EOF
Help me research and find recommends Monitor setup for Datadog DBM for SQL Server.

You can use data source for research from atlassian-mcp, datadog-mcp ask_docs, or GoogleSearch Tool.
EOF
)"
```

Ex3. General Datadog feature questions

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

## References

Gemini API
https://github.com/google-gemini/gemini-cli/blob/main/docs/tos-privacy.md
https://ai.google.dev/gemini-api/docs/rate-limits


Install uv
https://docs.astral.sh/uv/getting-started/installation/#installation-methods

UV venv
https://docs.astral.sh/uv/pip/environments/

Workspace MCP
https://github.com/taylorwilsdon/google_workspace_mcp
https://workspacemcp.com/

Atlassian MCP
https://support.atlassian.com/rovo/docs/getting-started-with-the-atlassian-remote-mcp-server/
