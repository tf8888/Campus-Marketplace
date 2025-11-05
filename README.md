# Campus Lend & Borrow

A lightweight web application for students to **lend, borrow, and coordinate items** within their campus community. Built using **Ruby on Rails**, **PostgreSQL**, and **SCSS** with minimal JavaScript.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Clone the Repository](#clone-the-repository)
  - [Install Dependencies](#install-dependencies)
  - [Environment Variables](#environment-variables)
  - [Database Setup](#database-setup)
- [Compile SCSS Styles](#compile-scss-styles)
- [Running the Application](#running-the-application)
- [Testing](#testing)
  - [RSpec (Unit & Integration Tests)](#rspec-unit--integration-tests)
  - [Cucumber (BDD Tests)](#cucumber-bdd-tests)
  - [Code Coverage with SimpleCov](#code-coverage-with-simplecov)
- [Development](#development)
- [Deployment](#deployment)
- [Contributing](#contributing)
  
## Image Uploads

This app supports item image uploads:

- Local (development/test): files are stored under `public/uploads/items/...` and the item stores a public path in `image_url`.
- Production: images are uploaded to Cloudinary; the `image_url` stores the Cloudinary secure URL.

### Cloudinary setup (production)

1. Create a Cloudinary account and a cloud name.
2. Configure the environment variable `CLOUDINARY_URL` (12-factor style):

```
CLOUDINARY_URL=cloudinary://API_KEY:API_SECRET@CLOUD_NAME
```

3. Ensure this variable is available in your production environment (e.g., server, CI/CD secrets).

4. No other configuration is required; the app detects this in production and uploads via the Cloudinary API.

In development/test, the app will not call Cloudinary and will store files locally.

## Features

- **Lend Items**: Post items you want to lend to other students
- **Borrow Items**: Browse and request items from fellow students
- **Item Coordination**: Communicate and coordinate pickup/return times
- **Community-Driven**: Campus-focused peer-to-peer sharing platform

## Tech Stack

- **Backend**: Ruby on Rails 8.0+
- **Database**: Sqlite (development/test), PostgreSQL (production)
- **Styling**: SCSS
- **Testing**: RSpec, Cucumber, SimpleCov
- **JavaScript**: Minimal 

## Prerequisites

Before you begin, ensure you have the following installed:

- **Ruby**: 3.2.0 or higher
  ```bash
  ruby --version
  ```

- **Rails**: 8.0 or higher
  ```bash
  rails --version
  ```

- **Bundler**: 2.0 or higher
  ```bash
  bundler --version
  ```

- **Git**
  ```bash
  git --version
  ```

## Getting Started

### Clone the Repository

```bash
# Clone via HTTPS
git clone https://github.com/tamu-edu-students/CSCE606-group5-project2.git

# OR clone via SSH
git clone git@github.com:tamu-edu-students/CSCE606-group5-project2.git

# Navigate to the project directory
cd CSCE606-group5-project2
```

### Install Dependencies

Install all required Ruby gems:

```bash
bundle install
```

If you encounter any issues, try:

```bash
bundle update
bundle install
```

### Environment Variables

Create a `.env` file in the root directory and add the following environment variables:

```bash
# Google OAuth Configuration
GOOGLE_CLIENT_ID=your_google_client_id_here
GOOGLE_CLIENT_SECRET=your_google_client_secret_here

# Optional: only needed in production if using Cloudinary for image uploads
# CLOUDINARY_URL=cloudinary://API_KEY:API_SECRET@CLOUD_NAME
```

To obtain Google OAuth credentials:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google+ API
4. Go to "Credentials" and create OAuth 2.0 Client ID
5. Set authorized redirect URI to: `http://localhost:3000/auth/google_oauth2/callback`
6. Copy the Client ID and Client Secret to your `.env` file

### Database Setup

#### 1. Create and Setup Database

```bash
# Create the database
rails db:create

# Run migrations
rails db:migrate

# Seed the database (optional)
rails db:seed
```

#### 2. Setup Test Database

```bash
# Create test database
RAILS_ENV=test rails db:create

# Run migrations for test database
RAILS_ENV=test rails db:migrate
```

### Compile SCSS Styles

For development with live SCSS compilation, run the Dart Sass watcher in a separate terminal:

```bash
bin/rails dartsass:watch
```

This command will:
- Watch for changes in your `.scss` files
- Automatically compile them to CSS
- Update the styles in real-time during development

**Recommended Development Setup:**

Open two terminal windows:

Terminal 1 - Rails Server:
```bash
rails server
```

Terminal 2 - SCSS Compiler:
```bash
bin/rails dartsass:watch
```
## Running the Application

Start the Rails server:

```bash
# Standard way
rails server

# OR using the short form
rails s

# OR using the development Procfile (if configured)
bin/dev
```

The application will be available at: **http://localhost:3000**

## Testing

### RSpec (Unit & Integration Tests)

RSpec is used for unit tests, model tests, controller tests, and request specs.

Install and initialize:

```bash
bundle install
rails generate rspec:install
```

#### Running RSpec Tests

```bash
# Run all specs
bundle exec rspec

# Run specific spec file
bundle exec rspec spec/models/user_spec.rb

# Run specs with documentation format
bundle exec rspec --format documentation

# Run specs for a specific line
bundle exec rspec spec/models/user_spec.rb:23
```

### Cucumber (BDD Tests)

Cucumber is used for behavior-driven development and acceptance testing.

#### Setup Cucumber

Install and initialize:

```bash
bundle install
rails generate cucumber:install
```

#### Running Cucumber Tests

```bash
# Run all features
bundle exec cucumber

# Run specific feature file
bundle exec cucumber features/borrowing_items.feature

# Run with specific profile
bundle exec cucumber -p default

# Run with tags
bundle exec cucumber --tags @wip
```

### Code Coverage with SimpleCov

SimpleCov generates code coverage reports for your test suite.

#### Setup SimpleCov

Install:

```bash
bundle install
```

#### Viewing Coverage Reports

After running your tests:

```bash
# Run tests (this generates coverage data)
bundle exec rspec
bundle exec cucumber

# Open coverage report
open coverage/index.html
```

The coverage report will show:
- Overall coverage percentage
- Per-file coverage
- Lines covered/missed

#### Running All Tests with Coverage

```bash
# Run all RSpec and Cucumber tests
bundle exec rspec && bundle exec cucumber

# View the consolidated coverage report
open coverage/index.html
```

### Test Best Practices

- Maintain **>90%** code coverage
- Write tests before implementing features (TDD/BDD)
- Use **FactoryBot** for test data
- Keep tests fast and isolated
- Use **database_cleaner** to maintain clean test database state

## Development

### Code Quality Tools

Run code quality checks:

```bash
# Run RuboCop (linter)
bundle exec rubocop
```

### Database Commands

```bash
# Reset database (drop, create, migrate, seed)
rails db:reset

# Rollback last migration
rails db:rollback

# Check migration status
rails db:migrate:status

# Access Rails console
rails console
```

## Deployment

Deployment instructions will be added once the application is production-ready.

Potential platforms:
- Heroku

## Links
Slack Channel : https://join.slack.com/t/csce606project2group5/shared_invite/zt-3hfxd0frb-Exfc1ezNndK3eEedNx1p6w
Github Board : https://github.com/orgs/tamu-edu-students/projects/161


## License

This project is part of CSCE 606 coursework at Texas A&M University.

---