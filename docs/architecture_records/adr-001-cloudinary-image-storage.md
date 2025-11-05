# ADR-001: Use Cloudinary for production image storage

## Status
Accepted

## Context
- The app lets users upload item images.
- Hosting on platforms like Heroku provides an ephemeral filesystem; local file storage is not durable.
- We need reliable, CDN-backed hosting and simple integration with Rails.

## Decision
- Use Cloudinary in production, configured via `ENV["CLOUDINARY_URL"]`.
- Keep development/test on local storage under `public/uploads/...`.
- Implement a service object `ImageUploader` that switches behavior based on environment and presence of `CLOUDINARY_URL`.

## Consequences
- Production uploads are durable and globally accessible via secure URLs.
- Local development remains simple; no external dependencies required.
- Add the `cloudinary` gem and a minimal initializer to configure from environment.
