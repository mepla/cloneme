<template>
  <section class="for-creators-section py-24 bg-gradient-to-br from-slate-50 to-blue-50 dark:from-slate-900 dark:to-slate-800">
    <div class="container mx-auto px-6">
      <div class="grid lg:grid-cols-2 gap-16 items-center">
        <!-- Content Left -->
        <div class="creators-content space-y-8">
          <div class="section-header">
            <h2 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-6">
              For the 
              <span class="gradient-text">creators</span>
            </h2>
            <p class="text-xl text-gray-600 dark:text-gray-300 leading-relaxed">
              Transform your expertise into a scalable AI-powered coaching business that works around the clock.
            </p>
          </div>

          <!-- Value Propositions -->
          <div class="value-props space-y-6">
            <div
              v-for="(prop, index) in valuePropositions"
              :key="index"
              class="value-prop flex items-start space-x-4 transform transition-all duration-500 hover:translate-x-2"
            >
              <div class="icon-wrapper flex-shrink-0 w-12 h-12 rounded-full bg-gradient-to-r from-primary-500 to-purple-500 flex items-center justify-center">
                <component :is="prop.icon" class="h-6 w-6 text-white" />
              </div>
              <div>
                <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-1">
                  {{ prop.title }}
                </h3>
                <p class="text-gray-600 dark:text-gray-300">
                  {{ prop.description }}
                </p>
              </div>
            </div>
          </div>

          <!-- Stats -->
          <div class="creator-stats grid grid-cols-3 gap-6 pt-8">
            <div
              v-for="(stat, index) in stats"
              :key="index"
              class="stat-item text-center"
            >
              <div class="text-3xl font-bold gradient-text mb-2">{{ stat.value }}</div>
              <div class="text-sm text-gray-500 dark:text-gray-400">{{ stat.label }}</div>
            </div>
          </div>
        </div>

        <!-- Interactive Coach Config Demo -->
        <div class="coach-config-demo">
          <div class="demo-container glass-card rounded-3xl p-8 shadow-2xl">
            <div class="demo-header mb-8">
              <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                Configure Your AI Coach
              </h3>
              <p class="text-gray-600 dark:text-gray-300">
                Customize your coach to match your expertise and audience
              </p>
            </div>

            <!-- Demo Interface -->
            <div class="demo-interface space-y-6">
              <!-- Coach Name -->
              <div class="config-section">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Coach Name
                </label>
                <div class="mock-input p-3 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg">
                  <TypingText 
                    text="Dr. Sarah's Wellness Coach"
                    :duration="100"
                    :delay="500"
                    class="text-gray-900 dark:text-white"
                  />
                </div>
              </div>

              <!-- Features Toggle -->
              <div class="config-section">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">
                  Available Features
                </label>
                <div class="features-list space-y-3">
                  <div
                    v-for="(feature, index) in features"
                    :key="index"
                    class="feature-toggle flex items-center justify-between p-3 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg cursor-pointer transition-all duration-200 hover:border-primary-500"
                    @click="toggleFeature(index)"
                  >
                    <div class="flex items-center space-x-3">
                      <component :is="feature.icon" class="h-5 w-5 text-gray-600 dark:text-gray-300" />
                      <span class="text-gray-900 dark:text-white">{{ feature.name }}</span>
                    </div>
                    <div class="toggle-switch relative">
                      <div
                        class="toggle-track w-12 h-6 rounded-full transition-colors duration-200"
                        :class="feature.enabled ? 'bg-primary-500' : 'bg-gray-300 dark:bg-gray-600'"
                      >
                        <div
                          class="toggle-thumb w-5 h-5 bg-white rounded-full shadow-sm transition-transform duration-200 transform translate-y-0.5"
                          :class="feature.enabled ? 'translate-x-6' : 'translate-x-0.5'"
                        ></div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Pricing Slider -->
              <div class="config-section">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Monthly Subscription Price
                </label>
                <div class="pricing-slider p-4 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg">
                  <div class="flex items-center justify-between mb-3">
                    <span class="text-2xl font-bold gradient-text">${{ currentPrice }}</span>
                    <span class="text-sm text-gray-500 dark:text-gray-400">per month</span>
                  </div>
                  <input
                    v-model="currentPrice"
                    type="range"
                    min="19.99"
                    max="499.99"
                    step="10"
                    class="price-slider w-full h-2 bg-gray-200 dark:bg-gray-700 rounded-lg appearance-none cursor-pointer"
                  />
                  <div class="flex justify-between text-xs text-gray-500 dark:text-gray-400 mt-2">
                    <span>$19.99</span>
                    <span>$499.99</span>
                  </div>
                </div>
              </div>

              <!-- Live Preview -->
              <div class="config-section">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Live Preview
                </label>
                <div class="preview-card p-4 bg-gradient-to-r from-primary-50 to-purple-50 dark:from-primary-900/20 dark:to-purple-900/20 border border-primary-200 dark:border-primary-700 rounded-lg">
                  <div class="flex items-center space-x-3 mb-2">
                    <div class="w-8 h-8 rounded-full bg-gradient-to-r from-primary-500 to-purple-500 flex items-center justify-center">
                      <span class="text-white text-sm font-bold">S</span>
                    </div>
                    <div>
                      <div class="font-medium text-gray-900 dark:text-white">Dr. Sarah's Wellness Coach</div>
                      <div class="text-sm text-gray-600 dark:text-gray-300">${{ currentPrice }}/month</div>
                    </div>
                  </div>
                  <div class="features-preview flex flex-wrap gap-2">
                    <span
                      v-for="feature in enabledFeatures"
                      :key="feature.name"
                      class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-primary-100 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300"
                    >
                      <component :is="feature.icon" class="h-3 w-3 mr-1" />
                      {{ feature.name }}
                    </span>
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
import { ref, computed } from 'vue'
import TypingText from '@/components/ui/TypingText.vue'
import {
  TrendingUp,
  Users,
  Clock,
  DollarSign,
  MessageCircle,
  Mic,
  FileText,
  Video,
  BarChart3
} from 'lucide-vue-next'

const valuePropositions = [
  {
    icon: TrendingUp,
    title: "Turn your expertise into scalable income",
    description: "Monetize your knowledge 24/7 without being limited by your time"
  },
  {
    icon: Users,
    title: "Reach unlimited students simultaneously",
    description: "Scale from coaching 10 people to 10,000 with the same personal touch"
  },
  {
    icon: Clock,
    title: "Maintain your personal touch at scale",
    description: "Your AI coach learns your style and delivers personalized coaching"
  }
]

const stats = [
  { value: "10x", label: "Audience Reach" },
  { value: "24/7", label: "Availability" },
  { value: "$100K+", label: "Annual Potential" }
]

const currentPrice = ref(49.99)

const features = ref([
  { name: "Voice Chat", icon: Mic, enabled: true },
  { name: "Content Preview", icon: FileText, enabled: true },
  { name: "Analytics", icon: BarChart3, enabled: true },
])

const enabledFeatures = computed(() => {
  return features.value.filter(feature => feature.enabled)
})

const toggleFeature = (index: number) => {
  features.value[index].enabled = !features.value[index].enabled
}
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
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.price-slider::-webkit-slider-thumb {
  appearance: none;
  height: 20px;
  width: 20px;
  border-radius: 50%;
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.price-slider::-moz-range-thumb {
  height: 20px;
  width: 20px;
  border-radius: 50%;
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
  cursor: pointer;
  border: none;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
</style>