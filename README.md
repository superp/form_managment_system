# Form Management System

A Rails application for creating and managing dynamic forms with different field types.

## Features

- User authentication with custom session management (From Rails 8 authentication generator)
- Dynamic form creation with multiple field types (string, integer, datetime)
- Form field validation and constraints
- Form entry submission and management
- CSV export functionality

## Setup

### Prerequisites

- Ruby 3.2.6
- PostgreSQL

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```

3. Setup database:
   ```bash
   rails db:create
   rails db:migrate
   ```

4. Start the server:
   ```bash
   rails server
   ```

## Testing

### Run all tests
```bash
bundle exec rspec
```


## Usage

1. Register a new account
2. Create fields with limitation (min/max length)
3. Create forms with custom fields
4. Collect responses
5. View and export form data

## Database Schema

```
users
├── id (PK)
├── email_address (unique)
├── password_digest
└── created_at, updated_at

sessions
├── id (PK)
├── user_id (FK → users)
├── ip_address
├── user_agent
└── created_at, updated_at

forms
├── id (PK)
├── title
├── description
├── user_id (FK → users)
└── created_at, updated_at

fields
├── id (PK)
├── name
├── field_type (enum: string, integer, datetime)
├── min_length, max_length
├── min_value, max_value
├── user_id (FK → users)
└── created_at, updated_at

form_fields (join table)
├── id (PK)
├── form_id (FK → forms)
├── field_id (FK → fields)
├── position
└── created_at, updated_at

form_entries
├── id (PK)
├── form_id (FK → forms)
└── created_at, updated_at

entry_values
├── id (PK)
├── string_value
├── integer_value
├── datetime_value
├── form_entry_id (FK → form_entries)
├── form_field_id (FK → form_fields)
└── created_at, updated_at
```

> **Note**: The EntryValue model uses distinct columns (string_value, integer_value, etc.) to enforce data integrity at the database level and leverage native data type indexing for better query performance.

## Tech Stack

- **Backend**: Ruby on Rails 8.0
- **Database**: PostgreSQL
- **Frontend**: Stimulus, Turbo
- **Testing**: RSpec, FactoryBot
- **Authentication**: Custom session-based system