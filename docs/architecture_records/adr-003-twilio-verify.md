# ADR-003: Use Twilio Verify for phone verification (SMS)

## Status
Accepted

## Context
- The app includes user phone verification for trust and safety.
- We need a reliable SMS verification flow.

## Decision
- Use `twilio-ruby` with Twilio Verify v2 for sending and checking verification codes.
- Keep Twilio credentials in Rails encrypted credentials (not `.env`).
- Implement the flow in `ProfilesController` with two endpoints: `send_verification_code` and `check_verification_code`.

## Consequences
- External dependency on Twilio’s API and provisioning of Verify service SID.
- In specs, calls must be mocked to avoid network access.
