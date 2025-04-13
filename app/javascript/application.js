// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// import Swiper JS
import Swiper from "https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.mjs";
// init Swiper
document.addEventListener("turbo:load", () => {
  const swiper = new Swiper('.swiper', {
    pagination: {
      el: ".swiper-pagination",
      dynamicBullets: true,
    },
  });
});
