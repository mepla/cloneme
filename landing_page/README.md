# EverMynd Landing Page

A modern, responsive landing page for EverMynd - a human-centric AI coaching platform that enables personalized coaching at scale.

## 🚀 Features

- **Modern Design**: Clean, professional design with glass morphism effects
- **Dark/Light Mode**: Complete theme switching with system preference detection
- **Responsive**: Optimized for all devices (mobile, tablet, desktop)
- **Animations**: Smooth animations using CSS transitions and custom keyframes
- **Interactive Components**: 
  - Aurora background animation
  - Typing text animations
  - Animated beams connecting elements
  - Interactive coach configuration demo
  - Real-time chat interface mockup
  - Personalized content feed simulation

## 🛠 Tech Stack

- **Vue.js 3** - Progressive JavaScript framework
- **TypeScript** - Type-safe JavaScript
- **Tailwind CSS** - Utility-first CSS framework
- **Vite** - Fast build tool
- **Pinia** - State management
- **Lucide Vue** - Beautiful icons
- **VueUse** - Composition utilities

## 📁 Project Structure

```
src/
├── components/
│   ├── sections/           # Page sections
│   │   ├── HeroSection.vue
│   │   ├── ForCreatorsSection.vue
│   │   └── ForUsersSection.vue
│   ├── ui/                # Reusable UI components
│   │   ├── AuroraBackground.vue
│   │   ├── AnimatedBeam.vue
│   │   ├── TypingText.vue
│   │   ├── AnimatedModal.vue
│   │   └── ThemeSwitcher.vue
│   └── forms/             # Form components
│       └── EarlyAccessForm.vue
├── composables/           # Vue composables
│   └── useTheme.ts
├── stores/               # Pinia stores
│   └── theme.ts
├── assets/              # Static assets
│   └── styles/
│       └── main.css
└── views/              # Page views
    └── LandingView.vue
```

## 🎨 Design System

### Colors

**Light Mode:**
- Primary: `#3b82f6` (Blue-500)
- Secondary: `#a5b4fc` (Indigo-300)
- Background: `#ffffff`
- Text: `#0f172a`

**Dark Mode:**
- Primary: `#60a5fa` (Blue-400)
- Secondary: `#a5b4fc` (Indigo-300)
- Background: `#0f172a`
- Text: `#f1f5f9`

### Animations

- **Aurora Background**: 60s linear infinite gradient animation
- **Typing Text**: Character-by-character text reveal
- **Animated Beams**: SVG path animations with gradient effects
- **Slide Transitions**: Smooth enter/exit animations

## 🚀 Getting Started

### Prerequisites

- Node.js 18+
- npm or yarn

### Installation

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start development server:
   ```bash
   npm run dev
   ```

3. Build for production:
   ```bash
   npm run build
   ```

4. Preview production build:
   ```bash
   npm run preview
   ```

## 📱 Responsive Breakpoints

- **Mobile**: 320px - 767px
- **Tablet**: 768px - 1023px
- **Desktop**: 1024px - 1279px
- **Large Desktop**: 1280px+

## ♿ Accessibility Features

- Semantic HTML structure
- ARIA labels and roles
- Keyboard navigation support
- Focus management
- Color contrast compliance (WCAG 2.1)
- Reduced motion preferences

## 🔧 Customization

### Theme Colors

Update colors in `tailwind.config.js`:

```javascript
theme: {
  extend: {
    colors: {
      primary: {
        // Your custom colors
      }
    }
  }
}
```

### Animations

Modify animations in `src/assets/styles/main.css`:

```css
@keyframes yourAnimation {
  /* Your keyframes */
}
```

## 📊 Performance Optimizations

- **Lazy Loading**: Components loaded on demand
- **Image Optimization**: WebP format with fallbacks
- **Code Splitting**: Vendor and route-based splitting
- **CSS Purging**: Unused Tailwind classes removed
- **Tree Shaking**: Dead code elimination

## 🔗 Key Components

### HeroSection
- Aurora background animation
- Problem-solution flow
- Three-step visualization
- Animated beams connecting elements

### ForCreatorsSection
- Interactive coach configuration
- Real-time preview updates
- Value proposition cards
- Statistics display

### ForUsersSection
- Chat interface mockup
- Content feed simulation
- Progress tracking
- Multi-modal features

### UI Components
- **AuroraBackground**: Animated gradient background
- **TypingText**: Character-by-character text animation
- **AnimatedBeam**: SVG path animations between elements
- **AnimatedModal**: Smooth modal transitions
- **ThemeSwitcher**: Theme toggle with system detection

## 🚀 Deployment

The application is ready for deployment to any static hosting service:

- **Vercel**: `vercel`
- **Netlify**: Drag and drop `dist` folder
- **GitHub Pages**: Configure GitHub Actions
- **AWS S3**: Upload `dist` folder

## 📄 License

This project is part of the EverMynd platform. All rights reserved.