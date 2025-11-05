# Architecture Diagram

```mermaid
flowchart TD
    subgraph Client
      A[Browser]
    end

    subgraph RailsApp[Campus Lend & Borrow (Rails 8)]
      B[Controllers\n- Items\n- Requests\n- Messages\n- Ratings\n- Profiles\n- Sessions]
      C[Models\nUser, Item, Request, Message, Rating, Category]
      D[Views (ERB) + Turbo/Stimulus]
      B --> C
      B --> D
    end

    A <-->|HTTP / HTML| B

    subgraph Data
      E[(DB\nSQLite dev/test\nPostgreSQL prod)]
      F[(Local Uploads\npublic/uploads/*\n(dev/test))]
    end

    C <-- ActiveRecord --> E

    %% Image upload paths
    B -- ImageUploader.upload() --> F

    %% External services
    subgraph External Services
      G[Cloudinary\nProduction image storage]
      H[Google OAuth2\nAuthentication]
      I[Twilio Verify\nSMS verification]
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
