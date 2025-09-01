/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f3f0ff',
          100: '#e6dbff',
          200: '#d0bfff',
          300: '#b399ff',
          400: '#9966ff',
          500: '#8C52FF',
          600: '#7A3FE6',
          700: '#6B2CCC',
          800: '#5C1AB3',
          900: '#4D0F99',
          950: '#3E0A7F'
        },
        secondary: {
          300: '#a5b4fc',
          400: '#818cf8',
          500: '#6366f1'
        },
        accent: {
          400: '#60a5fa',
          500: '#3b82f6'
        }
      },
      animation: {
        'aurora': 'aurora 60s linear infinite',
        'typing': 'typing 3.5s steps(40, end), blink-caret .75s step-end infinite',
        'float': 'float 3s ease-in-out infinite',
        'fade-in': 'fadeIn 0.6s ease-out',
        'slide-up': 'slideUp 0.6s ease-out',
        'scale-in': 'scaleIn 0.4s ease-out'
      },
      keyframes: {
        aurora: {
          'from': { backgroundPosition: '50% 50%, 50% 50%' },
          'to': { backgroundPosition: '350% 50%, 350% 50%' }
        },
        typing: {
          'from': { width: '0' },
          'to': { width: '100%' }
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-20px)' }
        },
        fadeIn: {
          'from': { opacity: '0' },
          'to': { opacity: '1' }
        },
        slideUp: {
          'from': { 
            opacity: '0',
            transform: 'translateY(30px)'
          },
          'to': {
            opacity: '1',
            transform: 'translateY(0)'
          }
        },
        scaleIn: {
          'from': {
            opacity: '0',
            transform: 'scale(0.9)'
          },
          'to': {
            opacity: '1',
            transform: 'scale(1)'
          }
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif']
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem'
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography')
  ]
}