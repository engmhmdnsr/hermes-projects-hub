---
name: hermes-projects-hub
description: Manage a collection of projects with one picker page; each card opens a ready Hermes session.
version: 1.0.0
scope: user
author: Mohamed Nasr
license: MIT
metadata:
  hermes:
    tags: [hermes, projects, picker-page, sessions, windows]
---

# Hermes Projects Hub

## When to Use

The user keeps a standing collection of projects with a single picker page to
choose what to work on. Load this skill when adding or reorganizing projects,
rebuilding the picker page, or wiring one-click access from the page into
ready Hermes sessions.

## Goal

One click takes the user into a session that already has the project context
(`AGENTS.md` auto-loads from the session cwd). Never make the user copy paths
or explain the project twice.

## The shape (all four parts, every time)

1. **Registry** (`00-RULES.md` next to the picker): the standing rule is to
   ask the user before adding any NEW project to the collection.
2. **Picker page** (one static HTML file, see `picker.html`): sections by
   status (Active vs Paused/Archive), one card per project with a status dot,
   a one-line description, the local path in a `code` element, and action
   buttons.
3. **Per-project `AGENTS.md`** (see `templates/AGENTS.md`): what it is, key
   files, deploy/live notes, standing rules. Any session whose cwd is that
   folder loads it automatically, which is what makes a new session "ready".
4. **Desktop Projects**: one desktop Project anchored to each folder
   (`desktop_project create`), so new desktop chats inside it start with
   full context.

## Picker buttons (generated, not hand-written)

Do not hand-write a button per card. One script reads each card's `code`
path and appends the session buttons, so adding a project is card-only:

- **Terminal session**: `<own-scheme>://<forward-slash-path>` opens a ready
  terminal chat in that folder through the windowless protocol handler
  (`windows/`). Pick your own scheme name (e.g. `mysessions`).
- **Desktop app**: `hermes://open/sessions` focuses Hermes Desktop; the user
  picks the matching desktop Project there.

There is NO deep link that creates a desktop session with a given cwd
(verified against the desktop build: supported kinds are
`open/<in-app-route>` and `<plugin-id>/<page>` only), so the two-button
split is the mechanism, not a placeholder.

## Windows protocol handler recipe

- Register `HKCU\Software\Classes\<scheme>` (see
  `windows/register-protocol.ps1`): `(Default)` = display name,
  `URL Protocol` = empty, `shell\open\command` = the launcher.
- **Never register `hermes://` yourself.** It is owned by Hermes Desktop
  (setAsDefaultProtocolClient at startup); hijacking it breaks the app's
  own deep links. Use your own scheme.
- The launcher MUST be windowless: a wscript-run `.vbs`, never a `.bat`
  (a .bat flashes a cmd window and its console becomes the failure surface).
- Parse `WScript.Arguments(0)`: strip the `scheme://` prefix, convert `/`
  to `\`, delete all `"` chars, Trim. Never trust `%~1` alone.
- `sh.CurrentDirectory = dir`, then run the agent CLI chat there.
- Log every invocation (timestamp, raw URL, resolved dir, exists?) to a file
  next to the launcher. Browser-passed arguments differ from manual tests;
  the log is what tells you what actually arrived.
- On a missing dir, show a message box naming the received URL. Never let a
  raw script-host error dialog be the user-facing failure.

## Procedure: add a project

1. Ask the user first (standing rule). On yes: append the card, write the
   project's `AGENTS.md`.
2. Create the desktop Project anchored to the folder.
3. Verify every card path exists on disk (a bad path fails only at click
   time with a confusing OS error).
4. Re-screenshot the page headless and check every card visually before
   calling it done.

## Procedure: rebuild or restyle the page

Keep the copy free of AI fingerprints (no em dashes); sweep with a
full-file grep before delivery. If the editor tool refuses a blind
overwrite of the existing page, write the rebuild to a new file and move
it over the target.

## Pitfalls

- Test with the EXACT browser invocation
  (`wscript.exe launcher.vbs "scheme://D:/path"`), not a hand-cleaned
  equivalent. Manual tests pass while the real call fails on quoting the
  test did not reproduce.
- Build Windows paths in scripts with chr(92) or raw strings. printf/echo
  and non-raw literals silently mangle backslashes.
- Keep this skill public-safe: no credentials, tokens, IPs, or personal
  paths in the repo. Placeholders only.
