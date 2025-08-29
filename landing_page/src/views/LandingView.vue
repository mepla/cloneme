<template>
  <div class="landing-page">
    <HeroSection @open-early-access="openEarlyAccessModal" />
    <ForCreatorsSection />
    <ForUsersSection />
    
    <!-- Early Access Modal -->
    <AnimatedModal v-model="showEarlyAccessModal">
      <EarlyAccessForm @close="closeEarlyAccessModal" />
    </AnimatedModal>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import HeroSection from '@/components/sections/HeroSection.vue'
import ForCreatorsSection from '@/components/sections/ForCreatorsSection.vue'
import ForUsersSection from '@/components/sections/ForUsersSection.vue'
import AnimatedModal from '@/components/ui/AnimatedModal.vue'
import EarlyAccessForm from '@/components/forms/EarlyAccessForm.vue'

const showEarlyAccessModal = ref(false)

const openEarlyAccessModal = () => {
  showEarlyAccessModal.value = true
}

const closeEarlyAccessModal = () => {
  showEarlyAccessModal.value = false
}
</script>