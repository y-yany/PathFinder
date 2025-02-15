// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// import Swiper JS
import Swiper from "https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.mjs";
// init Swiper
document.addEventListener("turbo:load", () => {
  const swiper = new Swiper('.swiper', {  
    navigation: {
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev",
    },
    pagination: {
      el: ".swiper-pagination",
    },
  });
});
