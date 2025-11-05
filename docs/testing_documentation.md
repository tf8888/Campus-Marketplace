# Testing Documentation

This document describes how to set up and run the test suite (RSpec and Cucumber), how coverage works, and common tips.

## Overview

- Unit/Integration tests: RSpec, located under `spec/`
- Acceptance/BDD tests: Cucumber, located under `features/`
- Coverage: SimpleCov outputs HTML to `coverage/index.html`

## One-time Setup

1. Install gems

```bash
bundle install
```

2. Prepare databases (development and test)

```bash
rails db:create db:migrate
RAILS_ENV=test rails db:create db:migrate
```

3. Environment variables (dev/test)

Create a local `.env` with the Google OAuth keys (some flows stub auth, but having these prevents surprises):

```bash
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

Note: Twilio credentials are loaded from Rails credentials and are stubbed in specs; you should not need real Twilio values to run tests.

## SCSS compilation (Dart Sass)

It’s helpful to run the Dart Sass build in a separate terminal to update style components:

```bash
bin/rails dartsass:build
```

## Running RSpec

Run the entire RSpec suite:

```bash
bundle exec rspec
```

Useful variants:

```bash
# Verbose output
bundle exec rspec --format documentation

# Single file
bundle exec rspec spec/models/item_spec.rb

# Single example (by line number)
bundle exec rspec spec/models/item_spec.rb:12
```

RSpec covers models (validations/associations), requests/controllers (auth rules, status codes), and edge cases (e.g., item sale/lend XOR, rating constraints).

## Running Cucumber

Run all features:

```bash
bundle exec cucumber
```

Useful variants:

```bash
# Specific feature
bundle exec cucumber features/item.feature

# With tags (e.g., work-in-progress)
bundle exec cucumber --tags @wip
```

Notes:
- Capybara + Selenium WebDriver are included; headless Chrome is the default.
- If Chrome/Chromedriver are missing, install a recent Chrome and try again on macOS.
- Most features avoid external network calls and sign-in flows, or they stub them.

## Coverage (SimpleCov)

SimpleCov is already wired in the test helpers. To generate and view coverage:

```bash
# Run tests (generates coverage data)
bundle exec rspec && bundle exec cucumber

# Open the HTML report (macOS)
open coverage/index.html
```

## Data and Seeds

- RSpec and Cucumber use the test database (`RAILS_ENV=test`). Migrations must be applied in the test environment.
- Feature tests and specs build their own data via factories/fixtures/step-definitions; running `rails db:seed` is not required for tests.

## External Services in Tests

- Cloudinary: Uploads are not called in test runs; uploads are stored locally via `ImageUploader` (dev/test path) or are bypassed in test paths. No `CLOUDINARY_URL` needed for tests.
- Twilio: Calls are stubbed in controller specs (see `spec/controllers/profiles_controller_spec.rb`). You do not need Twilio credentials when running tests.
- Google OAuth: Most tests do not hit the OmniAuth callback. If a scenario requires OAuth, mock OmniAuth in test mode or ensure `.env` has keys.
