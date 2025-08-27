from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    # Database
    supabase_url: str
    supabase_publishable_key: str
    supabase_secret_key: str
    
    # Security
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    class Config:
        env_file = ".env"


settings = Settings()