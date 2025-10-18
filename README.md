# Campus Lend & Borrow

A lightweight web application for students to **lend, borrow, and coordinate items** within their campus community. Built using **Ruby on Rails**, **PostgreSQL**, and **SCSS** with minimal JavaScript.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Clone the Repository](#clone-the-repository)
  - [Install Dependencies](#install-dependencies)
  - [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [Testing](#testing)
  - [RSpec (Unit & Integration Tests)](#rspec-unit--integration-tests)
  - [Cucumber (BDD Tests)](#cucumber-bdd-tests)
  - [Code Coverage with SimpleCov](#code-coverage-with-simplecov)
- [Development](#development)
- [Deployment](#deployment)
- [Contributing](#contributing)

## Features

- **Lend Items**: Post items you want to lend to other students
- **Borrow Items**: Browse and request items from fellow students
- **Item Coordination**: Communicate and coordinate pickup/return times
- **Community-Driven**: Campus-focused peer-to-peer sharing platform

## Tech Stack

- **Backend**: Ruby on Rails 8.0+
- **Database**: PostgreSQL
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

- **PostgreSQL**: 14 or higher
  ```bash
  psql --version
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

### Database Setup

#### 1. Configure Database Credentials

Create a `.env` file in the root directory or update `config/database.yml` with your PostgreSQL credentials:

```bash
# .env file (optional)
DATABASE_USERNAME=your_postgres_username
DATABASE_PASSWORD=your_postgres_password
```

#### 2. Create and Setup Database

```bash
# Create the database
rails db:create

# Run migrations
rails db:migrate

# Seed the database (optional)
rails db:seed
```

#### 3. Setup Test Database

```bash
# Create test database
RAILS_ENV=test rails db:create

# Run migrations for test database
RAILS_ENV=test rails db:migrate
```

#### Troubleshooting PostgreSQL

If PostgreSQL is not running:

```bash
# Start PostgreSQL service
brew services start postgresql@14

# Check if PostgreSQL is running
brew services list

# If you need to restart
brew services restart postgresql@14
```

If you need to create a PostgreSQL user:

```bash
# Access PostgreSQL console
psql postgres

# Create user (inside psql console)
CREATE USER your_username WITH PASSWORD 'your_password';
ALTER USER your_username CREATEDB;

# Exit
\q
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

Add to your `Gemfile` (in the `:test` group):

```ruby
group :test do
  gem 'simplecov', require: false
end
```

Install:

```bash
bundle install
```

Add to the top of `spec/spec_helper.rb`:

```ruby
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # Don't include test code in coverage
  add_filter '/config/'
end
```

Add to the top of `features/support/env.rb`:

```ruby
require 'simplecov'
SimpleCov.start 'rails'
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
- Use **Faker** for realistic fake data
- Keep tests fast and isolated
- Use **database_cleaner** to maintain clean test database state

## Development

### Code Quality Tools

Consider adding these gems for code quality:

```ruby
group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'brakeman', require: false
end
```

Run code quality checks:

```bash
# Run RuboCop (linter)
bundle exec rubocop

# Run Brakeman (security scanner)
bundle exec brakeman
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

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Commit Message Guidelines

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests

## License

This project is part of CSCE 606 coursework at Texas A&M University.

## Contact

For questions or issues, please open an issue on GitHub or contact the development team.

---