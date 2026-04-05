// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Hamburger menu toggle
document.addEventListener("turbo:load", () => {
  const hamburger = document.getElementById("hamburger-btn")
  const mobileMenu = document.getElementById("mobile-menu")

  if (hamburger && mobileMenu) {
    mobileMenu.classList.add("hidden")
    hamburger.addEventListener("click", () => {
      mobileMenu.classList.toggle("hidden")
    })
  }

  // Quantity selector buttons
  document.querySelectorAll(".quantity-selector__btn").forEach(btn => {
    btn.addEventListener("click", () => {
      const input = btn.closest(".quantity-selector__controls").querySelector(".quantity-selector__input")
      let val = parseInt(input.value) || 1
      if (btn.dataset.action === "increase") val++
      if (btn.dataset.action === "decrease" && val > 1) val--
      input.value = val
    })
  })

  // Auto-submit quantity form on change
  document.querySelectorAll("[data-autosubmit]").forEach(input => {
    input.addEventListener("change", () => input.closest("form").requestSubmit())
  })

  // Flash auto-dismiss
  document.querySelectorAll(".flash").forEach(flash => {
    setTimeout(() => flash.style.transition = "opacity .5s", 2500)
    setTimeout(() => flash.style.opacity = "0", 3000)
    setTimeout(() => flash.remove(), 3500)
  })
})
