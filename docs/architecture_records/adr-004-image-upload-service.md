# ADR-004: Image upload via service object with env-based routing

## Status
Accepted

## Context
- Image upload logic should be centralized, validated, and environment-aware.
- Controllers should not contain file handling concerns.

## Decision
- Implement `app/services/image_uploader.rb` with:
  - Content type and size validation
  - `upload` entry point that decides between local storage and Cloudinary
  - Separate `store_locally` and `upload_to_cloudinary` paths
- Controllers (e.g., `ItemsController`) pass `params[:item][:image_file]` to the service and save the returned URL.

## Consequences
- Clear separation of concerns and easier testing.
- Minimal controller code and consistent behavior across the app.
- Straightforward future extensions (e.g., transformations, virus scanning).
