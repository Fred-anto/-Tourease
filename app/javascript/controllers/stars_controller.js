import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "input", "label"]

  connect() {
    this.value = parseInt(this.inputTarget.value || 0, 10)
    this.render()
  }

  select(e) {
    this.value = parseInt(e.currentTarget.dataset.value, 10)
    this.inputTarget.value = this.value
    this.render()
  }

  hover(e) {
    const n = parseInt(e.currentTarget.dataset.value, 10)
    this.paint(n)
  }

  leave() {
    this.render()
  }

  render() {
    this.paint(this.value)
    this.labelTarget.textContent = this.value ? `${this.value}/5` : "—"
  }

  paint(n) {
    this.starTargets.forEach((el, i) => {
      el.classList.toggle("is-active", i < n)
    })
  }
}
