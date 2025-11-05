# Technical Documentation

This document explains the architecture, integrations, and operational details of the Campus Exchange application so developers can work productively and deploy safely.

## Stack and Architecture

- Framework: Ruby on Rails 8
- Ruby: See `.ruby-version` or Gemfile constraints
- DB: SQLite (dev/test) and PostgreSQL (prod)
- Auth: OmniAuth Google OAuth2
- Verification: Twilio Verify for phone verification (SMS)
- File uploads: Local filesystem in development/test; Cloudinary in production
- Testing: RSpec, Cucumber, SimpleCov

Rails standard MVC applies:
- Models: `User`, `Item`, `Request`, `Message`, `Rating`, `Category`
- Controllers: `ItemsController`, `RequestsController`, `MessagesController`, `RatingsController`, `ProfilesController`, `SessionsController`, etc.
- Views: ERB templates under `app/views/...`

## Domain Model Overview

- User
  - has many `items`, `requests`
  - has many `sent_messages` and `received_messages`
  - receives `ratings` from other users; can also give ratings
  - `average_rating` helper provided
- Category
  - has many `items`
- Item
  - belongs to `user` and `category`
  - has many `requests` (dependent: destroy)
  - validations: title, description length, price numericality
  - XOR constraint: must be either `for_sale` or `for_lend` (not both/neither)
  - `price` required when `for_sale`
  - `image_url` stores either a local relative URL (dev/test) or Cloudinary secure URL (prod)
- Request
  - belongs to `user` (requester) and `item`
  - statuses: `pending`, `approved`, `rejected`
  - owner (`item.user`) can approve/reject; requester can delete
  - has many `messages`; has one `rating`
- Message
  - conversation between requester and owner under a Request
  - basic validations (content, length, sender != receiver)
- Rating
  - belongs to `request`, `rater` (User), `ratee` (User)
  - score 1..10
  - constraints: only requester can rate, request must be approved, requester cannot rate themselves, one rating per requester/request

## Routing Highlights

See `config/routes.rb` for full details. Key endpoints:
- Items: CRUD, plus `PATCH /items/:id/mark_unavailable` and `GET /items/my_listings`
- Requests: `show/new/create/destroy` and member actions `approve`/`reject`
- Messages: `POST /requests/:request_id/messages`
- Rating: `GET /requests/:request_id/rating/new` and `POST /requests/:request_id/rating`
- Users: `GET /users/:id`, `items`, `requests`, `incoming_requests`
- Profile: `show/edit/update`, `patch :send_verification_code`, `post :check_verification_code`
- Auth: `/auth/google_oauth2` → callback `/auth/:provider/callback`

Authorization rules enforced in controllers:
- RequestsController#show: only requester or item owner can view
- RequestsController#approve/#reject: only item owner
- RequestsController#destroy: only requester
- RatingsController: only requester of an approved request can create a rating; one rating per request/user

## Image Uploads and Cloudinary (Important)

The service `app/services/image_uploader.rb` centralizes upload logic:
- In production, when `CLOUDINARY_URL` is present, files are uploaded to Cloudinary and the secure URL is persisted in `item.image_url`.
- In development/test, files are stored locally under `public/uploads/items/...` and `item.image_url` is a public relative path like `/uploads/items/<file>.jpg`.

Initializer: `config/initializers/cloudinary.rb`
- Reads `ENV["CLOUDINARY_URL"]` and configures Cloudinary (secure URLs enabled)
- Example: `cloudinary://API_KEY:API_SECRET@CLOUD_NAME`

Controller integration: `ItemsController`
- Accepts form field `image_file` (an `ActionDispatch::Http::UploadedFile`)
- Calls `ImageUploader.upload(uploaded, folder: "items")`
- Handles errors with `ImageUploader::UploadError`

Seed images: `db/seeds.rb`
- Uses Unsplash CDN placeholder URLs so seeds work in any environment (no local files required)

Why Cloudinary in production?
- Heroku and many cloud platforms have ephemeral filesystems; local file writes are not durable. Offloading to Cloudinary ensures persistent, performant image hosting with CDN.

## Authentication and OAuth

- OmniAuth configuration: `config/initializers/omniauth.rb`
- Required env vars (usually via `.env` in dev):
  - `GOOGLE_CLIENT_ID`
  - `GOOGLE_CLIENT_SECRET`
- Callback: `/auth/google_oauth2` → `/auth/:provider/callback` handled by `SessionsController#create`
- User provisioning: `User.from_omniauth(auth)` sets name/email and persists user

## Phone Verification with Twilio

- Implemented in `ProfilesController`
- Uses Twilio Verify (v2) via `twilio-ruby` gem
- Credentials are loaded from Rails credentials (not `.env`):
  - `Rails.application.credentials.twilio[:account_sid]`
  - `Rails.application.credentials.twilio[:auth_token]`
  - `Rails.application.credentials.twilio[:verify_service_sid]`
- Flow:
  1. `PATCH /profile/send_verification_code` sends SMS to the current user’s `contact_number`
  2. `POST /profile/check_verification_code` verifies the code; on success sets `user.verified = true`

Note: In specs, Twilio calls are stubbed/mocked; no real API calls are made.

## Environments and Configuration

- Development/Test
  - `.env` for Google OAuth keys (dotenv loaded in dev/test)
  - Local uploads directory: `public/uploads` (committed images are not required)
  - SQLite databases under `storage/`
- Production
  - `CLOUDINARY_URL` must be set for image uploads
  - PostgreSQL database via `DATABASE_URL`
  - Secrets (e.g., Twilio) stored in Rails credentials or platform secrets

## Deployment Notes

- Ensure `CLOUDINARY_URL` is set (images won’t persist otherwise)
- Ensure Google OAuth redirect URI points to your production host
- Migrate database on deploy
- If hosted on Heroku: remember the dyno filesystem is ephemeral; rely on Cloudinary for images

## Testing Overview

- RSpec: model, controller/request, and other unit/integration tests under `spec/`
- Cucumber: feature tests under `features/`
- Coverage: `SimpleCov` generates `coverage/index.html`
- See `docs/testing_documentation.md` for exact commands and setup steps.

## Known Validations and Constraints

- Item: XOR sale/lend; price required for sale
- Request: cannot request your own item (validation in model)
- Message: content presence/length; sender != receiver
- Rating: score 1..10; only requester can rate; request must be approved; uniqueness per requester/request

## Local setup and common commands

Below are practical, copy‑pasteable commands for getting started locally. See repository URLs and environment details as needed.

### 1) Clone the project

```bash
# HTTPS
git clone https://github.com/tamu-edu-students/CSCE606-group5-project2.git

# or SSH
git clone git@github.com:tamu-edu-students/CSCE606-group5-project2.git

cd CSCE606-group5-project2
```

### 2) Install Ruby gems

```bash
bundle install
# If needed
bundle update && bundle install
```

### 3) Environment variables (development/test)

Create a `.env` in the repo root and add your Google OAuth keys:

```bash
GOOGLE_CLIENT_ID=your_google_client_id_here
GOOGLE_CLIENT_SECRET=your_google_client_secret_here
```

Twilio credentials are stored in Rails credentials, not `.env`.

In production, set:

```bash
CLOUDINARY_URL=cloudinary://API_KEY:API_SECRET@CLOUD_NAME
```

### 4) Database setup

```bash
# Development DB
rails db:create db:migrate

# Optional demo data
rails db:seed

# Test DB
RAILS_ENV=test rails db:create db:migrate
```

Useful DB commands:

```bash
rails db:reset            # drop, create, migrate, seed
rails db:rollback         # rollback last migration
rails db:migrate:status   # check migration status
```

### 5) Run the application

```bash
# Start the Rails server
rails s

# Or use the development Procfile if available
bin/dev
```

The app is available at http://localhost:3000.

### 6) SCSS compilation (Dart Sass)

Run the Dart Sass watcher in a separate terminal for live style updates during development:

```bash
bin/rails dartsass:watch
```

### 7) Testing quickstart

See `docs/testing_documentation.md` for full details. Common commands:

```bash
bundle exec rspec                 # run all RSpec tests
bundle exec cucumber              # run all Cucumber features
open coverage/index.html          # open SimpleCov report on macOS
```
