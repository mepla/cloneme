<template>
  <span ref="textRef" class="typing-text">
    <span>{{ displayedText }}</span>
    <span 
      v-if="cursor"
      class="cursor inline-block h-5 w-[1px] translate-y-1 bg-current animate-pulse"
      :class="cursorClass"
    />
  </span>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, onUnmounted } from 'vue'
import { useIntersectionObserver } from '@vueuse/core'

interface Props {
  text: string | string[]
  duration?: number
  delay?: number
  cursor?: boolean
  loop?: boolean
  holdDelay?: number
  cursorClass?: string
  animateOnChange?: boolean
  inView?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  duration: 100,
  delay: 0,
  cursor: false,
  loop: false,
  holdDelay: 1000,
  cursorClass: '',
  animateOnChange: true,
  inView: false
})

const textRef = ref<HTMLElement>()
const displayedText = ref('')
const started = ref(false)
let timeoutIds: number[] = []

const { stop } = useIntersectionObserver(
  textRef,
  ([{ isIntersecting }]) => {
    if (props.inView && isIntersecting && !started.value) {
      startAnimation()
    }
  }
)

const startAnimation = () => {
  if (started.value) return
  
  setTimeout(() => {
    started.value = true
    animateText()
  }, props.delay)
}

const clearTimeouts = () => {
  timeoutIds.forEach(id => clearTimeout(id))
  timeoutIds = []
}

const typeText = (str: string, onComplete: () => void) => {
  let currentIndex = 0
  const type = () => {
    if (currentIndex <= str.length) {
      displayedText.value = str.substring(0, currentIndex)
      currentIndex++
      const id = window.setTimeout(type, props.duration)
      timeoutIds.push(id)
    } else {
      onComplete()
    }
  }
  type()
}

const eraseText = (str: string, onComplete: () => void) => {
  let currentIndex = str.length
  const erase = () => {
    if (currentIndex >= 0) {
      displayedText.value = str.substring(0, currentIndex)
      currentIndex--
      const id = window.setTimeout(erase, props.duration)
      timeoutIds.push(id)
    } else {
      onComplete()
    }
  }
  erase()
}

const animateText = () => {
  const texts = typeof props.text === 'string' ? [props.text] : props.text
  
  const animateTexts = (index: number) => {
    typeText(texts[index] || '', () => {
      const isLast = index === texts.length - 1
      if (isLast && !props.loop) {
        return
      }
      
      const id = window.setTimeout(() => {
        eraseText(texts[index] || '', () => {
          const nextIndex = isLast ? 0 : index + 1
          animateTexts(nextIndex)
        })
      }, props.holdDelay)
      timeoutIds.push(id)
    })
  }
  
  animateTexts(0)
}

watch(
  () => props.text,
  () => {
    if (props.animateOnChange) {
      clearTimeouts()
      started.value = false
      displayedText.value = ''
      if (!props.inView || textRef.value) {
        startAnimation()
      }
    }
  },
  { deep: true }
)

onMounted(() => {
  if (!props.inView) {
    startAnimation()
  }
})

onUnmounted(() => {
  clearTimeouts()
  stop()
})
</script>