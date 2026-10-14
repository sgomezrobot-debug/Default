# Matt Pocock's skills, on every Claude surface

The 27 skills from [mattpocock/skills](https://github.com/mattpocock/skills) (the set its official plugin ships), packaged for each place Claude runs. The upstream commit is recorded in `.claude/skills/UPSTREAM_COMMIT`. MIT licensed; see `.claude/skills/LICENSE-mattpocock-skills`.

| Surface | How it gets the skills | What you need to do |
|---|---|---|
| Claude Code in this repo (CLI, desktop, web/cloud, VS Code, JetBrains) | `.claude/skills/` | Nothing. They load when you open this repo. |
| Claude Code in every repo | Official plugin | `claude plugin install mattpocock-skills@claude-plugins-official` |
| claude.ai, Claude Desktop, Claude mobile | `dist/claude-ai/*.zip` | Upload once (see below). They sync to your account. |
| Claude API / Agent SDK | Skills API | `ANTHROPIC_API_KEY=... scripts/upload-skills-to-api.sh` |

## claude.ai, Desktop and mobile

1. Turn on **Settings → Capabilities → Code execution and file creation**.
2. Go to **Settings → Capabilities → Skills → Upload skill** and upload each zip from `dist/claude-ai/`.
   The skills are tied to your account, so once uploaded they show up on web, desktop and mobile.

On a Team or Enterprise plan, an owner can upload them under **Admin settings → Skills** to give them to the whole org.

## Notes

- **If you install the plugin globally, you get every skill twice in this repo.** Delete `.claude/skills/` if you use the plugin.
- `code-review` has the same name as Claude Code's built-in `/code-review`.
- After installing, run `/setup-matt-pocock-skills` once per repo. It sets up your issue tracker, triage labels and docs location.

## Updating

```bash
scripts/sync-skills.sh          # pull upstream main, rebuild .claude/skills and the zips
```

Then commit, re-upload any changed zips to claude.ai, and re-run the API script. The API script creates new skills each time it runs. To update a skill that is already uploaded, add a version to it instead.
