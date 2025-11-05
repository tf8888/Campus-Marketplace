# Architecture Diagram

```mermaid
flowchart TD
    subgraph Client
      A[Browser]
    end

    subgraph "RailsApp [Campus Exchange Rails 8]"
      B["Controllers<br/>- Items<br/>- Requests<br/>- Messages<br/>- Ratings<br/>- Profiles<br/>- Sessions"]
      C["Models<br/>User<br/>Item<br/>Request<br/>Message<br/>Rating<br/>Category"]
      D["Views (ERB)"]
      B --> C
      B --> D
    end

    A <-->|HTTP / HTML| B

    subgraph Data
      E["DB<br/>SQLite dev/test<br/>PostgreSQL prod"]
      F["Local Uploads<br/>public/uploads/*<br/>(dev/test)"]
    end

    C <-- ActiveRecord --> E

    %% Image upload paths
    B -- ImageUploader.upload() --> F

    %% External services
    subgraph "External Services"
      G["Cloudinary<br/>Production image storage"]
      H["Google OAuth2<br/>Authentication"]
      I["Twilio Verify<br/>SMS verification"]
    end

    %% Production path
    B -- if Rails.env.production? and CLOUDINARY_URL --> G

    %% OAuth
    A -->|/auth/google_oauth2| H
    H -->|callback /auth/:provider/callback| B

    %% Twilio Verify
    B -- send_verification_code / check_verification_code --> I
```

Notes:
- In development/test, images are saved under `public/uploads/...` and served directly by Rails.
- In production, images are uploaded to Cloudinary and the secure URL is stored in `items.image_url`.
- Twilio credentials live in Rails encrypted credentials; Google OAuth client ID/secret live in `.env` for local dev.
