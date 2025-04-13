// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// import Swiper JS
import Swiper from "https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.mjs";
// init Swiper
document.addEventListener("turbo:load", () => {
  const courseIndexSwiper = new Swiper('.courseIndexSwiper', {
    pagination: {
      el: ".swiper-pagination",
      dynamicBullets: true,
    },
  });

  const courseShowSwiper = new Swiper('.courseShowSwiper', {
    effect: "coverflow",
    grabCursor: true,
    centeredSlides: true,
    slidesPerView: "auto",
    coverflowEffect: {
      rotate: 50,
      stretch: 0,
      depth: 100,
      modifier: 1,
      slideShadows: true,
    },
  });
});
