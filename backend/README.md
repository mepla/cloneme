# EverMynd Backend - Authentication Service

A minimal FastAPI authentication service using Supabase Auth.

## Features

- User registration with Supabase Auth
- Login/logout functionality
- JWT token management with refresh tokens
- User profile management
- Role-based access (Consumer/Creator/Admin)

## Setup

1. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Environment setup**:
   ```bash
   cp .env.example .env
   ```
   
   Fill in your Supabase credentials:
   - `SUPABASE_URL`: Your Supabase project URL
   - `SUPABASE_PUBLISHABLE_KEY`: Your publishable key
   - `SUPABASE_SECRET_KEY`: Your secret key (for admin operations)
   - `SECRET_KEY`: Generate a secure secret key for JWT

3. **Database schema**: Ensure your Supabase database has the `user_profiles` table:
   ```sql
   CREATE TABLE public.user_profiles (
       user_id UUID PRIMARY KEY REFERENCES auth.users(id),
       created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
       updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
       display_name TEXT,
       avatar_url TEXT,
       roles TEXT[] DEFAULT '{"Consumer"}',
       subscription_status TEXT DEFAULT 'free',
       user_graph_id TEXT
   );
   ```

4. **Run the server**:
   ```bash
   uvicorn app.main:app --reload
   ```

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/logout` - Logout user
- `POST /api/v1/auth/refresh` - Refresh JWT token
- `GET /api/v1/auth/me` - Get current user profile

### Health Check
- `GET /` - API info
- `GET /health` - Health check

## Usage Example

```bash
# Register new user
curl -X POST "http://localhost:8000/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "secure_password",
    "display_name": "John Doe"
  }'

# Login
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "secure_password"
  }'

# Get profile (requires JWT token)
curl -X GET "http://localhost:8000/api/v1/auth/me" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Development

The service is designed to be minimal and focused only on authentication. It follows the KISS principle and implements only what's necessary for the auth workflow.

Run with auto-reload for development:
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```