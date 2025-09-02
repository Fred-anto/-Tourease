import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.observer = new MutationObserver(() => this.scroll())
    this.observer.observe(this.element, { childList: true, subtree: true, characterData: true })
    this.scroll()
  }
  disconnect() { this.observer?.disconnect() }
  scroll() { this.element.scrollTop = this.element.scrollHeight }
}
