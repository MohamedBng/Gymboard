import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.updateActiveLink()
    document.addEventListener("turbo:load", this.updateActiveLink.bind(this))
    document.addEventListener("turbo:frame-load", this.updateActiveLink.bind(this))
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.updateActiveLink.bind(this))
    document.removeEventListener("turbo:frame-load", this.updateActiveLink.bind(this))
  }

  updateActiveLink() {
    const currentPath = window.location.pathname

    this.linkTargets.forEach(link => {
      const href = link.getAttribute("href")
      link.classList.toggle("dock-active", href === currentPath)
    })
  }
}
