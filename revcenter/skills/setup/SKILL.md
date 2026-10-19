---
name: setup
description: Revcenter setup — install the revcenter CLI, sign in, and connect Revcenter to this agent. Use when revcenter is not on PATH or too old, when a call fails with missing_api_key or invalid_api_key, when the session note says setup is required, or when the user asks to set Revcenter up.
allowed-tools: Bash, Read
---

# Revcenter setup

Install the CLI, sign the user in through their browser, connect this agent, and check it worked.
Every step can be run by you; only the sign-in needs the user to click once.

`<PLUGIN_ROOT>` is two levels above this skill's directory. Without the plugin (setup from a
pasted link), skip `<PLUGIN_ROOT>` and use the commands in brackets.

## 1. Check

```bash
bash "<PLUGIN_ROOT>/scripts/check-cli.sh" plain     # [revcenter --version; revcenter auth status]
```

Nothing printed means installed, recent enough and signed in: go to step 4.

## 2. Install or update

```bash
bash "<PLUGIN_ROOT>/scripts/install-cli.sh"          # [curl -fsSL https://revcenter.ai/install.sh | REVCENTER_NO_LOGIN=1 sh]
```

It needs Node.js 20 or later and never uses sudo. If it says the PATH changed, use the full path it
printed (for example `~/.revcenter/bin/revcenter`) for the rest of this session.

## 3. Sign in

The sign-in happens in the user's browser; the key comes back to this machine and is never shown.
Your shell only shows output when a command ends, so sign in in two steps:

```bash
revcenter auth login --start
```

Show the user the `approve_at` link and the `code` from its output, and ask them to open the link,
pick a workspace and click **Authorize**. When they say they have, run:

```bash
revcenter auth login --finish
```

It waits until they authorize (up to 10 minutes) and saves the key. If it ends with
`access_denied`, they clicked Deny: ask before trying again.

On a machine where the user can't open a browser link (a server), they can instead create a key in
Revcenter under **Settings → Usage → API** and set it as `REVCENTER_API_KEY` in the agent's
environment. Never ask them to paste a key into the chat.

## 4. Connect this agent (MCP)

```bash
revcenter setup
```

This adds the Revcenter MCP server to every AI tool it finds here (Claude Code, Codex, Gemini CLI,
Cursor, Claude Desktop), using the saved key. If this plugin is already installed in Claude Code,
its MCP server is already connected and this step only adds the others. Tell the user to restart
their agent if a tool was newly added.

## 5. Check it works

```bash
revcenter whoami --pretty
revcenter usage
```

Tell the user which workspace they're connected to and how many credits it has (about 1,000 per standard search). Then
offer to start: "Tell me a role and a location and I'll draft a search."
