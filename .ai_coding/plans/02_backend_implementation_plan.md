# EverMynd Backend Implementation Plan (Updated)

## Key Changes Made

### 1. User-Creator Merge
- **Removed**: Separate Creator entity/table
- **Updated**: All users can have multiple roles (Admin, Consumer, Creator)
- **Change Impact**: Simplified data model and eliminated creator-user separation

### 2. Knowledge Graph for User Data
- **Removed**: User progress and preferences from Supabase schema
- **Updated**: All user learning data, preferences, and progress stored in individual Graphiti knowledge graphs
- **Change Impact**: More sophisticated user modeling with temporal relationships

### 3. Real-time Progress Tracking
- **Added**: WebSocket support for real-time content ingestion progress
- **Added**: Server-sent events for dashboard updates
- **Change Impact**: Enhanced creator experience with live feedback

### 4. Authentication Modernization  
- **Removed**: service_key usage (deprecated)
- **Updated**: Use publishable/secret keys with proper RLS policies
- **Change Impact**: Better security practices and key management

### 5. Simplified LLM Stack
- **Removed**: Anthropic integration
- **Updated**: OpenAI-only implementation
- **Change Impact**: Simplified external service management

### 6. ID Field Naming Convention
- **Updated**: All ID fields now include entity name prefix (e.g., `coach_id` instead of `id`)
- **Change Impact**: Improved clarity and reduced ambiguity in database relationships and API responses

---

## Project Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                 # FastAPI app entry point
│   ├── config.py              # Configuration management
│   ├── dependencies.py        # Dependency injection
│   │
│   ├── api/                   # API routes
│   │   ├── __init__.py
│   │   ├── v1/                # API version 1
│   │   │   ├── __init__.py
│   │   │   ├── auth.py        # Authentication endpoints
│   │   │   ├── users.py       # User management (merged creator functionality)
│   │   │   ├── coaches.py     # Coach management
│   │   │   ├── content.py     # Content ingestion/retrieval
│   │   │   ├── chat.py        # Chat interactions
│   │   │   └── progress.py    # Real-time progress endpoints
│   │   └── deps.py            # API dependencies
│   │
│   ├── core/                  # Core business logic
│   │   ├── __init__.py
│   │   ├── auth.py           # Authentication logic
│   │   ├── rbac.py           # Role-based access control
│   │   ├── exceptions.py     # Custom exceptions
│   │   └── security.py       # Security utilities
│   │
│   ├── models/               # Pydantic models
│   │   ├── __init__.py
│   │   ├── auth.py          # Auth-related models
│   │   ├── user.py          # User models (includes creator functions)
│   │   ├── coach.py         # Coach models
│   │   ├── content.py       # Content models
│   │   ├── chat.py          # Chat models
│   │   └── progress.py      # Progress tracking models
│   │
│   ├── services/            # Business logic services
│   │   ├── __init__.py
│   │   ├── auth_service.py          # Authentication service
│   │   ├── user_service.py          # User management (merged creator service)
│   │   ├── coach_service.py         # Coach management
│   │   ├── content_service.py       # Content processing
│   │   ├── knowledge_graph_service.py # Graphiti integration
│   │   ├── chat_service.py          # Chat interactions
│   │   ├── feed_service.py          # Content feed generation
│   │   ├── progress_service.py      # Real-time progress tracking
│   │   └── external/                # External API integrations
│   │       ├── __init__.py
│   │       ├── youtube_service.py   # YouTube API
│   │       ├── instagram_service.py # Instagram API
│   │       └── openai_service.py    # OpenAI only (removed Anthropic)
│   │
│   ├── database/            # Database configurations
│   │   ├── __init__.py
│   │   ├── supabase_client.py      # Supabase connection (updated auth)
│   │   └── graph_client.py         # Neo4j/FalkorDB connection
│   │
│   ├── schemas/             # Database schemas & custom Graphiti types
│   │   ├── __init__.py
│   │   ├── graphiti_entities.py    # Custom entity types (updated)
│   │   └── graphiti_edges.py       # Custom edge types (updated)
│   │
│   ├── utils/               # Utility functions
│   │   ├── __init__.py
│   │   ├── file_processing.py      # PDF/EPUB processing
│   │   ├── content_extractors.py   # Text/media extraction
│   │   ├── validators.py           # Input validation
│   │   └── websocket_manager.py    # WebSocket connection management
│   │
│   └── workers/             # Background task workers
│       ├── __init__.py
│       ├── content_ingestion.py    # Async content processing (with progress)
│       └── feed_generation.py      # Content feed creation
│
├── requirements.txt         # Python dependencies (updated)
├── pyproject.toml          # Project configuration
├── docker-compose.yml      # Local development setup
├── Dockerfile             # Container configuration
└── .env.example           # Environment variables template (updated)
```

## Core Dependencies (Updated)

### Primary Framework Stack
```python
# requirements.txt
fastapi[all]==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.0
python-multipart==0.0.6
websockets==12.0  # Added for real-time progress

# Knowledge Graph
graphiti-core==0.3.0

# Database
supabase==2.3.0
neo4j==5.15.0  # or falkordb as alternative

# Authentication & Security
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4

# External APIs
google-api-python-client==2.110.0  # YouTube
requests==2.31.0                   # Instagram/general HTTP
openai==1.6.0                      # OpenAI only (removed Anthropic)

# File Processing
PyPDF2==3.0.1
python-docx==1.1.0
markdown==3.5.1
pypdf==3.17.0

# Background Tasks
celery[redis]==5.3.4
redis==5.0.1

# Utilities
python-dotenv==1.0.0
tenacity==8.2.3  # Retry logic
aiofiles==23.2.1  # Async file operations
```

## Database Schema Design (Updated)

### Supabase Schema (Auth & Metadata Only)
```sql
-- Users table (extends Supabase auth.users) - MERGED CREATOR FUNCTIONALITY
CREATE TABLE public.user_profiles (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id), -- Updated: prefixed with entity name
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    display_name TEXT,
    avatar_url TEXT,
    roles TEXT[] DEFAULT '{"Consumer"}', -- Consumer, Creator, Admin (users can have multiple)
    subscription_status TEXT DEFAULT 'free',
    -- Removed: preferences, learning_goals, interests (now in knowledge graph)
    user_graph_id TEXT -- Individual Graphiti graph for user progress/preferences
);

-- Coaches table (updated foreign key reference)
CREATE TABLE public.coaches (
    coach_id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Updated: prefixed with entity name
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    creator_user_id UUID REFERENCES public.user_profiles(user_id), -- Updated: references users not creators
    name TEXT NOT NULL,
    description TEXT,
    avatar_url TEXT,
    pricing_tier TEXT, -- free, basic, premium
    monthly_price DECIMAL(10,2),
    features JSONB DEFAULT '{}', -- voice_chat, content_preview, etc.
    is_published BOOLEAN DEFAULT FALSE,
    coach_graph_id TEXT, -- Graphiti graph identifier for coach knowledge
    configuration JSONB DEFAULT '{}'
);

-- User-Coach subscriptions (updated with prefixed IDs)
CREATE TABLE public.user_coach_subscriptions (
    subscription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Updated: prefixed with entity name
    user_id UUID REFERENCES public.user_profiles(user_id),
    coach_id UUID REFERENCES public.coaches(coach_id),
    subscription_status TEXT DEFAULT 'active', -- active, cancelled, expired
    subscribed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(user_id, coach_id)
);

-- Content ingestion jobs (updated with progress tracking and prefixed IDs)
CREATE TABLE public.content_ingestion_jobs (
    job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Updated: prefixed with entity name
    user_id UUID REFERENCES public.user_profiles(user_id), -- Updated: user instead of creator
    coach_id UUID REFERENCES public.coaches(coach_id),
    source_type TEXT, -- youtube, instagram, file
    source_url TEXT,
    status TEXT DEFAULT 'pending', -- pending, processing, completed, failed
    progress_percentage DECIMAL(5,2) DEFAULT 0.00, -- Added: progress tracking
    current_step TEXT, -- Added: current processing step description
    total_items INTEGER, -- Added: total items to process
    processed_items INTEGER DEFAULT 0, -- Added: items processed so far
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    error_message TEXT,
    metadata JSONB DEFAULT '{}'
);

-- RLS Policies (updated)
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coaches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_coach_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_ingestion_jobs ENABLE ROW LEVEL SECURITY;

-- Users can only access their own profile
CREATE POLICY "Users can access own profile" ON public.user_profiles
    FOR ALL USING (auth.uid() = user_id); -- Updated: reference new column name

-- Users with Creator role can manage their own coaches
CREATE POLICY "Creators can manage own coaches" ON public.coaches
    FOR ALL USING (
        creator_user_id = auth.uid() 
        AND 'Creator' = ANY((SELECT roles FROM public.user_profiles WHERE user_id = auth.uid())) -- Updated: reference new column name
    );

-- Users can view published coaches
CREATE POLICY "Users can view published coaches" ON public.coaches
    FOR SELECT USING (is_published = true);

-- Users can view their own ingestion jobs
CREATE POLICY "Users can view own ingestion jobs" ON public.content_ingestion_jobs
    FOR ALL USING (user_id = auth.uid());
```

## Custom Graphiti Entity Types (Updated)

```python
# app/schemas/graphiti_entities.py
from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from enum import Enum

class ContentType(str, Enum):
    VIDEO = "video"
    IMAGE = "image"
    TEXT = "text"
    AUDIO = "audio"
    DOCUMENT = "document"

# REMOVED: Creator entity (merged with User)

class User(BaseModel):
    """Represents a platform user with potential multiple roles."""
    display_name: str = Field(description="User's display name")
    roles: List[str] = Field(description="User roles: Consumer, Creator, Admin")
    # MOVED TO GRAPH: All preference and learning data now in knowledge graph
    interaction_history: Dict[str, Any] = Field(description="User interaction patterns")
    engagement_patterns: Dict[str, float] = Field(description="Engagement metrics per content type")

class UserPreferences(BaseModel):
    """Represents user preferences and learning style - NEW ENTITY FOR GRAPH."""
    learning_style: str = Field(description="Visual, auditory, kinesthetic, reading/writing")
    preferred_content_length: str = Field(description="Short, medium, long form content preference")
    difficulty_preference: str = Field(description="Beginner, intermediate, advanced")
    topic_interests: List[str] = Field(description="User's topic interests")
    learning_goals: List[str] = Field(description="User's learning objectives")
    time_availability: str = Field(description="Available learning time slots")

class UserProgress(BaseModel):
    """Represents user learning progress - ENHANCED FOR GRAPH."""
    skill_area: str = Field(description="Area of learning")
    proficiency_level: str = Field(description="Current proficiency")
    completion_percentage: float = Field(description="Progress percentage")
    last_interaction: str = Field(description="Most recent interaction date")
    mastery_indicators: List[str] = Field(description="Evidence of understanding")
    learning_path: List[str] = Field(description="Sequence of learning activities")
    time_spent: float = Field(description="Total time spent on this skill area")

class Coach(BaseModel):
    """Represents an AI coach instance."""
    name: str = Field(description="Coach name")
    specialization: str = Field(description="Primary coaching area")
    personality_traits: List[str] = Field(description="Coach personality characteristics")
    coaching_approach: str = Field(description="Coaching methodology")
    target_audience: str = Field(description="Intended user demographic")
    creator_user_id: str = Field(description="ID of the user who created this coach")

class Content(BaseModel):
    """Represents ingested content."""
    title: str = Field(description="Content title")
    content_type: ContentType = Field(description="Type of content")
    source_platform: str = Field(description="Original platform")
    topic_tags: List[str] = Field(description="Content topic classifications")
    key_concepts: List[str] = Field(description="Main concepts covered")
    difficulty_level: str = Field(description="Content difficulty rating")
    engagement_metrics: Dict[str, int] = Field(description="Views, likes, shares")
    creator_user_id: str = Field(description="ID of the user who created this content")

class LearningConcept(BaseModel):
    """Represents a learning concept or topic."""
    concept_name: str = Field(description="Name of the concept")
    category: str = Field(description="Concept category")
    difficulty_level: str = Field(description="Learning difficulty")
    prerequisites: List[str] = Field(description="Required prior knowledge")
    related_skills: List[str] = Field(description="Associated skills")

# NEW: Interaction tracking entities
class ChatInteraction(BaseModel):
    """Represents a chat interaction between user and coach."""
    message_content: str = Field(description="User's message content")
    response_content: str = Field(description="Coach's response content")
    interaction_type: str = Field(description="Question, clarification, practice, etc.")
    satisfaction_level: Optional[float] = Field(description="User satisfaction with response")
    topics_discussed: List[str] = Field(description="Topics covered in interaction")

class ContentConsumption(BaseModel):
    """Represents user consumption of content."""
    content_id: str = Field(description="Reference to consumed content")
    consumption_duration: float = Field(description="Time spent consuming content")
    completion_status: str = Field(description="Started, paused, completed, skipped")
    engagement_score: float = Field(description="Calculated engagement score")
    notes_taken: Optional[str] = Field(description="User notes during consumption")
```

## Custom Graphiti Edge Types (Updated)

```python
# app/schemas/graphiti_edges.py
from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from datetime import datetime

class CreatedBy(BaseModel):
    """Edge representing content creation relationship."""
    creation_date: datetime = Field(description="When content was created")
    platform: str = Field(description="Platform where created")
    original_url: Optional[str] = Field(description="Original content URL")

class Teaches(BaseModel):
    """Edge representing teaching relationship between user/coach and concept."""
    expertise_level: str = Field(description="Teaching expertise level")
    teaching_approach: str = Field(description="Method used to teach")
    content_examples: List[str] = Field(description="Example content covering this")

class LearnedFrom(BaseModel):
    """Edge representing user learning from content/coach."""
    interaction_date: datetime = Field(description="When interaction occurred")
    engagement_type: str = Field(description="Type of interaction")
    learning_outcome: Optional[str] = Field(description="What was learned")
    confidence_score: float = Field(description="User's confidence level")

class HasPreference(BaseModel):
    """Edge connecting user to their preferences - NEW."""
    preference_strength: float = Field(description="How strong this preference is")
    last_updated: datetime = Field(description="When preference was last updated")
    context: str = Field(description="Context where preference was observed")

class MadeProgress(BaseModel):
    """Edge representing user progress - ENHANCED."""
    start_level: str = Field(description="Starting proficiency level")
    current_level: str = Field(description="Current proficiency level")
    progress_date: datetime = Field(description="When progress was made")
    activities_completed: List[str] = Field(description="Activities that led to progress")
    time_invested: float = Field(description="Time spent achieving this progress")
    confidence_gain: float = Field(description="Increase in confidence")

class InteractedWith(BaseModel):
    """Edge representing user interaction with coach - NEW."""
    interaction_type: str = Field(description="Chat, voice, content_request, feedback")
    interaction_duration: float = Field(description="Duration of interaction")
    user_satisfaction: Optional[float] = Field(description="User satisfaction rating")
    topics_covered: List[str] = Field(description="Topics discussed")
    follow_up_needed: bool = Field(description="Whether follow-up is needed")

class ConsumerOf(BaseModel):
    """Edge representing user consumption of content - NEW."""
    consumption_date: datetime = Field(description="When content was consumed")
    completion_percentage: float = Field(description="How much was consumed")
    engagement_score: float = Field(description="Engagement level")
    led_to_action: bool = Field(description="Whether consumption led to action")

class Recommends(BaseModel):
    """Edge representing AI coach recommendation."""
    recommendation_type: str = Field(description="Type of recommendation")
    confidence_score: float = Field(description="AI confidence in recommendation")
    reasoning: str = Field(description="Why this was recommended")
    personalization_factors: List[str] = Field(description="Factors influencing recommendation")

class RelatedTo(BaseModel):
    """Edge representing general relationships between concepts."""
    relationship_type: str = Field(description="Type of relationship")
    strength: float = Field(description="Strength of relationship")
    context: Optional[str] = Field(description="Context where relationship applies")
```

## API Endpoints Design (Updated)

### Authentication & Authorization
```python
# app/api/v1/auth.py
from fastapi import APIRouter, Depends, HTTPException, status
from app.services.auth_service import AuthService
from app.models.auth import LoginRequest, TokenResponse, UserCreate

router = APIRouter(prefix="/auth", tags=["authentication"])

@router.post("/login", response_model=TokenResponse)
async def login(request: LoginRequest):
    """Login with Supabase authentication using publishable key."""
    pass

@router.post("/register", response_model=TokenResponse)
async def register(request: UserCreate):
    """Register new user with Supabase using publishable key."""
    pass

@router.post("/refresh", response_model=TokenResponse)
async def refresh_token():
    """Refresh JWT token."""
    pass

@router.post("/logout")
async def logout():
    """Logout user."""
    pass
```

### User Management (Merged Creator Functionality)
```python
# app/api/v1/users.py
from fastapi import APIRouter, Depends, HTTPException
from app.core.rbac import require_roles
from app.models.user import UserUpdate, UserResponse
from app.models.coach import CoachCreate, CoachUpdate, CoachResponse

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/profile", response_model=UserResponse)
async def get_user_profile():
    """Get current user's profile."""
    pass

@router.put("/profile", response_model=UserResponse)
async def update_user_profile(profile_data: UserUpdate):
    """Update user profile."""
    pass

@router.post("/roles/creator")
async def become_creator():
    """Add Creator role to user (self-service)."""
    pass

# CREATOR FUNCTIONALITY MERGED HERE
@router.post("/coaches", response_model=CoachResponse)
@require_roles(["Creator"])
async def create_coach(coach_data: CoachCreate):
    """Create new AI coach (requires Creator role)."""
    pass

@router.get("/coaches", response_model=List[CoachResponse])
@require_roles(["Creator"])
async def list_my_coaches():
    """List user's coaches."""
    pass

@router.put("/coaches/{coach_id}", response_model=CoachResponse)
@require_roles(["Creator"])
async def update_coach(coach_id: str, coach_data: CoachUpdate):
    """Update coach configuration."""
    pass

@router.post("/coaches/{coach_id}/publish")
@require_roles(["Creator"])
async def publish_coach(coach_id: str):
    """Publish coach for public access."""
    pass
```

### Real-time Progress Tracking (NEW)
```python
# app/api/v1/progress.py
from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends
from app.services.progress_service import ProgressService
from app.utils.websocket_manager import ConnectionManager

router = APIRouter(prefix="/progress", tags=["progress"])
manager = ConnectionManager()

@router.websocket("/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    """WebSocket for real-time progress updates."""
    await manager.connect(websocket, user_id)
    try:
        while True:
            # Keep connection alive and handle incoming messages
            data = await websocket.receive_text()
            # Process any client-side progress updates
    except WebSocketDisconnect:
        manager.disconnect(user_id)

@router.get("/jobs/{job_id}")
async def get_job_progress(job_id: str):
    """Get current progress of content ingestion job."""
    pass

@router.get("/jobs")
async def list_user_jobs():
    """List all ingestion jobs for current user."""
    pass
```

## Services Implementation (Updated)

### Knowledge Graph Service (Updated for User Graphs)
```python
# app/services/knowledge_graph_service.py
from graphiti_core import Graphiti
from graphiti_core.nodes import EpisodeType
from app.schemas.graphiti_entities import User, UserPreferences, UserProgress, Coach, Content
from app.schemas.graphiti_edges import HasPreference, MadeProgress, InteractedWith

class KnowledgeGraphService:
    def __init__(self, neo4j_uri: str, neo4j_user: str, neo4j_password: str):
        self.graphiti = Graphiti(
            neo4j_uri,
            neo4j_user, 
            neo4j_password,
            entity_types=[User, UserPreferences, UserProgress, Coach, Content],
            edge_types=[HasPreference, MadeProgress, InteractedWith]
        )
    
    async def create_user_graph(self, user_id: str) -> str:
        """Create individual knowledge graph for user progress/preferences."""
        graph_id = f"user_{user_id}"
        await self.graphiti.build_graph(graph_id)
        return graph_id
    
    async def create_coach_graph(self, coach_id: str, user_id: str) -> str:
        """Create new knowledge graph for a coach."""
        graph_id = f"coach_{coach_id}"
        await self.graphiti.build_graph(graph_id)
        return graph_id
    
    async def update_user_preferences(self, user_graph_id: str, preferences_data: dict):
        """Update user preferences in their personal graph."""
        episode = {
            "graph_id": user_graph_id,
            "content": f"User preferences update: {preferences_data}",
            "episode_type": EpisodeType.JSON,
            "metadata": {"type": "preferences_update", "timestamp": datetime.utcnow()}
        }
        await self.graphiti.add_episode(**episode)
    
    async def track_user_interaction(self, user_graph_id: str, coach_id: str, interaction_data: dict):
        """Track user interaction with coach in user's personal graph."""
        episode = {
            "graph_id": user_graph_id,
            "content": f"Interaction with coach {coach_id}: {interaction_data}",
            "episode_type": EpisodeType.JSON,
            "metadata": {"type": "coach_interaction", "coach_id": coach_id}
        }
        await self.graphiti.add_episode(**episode)
    
    async def ingest_content(self, coach_graph_id: str, content: str, metadata: dict):
        """Ingest content into coach knowledge graph."""
        episode = {
            "graph_id": coach_graph_id,
            "content": content,
            "episode_type": EpisodeType.TEXT,
            "metadata": metadata
        }
        await self.graphiti.add_episode(**episode)
    
    async def search_personalized_knowledge(self, coach_graph_id: str, user_graph_id: str, query: str):
        """Search coach knowledge with user context from personal graph."""
        # Get user context from personal graph
        user_context = await self.graphiti.search(
            graph_id=user_graph_id,
            query="user preferences and learning progress"
        )
        
        # Search coach knowledge with user context
        results = await self.graphiti.search(
            graph_id=coach_graph_id,
            query=query,
            context=user_context
        )
        return results
```

### Progress Service (NEW)
```python
# app/services/progress_service.py
from app.utils.websocket_manager import ConnectionManager
from app.database.supabase_client import supabase

class ProgressService:
    def __init__(self):
        self.manager = ConnectionManager()
    
    async def update_job_progress(self, job_id: str, progress: float, current_step: str, processed_items: int):
        """Update job progress and notify connected clients."""
        # Update database
        await supabase.table("content_ingestion_jobs").update({
            "progress_percentage": progress,
            "current_step": current_step,
            "processed_items": processed_items
        }).eq("job_id", job_id).execute() # Updated: use prefixed column name
        
        # Get job details to find user_id
        job_result = await supabase.table("content_ingestion_jobs").select("user_id").eq("job_id", job_id).execute() # Updated: use prefixed column name
        
        if job_result.data:
            user_id = job_result.data[0]["user_id"]
            
            # Send real-time update
            progress_update = {
                "job_id": job_id,
                "progress": progress,
                "current_step": current_step,
                "processed_items": processed_items
            }
            
            await self.manager.send_personal_message(progress_update, user_id)
    
    async def complete_job(self, job_id: str):
        """Mark job as completed and notify user."""
        await supabase.table("content_ingestion_jobs").update({
            "status": "completed",
            "progress_percentage": 100.0,
            "completed_at": datetime.utcnow()
        }).eq("job_id", job_id).execute() # Updated: use prefixed column name
        
        # Notify user of completion
        job_result = await supabase.table("content_ingestion_jobs").select("user_id").eq("job_id", job_id).execute() # Updated: use prefixed column name
        if job_result.data:
            user_id = job_result.data[0]["user_id"]
            await self.manager.send_personal_message({"job_id": job_id, "status": "completed"}, user_id)
```

### WebSocket Manager (NEW)
```python
# app/utils/websocket_manager.py
from fastapi import WebSocket
from typing import Dict, List
import json

class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, WebSocket] = {}
    
    async def connect(self, websocket: WebSocket, user_id: str):
        await websocket.accept()
        self.active_connections[user_id] = websocket
    
    def disconnect(self, user_id: str):
        if user_id in self.active_connections:
            del self.active_connections[user_id]
    
    async def send_personal_message(self, message: dict, user_id: str):
        if user_id in self.active_connections:
            websocket = self.active_connections[user_id]
            await websocket.send_text(json.dumps(message))
    
    async def broadcast(self, message: dict):
        for connection in self.active_connections.values():
            await connection.send_text(json.dumps(message))
```

## Background Workers (Updated)

### Content Ingestion Worker (With Progress)
```python
# app/workers/content_ingestion.py
from celery import Celery
from app.services.content_service import ContentService
from app.services.progress_service import ProgressService
from app.database.supabase_client import supabase

celery_app = Celery("evermynd", broker="redis://localhost:6379")

@celery_app.task
async def ingest_youtube_channel(job_id: str, channel_url: str, coach_graph_id: str):
    """Background task for YouTube content ingestion with progress tracking."""
    progress_service = ProgressService()
    
    try:
        # Update job status to processing
        await progress_service.update_job_progress(job_id, 0, "Starting YouTube channel analysis", 0)
        
        # Get channel videos
        content_service = ContentService(kg_service)
        videos = await content_service.youtube.get_channel_videos(channel_url)
        
        # Update total items
        await supabase.table("content_ingestion_jobs").update({
            "total_items": len(videos)
        }).eq("job_id", job_id).execute() # Updated: use prefixed column name
        
        # Process each video with progress updates
        for i, video in enumerate(videos):
            progress = (i / len(videos)) * 100
            await progress_service.update_job_progress(
                job_id, 
                progress, 
                f"Processing video: {video['title']}", 
                i
            )
            
            transcript = await content_service.youtube.get_transcript(video['id'])
            metadata = {
                "source": "youtube",
                "video_id": video['id'],
                "title": video['title'],
                "url": video['url'],
                "duration": video['duration']
            }
            
            await content_service.kg_service.ingest_content(
                graph_id=coach_graph_id,
                content=transcript,
                metadata=metadata
            )
        
        # Complete job
        await progress_service.complete_job(job_id)
        
    except Exception as e:
        # Mark failed and notify user
        await supabase.table("content_ingestion_jobs").update({
            "status": "failed",
            "error_message": str(e)
        }).eq("job_id", job_id).execute() # Updated: use prefixed column name
        
        job_result = await supabase.table("content_ingestion_jobs").select("user_id").eq("job_id", job_id).execute() # Updated: use prefixed column name
        if job_result.data:
            user_id = job_result.data[0]["user_id"]
            await progress_service.manager.send_personal_message(
                {"job_id": job_id, "status": "failed", "error": str(e)}, 
                user_id
            )
        raise
```

## Configuration & Environment (Updated)

### Environment Variables
```bash
# .env.example
# Supabase (Updated authentication approach)
SUPABASE_URL=your_supabase_url
SUPABASE_PUBLISHABLE_KEY=sb_publishable_...  # Updated: use publishable key
SUPABASE_SECRET_KEY=sb_secret_...            # Updated: use secret key (not service_key)

# Neo4j/FalkorDB
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=password

# OpenAI (only - removed Anthropic)
OPENAI_API_KEY=your_openai_key

# YouTube API
YOUTUBE_API_KEY=your_youtube_key

# Instagram
INSTAGRAM_ACCESS_TOKEN=your_instagram_token

# Redis
REDIS_URL=redis://localhost:6379

# App Settings
SECRET_KEY=your_secret_key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

### FastAPI Configuration (Updated)
```python
# app/config.py
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Database (Updated authentication)
    supabase_url: str
    supabase_publishable_key: str  # Updated: publishable key
    supabase_secret_key: str       # Updated: secret key
    neo4j_uri: str = "bolt://localhost:7687"
    neo4j_user: str = "neo4j"
    neo4j_password: str
    
    # LLM Services (OpenAI only)
    openai_api_key: str
    
    # External APIs
    youtube_api_key: str
    instagram_access_token: str
    
    # Security
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # Background Tasks
    redis_url: str = "redis://localhost:6379"
    
    class Config:
        env_file = ".env"

settings = Settings()
```

### Supabase Client (Updated Authentication)
```python
# app/database/supabase_client.py
from supabase import create_client, Client
from app.config import settings

# Use publishable key for general operations
supabase: Client = create_client(
    settings.supabase_url, 
    settings.supabase_publishable_key
)

# Use secret key for admin operations (when needed)
supabase_admin: Client = create_client(
    settings.supabase_url, 
    settings.supabase_secret_key
)
```

## Key Improvements Summary

### 1. Simplified User Model
- **Before**: Separate Creator and User entities with complex relationships
- **After**: Single User entity with role-based permissions (Consumer, Creator, Admin)
- **Benefits**: Reduced complexity, easier role transitions, cleaner data model

### 2. Enhanced User Experience Tracking
- **Before**: Static user preferences in database
- **After**: Dynamic, temporal user modeling in individual knowledge graphs
- **Benefits**: Personalized learning paths, better recommendation system, temporal relationship tracking

### 3. Real-time Creator Experience
- **Before**: No progress feedback during content ingestion
- **After**: WebSocket-based real-time progress updates with detailed step tracking
- **Benefits**: Better creator experience, transparency in processing, ability to handle large ingestion jobs

### 4. Modern Authentication
- **Before**: Deprecated service_role key usage
- **After**: Proper publishable/secret key usage with enhanced RLS policies
- **Benefits**: Better security practices, easier key rotation, improved compliance

### 5. Focused AI Integration
- **Before**: Multiple LLM providers (OpenAI + Anthropic)
- **After**: OpenAI-only implementation
- **Benefits**: Simpler integration, reduced external dependencies, easier maintenance

This updated implementation plan provides a more robust, scalable, and user-friendly foundation for the EverMynd backend while incorporating modern best practices for authentication, real-time communication, and knowledge graph-based user modeling.