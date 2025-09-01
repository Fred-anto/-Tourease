import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stars", "input", "value"]

  connect() {
    const n = parseInt(this.inputTarget.value || "0", 10)
    this.paint(n)
  }

  pick(e) {
    const n = parseInt(e.target.dataset.index, 10)
    if (!n) return
    this.inputTarget.value = n
    this.paint(n)
  }

  hover(e) {
    const n = parseInt(e.target.dataset.index, 10)
    if (!n) return
    this.paint(n)
  }

  leave() {
    const n = parseInt(this.inputTarget.value || "0", 10)
    this.paint(n)
  }

  paint(n) {
    this.starsTarget.querySelectorAll("i").forEach((i, idx) => {
      i.classList.toggle("fa-solid", idx < n)
      i.classList.toggle("fa-regular", idx >= n)
    })
    if (this.hasValueTarget) this.valueTarget.textContent = n ? `${n}/5` : ""
  }
}
