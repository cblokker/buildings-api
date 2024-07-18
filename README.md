### Note from Developer

I chose to use the `jsonb` type in PostgreSQL for the custom fields instead of the traditional Entity-Attribute-Value (EAV) model. Here are the pros and cons of this approach:

#### Pros:
- Fewer joins and tables than EAV, potentially improving performance for retrieval and storage.
- Flexibility with jsonb, allowing it to act as extra data on the building.
- Clean and straightforward schema.
#### Cons:
- Referential integrity is lost with any NoSQL approach, relying on JSON validators and application layer logic to ensure data integrity.
- Querying JSONB can be complex (e.g., flattening the data in SQL to match API response requirements) and may increase cognitive load for other developers.
I've included comments in the code about performance and suggested changes beyond the requirements.

I also intended to move logic out of the controller and into use cases but was constrained by time. I can discuss this in person. For example, I'm not a fan of `accepts_nested_attributes_for :address`, as it relies too much on "Rails magic." I prefer approaches that align more closely with the database operations to avoid unexpected queries.

#### Code Structure:
- `adapters/*` - Converts one format into another.
- `models/concerns/*` - Contains reusable modules to keep models clean.
- `queries/*` - Handles complex queries that can be shared or merged across ActiveRecord (outside of scopes defined on models).
- `validators/*` - Contains complex validation logic that can be shared across models or used outside of models, such as in use cases or service objects.



# Buildings API

## Overview
This is an API-only Rails 7 application with a PostgreSQL database.

## Prerequisites
Ensure you have the following installed on your local machine:
- Ruby (version 3.3.4)
- Rails (version 7.1.3.4)
- PostgreSQL (version 14 or higher)

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/cblokker/buildings-api.git
cd buildings-api
```

### 2. Install Ruby Dependencies
Ensure you are using the correct Ruby version. You can use tools like [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/) to manage Ruby versions: 

```bash
rbenv install 3.1.0
rbenv local 3.1.0
```

Bundle install:

```bash
gem install bundler
bundle install
```

### 4. Set Up PostgreSQL
#### 4.1 Create PostgreSQL Role
First, ensure PostgreSQL is running. Then create a new role and database:

Login in postgres console:

```bash
$> sudo -u postgres psql
```

create user with name rails and password:

```bash
=# create user rails with password 'password';
```

make user rails superuser:

```bash
=# alter role rails superuser createrole createdb replication;
```

in database.yml:
```yml
development:
  adapter: postgresql
  encoding: unicode
  database: projectname
  pool:
  username: rails
  password: password
```

You may need to do the same for the test db.

#### 4.2 Create, migrate, & seed Database

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 5. Run tests

```bash
bundle exec rspec
```

### 6. Start localserver to see at `http://localhost:3000`

```bash
rails server
```
