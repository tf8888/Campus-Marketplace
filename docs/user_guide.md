# User Guide

This guide walks through common actions in the Campus Lend & Borrow app and how to get set up locally.

## Sign in with Google

- Click “Sign in with Google” to access the app.
- Local development requires setting two environment variables in `.env` (see below):
  - `GOOGLE_CLIENT_ID`
  - `GOOGLE_CLIENT_SECRET`

If Google returns an error locally, ensure the callback URL is allowed: `http://localhost:3000/auth/google_oauth2/callback`.

## Creating and Managing Items

1. Go to Items → New
2. Fill in the title, description, condition, and select exactly one: For Sale or For Lend
   - If For Sale, you must provide a price
3. (Optional) Upload an image by choosing a file
4. Submit the form

Where are images stored?
- Local (development/test): the uploaded file is saved under `public/uploads/items/...` and the item stores a relative `image_url`
- Production: the image is uploaded to Cloudinary automatically and the item stores a secure Cloudinary URL

Other item actions:
- Edit or Delete your own items
- View your own items under Items → My Listings

## Browsing and Searching Items

- Use the search bar to filter by title/description
- Filter by category
- Sort by title, price, condition, or created date (ascending/descending)

## Requesting an Item

1. Visit an item page and create a request
2. The owner can approve or reject the request
3. You can delete your own pending request

Incoming requests for owners:
- Go to your profile or the “Incoming Requests” view to approve/reject

## Messaging on a Request

- Open a specific request page to see the conversation thread
- Post a message to coordinate pickup/return details

## Rating After a Transaction

- When a request is approved and completed, the requester can rate the owner (1–10)
- Access: `Requests → your request → "Rate"` or directly `/requests/:id/rating/new`
- Constraints:
  - Only the requester can rate
  - The request must be approved
  - One rating per requester/request pair

Your average rating is computed from all ratings you’ve received.

## Phone Verification (SMS)

- Add your phone number on the profile edit page
- Click “Send Verification Code” to receive an SMS via Twilio
- Enter the received code to verify your number

Note: Twilio credentials are managed in the application’s secured credentials, not `.env`.

## Local Setup Checklist (Developers)

1. Install Ruby, Bundler, and dependencies: `bundle install`
2. Create `.env` with:
   - `GOOGLE_CLIENT_ID=...`
   - `GOOGLE_CLIENT_SECRET=...`
3. Prepare the database:
   - `rails db:create db:migrate db:seed`
4. Start the app:
   - `rails s` (and optionally `bin/rails dartsass:watch` for SCSS)

If you don’t see images locally, ensure your browser can access paths like `/uploads/items/...`. If images are missing on production, Cloudinary must be configured.
