<template>
  <div class="landing-page">
    <HeroSection />
    <ForCreatorsSection />
    <ForUsersSection />
    <!-- Hidden element for Kit.com modal trigger -->
    <div style="display: none;">
      <a data-formkit-toggle="1fe98e99bc" ref="kitTrigger"></a>
    </div>
  </div>
</template>

<script setup lang="ts">
import { provide, ref } from 'vue'
import HeroSection from '@/components/sections/HeroSection.vue'
import ForCreatorsSection from '@/components/sections/ForCreatorsSection.vue'
import ForUsersSection from '@/components/sections/ForUsersSection.vue'

// Reference to hidden Kit trigger element
const kitTrigger = ref<HTMLElement>()

// Load Kit.com script and show modal
const showKitModal = () => {
  return new Promise((resolve) => {
    // Check if script is already loaded
    const existingScript = document.querySelector('script[src="https://yef.kit.com/1fe98e99bc/index.js"]')
    
    if (existingScript) {
      // Script already loaded, try to show the form using the hidden trigger
      setTimeout(() => {
        if (kitTrigger.value) {
          kitTrigger.value.click()
          resolve(true)
        } else {
          resolve(false)
        }
      }, 100)
      return
    }
    
    // Load the script
    const script = document.createElement('script')
    script.async = true
    script.setAttribute('data-uid', '1fe98e99bc')
    script.src = 'https://yef.kit.com/1fe98e99bc/index.js'
    
    script.onload = () => {
      // Wait for Kit to initialize, then show the form using the hidden trigger
      setTimeout(() => {
        if (kitTrigger.value) {
          kitTrigger.value.click()
          resolve(true)
        } else {
          resolve(false)
        }
      }, 1000)
    }
    
    script.onerror = () => {
      resolve(false)
    }
    
    document.head.appendChild(script)
  })
}

// Provide function to child components
provide('showKitModal', showKitModal)
</script>