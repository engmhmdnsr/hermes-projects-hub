# hermes-projects-hub

One picker page for all your projects. Each card opens a ready Hermes
session (a chat that already has the project context). No copy-paste of
paths, no "which folder was that again".

## Layout

- `SKILL.md` : the agent skill (give it to your agent)
- `picker.html` : the picker page template (static, English, dark)
- `templates/AGENTS.md` : per-project context file template
- `templates/00-RULES.md` : standing-rule template
- `windows/session-launcher.vbs` : windowless protocol handler
- `windows/register-protocol.ps1` : registers your URL scheme once

## Workflow

1. Copy `picker.html`, add one card per project (path in the `code` element).
2. Run `windows/register-protocol.ps1` once.
3. Put an `AGENTS.md` (from template) in each project folder.
4. In Hermes Desktop, create one Project per folder.
5. Card buttons: **Terminal session** opens a ready terminal chat now,
   **Desktop app** focuses Hermes Desktop where you pick the Project.

## Rules (do not break)

1. Ask the user before adding any NEW project to the picker.
2. Never register `hermes://` yourself, it belongs to Hermes Desktop.
   Use your own scheme (default `mysessions`).
3. Public-safe only: no credentials, tokens, IPs, or personal paths
   in this repo. Placeholders everywhere.
