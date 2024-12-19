module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [
    require('daisyui')
  ],
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#24C1C7",
          "secondary": "#cffafe",
          "accent": "#FC8A26",
          "neutral": "#2F5461",
          "info": "#67e8f9",
          "success": "#6ee7b7",
          "warning": "#fde047",
          "error": "#fda4af",
        },
      },
    ],
  },
}
