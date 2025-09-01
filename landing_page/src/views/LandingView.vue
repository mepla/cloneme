<template>
  <div class="landing-page">
    <HeroSection />
    <ForCreatorsSection />
    <ForUsersSection />
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import HeroSection from '@/components/sections/HeroSection.vue'
import ForCreatorsSection from '@/components/sections/ForCreatorsSection.vue'
import ForUsersSection from '@/components/sections/ForUsersSection.vue'

onMounted(() => {
  // Load Kit.com script
  const script = document.createElement('script')
  script.async = true
  script.setAttribute('data-uid', '1fe98e99bc')
  script.src = 'https://yef.kit.com/1fe98e99bc/index.js'
  document.head.appendChild(script)
})
</script>