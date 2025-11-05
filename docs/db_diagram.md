# Database Diagram

```mermaid
erDiagram
    USERS ||--o{ ITEMS : owns
    USERS ||--o{ REQUESTS : creates
    USERS ||--o{ MESSAGES : sends
    USERS ||--o{ MESSAGES : receives
    USERS ||--o{ RATINGS : rates
    USERS ||--o{ RATINGS : is_rated

    CATEGORIES ||--o{ ITEMS : categorizes

    ITEMS ||--o{ REQUESTS : has
    REQUESTS ||--o{ MESSAGES : includes
    REQUESTS ||--|{ RATINGS : results_in

    USERS {
      integer id PK
      string  email
      string  name
      string  role
      string  uid
      string  address
      string  contact_number
      boolean verified
      timestamps
    }

    CATEGORIES {
      integer id PK
      string  name
      text    description
      timestamps
    }

    ITEMS {
      integer id PK
      string  title
      text    description
      string  condition
      boolean available
      boolean for_lend
      boolean for_sale
      string  location
      string  image_url
      decimal price
      integer user_id FK
      integer category_id FK
      timestamps
    }

    REQUESTS {
      integer id PK
      integer item_id FK
      integer user_id FK
      string  status  "pending|approved|rejected"
      text    message
      timestamps
    }

    MESSAGES {
      integer id PK
      text    content
      boolean read
      integer request_id FK
      integer sender_id  FK "users.id"
      integer receiver_id FK "users.id"
      timestamps
    }

    RATINGS {
      integer id PK
      integer score "1..10"
      integer rater_id FK "users.id"
      integer ratee_id FK "users.id"
      integer request_id FK
      timestamps
    }
```

Legend:
- FK edges show ownership/association direction; many-to-one is encoded by Mermaid cardinalities.
- There is a uniqueness constraint on `ratings (rater_id, request_id)` and on `requests (item_id, user_id)`.
