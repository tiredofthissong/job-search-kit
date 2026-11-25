# job-search-kit

A beginner-friendly job search kit for Claude Duet, aimed at customer service, remote support and entry-level help desk roles. Seven small Claude skills that coach one question at a time: Claude drafts, the job seeker clicks.

**New here? Read [INSTALL.md](INSTALL.md), then [START-HERE.md](START-HERE.md).**

## What's inside
| Skill | What it does |
|---|---|
| job-onboarding | A friendly interview that builds a Career Profile with real wins and numbers |
| resume-builder | One-column, hiring-software-safe master resume (.docx + plain text) |
| linkedin-writer | Headline, About, experience and skills, one section at a time, to paste in |
| job-scam-check | Green / Yellow / Red check on postings, recruiter messages and offers |
| job-tailor | Tailored resume and short cover letter for one posting, plus apply steps |
| interview-coach | Mock interviews, angry-customer and help desk role-plays, test and AI-screen prep |
| job-tracking | Application tracker, follow-up and thank-you drafts |

## Principles
- Never invent experience or numbers.
- Claude never applies, posts, edits LinkedIn or sends messages; it drafts and the person clicks.
- No personal data in this repo. Each person's resume, Career Profile and tracker live in their own Google Drive or computer.
- Sources are cited inside each skill's `references/` files.

## For maintainers
- Edit shared rules in `shared/coach-rules.md` only; `scripts/build-zips.sh` copies them into each skill and rebuilds `dist/`.
- `scripts/check.sh` runs the same checks as CI: skill names match folders, descriptions under 200 characters, no secrets, no emails or phone numbers.
- Run: `bash scripts/build-zips.sh && bash scripts/check.sh`

License: MIT. See [CREDITS.md](CREDITS.md).
