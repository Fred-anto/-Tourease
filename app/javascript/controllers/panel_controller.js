import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  toggle(e) {
    e.preventDefault()
    // un seul panneau visible à la fois
    document.querySelectorAll("[data-panel-target='panel']").forEach(p => {
      if (p !== this.panelTarget) p.classList.add("d-none")
    })
    this.panelTarget.classList.toggle("d-none")
  }

  close() { this.panelTarget.classList.add("d-none") }
}
