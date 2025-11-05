# ADR-002: Use Google OAuth2 for authentication

## Status
Accepted

## Context
- We want simple, secure sign-in without managing passwords.
- Students commonly have Google accounts.

## Decision
- Use OmniAuth with the `omniauth-google-oauth2` strategy.
- Configure via `.env` in development (`GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`).
- Callback endpoint: `/auth/:provider/callback` handled by `SessionsController#create`.

## Consequences
- Reduced auth surface area (no password storage).
- Requires properly configured OAuth credentials and redirect URIs in each environment.
