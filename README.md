# Campus Lend & Borrow

A lightweight Rails web app for students to lend, borrow, and coordinate items within their campus community.

## Quick links

- Technical documentation: `docs/techinical_documentation.md`
- User guide: `docs/user_guide.md`
- Testing guide (RSpec & Cucumber): `docs/testing_documentation.md`
- Architecture diagram: `docs/architecture_diagram.md`
- Database (ER) diagram: `docs/db_diagram.md`
- Architecture Records:
	- Index: `docs/architecture_records/README.md`
	- ADR-001 Cloudinary image storage: `docs/architecture_records/adr-001-cloudinary-image-storage.md`
	- ADR-002 Google OAuth: `docs/architecture_records/adr-002-google-oauth.md`
	- ADR-003 Twilio Verify: `docs/architecture_records/adr-003-twilio-verify.md`
	- ADR-004 Image upload service: `docs/architecture_records/adr-004-image-upload-service.md`
- Scrum Events: `docs/scrum events/`
	- Scrum events overview: `docs/scrum events/scrum_events.md`
	- Sprint planning: `docs/scrum events/scrum_planning.md`
	- Sprint review: `docs/scrum events/sprint_review.md`
	- Sprint retrospective: `docs/scrum events/sprint_retrospective.md`

## Overview

- Backend: Rails 8
- DB: SQLite (dev/test), PostgreSQL (production)
- Auth: Google OAuth2 (requires `.env` with `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`)
- Images: Local in development (`public/uploads/...`), Cloudinary in production
- SMS Verify: Twilio (credentials in Rails credentials)

For full setup, commands, and deployment notes, see Technical documentation. For end‑user flows and screenshots, see the User guide.

## Development

To get started locally (full steps in Technical documentation):

1) Clone the repo and install gems
2) Create `.env` with Google OAuth keys
3) Setup DB: create, migrate, (optionally seed)
4) Run the app (`rails s`) and, optionally, SCSS watcher (`bin/rails dartsass:watch`)

Details, exact commands, and troubleshooting live in the docs linked above.

## Testing

See `docs/testing_documentation.md` for RSpec/Cucumber usage and coverage.

## Image uploads

- Development/test: files are stored locally under `public/uploads/...`
- Production: uploads go to Cloudinary when `CLOUDINARY_URL` is configured

More details in the Technical documentation.

## Links
Slack Channel : https://join.slack.com/t/csce606project2group5/shared_invite/zt-3hfxd0frb-Exfc1ezNndK3eEedNx1p6w
Github Board : https://github.com/orgs/tamu-edu-students/projects/161


## License

This project is part of CSCE 606 coursework at Texas A&M University.

---