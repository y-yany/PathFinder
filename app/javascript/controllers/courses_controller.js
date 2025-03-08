import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="courses"
export default class extends Controller {
  static targets = ["min_distance", "max_distance", "distance"];

  connect() {
    // console.log("Hello, I'm courses_controller.js");
  }

  setDistanceRange() {
    this.distanceTarget.textContent = `${this.min_distanceTarget.value} - ${this.max_distanceTarget.value} km`
  }
}
