import { ref, computed, onMounted, watch } from 'vue'

type Theme = 'light' | 'dark' | 'system'

export function useTheme() {
  const theme = ref<Theme>('system')
  
  const isDark = computed(() => {
    if (theme.value === 'system') {
      return window.matchMedia('(prefers-color-scheme: dark)').matches
    }
    return theme.value === 'dark'
  })
  
  const setTheme = (newTheme: Theme) => {
    theme.value = newTheme
    localStorage.setItem('theme', newTheme)
    updateDOM()
  }
  
  const updateDOM = () => {
    const root = document.documentElement
    if (isDark.value) {
      root.classList.add('dark')
    } else {
      root.classList.remove('dark')
    }
  }
  
  // Watch for system theme changes
  const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
  const handleSystemThemeChange = () => {
    if (theme.value === 'system') {
      updateDOM()
    }
  }
  
  onMounted(() => {
    const savedTheme = localStorage.getItem('theme') as Theme
    if (savedTheme && ['light', 'dark', 'system'].includes(savedTheme)) {
      theme.value = savedTheme
    }
    
    updateDOM()
    mediaQuery.addEventListener('change', handleSystemThemeChange)
  })
  
  // Watch for theme changes
  watch(isDark, updateDOM, { immediate: true })
  
  return { 
    theme: readonly(theme), 
    isDark: readonly(isDark), 
    setTheme 
  }
}

// Readonly helper for better type safety
function readonly<T>(ref: any): Readonly<T> {
  return ref
}