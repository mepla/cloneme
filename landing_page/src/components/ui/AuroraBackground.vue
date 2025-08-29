<template>
  <div class="aurora-container relative flex min-h-screen flex-col items-center justify-center overflow-hidden bg-slate-50 text-slate-950 dark:bg-slate-900 dark:text-slate-50">
    <div class="aurora-overlay absolute inset-0 overflow-hidden">
      <div 
        class="aurora-gradient"
        :class="{ 'aurora-dark': isDark }"
      ></div>
    </div>
    <div class="relative z-10 w-full">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { useThemeStore } from '@/stores/theme'
import { storeToRefs } from 'pinia'

const themeStore = useThemeStore()
const { isDark } = storeToRefs(themeStore)
</script>

<style scoped>
/* Light mode background - clean and bright */
.aurora-container {
  background: linear-gradient(135deg, #ffffff 0%, #f8fafc 30%, #e2e8f0 70%, #f1f5f9 100%);
  color: #0f172a;
}

/* Dark mode background - much darker with better contrast */
.dark .aurora-container {
  background: linear-gradient(135deg, #020617 0%, #0c1429 30%, #1e293b 70%, #0f172a 100%);
  color: #f1f5f9;
}

/* Light mode aurora - subtle and elegant */
.aurora-gradient {
  @apply absolute -inset-[10px] pointer-events-none will-change-transform;
  opacity: 0.3;
  blur: 8px;
  
  background: 
    repeating-linear-gradient(100deg, transparent 0%, transparent 7%, rgba(59, 130, 246, 0.02) 10%, rgba(59, 130, 246, 0.02) 12%, transparent 16%),
    linear-gradient(100deg, 
      rgba(59, 130, 246, 0.15) 10%, 
      rgba(165, 180, 252, 0.12) 15%, 
      rgba(147, 197, 253, 0.10) 20%, 
      rgba(221, 214, 254, 0.08) 25%, 
      rgba(96, 165, 250, 0.12) 30%);
  background-size: 300% 200%, 200% 100%;
  background-position: 50% 50%, 50% 50%;
  animation: aurora 60s linear infinite;
}

/* Dark mode aurora - darker and more subtle */
.dark .aurora-gradient {
  opacity: 0.2;
  background: 
    repeating-linear-gradient(100deg, transparent 0%, transparent 7%, rgba(0, 0, 0, 0.3) 10%, rgba(0, 0, 0, 0.3) 12%, transparent 16%),
    linear-gradient(100deg, 
      rgba(30, 58, 138, 0.08) 10%, 
      rgba(67, 56, 202, 0.06) 15%, 
      rgba(59, 130, 246, 0.05) 20%, 
      rgba(139, 92, 246, 0.04) 25%, 
      rgba(79, 70, 229, 0.06) 30%);
}

.aurora-gradient::after {
  content: '';
  @apply absolute inset-0;
  background: 
    repeating-linear-gradient(100deg, rgba(255, 255, 255, 0.01) 0%, rgba(255, 255, 255, 0.01) 7%, transparent 10%, transparent 12%, rgba(255, 255, 255, 0.01) 16%),
    linear-gradient(100deg, 
      rgba(59, 130, 246, 0.03) 10%, 
      rgba(165, 180, 252, 0.02) 15%, 
      rgba(147, 197, 253, 0.02) 20%, 
      rgba(221, 214, 254, 0.02) 25%, 
      rgba(96, 165, 250, 0.03) 30%);
  background-size: 200% 100%, 100% 200%;
  animation: aurora 60s linear infinite reverse;
  mix-blend-mode: soft-light;
}

.dark .aurora-gradient::after {
  background: 
    repeating-linear-gradient(100deg, rgba(0, 0, 0, 0.4) 0%, rgba(0, 0, 0, 0.4) 7%, transparent 10%, transparent 12%, rgba(0, 0, 0, 0.4) 16%),
    linear-gradient(100deg, 
      rgba(15, 23, 42, 0.3) 10%, 
      rgba(30, 41, 59, 0.2) 15%, 
      rgba(51, 65, 85, 0.15) 20%, 
      rgba(71, 85, 105, 0.1) 25%, 
      rgba(30, 58, 138, 0.2) 30%);
  mix-blend-mode: multiply;
}

@keyframes aurora {
  from {
    background-position: 50% 50%, 50% 50%;
  }
  to {
    background-position: 350% 50%, 350% 50%;
  }
}
</style>