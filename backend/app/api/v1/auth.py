from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.services.auth_service import AuthService
from app.models.auth import LoginRequest, TokenResponse, UserCreate, UserResponse
from app.core.security import verify_token
from app.core.exceptions import AuthenticationError

router = APIRouter(prefix="/auth", tags=["authentication"])
security = HTTPBearer()

auth_service = AuthService()


@router.post("/register", response_model=TokenResponse)
async def register(user_data: UserCreate):
    """Register a new user with Supabase authentication."""
    return await auth_service.register(user_data)


@router.post("/login", response_model=TokenResponse)
async def login(login_data: LoginRequest):
    """Login with Supabase authentication."""
    return await auth_service.login(login_data)


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(refresh_token: str):
    """Refresh JWT token using Supabase refresh token."""
    return await auth_service.refresh_token(refresh_token)


@router.post("/logout")
async def logout():
    """Logout user."""
    return await auth_service.logout()


@router.get("/me", response_model=UserResponse)
async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Get current user's profile."""
    token = credentials.credentials
    payload = verify_token(token)
    
    if not payload:
        raise AuthenticationError("Invalid or expired token")
    
    user_id = payload.get("sub")
    if not user_id:
        raise AuthenticationError("Invalid token payload")
    
    return await auth_service.get_user_profile(user_id)