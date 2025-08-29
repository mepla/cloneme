<template>
  <div class="early-access-form">
    <div class="form-header text-center mb-8">
      <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">
        Get Early Access
      </h2>
      <p class="text-gray-600 dark:text-gray-300">
        Join the waitlist and be the first to monetize your expertise with AI coaching
      </p>
    </div>

    <form @submit.prevent="handleSubmit" class="space-y-6">
      <!-- Name Field -->
      <div class="form-group">
        <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Full Name *
        </label>
        <input
          id="name"
          v-model="form.name"
          type="text"
          required
          class="form-input w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-colors duration-200"
          :class="{ 'border-red-500': errors.name }"
          placeholder="Enter your full name"
        />
        <p v-if="errors.name" class="mt-1 text-sm text-red-600">{{ errors.name }}</p>
      </div>

      <!-- Email Field -->
      <div class="form-group">
        <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Email Address *
        </label>
        <input
          id="email"
          v-model="form.email"
          type="email"
          required
          class="form-input w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-colors duration-200"
          :class="{ 'border-red-500': errors.email }"
          placeholder="Enter your email address"
        />
        <p v-if="errors.email" class="mt-1 text-sm text-red-600">{{ errors.email }}</p>
      </div>

      <!-- Website/Socials Field -->
      <div class="form-group">
        <label for="website" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Website or Social Media
        </label>
        <input
          id="website"
          v-model="form.website"
          type="url"
          class="form-input w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-colors duration-200"
          placeholder="https://your-website.com or social media profile"
        />
      </div>

      <!-- Revenue Question -->
      <div class="form-group">
        <label for="revenue" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Do you currently generate revenue from coaching or educating? *
        </label>
        <select
          id="revenue"
          v-model="form.revenue"
          required
          class="form-select w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-colors duration-200"
          :class="{ 'border-red-500': errors.revenue }"
        >
          <option value="">Select your current revenue range</option>
          <option value="no-revenue">No current revenue</option>
          <option value="10k-50k">$10,000-50,000 /year</option>
          <option value="50k-200k">$50,000-200,000 /year</option>
          <option value="200k-plus">$200,000+ /year</option>
        </select>
        <p v-if="errors.revenue" class="mt-1 text-sm text-red-600">{{ errors.revenue }}</p>
      </div>

      <!-- Submit Button -->
      <div class="form-actions">
        <button
          type="submit"
          :disabled="isSubmitting"
          class="w-full btn-primary relative overflow-hidden"
          :class="{ 'opacity-50 cursor-not-allowed': isSubmitting }"
        >
          <span v-if="!isSubmitting">Join Waitlist</span>
          <span v-else class="flex items-center justify-center">
            <div class="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-2"></div>
            Submitting...
          </span>
        </button>
      </div>

      <!-- Success Message -->
      <div
        v-if="showSuccess"
        class="success-message p-4 bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-lg"
      >
        <div class="flex items-center">
          <Check class="h-5 w-5 text-green-500 mr-2" />
          <div>
            <h3 class="text-sm font-medium text-green-800 dark:text-green-200">
              Successfully joined the waitlist!
            </h3>
            <p class="text-sm text-green-700 dark:text-green-300 mt-1">
              We'll keep you updated on EverMynd's launch and send you early access when available.
            </p>
          </div>
        </div>
      </div>
    </form>

    <!-- Close Button for Mobile -->
    <div class="mt-6 sm:hidden">
      <button
        @click="$emit('close')"
        class="w-full px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition-colors duration-200"
      >
        Cancel
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { Check } from 'lucide-vue-next'

interface FormData {
  name: string
  email: string
  website: string
  revenue: string
}

interface FormErrors {
  name?: string
  email?: string
  revenue?: string
}

interface Emits {
  (e: 'close'): void
}

defineEmits<Emits>()

const form = reactive<FormData>({
  name: '',
  email: '',
  website: '',
  revenue: ''
})

const errors = reactive<FormErrors>({})
const isSubmitting = ref(false)
const showSuccess = ref(false)

const validateForm = (): boolean => {
  // Clear previous errors
  Object.keys(errors).forEach(key => {
    delete errors[key as keyof FormErrors]
  })

  let isValid = true

  // Name validation
  if (!form.name.trim()) {
    errors.name = 'Full name is required'
    isValid = false
  }

  // Email validation
  if (!form.email.trim()) {
    errors.email = 'Email address is required'
    isValid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
    errors.email = 'Please enter a valid email address'
    isValid = false
  }

  // Revenue validation
  if (!form.revenue) {
    errors.revenue = 'Please select your revenue range'
    isValid = false
  }

  return isValid
}

const handleSubmit = async () => {
  if (!validateForm()) {
    return
  }

  isSubmitting.value = true

  try {
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000))

    // Store form data (in real app, this would be sent to backend)
    console.log('Early access form submitted:', form)

    // Show success message
    showSuccess.value = true

    // Clear form
    Object.assign(form, {
      name: '',
      email: '',
      website: '',
      revenue: ''
    })

    // Auto-close after showing success
    setTimeout(() => {
      showSuccess.value = false
    }, 3000)

  } catch (error) {
    console.error('Failed to submit form:', error)
    // Handle error (show error message to user)
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.form-input:focus,
.form-select:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.btn-primary {
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
}

.btn-primary:hover:not(:disabled) {
  background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
  transform: translateY(-1px);
}

.success-message {
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>