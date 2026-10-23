# Hermes Projects Hub

One picker page for all your projects. Each card opens a **ready Hermes session**
(a chat that already has the project context), either in the terminal or in
Hermes Desktop. No copy-paste of paths, no "which folder was that again".

## How it works (4 parts)

1. **Picker page** (`picker.html`): one static HTML file, cards grouped by status
   (Active / Paused / Archive). Each card: status dot, one-line description,
   local path, action buttons.
2. **Per-project `AGENTS.md`**: a short context file inside each project folder
   (what it is, key files, deploy notes, rules). Any Hermes session started in
   that folder loads it automatically. This is what makes a session "ready".
3. **Desktop Projects**: one Hermes desktop Project anchored to each folder,
   so new desktop chats inside it start with full context.
4. **Standing rule** (`00-RULES.md`): ask before adding any NEW project to
   the collection, so the picker never rots.

## Session buttons (generated, not hand-written)

The page has one script that reads each card's path and appends two buttons:

- **Terminal session** (`<your-scheme>://<forward-slash-path>`): opens a ready
  terminal chat in that folder via a small windowless protocol handler
  (`windows/session-launcher.vbs` + `windows/register-protocol.ps1`).
  Never use `hermes://` for this: that scheme is owned by Hermes Desktop.
- **Desktop app** (`hermes://open/sessions`): focuses Hermes Desktop on the
  sessions view; you pick the matching desktop Project there. There is no
  deep link that creates a desktop session with a given cwd (verified against
  the desktop build), so the two-button split is the mechanism.

## Use as an agent skill

`SKILL.md` is a Hermes/agent skill: give it to your agent and say
"set up my projects hub" or "add project X to my hub". It contains the full
procedure (add project, rebuild page, handler recipe, pitfalls).

## Layout

```
SKILL.md                  the shareable skill
picker.html               generic picker page template (English, dark)
templates/AGENTS.md       per-project context file template
templates/00-RULES.md     standing-rule template
windows/session-launcher.vbs      windowless protocol handler (terminal sessions)
windows/register-protocol.ps1     registers your own URL scheme on Windows
```

## Setup in short

1. Copy `picker.html` somewhere (e.g. a `projects` folder), add one card per
   project with its local path in the `code` element.
2. Run `windows/register-protocol.ps1` once (edit the scheme name first if
   you like), pointing at `windows/session-launcher.vbs`.
3. Click a card's **Terminal session** button, allow the protocol once, done.
4. In Hermes Desktop, create one Project per folder for the **Desktop app**
   button to land in.

MIT licensed.
