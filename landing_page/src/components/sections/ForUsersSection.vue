<template>
  <section class="for-users-section py-16 bg-gradient-to-br from-purple-50 to-pink-50 dark:from-slate-900 dark:to-slate-800">
    <div class="container mx-auto px-6">
      <div class="section-header text-center mb-16">
        <h2 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-6">
          For your
          <span class="gradient-text">users</span>
        </h2>
        <p class="text-xl text-gray-600 dark:text-gray-300 leading-relaxed max-w-3xl mx-auto">
          Give your audience an unprecedented learning experience with personalized AI coaching that adapts to their needs.
        </p>
      </div>

      <div class="grid lg:grid-cols-2 gap-8 lg:gap-16 items-start justify-items-center lg:justify-items-start">
        <!-- Chat Interface Demo -->
        <div class="chat-demo w-full max-w-lg lg:max-w-none mx-auto lg:mx-0">
          <div class="demo-container glass-card rounded-3xl p-4 lg:p-6 shadow-2xl w-full overflow-hidden">
            <div class="demo-header flex items-center justify-between mb-6">
              <div class="flex items-center space-x-3">
                <div class="w-10 h-10 rounded-full bg-gradient-to-r from-purple-500 to-pink-500 flex items-center justify-center">
                  <span class="text-white font-bold">SC</span>
                </div>
                <div>
                  <div class="font-semibold text-gray-900 dark:text-white">Sarah's Coach</div>
                  <div class="flex items-center space-x-1 text-sm text-green-500">
                    <div class="w-2 h-2 bg-green-500 rounded-full"></div>
                    <span>Online</span>
                  </div>
                </div>
              </div>
              <button class="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors">
                <PhoneCall class="h-5 w-5 text-gray-600 dark:text-gray-300" />
              </button>
            </div>

            <!-- Chat Messages -->
            <div class="chat-messages space-y-4 h-96 overflow-y-auto mb-4">
              <div
                v-for="(message, index) in chatMessages"
                :key="index"
                class="message"
                :class="message.sender === 'user' ? 'user-message' : 'coach-message'"
                :style="{ animationDelay: `${index * 800}ms` }"
              >
                <div
                  class="message-bubble max-w-[280px] sm:max-w-xs p-3 rounded-2xl"
                  :class="message.sender === 'user' 
                    ? 'bg-primary-500 text-white ml-auto' 
                    : 'bg-white dark:bg-gray-800 text-gray-900 dark:text-white border border-gray-200 dark:border-gray-700'"
                >
                  <div v-if="message.sender === 'coach' && message.typing" class="typing-indicator">
                    <div class="typing-dots flex space-x-1">
                      <div class="dot w-2 h-2 bg-gray-400 rounded-full animate-pulse"></div>
                      <div class="dot w-2 h-2 bg-gray-400 rounded-full animate-pulse" style="animation-delay: 0.2s"></div>
                      <div class="dot w-2 h-2 bg-gray-400 rounded-full animate-pulse" style="animation-delay: 0.4s"></div>
                    </div>
                  </div>
                  <TypingText
                    v-else
                    :text="message.text"
                    :delay="index * 800 + 500"
                    :duration="30"
                    class="text-sm"
                  />
                </div>
                
                <!-- Message Features -->
                <div v-if="message.features" class="message-features mt-2 space-y-2">
                  <!-- Progress Tracking -->
                  <div v-if="message.features.progress" class="progress-card p-3 bg-blue-50 dark:bg-blue-900/20 rounded-lg border border-blue-200 dark:border-blue-800">
                    <div class="flex items-center justify-between mb-2">
                      <span class="text-sm font-medium text-blue-900 dark:text-blue-100">Nutrition Goal Progress</span>
                      <span class="text-sm text-blue-600 dark:text-blue-400">{{ message.features.progress }}%</span>
                    </div>
                    <div class="progress-bar w-full bg-blue-200 dark:bg-blue-800 rounded-full h-2">
                      <div 
                        class="progress-fill bg-blue-500 h-2 rounded-full transition-all duration-1000"
                        :style="{ width: `${message.features.progress}%` }"
                      ></div>
                    </div>
                  </div>

                  <!-- Reference Links -->
                  <div v-if="message.features.references" class="references space-y-2">
                    <div
                      v-for="(ref, refIndex) in message.features.references"
                      :key="refIndex"
                      class="reference-card p-3 bg-gray-50 dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 hover:border-primary-300 dark:hover:border-primary-700 transition-colors cursor-pointer"
                    >
                      <div class="flex items-center space-x-3">
                        <div class="reference-icon">
                          <Youtube v-if="ref.type === 'youtube'" class="h-5 w-5 text-red-500" />
                          <FileText v-else class="h-5 w-5 text-blue-500" />
                        </div>
                        <div class="flex-1">
                          <div class="text-sm font-medium text-gray-900 dark:text-white">{{ ref.title }}</div>
                          <div class="text-xs text-gray-500 dark:text-gray-400">{{ ref.source }}</div>
                        </div>
                        <ExternalLink class="h-4 w-4 text-gray-400" />
                      </div>
                    </div>
                  </div>

                  <!-- Voice Message -->
                  <div v-if="message.features.voice" class="voice-message p-3 bg-green-50 dark:bg-green-900/20 rounded-lg border border-green-200 dark:border-green-800">
                    <div class="flex items-center space-x-3">
                      <button class="voice-play-btn w-8 h-8 bg-green-500 text-white rounded-full flex items-center justify-center hover:bg-green-600 transition-colors">
                        <Play class="h-4 w-4" />
                      </button>
                      <div class="voice-waveform flex items-center space-x-1 flex-1">
                        <div v-for="n in 12" :key="n" class="wave-bar w-1 bg-green-400 rounded-full transition-all duration-300" :style="{ height: `${Math.random() * 20 + 5}px` }"></div>
                      </div>
                      <span class="text-sm text-green-600 dark:text-green-400">0:24</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Chat Input -->
            <div class="chat-input flex items-center space-x-2 p-3 bg-gray-50 dark:bg-gray-800 rounded-xl w-full">
              <input
                type="text"
                placeholder="Ask your coach anything..."
                class="flex-1 bg-transparent text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 focus:outline-none text-sm"
                readonly
              />
              <button class="p-2 text-gray-600 dark:text-gray-300 hover:text-primary-500 transition-colors">
                <Paperclip class="h-5 w-5" />
              </button>
              <button class="p-2 text-gray-600 dark:text-gray-300 hover:text-primary-500 transition-colors">
                <Mic class="h-5 w-5" />
              </button>
              <button class="p-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition-colors">
                <Send class="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>

        <!-- Content Feed Demo -->
        <div class="feed-demo w-full max-w-lg lg:max-w-none mx-auto lg:mx-0">
          <div class="demo-container glass-card rounded-3xl p-4 lg:p-6 shadow-2xl w-full overflow-hidden">
            <div class="demo-header mb-6">
              <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">
                Personalized Content Feed
              </h3>
              <p class="text-gray-600 dark:text-gray-300 text-sm">
                AI-generated content tailored to each user's progress and interests
              </p>
            </div>

            <!-- Coach Avatars -->
            <div class="coach-avatars flex space-x-3 mb-6">
              <div
                v-for="(coach, index) in coaches"
                :key="index"
                class="coach-avatar relative"
              >
                <div 
                  class="w-12 h-12 rounded-full bg-gradient-to-r from-purple-500 to-pink-500 flex items-center justify-center text-white font-bold text-sm cursor-pointer hover:scale-110 transition-transform"
                  :style="{ background: coach.gradient }"
                >
                  {{ coach.initials }}
                </div>
                <div v-if="coach.hasUpdate" class="absolute -top-1 -right-1 w-4 h-4 bg-red-500 text-white text-xs rounded-full flex items-center justify-center">
                  {{ coach.updateCount }}
                </div>
              </div>
            </div>

            <!-- Feed Posts -->
            <div class="feed-posts space-y-4 h-96 overflow-y-auto">
              <div
                v-for="(post, index) in feedPosts"
                :key="index"
                class="feed-post p-4 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 hover:border-primary-300 dark:hover:border-primary-700 transition-all duration-200 cursor-pointer"
                :style="{ animationDelay: `${index * 500}ms` }"
              >
                <!-- Post Header -->
                <div class="post-header flex items-center space-x-3 mb-3">
                  <div 
                    class="w-8 h-8 rounded-full bg-gradient-to-r flex items-center justify-center text-white font-bold text-xs"
                    :style="{ background: post.coach.gradient }"
                  >
                    {{ post.coach.initials }}
                  </div>
                  <div class="flex-1">
                    <div class="font-medium text-gray-900 dark:text-white text-sm">{{ post.coach.name }}</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">{{ post.timeAgo }}</div>
                  </div>
                  <Bookmark class="h-4 w-4 text-gray-400 hover:text-primary-500 transition-colors cursor-pointer" />
                </div>

                <!-- Post Content -->
                <div class="post-content">
                  <TypingText
                    :text="post.content"
                    :delay="index * 500 + 1000"
                    :duration="20"
                    class="text-sm text-gray-900 dark:text-white mb-3"
                  />
                  
                  <!-- Post Actions -->
                  <div v-if="post.action" class="post-action mt-3">
                    <button
                      v-if="post.action.type === 'poll'"
                      class="w-full text-left p-3 bg-primary-50 dark:bg-primary-900/20 rounded-lg border border-primary-200 dark:border-primary-800 hover:border-primary-400 transition-colors"
                    >
                      <div class="text-sm font-medium text-primary-900 dark:text-primary-100 mb-2">
                        {{ post.action.question }}
                      </div>
                      <div class="space-y-2">
                        <div
                          v-for="(option, optIndex) in post.action.options"
                          :key="optIndex"
                          class="flex items-center justify-between text-xs"
                        >
                          <span class="text-primary-700 dark:text-primary-300">{{ option.text }}</span>
                          <span class="text-primary-600 dark:text-primary-400">{{ option.percentage }}%</span>
                        </div>
                      </div>
                    </button>

                    <button
                      v-else-if="post.action.type === 'chat'"
                      class="w-full text-left p-3 bg-green-50 dark:bg-green-900/20 rounded-lg border border-green-200 dark:border-green-800 hover:border-green-400 transition-colors"
                    >
                      <div class="flex items-center space-x-2">
                        <MessageCircle class="h-4 w-4 text-green-600 dark:text-green-400" />
                        <span class="text-sm font-medium text-green-900 dark:text-green-100">
                          {{ post.action.cta }}
                        </span>
                      </div>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import TypingText from '@/components/ui/TypingText.vue'
import {
  Paperclip,
  Mic,
  Send,
  Youtube,
  FileText,
  ExternalLink,
  Play,
  MessageCircle,
  Bookmark,
  PhoneCall
} from 'lucide-vue-next'

const chatMessages = [
  {
    sender: 'user',
    text: "I'm struggling to stick to my nutrition plan"
  },
  {
    sender: 'coach',
    text: "I understand how challenging that can be! Let me check your progress and give you personalized advice.",
    features: {
      progress: 65
    }
  },
  {
    sender: 'coach',
    text: "Based on your 65% completion rate, you're doing better than you think! Here are some strategies from my latest content that might help:",
    features: {
      references: [
        {
          type: 'youtube',
          title: 'Building Sustainable Nutrition Habits',
          source: 'YouTube • 12 min'
        },
        {
          type: 'document',
          title: 'Meal Prep Success Guide',
          source: 'Course Material • Chapter 4'
        }
      ]
    }
  },
  {
    sender: 'coach',
    text: "I've also recorded a personalized message for you about overcoming nutrition challenges:",
    features: {
      voice: true
    }
  }
]

const coaches = [
  {
    initials: 'SC',
    gradient: 'linear-gradient(135deg, #8b5cf6, #ec4899)',
    hasUpdate: true,
    updateCount: 3
  },
  {
    initials: 'MF',
    gradient: 'linear-gradient(135deg, #3b82f6, #06b6d4)',
    hasUpdate: false,
    updateCount: 0
  },
  {
    initials: 'DR',
    gradient: 'linear-gradient(135deg, #10b981, #3b82f6)',
    hasUpdate: true,
    updateCount: 1
  }
]

const feedPosts = [
  {
    coach: {
      name: "Sarah's Coach",
      initials: 'SC',
      gradient: 'linear-gradient(135deg, #8b5cf6, #ec4899)'
    },
    timeAgo: '2 min ago',
    content: "Your progress this week shows you're 23% more consistent with morning routines. Here's how to build on this momentum...",
    action: {
      type: 'chat',
      cta: 'Continue conversation about morning routines'
    }
  },
  {
    coach: {
      name: "Sarah's Coach",
      initials: 'SC',
      gradient: 'linear-gradient(135deg, #8b5cf6, #ec4899)'
    },
    timeAgo: '1 hour ago',
    content: "Quick check-in: How are you feeling about your nutrition goals today?",
    action: {
      type: 'poll',
      question: 'How confident are you about reaching today\'s nutrition goals?',
      options: [
        { text: 'Very confident', percentage: 45 },
        { text: 'Somewhat confident', percentage: 35 },
        { text: 'Need support', percentage: 20 }
      ]
    }
  },
  {
    coach: {
      name: "Sarah's Coach",
      initials: 'SC',
      gradient: 'linear-gradient(135deg, #8b5cf6, #ec4899)'
    },
    timeAgo: '3 hours ago',
    content: "Based on your recent questions about meal prep, I created this personalized guide just for you...",
    action: {
      type: 'chat',
      cta: 'View your personalized meal prep guide'
    }
  }
]

</script>

<style scoped>
.glass-card {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.dark .glass-card {
  background: rgba(15, 23, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.gradient-text {
  background: linear-gradient(135deg, #8b5cf6 0%, #ec4899 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.message {
  opacity: 0;
  transform: translateY(20px);
  animation: messageSlideIn 0.5s ease-out forwards;
}

@keyframes messageSlideIn {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.feed-post {
  opacity: 0;
  transform: translateY(20px);
  animation: messageSlideIn 0.5s ease-out forwards;
}

.chat-messages::-webkit-scrollbar,
.feed-posts::-webkit-scrollbar {
  width: 4px;
}

.chat-messages::-webkit-scrollbar-track,
.feed-posts::-webkit-scrollbar-track {
  background: transparent;
}

.chat-messages::-webkit-scrollbar-thumb,
.feed-posts::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 2px;
}

.dark .chat-messages::-webkit-scrollbar-thumb,
.dark .feed-posts::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
}
</style>