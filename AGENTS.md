This is a Django-based HTMX application that implements the RealWorld specification using a hypermedia-driven architecture instead of the
  traditional REST API approach.

  Tech Stack:
  - Backend: Python 3.11+ with Django 4.0.1
  - Frontend: HTMX + Alpine.js (minimal JavaScript)
  - Database: PostgreSQL 17 (production) / SQLite (dev)
  - Infrastructure: Docker + docker-compose

  Key Patterns:
  - MTV (Model-Template-View) architecture
  - HTMX-driven hypermedia for dynamic updates
  - Function-based views with type annotations
  - Custom QuerySet/Manager patterns
  - Partial template rendering for HTMX fragments

  Architectural Highlights:
  - HTML-over-the-wire instead of JSON APIs
  - Email-based authentication with custom User model
  - Modern Python tooling (uv, ruff, pytest)
  - Docker-first development workflow
  - Strong emphasis on code quality and type safety


  Testing Ground Rules
  7 Essential Rules:

  1. Use setUpTestData for static test data - Create users, articles, and URLs once per test class. Only use setUp for per-test state like
  authentication.
  2. Authenticate with force_login, not passwords - Use self.client.force_login(user) in tests, not client.login(). Create users with set_password()
  in setup for consistency.
  3. Use http.HTTPStatus constants, not integers - Write http.HTTPStatus.OK instead of 200 for better readability and self-documenting tests.
  4. Test HTMX headers and context - Always verify HTMX-specific behavior: check HX-Redirect headers, test with HTTP_HX_TARGET parameters, and
  validate context variables like is_detail.
  5. Follow the naming pattern: Test<Name> + test_<scenario> - Test classes are TestArticleModel, TestFollowView, etc. Methods describe scenarios:
  test_post_invalid, test_same_user, test_add_favorite.
  6. Verify database state changes explicitly - After POST/DELETE operations, always check database state with .exists(), .filter(), or .get()
  assertions - don't just trust the response code.
  7. Test both success and edge cases - For every view, test: valid input, invalid input, anonymous users, authenticated users, and business logic
  edge cases (e.g., user can't favorite their own article).

  ---
  Key Patterns Observed

  - Organization: One tests.py per app, Django TestCase classes
  - HTMX testing: Verifies headers (HX-Redirect) and request context
  - Authentication: Uses force_login() consistently
  - Assertions: Checks HTTP status, database state, response context, and content
  - Setup efficiency: setUpTestData for read-only data, setUp for per-test state