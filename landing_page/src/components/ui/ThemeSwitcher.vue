<template>
  <div class="theme-switcher relative isolate flex h-8 rounded-full bg-white/40 dark:bg-gray-800/60 p-1 ring-1 ring-white/30 dark:ring-gray-600/80 backdrop-blur-md">
    <button
      v-for="themeOption in themes"
      :key="themeOption.key"
      :aria-label="themeOption.label"
      class="relative h-6 w-6 rounded-full transition-all duration-200 hover:scale-110"
      @click="setTheme(themeOption.key as Theme)"
    >
      <div
        v-if="theme === themeOption.key"
        class="absolute inset-0 rounded-full bg-white/60 dark:bg-gray-600/70 transition-all duration-300"
      />
      <component
        :is="themeOption.icon"
        class="relative z-10 m-auto h-4 w-4 transition-colors duration-200"
        :class="theme === themeOption.key 
          ? 'text-gray-800 dark:text-gray-100' 
          : 'text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200'"
      />
    </button>
  </div>
</template>

<script setup lang="ts">
import { useThemeStore } from '@/stores/theme'
import { storeToRefs } from 'pinia'
import { Monitor, Moon, Sun } from 'lucide-vue-next'

type Theme = 'light' | 'dark' | 'system'

const themes = [
  {
    key: 'system',
    icon: Monitor,
    label: 'System theme',
  },
  {
    key: 'light',
    icon: Sun,
    label: 'Light theme',
  },
  {
    key: 'dark',
    icon: Moon,
    label: 'Dark theme',
  },
]

const themeStore = useThemeStore()
const { theme } = storeToRefs(themeStore)
const { setTheme } = themeStore
</script>