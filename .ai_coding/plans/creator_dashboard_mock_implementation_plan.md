# Creator Dashboard Mock Implementation Plan

## Overview
Implementation plan for the Creator dashboard in the Flutter frontend, using mock data and closely following the reference React TypeScript dashboard design from `/Users/mepla/Downloads/Creator Dashboard Setup`.

## Architecture Overview

The Creator dashboard will be integrated into the existing Flutter frontend app (`frontend/`) and will be role-based - only users with "Creator" role can access it. The dashboard will closely follow the reference design patterns from the React TypeScript implementation.

## Core Dashboard Structure

### 1. Navigation & Layout
- **Sidebar Navigation** (similar to reference):
  - Overview (dashboard home)
  - Coaches (manage AI coaches)
  - Knowledge Base (content ingestion)
  - Settings (coach configuration)
- **Responsive Design**: Follow the multiplatform guidelines in `.ai_coding/guidelines/flutter-multiplatform-development-guide.md`
- **Theme Integration**: Use existing `DashboardTheme.lightTheme` with dashboard-specific extensions

### 2. Dashboard Screens to Implement

#### A. Overview Screen (`DashboardOverviewScreen`)
**Mock Data Features:**
- **Stats Cards Grid**:
  - Total Subscribers: 456 (+23 this week)
  - Total Revenue: $12,450 ($1,200 this month)
  - Knowledge Articles: 127 (+15 this week)
  - Conversations: 1,234 (+89 today)
- **Recent Activity Feed**: Coach creations, knowledge updates, conversations
- **Quick Actions Panel**: Create coach, add knowledge, view analytics
- **Performance Chart Placeholder**: Mock chart visualization area

#### B. Coaches Screen (`CoachesManagementScreen`)
**Mock Data Features:**
- **Coach Cards Grid**: Display 4-6 mock coaches
  - Marketing Expert (Active, 156 conversations, 23 articles)
  - Sales Assistant (Active, 89 conversations, 18 articles)
  - Customer Support Bot (Active, 234 conversations, 45 articles)
  - Product Guide (Paused, 67 conversations, 32 articles)
- **Search/Filter**: Client-side filtering of coaches
- **Create Coach Dialog**: Form with name and description
- **Coach Actions**: Edit, Settings, Test Chat, Delete buttons

#### C. Knowledge Base Screen (`KnowledgeBaseScreen`)
**Mock Data Features:**
- **Upload Interface**: File drop zone for PDF, EPUB, Markdown
- **Social Media Integration**: YouTube channel, Instagram page input forms
- **Knowledge Articles List**: Display mock ingested content
- **Processing Status**: Show mock ingestion progress
- **Content Categories**: Organize by source type (YouTube, Instagram, Files)

#### D. Settings Screen (`CoachSettingsScreen`)
**Mock Data Features:**
- **Coach Configuration**: Select which coach to configure
- **QA Section**: List of sample Q&A pairs for quality assurance
- **Features Toggle**: Voice chat, content preview, etc.
- **Pricing Configuration**: Subscription tier settings
- **Publish Options**: Generate coach link, publish status

### 3. Flutter Implementation Details

#### File Structure
```
frontend/lib/screens/dashboard/
├── dashboard_wrapper.dart          # Role-based access wrapper
├── dashboard_main_screen.dart      # Main dashboard with navigation
├── overview/
│   └── dashboard_overview_screen.dart
├── coaches/
│   ├── coaches_management_screen.dart
│   ├── coach_card_widget.dart
│   └── create_coach_dialog.dart
├── knowledge/
│   ├── knowledge_base_screen.dart
│   ├── upload_widget.dart
│   └── social_integration_widget.dart
└── settings/
    └── coach_settings_screen.dart
```

#### Mock Data Services
```
frontend/lib/services/mock/
├── mock_dashboard_service.dart     # Dashboard stats and activity
├── mock_coaches_service.dart       # Coaches management
└── mock_knowledge_service.dart     # Knowledge base content
```

#### Widgets & Components
```
frontend/lib/widgets/dashboard/
├── dashboard_sidebar.dart          # Navigation sidebar
├── stats_card.dart                # Metric display cards
├── activity_feed.dart             # Recent activity list
├── coach_status_badge.dart        # Active/Paused status
└── upload_drop_zone.dart          # File upload interface
```

### 4. Design System Alignment

#### Visual Elements (matching reference)
- **Glassmorphism Effects**: `backdrop-blur-xl`, translucent backgrounds
- **Gradient Accents**: Blue-to-purple gradients for highlights
- **Card System**: Elevated cards with hover effects and shadows
- **Color Palette**: 
  - Primary: Blue (#3B82F6) to Purple (#8B5CF6)
  - Background: Gradient from slate to blue/indigo
  - Text: Gradient text for headings
- **Typography**: Semibold headings, gradient text effects

#### Flutter Implementation Strategy
- **Custom Theme Extension**: Extend existing theme with dashboard-specific colors
- **Reusable Components**: Create dashboard-specific widget library
- **Animation**: Subtle hover effects, smooth transitions
- **Responsive Breakpoints**: Follow existing adaptive design patterns

### 5. Role-Based Access Implementation

#### Access Control
- **Role Check**: Verify user has "Creator" role from `AuthState`
- **Navigation Integration**: Add dashboard menu item only for creators
- **Route Protection**: Wrap dashboard routes with role verification

#### User Flow Integration
- **From Home Screen**: Add "Dashboard" button for creator users
- **Navigation Drawer**: Include dashboard option in drawer menu
- **Deep Linking**: Support direct dashboard navigation

## Post-Login Redirect Strategy

### Current Flow Analysis
Currently in `main.dart:64`, authenticated users are redirected to `HomeScreen`. We need to implement role-based routing:

### Proposed Redirect Logic
1. **User Authentication State Check**: After successful login via `AuthBloc`
2. **Role Detection**: Check if user has "Creator" role in `AuthAuthenticated.user.roles`
3. **Conditional Redirect**:
   - If user has "Creator" role → Redirect to **Dashboard**
   - If user only has "Consumer" role → Redirect to current **HomeScreen**
   - If user has both roles → Provide choice or default to Dashboard with option to switch

### Implementation Approach

#### Option 1: Automatic Dashboard Redirect (Recommended)
```dart
// In AuthWrapper (main.dart)
if (state is AuthAuthenticated) {
  if (state.user.roles.contains('Creator')) {
    return const DashboardMainScreen();
  }
  return const HomeScreen();
}
```

#### Option 2: Landing Page with Role Selection
```dart
// Create intermediate landing screen for users with multiple roles
if (state is AuthAuthenticated) {
  if (state.user.roles.contains('Creator') && state.user.roles.length > 1) {
    return const RoleSelectorScreen(); // Let user choose interface
  } else if (state.user.roles.contains('Creator')) {
    return const DashboardMainScreen();
  }
  return const HomeScreen();
}
```

#### Option 3: Enhanced Home Screen with Dashboard Access
- Keep existing HomeScreen as default
- Add prominent "Dashboard" button/card for creator users
- Maintain current user experience while providing dashboard access

### Navigation Integration
- **Bottom Navigation**: Add dashboard tab for creator users
- **App Drawer**: Include dashboard option in navigation drawer
- **Floating Action**: Quick access button for switching between interfaces

## Mock Data Specifications

### Dashboard Stats (Static Mock Data)
```dart
class MockDashboardStats {
  static const stats = {
    'subscribers': {'value': 456, 'change': '+23 this week'},
    'revenue': {'value': '\$12,450', 'change': '\$1,200 this month'},
    'articles': {'value': 127, 'change': '+15 this week'},
    'conversations': {'value': 1234, 'change': '+89 today'},
  };
  
  static const recentActivity = [
    {
      'action': 'Created new coach',
      'coach': 'Marketing Expert',
      'time': '2 hours ago',
    },
    {
      'action': 'Updated knowledge base',
      'coach': 'Sales Assistant',
      'time': '4 hours ago',
    },
    {
      'action': 'New conversation started',
      'coach': 'Customer Support Bot',
      'time': '6 hours ago',
    },
    {
      'action': 'Knowledge article added',
      'coach': 'Product Guide',
      'time': '1 day ago',
    },
  ];
}
```

### Coach Models (Mock Data)
```dart
class MockCoach {
  final String id;
  final String name;
  final String description;
  final String status; // 'active' or 'paused'
  final int conversations;
  final int knowledgeArticles;
  final String lastActive;
  final String avatarUrl;
  
  const MockCoach({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.conversations,
    required this.knowledgeArticles,
    required this.lastActive,
    required this.avatarUrl,
  });
}

class MockCoachesData {
  static const coaches = [
    MockCoach(
      id: '1',
      name: 'Marketing Expert',
      description: 'Helps with marketing strategies, content creation, and campaign optimization.',
      status: 'active',
      conversations: 156,
      knowledgeArticles: 23,
      lastActive: '2 hours ago',
      avatarUrl: 'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=40&h=40&fit=crop&crop=face',
    ),
    MockCoach(
      id: '2',
      name: 'Sales Assistant',
      description: 'Assists with sales processes, lead qualification, and customer interactions.',
      status: 'active',
      conversations: 89,
      knowledgeArticles: 18,
      lastActive: '30 minutes ago',
      avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=40&h=40&fit=crop&crop=face',
    ),
    MockCoach(
      id: '3',
      name: 'Customer Support Bot',
      description: 'Provides 24/7 customer support and handles common inquiries.',
      status: 'active',
      conversations: 234,
      knowledgeArticles: 45,
      lastActive: '5 minutes ago',
      avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=40&h=40&fit=crop&crop=face',
    ),
    MockCoach(
      id: '4',
      name: 'Product Guide',
      description: 'Helps users navigate and understand product features.',
      status: 'paused',
      conversations: 67,
      knowledgeArticles: 32,
      lastActive: '1 day ago',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face',
    ),
  ];
}
```

### Knowledge Base Content (Mock Data)
```dart
class MockKnowledgeArticle {
  final String id;
  final String title;
  final String source; // 'youtube', 'instagram', 'file'
  final String type; // 'video', 'image', 'pdf', 'epub', 'markdown'
  final DateTime createdAt;
  final String status; // 'processing', 'ready', 'error'
  final String? url;
  final int? size; // for files
  
  const MockKnowledgeArticle({
    required this.id,
    required this.title,
    required this.source,
    required this.type,
    required this.createdAt,
    required this.status,
    this.url,
    this.size,
  });
}

class MockKnowledgeData {
  static final articles = [
    MockKnowledgeArticle(
      id: '1',
      title: 'Marketing Fundamentals Course',
      source: 'youtube',
      type: 'video',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'ready',
      url: 'https://youtube.com/watch?v=example1',
    ),
    MockKnowledgeArticle(
      id: '2',
      title: 'Instagram Growth Strategy',
      source: 'instagram',
      type: 'image',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      status: 'processing',
    ),
    MockKnowledgeArticle(
      id: '3',
      title: 'Sales Process Guide.pdf',
      source: 'file',
      type: 'pdf',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'ready',
      size: 1024000, // 1MB
    ),
  ];
}
```

## Implementation Summary

This plan provides a comprehensive Creator dashboard implementation that:

1. **Maintains Design Consistency**: Closely follows the reference React TypeScript dashboard design
2. **Uses Mock Data**: All data will be static/mock until backend integration
3. **Follows Flutter Guidelines**: Adheres to the multiplatform development guide
4. **Role-Based Access**: Only creator users can access the dashboard
5. **Responsive Design**: Works across web, mobile, and desktop platforms
6. **Modular Architecture**: Clean separation of concerns with reusable components

The implementation will create a pixel-perfect Flutter version of the reference dashboard with all the visual elements (glassmorphism, gradients, animations) while using entirely mock data for all statistics, coaches, and knowledge base content.

## Next Steps

1. Create the file structure as outlined above
2. Implement mock data services first
3. Build the dashboard navigation and wrapper components
4. Implement each screen starting with Overview
5. Add role-based routing and navigation integration
6. Test across all target platforms (Web, Android, iOS)
7. Ensure responsive design works on all screen sizes