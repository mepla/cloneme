<template>
  <svg
    ref="svgRef"
    :width="svgDimensions.width"
    :height="svgDimensions.height"
    class="pointer-events-none absolute left-0 top-0 stroke-2"
    :class="className"
    :viewBox="`0 0 ${svgDimensions.width} ${svgDimensions.height}`"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <path
      :d="pathD"
      :stroke="pathColor"
      :stroke-width="pathWidth"
      :stroke-opacity="pathOpacity"
      stroke-linecap="round"
    />
    <path
      :d="pathD"
      :stroke-width="pathWidth"
      :stroke="`url(#${gradientId})`"
      stroke-opacity="1"
      stroke-linecap="round"
    />
    <defs>
      <linearGradient
        :id="gradientId"
        gradientUnits="userSpaceOnUse"
        :x1="gradientCoords.x1"
        :x2="gradientCoords.x2"
        :y1="gradientCoords.y1"
        :y2="gradientCoords.y2"
      >
        <stop :stop-color="gradientStartColor" stop-opacity="0">
          <animate
            attributeName="offset"
            :values="reverse ? '100%;70%;40%;0%' : '0%;30%;60%;100%'"
            :dur="`${duration}s`"
            :begin="`${delay}s`"
            repeatCount="indefinite"
          />
        </stop>
        <stop :stop-color="gradientStartColor">
          <animate
            attributeName="offset"
            :values="reverse ? '100%;70%;40%;0%' : '0%;30%;60%;100%'"
            :dur="`${duration}s`"
            :begin="`${delay}s`"
            repeatCount="indefinite"
          />
        </stop>
        <stop offset="32.5%" :stop-color="gradientStopColor">
          <animate
            attributeName="offset"
            :values="reverse ? '100%;70%;40%;0%' : '0%;30%;60%;100%'"
            :dur="`${duration}s`"
            :begin="`${delay}s`"
            repeatCount="indefinite"
          />
        </stop>
        <stop offset="100%" :stop-color="gradientStopColor" stop-opacity="0">
          <animate
            attributeName="offset"
            :values="reverse ? '100%;70%;40%;0%' : '0%;30%;60%;100%'"
            :dur="`${duration}s`"
            :begin="`${delay}s`"
            repeatCount="indefinite"
          />
        </stop>
      </linearGradient>
    </defs>
  </svg>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed, watch } from 'vue'
import { useResizeObserver } from '@vueuse/core'

interface Props {
  className?: string
  containerRef: HTMLElement | null
  fromRef: HTMLElement | null
  toRef: HTMLElement | null
  curvature?: number
  reverse?: boolean
  pathColor?: string
  pathWidth?: number
  pathOpacity?: number
  gradientStartColor?: string
  gradientStopColor?: string
  delay?: number
  duration?: number
  startXOffset?: number
  startYOffset?: number
  endXOffset?: number
  endYOffset?: number
}

const props = withDefaults(defineProps<Props>(), {
  className: '',
  curvature: 0,
  reverse: false,
  duration: 4,
  delay: 0,
  pathColor: 'gray',
  pathWidth: 2,
  pathOpacity: 0.2,
  gradientStartColor: '#ffaa40',
  gradientStopColor: '#9c40ff',
  startXOffset: 0,
  startYOffset: 0,
  endXOffset: 0,
  endYOffset: 0
})

const svgRef = ref<SVGElement>()
const pathD = ref('')
const svgDimensions = ref({ width: 0, height: 0 })
const gradientId = ref(`gradient-${Math.random().toString(36).substr(2, 9)}`)

const gradientCoords = computed(() => {
  if (props.reverse) {
    return {
      x1: '90%',
      x2: '100%',
      y1: '0%',
      y2: '0%'
    }
  }
  return {
    x1: '10%',
    x2: '0%', 
    y1: '0%',
    y2: '0%'
  }
})

const updatePath = () => {
  if (!props.containerRef || !props.fromRef || !props.toRef) return

  const containerRect = props.containerRef.getBoundingClientRect()
  const rectA = props.fromRef.getBoundingClientRect()
  const rectB = props.toRef.getBoundingClientRect()

  const svgWidth = containerRect.width
  const svgHeight = containerRect.height
  svgDimensions.value = { width: svgWidth, height: svgHeight }

  const startX = rectA.left - containerRect.left + rectA.width / 2 + props.startXOffset
  const startY = rectA.top - containerRect.top + rectA.height / 2 + props.startYOffset
  const endX = rectB.left - containerRect.left + rectB.width / 2 + props.endXOffset
  const endY = rectB.top - containerRect.top + rectB.height / 2 + props.endYOffset

  const controlY = startY - props.curvature
  const d = `M ${startX},${startY} Q ${(startX + endX) / 2},${controlY} ${endX},${endY}`
  pathD.value = d
}

let resizeObserver: ResizeObserver | null = null

onMounted(() => {
  updatePath()
  
  // Set up resize observer
  if (props.containerRef) {
    resizeObserver = new ResizeObserver(() => {
      updatePath()
    })
    resizeObserver.observe(props.containerRef)
  }
})

onUnmounted(() => {
  if (resizeObserver) {
    resizeObserver.disconnect()
  }
})

watch(
  () => [props.containerRef, props.fromRef, props.toRef, props.curvature],
  () => {
    updatePath()
  },
  { deep: true }
)
</script>