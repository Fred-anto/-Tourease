import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]

  connect() {
    this.updateButtons()
    this.onScroll = () => this.updateButtons()
    this.trackTarget.addEventListener("scroll", this.onScroll, { passive: true })
    this.onResize = () => this.updateButtons()
    window.addEventListener("resize", this.onResize)
  }

  disconnect() {
    this.trackTarget.removeEventListener("scroll", this.onScroll)
    window.removeEventListener("resize", this.onResize)
  }

  prev() { this.scrollBy(-this.cardStep()) }
  next() { this.scrollBy( this.cardStep()) }

  scrollBy(dx) { this.trackTarget.scrollBy({ left: dx, behavior: "smooth" }) }

  cardStep() {
    const first = this.trackTarget.querySelector(".card")
    if (!first) return this.trackTarget.clientWidth
    const styles = getComputedStyle(this.trackTarget)
    const gap = parseInt(styles.gap || styles.columnGap || 0, 10)
    return first.getBoundingClientRect().width + gap
  }

  updateButtons() {
    const el = this.trackTarget
    const atStart = Math.floor(el.scrollLeft) <= 0
    const atEnd = Math.ceil(el.scrollLeft + el.clientWidth) >= el.scrollWidth
    this.element.querySelector(".swipe-carousel__btn--prev")?.classList.toggle("is-hidden", atStart)
    this.element.querySelector(".swipe-carousel__btn--next")?.classList.toggle("is-hidden", atEnd)
  }
}
