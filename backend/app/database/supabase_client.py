from supabase import create_client, Client
from app.config import settings
from typing import Optional

_supabase_client: Optional[Client] = None
_supabase_admin_client: Optional[Client] = None


def get_supabase_client() -> Client:
    """Get or create the main Supabase client."""
    global _supabase_client
    if _supabase_client is None:
        _supabase_client = create_client(
            settings.supabase_url, 
            settings.supabase_publishable_key
        )
    return _supabase_client


def get_supabase_admin_client() -> Client:
    """Get or create the admin Supabase client."""
    global _supabase_admin_client
    if _supabase_admin_client is None:
        _supabase_admin_client = create_client(
            settings.supabase_url, 
            settings.supabase_secret_key
        )
    return _supabase_admin_client