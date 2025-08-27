from pydantic import BaseModel, EmailStr
from typing import Optional, List


class UserCreate(BaseModel):
    email: EmailStr
    password: str
    display_name: Optional[str] = None


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_in: int
    refresh_token: str


class UserResponse(BaseModel):
    user_id: str
    email: str
    display_name: Optional[str] = None
    roles: List[str] = ["Consumer"]
    subscription_status: str = "free"
    created_at: str