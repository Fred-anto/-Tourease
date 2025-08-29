import { Controller } from "@hotwired/stimulus"

// Connecte ce contrôleur avec data-controller="file-input"
export default class extends Controller {
  static targets = ["input", "name"]

  connect() {
    this.update() // Initialise l'affichage
  }

  pick() {
    // Simule un clic sur l'input caché
    this.inputTarget.click()
  }

  update() {
    const files = this.inputTarget.files
    this.nameTarget.textContent =
      files && files.length ? files[0].name : "No file chosen"
  }
}
