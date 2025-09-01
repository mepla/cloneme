<template>
  <div class="relative" :class="containerClass">
    <span class="bg-gradient-to-br from-primary-400 to-primary-600 bg-clip-text text-transparent">Everm</span><span class="relative bg-gradient-to-br from-primary-400 to-primary-600 bg-clip-text text-transparent">y<span class="absolute -top-2 left-1/2 transform -translate-x-1/2 bg-gradient-to-br from-primary-400 to-primary-600 bg-clip-text text-transparent" :class="starClass">✦</span></span><span class="bg-gradient-to-br from-primary-400 to-primary-600 bg-clip-text text-transparent">nd</span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  size?: 'sm' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
  size: 'lg'
})

const containerClass = computed(() => {
  return props.size === 'sm' ? 'text-xl font-bold' : 'text-4xl font-bold'
})

const starClass = computed(() => {
  return props.size === 'sm' ? 'text-sm' : 'text-lg'
})
</script>