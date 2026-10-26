# Getting started with Revcenter

> This file is written for your coding agent. Point it here (paste the link or the file) and ask it
> to set Revcenter up: it can install, sign in and connect everything by following these steps. You
> only click **Authorize** once in your browser.

## For Claude Code

```
/plugin marketplace add revcenter/agent-plugins
/plugin install revcenter@revcenter-plugins
```

Then follow **Setup** below (the plugin's `setup` skill has the same steps).

## For Codex

```
codex plugin marketplace add revcenter/agent-plugins
```

Open **Plugins**, install **revcenter**, then follow **Setup** below.

## For Cursor and any other agent

Follow **Setup** below; step 4 connects the MCP server to every AI tool on the machine.

## Setup

1. **Check.** `revcenter --version` should print 0.6.0 or later, and `revcenter auth status` should
   succeed. If both do, skip to step 5.

2. **Install or update** (Node.js 20+, no sudo):

   ```bash
   curl -fsSL https://revcenter.ai/install.sh | REVCENTER_NO_LOGIN=1 sh
   ```

   If it says it changed PATH, use the full path it printed for the rest of the session.

3. **Sign in.** The key is created in the user's browser and saved on this machine; it never
   appears in the chat. Run:

   ```bash
   revcenter auth login --start
   ```

   Give the user the `approve_at` link and `code` from the output. They open it, pick a workspace
   and click **Authorize**. Then run:

   ```bash
   revcenter auth login --finish
   ```

4. **Connect the agent:**

   ```bash
   revcenter setup
   ```

   Adds the Revcenter MCP server to Claude Code, Codex, Gemini CLI, Cursor and Claude Desktop,
   whichever are installed. Restart the agent if one was newly added.

5. **Confirm.** Run `revcenter whoami --pretty` and `revcenter usage`, and tell the user their
   workspace and credits. Then ask what role they'd like to fill.

## Working rules

- A new search or an expansion reserves up to its cap in credits (by default the workspace's most per search; unused credits
  come back): show the criteria and the cap and get a yes first. Everything else is free.
- Several roles: one sub-agent per role, in parallel. There is no limit beyond credits.
- Exports land in `./revcenter-exports/` as CSVs with full profiles.
- Out of credits: `revcenter topup` opens checkout.
- Never print or ask for an API key in the chat.

Docs: https://docs.revcenter.ai · Index for agents: https://docs.revcenter.ai/llms.txt
