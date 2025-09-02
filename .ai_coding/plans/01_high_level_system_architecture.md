# EverMynd High-Level System Architecture

## Overview
EverMynd is a human-centric AI coaching platform that enables personalized coaching at scale. The system consists of three main components: an app backend, an app frontend, and a public landing page.

## System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Mobile Apps   │    │    Web App      │    │  Landing Page   │
│   (Flutter)     │    │   (Flutter)     │    │    (Vue.js)     │
│  - iOS/Android  │    │  - Creator UI   │    │  - Marketing    │
│  - Consumer UI  │    │  - Consumer UI  │    │  - Lead Gen     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   API Gateway   │
                    │   (FastAPI)     │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │  Backend Core   │
                    │   (Python)      │
                    └─────────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                       │                        │
┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐
│  Supabase   │    │   Neo4j/    │    │     External        │
│             │    │  FalkorDB   │    │    Services         │
│- Auth       │    │             │    │                     │
│- User Mgmt  │    │- Knowledge  │    │- OpenAI/Claude      │
│- RBAC       │    │  Graph      │    │- YouTube API        │
└─────────────┘    │- Graphiti   │    │- Instagram API      │
                   │- RAG        │    │- Content Processing │
                   └─────────────┘    └─────────────────────┘
```

## Core Components

### 1. Frontend Applications
- **Flutter Web/Mobile App**: Primary user interface supporting both creators and consumers
- **Vue.js Landing Page**: Marketing site for creator acquisition
- **Responsive Design**: Single codebase for web, iOS, and Android

### 2. Backend Services
- **Python FastAPI**: RESTful API and GraphQL endpoints
- **Authentication Layer**: Supabase integration for user management
- **RBAC System**: Role-based access control (Consumer, Creator, Admin)
- **Knowledge Graph Engine**: Graphiti-powered temporal knowledge graphs

### 3. Data Layer
- **Supabase**: User authentication, profiles, and metadata
- **Neo4j/FalkorDB**: Knowledge graph storage and querying
- **Temporal Graph Model**: User progress, preferences, and coaching relationships

### 4. External Integrations
- **LLM Services**: OpenAI/Anthropic for AI coach interactions
- **Content Ingestion**: YouTube and Instagram API integrations
- **File Processing**: PDF, EPUB, and Markdown parsers

## Data Flow Architecture

### Content Ingestion Flow
```
Creator Upload → Content Parser → Knowledge Graph → AI Coach Training
     ↓               ↓               ↓                    ↓
YouTube/IG      Text Extraction  Graphiti Nodes    Personalized Responses
   APIs         Media Processing   & Edges           & Content Feed
```

### User Interaction Flow
```
User Chat → Backend API → Knowledge Graph Query → LLM Processing → Response
    ↓            ↓              ↓                      ↓             ↓
 User App    Auth Check    Graphiti Search      AI Coach Logic   Personalized
             RBAC          Context Retrieval     Memory Update      Content
```

### Content Feed Flow
```
User Preferences → AI Generation → Content Personalization → Feed Display
       ↓                ↓                    ↓                    ↓
   Graph Memory    Multi-modal Content   User-specific Posts   Interactive UI
   Progress Data      Text/Image/Video      Based on Progress     Engagement
```

## Key Architectural Patterns

### 1. Microservices Design
- **Separation of Concerns**: Clear boundaries between auth, content, and AI services
- **Scalability**: Independent scaling of different system components
- **Maintainability**: Isolated development and deployment cycles

### 2. Temporal Knowledge Graphs
- **Dynamic Relationships**: Evolving user-coach relationships over time
- **Memory Persistence**: Long-term user progress and preference tracking
- **Contextual Retrieval**: RAG with temporal and semantic awareness

### 3. Multi-Tenancy
- **Creator Isolation**: Separate knowledge graphs per creator
- **Shared Infrastructure**: Common services with tenant separation
- **Role-Based Access**: Granular permissions for different user types

### 4. Event-Driven Architecture
- **Content Processing**: Asynchronous ingestion of YouTube/Instagram content
- **User Activity**: Real-time tracking of interactions and engagement
- **AI Generation**: Background processing of personalized content

## Security & Compliance

### Authentication & Authorization
- **OAuth Integration**: Supabase-managed social logins
- **JWT Tokens**: Secure API authentication
- **RBAC Implementation**: Role-based resource access control

### Data Privacy
- **Creator Content Isolation**: Separate knowledge graphs per creator
- **User Data Protection**: Encrypted personal information and preferences
- **Content Rights**: Proper handling of ingested social media content

## Scalability Considerations

### Horizontal Scaling
- **Stateless Backend**: Load balancer-friendly API design
- **Database Sharding**: Knowledge graph partitioning by creator
- **CDN Integration**: Static content delivery optimization

### Performance Optimization
- **Caching Strategy**: Redis for frequently accessed data
- **Async Processing**: Background jobs for content ingestion
- **Query Optimization**: Efficient graph traversal and search

## Technology Stack Summary

| Component | Technology | Purpose |
|-----------|------------|---------|
| Frontend | Flutter 3.35+ | Cross-platform app development |
| Backend | Python 3.12+ FastAPI | RESTful API and business logic |
| Knowledge Graph | Graphiti + Neo4j/FalkorDB | Temporal graph storage and RAG |
| Authentication | Supabase | User management and RBAC |
| Landing Page | Vue.js + Tailwind | Marketing site |
| AI Services | OpenAI/Anthropic | LLM inference and generation |
| Content APIs | YouTube/Instagram | Social media content ingestion |

## Deployment Architecture

### Development Environment
- **Local Development**: Docker Compose setup
- **Database**: FalkorDB for faster local development
- **API Gateway**: Local FastAPI development server

### Production Environment
- **Container Orchestration**: Kubernetes/Docker Swarm
- **Database**: Managed Neo4j or cloud FalkorDB
- **Load Balancing**: Application-level load balancing
- **Monitoring**: Comprehensive logging and metrics collection

This architecture provides a solid foundation for building EverMynd's coaching platform with emphasis on scalability, maintainability, and user experience across all touchpoints.