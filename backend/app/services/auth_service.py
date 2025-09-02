from typing import Optional
from datetime import timedelta
from app.database.supabase_client import get_supabase_client, get_supabase_admin_client
from app.models.auth import UserCreate, LoginRequest, TokenResponse, UserResponse
from app.core.security import create_access_token
from app.core.exceptions import AuthenticationError, UserAlreadyExistsError, UserNotFoundError
from app.config import settings


class AuthService:
    
    async def register(self, user_data: UserCreate) -> TokenResponse:
        try:
            supabase = get_supabase_client()
            supabase_admin = get_supabase_admin_client()
            
            # Create user in Supabase Auth
            auth_response = supabase.auth.sign_up({
                "email": user_data.email,
                "password": user_data.password,
            })
            
            if auth_response.user is None:
                raise UserAlreadyExistsError("Failed to create user account")
            
            user_id = auth_response.user.id
            
            # Note: User profile is automatically created by database trigger
            
            # Create access token
            access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
            access_token = create_access_token(
                data={"sub": user_id, "email": user_data.email},
                expires_delta=access_token_expires
            )
            
            return TokenResponse(
                access_token=access_token,
                expires_in=settings.access_token_expire_minutes * 60,
                refresh_token=auth_response.session.refresh_token if auth_response.session else ""
            )
            
        except Exception as e:
            if "already been registered" in str(e):
                raise UserAlreadyExistsError("User with this email already exists")
            raise AuthenticationError(f"Registration failed: {str(e)}")
    
    async def login(self, login_data: LoginRequest) -> TokenResponse:
        try:
            supabase = get_supabase_client()
            
            # Authenticate with Supabase
            auth_response = supabase.auth.sign_in_with_password({
                "email": login_data.email,
                "password": login_data.password
            })
            
            if not auth_response.user:
                raise AuthenticationError("Invalid email or password")
            
            user_id = auth_response.user.id
            
            # Create access token
            access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
            access_token = create_access_token(
                data={"sub": user_id, "email": login_data.email},
                expires_delta=access_token_expires
            )
            
            return TokenResponse(
                access_token=access_token,
                expires_in=settings.access_token_expire_minutes * 60,
                refresh_token=auth_response.session.refresh_token if auth_response.session else ""
            )
            
        except Exception as e:
            if "Invalid login credentials" in str(e):
                raise AuthenticationError("Invalid email or password")
            raise AuthenticationError(f"Login failed: {str(e)}")
    
    async def get_user_profile(self, user_id: str) -> UserResponse:
        try:
            supabase = get_supabase_client()
            supabase_admin = get_supabase_admin_client()
            
            # Get user profile
            profile_response = supabase.table("user_profiles").select("*").eq("user_id", user_id).execute()
            
            if not profile_response.data:
                raise UserNotFoundError()
            
            profile = profile_response.data[0]
            
            # Get user from Supabase Auth
            user_response = supabase_admin.auth.admin.get_user_by_id(user_id)
            
            return UserResponse(
                user_id=profile["user_id"],
                email=user_response.user.email,
                display_name=profile["display_name"],
                roles=profile["roles"],
                subscription_status=profile["subscription_status"],
                created_at=profile["created_at"]
            )
            
        except Exception as e:
            raise UserNotFoundError(f"Failed to get user profile: {str(e)}")
    
    async def refresh_token(self, refresh_token: str) -> TokenResponse:
        try:
            supabase = get_supabase_client()
            
            # Refresh token with Supabase
            auth_response = supabase.auth.refresh_session(refresh_token)
            
            if not auth_response.user:
                raise AuthenticationError("Invalid refresh token")
            
            user_id = auth_response.user.id
            
            # Create new access token
            access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
            access_token = create_access_token(
                data={"sub": user_id, "email": auth_response.user.email},
                expires_delta=access_token_expires
            )
            
            return TokenResponse(
                access_token=access_token,
                expires_in=settings.access_token_expire_minutes * 60,
                refresh_token=auth_response.session.refresh_token if auth_response.session else ""
            )
            
        except Exception as e:
            raise AuthenticationError(f"Token refresh failed: {str(e)}")
    
    async def logout(self) -> dict:
        try:
            supabase = get_supabase_client()
            supabase.auth.sign_out()
            return {"message": "Successfully logged out"}
        except Exception as e:
            raise AuthenticationError(f"Logout failed: {str(e)}")