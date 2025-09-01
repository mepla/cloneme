<template>
  <AuroraBackground>
    <div class="container mx-auto px-6 py-20 text-center">
      <!-- Navigation -->
      <nav class="absolute top-6 left-1/2 transform -translate-x-1/2 z-20 w-full max-w-5xl px-6">
        <div class="flex items-center justify-between px-6 py-4 rounded-2xl backdrop-blur-md bg-white/10 dark:bg-gray-900/10 border border-white/20 dark:border-gray-700/20 shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1">
          <div class="flex items-center">
            <EvermyndLogo size="sm" gradient="bg-gradient-to-r from-blue-600 to-purple-600" />
          </div>
          <div class="flex items-center space-x-4">
            <button
              @click="handleGetEarlyAccess"
              class="btn-primary text-sm px-4 py-2 transform transition-all duration-300 hover:scale-105"
            >
              Get Early Access
            </button>
            <ThemeSwitcher />
          </div>
        </div>
      </nav>

      <!-- Hero Content -->
      <div class="max-w-4xl mx-auto space-y-8 mt-24">
        <!-- Main Title -->
        <div class="space-y-6">
          <h1 class="text-5xl md:text-7xl font-bold text-hero-primary leading-tight">
            Be the perfect coach for
            <span class="gradient-text-hero">
              everyone
            </span>
          </h1>
        </div>

        <!-- Problem-Solution Animation -->
        <div class="problem-solution-container space-y-12 my-16">
          <!-- Problems Title -->
          <div class="problems-title text-center mb-8">
            <h4 class="text-2xl md:text-3xl font-semibold text-hero-primary">
              If you are a coach or educator you know:
            </h4>
          </div>
          
          <!-- Problems -->
          <div class="problems-grid grid md:grid-cols-3 gap-6 md:gap-8">
            <div
              v-for="(problem, index) in problems"
              :key="index"
              class="problem-card rounded-2xl p-6 transform transition-all duration-500"
              :class="{
                'animate-slide-up': showProblems,
                'opacity-0 translate-y-8': !showProblems
              }"
              :style="{ animationDelay: `${index * 200}ms` }"
            >
              <div class="text-gray-400 dark:text-gray-500 mb-4">
                <component :is="problem.icon" class="h-12 w-12 mx-auto" />
              </div>
              <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100 mb-2">{{ problem.title }}</h3>
              <TypingText
                v-if="showProblems"
                :text="problem.description"
                :delay="index * 200 + 500"
                :duration="30"
                class="text-gray-700 dark:text-gray-300 text-sm"
              />
            </div>
          </div>

          <!-- Solution Arrow -->
          <div class="solution-arrow flex justify-center">
            <div
              class="transform transition-all duration-700"
              :class="{
                'translate-y-0 opacity-100': showSolution,
                'translate-y-4 opacity-0': !showSolution
              }"
            >
              <ArrowDown class="h-8 w-8 text-gray-400 dark:text-gray-500 animate-bounce" />
            </div>
          </div>

          <!-- Solution -->
          <div
            class="solution-card rounded-3xl p-8 max-w-2xl mx-auto transform transition-all duration-700"
            :class="{
              'translate-y-0 opacity-100 scale-100': showSolution,
              'translate-y-8 opacity-0 scale-95': !showSolution
            }"
          >
            <div class="mb-6 flex justify-center">
              <EvermyndLogo size="lg" gradient="bg-gradient-to-r from-blue-600 to-purple-600" />
            </div>
            <h3 class="text-2xl font-bold text-gray-900 dark:text-gray-100 mb-4">
              Scale your coaching to thousands 🚀
            </h3>
            <p class="text-gray-700 dark:text-gray-300 text-lg leading-relaxed">
              Turn your expertise into AI-powered coaching that scales infinitely while maintaining your personal touch
            </p>
          </div>
        </div>

        <!-- Three Steps -->
        <div class="three-steps-section space-y-12 my-20">
          <h2 class="text-3xl md:text-4xl font-bold text-hero-primary mb-16">
            Get started quick
          </h2>
          
          <div class="steps-container relative max-w-5xl mx-auto">
            <!-- Connection Lines Container -->
            <div ref="stepsContainer" class="relative">
              <!-- Animated beams -->
              <AnimatedBeam
                v-if="stepRefs[0] && stepRefs[1]"
                :container-ref="stepsContainer"
                :from-ref="stepRefs[0]"
                :to-ref="stepRefs[1]"
                :curvature="80"
                gradient-start-color="#60a5fa"
                gradient-stop-color="#a855f7"
                :delay="1"
              />
              <AnimatedBeam
                v-if="stepRefs[1] && stepRefs[2]"
                :container-ref="stepsContainer"
                :from-ref="stepRefs[1]"
                :to-ref="stepRefs[2]"
                :curvature="80"
                gradient-start-color="#60a5fa"
                gradient-stop-color="#a855f7"
                :delay="2"
              />

              <!-- Steps -->
              <div class="grid md:grid-cols-3 gap-8 md:gap-12">
                <div
                  v-for="(step, index) in steps"
                  :key="index"
                  ref="stepRefs"
                  class="step-card text-center transform transition-all duration-700"
                  :class="{
                    'translate-y-0 opacity-100': showSteps,
                    'translate-y-8 opacity-0': !showSteps
                  }"
                  :style="{ animationDelay: `${index * 300}ms` }"
                >
                  <!-- Step Content -->
                  <div class="glass-card rounded-2xl p-6 relative">
                    <!-- Step Number - Top Left Corner -->
                    <div class="absolute -top-3 -left-3 w-10 h-10 rounded-full bg-gradient-to-r from-primary-500 to-purple-500 flex items-center justify-center text-white text-lg font-bold z-10">
                      {{ index + 1 }}
                    </div>
                    <div class="text-gray-400 dark:text-gray-500 mb-4">
                      <component :is="step.icon" class="h-12 w-12 mx-auto" />
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 dark:text-gray-100 mb-3">{{ step.title }}</h3>
                    <p class="text-gray-700 dark:text-gray-300 text-sm leading-relaxed mb-4">{{ step.description }}</p>
                    
                    <!-- Step Visual -->
                    <div class="step-visual mt-4">
                      <div v-if="index === 0" class="knowledge-sources flex justify-center space-x-2">
                        <Youtube class="h-6 w-6 text-red-500" />
                        <Instagram class="h-6 w-6 text-pink-500" />
                        <GraduationCap class="h-6 w-6 text-purple-500" />
                        <File class="h-6 w-6 text-blue-500" />
                        <BookOpen class="h-6 w-6 text-green-500" />
                      </div>
                      <div v-else-if="index === 1" class="config-demo">
                        <div class="space-y-2">
                          <div class="flex items-center justify-between text-xs">
                            <span class="text-gray-400">Voice Chat</span>
                            <div class="w-8 h-4 bg-primary-500 rounded-full relative">
                              <div class="w-3 h-3 bg-white rounded-full absolute right-0.5 top-0.5"></div>
                            </div>
                          </div>
                          <div class="flex items-center justify-between text-xs">
                            <span class="text-gray-400">Price: ${{ step.price }}/mo</span>
                            <div class="text-primary-400">●</div>
                          </div>
                        </div>
                      </div>
                      <div v-else class="revenue-demo text-center">
                        <div class="text-2xl font-bold text-primary-400 dark:text-primary-400">+42%</div>
                        <div class="text-xs text-gray-400">Monthly Revenue</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- CTA Button -->
        <div
          class="cta-section transform transition-all duration-700"
          :class="{
            'translate-y-0 opacity-100': showCTA,
            'translate-y-4 opacity-0': !showCTA
          }"
        >
          <button
            @click="handleGetEarlyAccess"
            class="btn-primary text-xl px-12 py-4 transform transition-all duration-300 hover:scale-110 hover:shadow-2xl inline-flex items-center"
          >
            Get Early Access
            <ArrowRight class="ml-2 h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
  </AuroraBackground>
</template>

<script setup lang="ts">
import { ref, onMounted, inject } from 'vue'
import AuroraBackground from '@/components/ui/AuroraBackground.vue'
import ThemeSwitcher from '@/components/ui/ThemeSwitcher.vue'
import TypingText from '@/components/ui/TypingText.vue'
import AnimatedBeam from '@/components/ui/AnimatedBeam.vue'
import EvermyndLogo from '@/components/ui/EvermyndLogo.vue'
import { 
  ArrowDown, 
  ArrowRight, 
  Shrink, 
  Users, 
  Target,
  Database,
  Settings,
  DollarSign,
  Youtube,
  Instagram,
  FileText,
  BookOpen,
  GraduationCap,
  File,
  BookHeart,
  BrainCircuit
} from 'lucide-vue-next'


const showProblems = ref(false)
const showSolution = ref(false)
const showSteps = ref(false)
const showCTA = ref(false)
const stepsContainer = ref<HTMLElement>()
const stepRefs = ref<HTMLElement[]>([])

// Inject the Kit modal function from parent
const showKitModal = inject<() => Promise<boolean>>('showKitModal')

const handleGetEarlyAccess = async () => {
  if (showKitModal) {
    const success = await showKitModal()
    if (!success) {
      console.warn('Failed to show Kit modal')
    }
  }
}

const problems = [
  {
    icon: Shrink,
    title: "Coaching doesn't scale",
    description: "You can only help so many people one-on-one"
  },
  {
    icon: BookHeart,
    title: "Courses don't engage",
    description: "Rigid courses don't keep users engaged"
  },
  {
    icon: Target,
    title: "Content isn't personal",
    description: "One-size-fits-all approach doesn't work"
  }
]

const steps = [
  {
    icon: BrainCircuit,
    title: "Build your AI Coach",
    description: "Train your AI coach with one click, using your knowledge and existing content",
    price: 0
  },
  {
    icon: Settings,
    title: "Configure your Coach",
    description: "Set personality, pricing, and features to match your style",
    price: 49
  },
  {
    icon: DollarSign,
    title: "Start Monetizing",
    description: "Launch your AI coach and start earning from your expertise",
    price: 0
  }
]

onMounted(() => {
  // Sequential animation timing
  setTimeout(() => {
    showProblems.value = true
  }, 500)

  setTimeout(() => {
    showSolution.value = true
  }, 2500)

  setTimeout(() => {
    showSteps.value = true
  }, 3500)

  setTimeout(() => {
    showCTA.value = true
  }, 4500)
})
</script>

<style scoped>
/* Glass card styles are now handled in main.css */
.step-card .glass-card {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.dark .step-card .glass-card {
  background: rgba(15, 23, 42, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
</style>