import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    altFormat:  { type: String, default: "d-m-Y" },
    dateFormat: { type: String, default: "Y-m-d" },
    minDate: String,
    maxDate: String,
    mode: String
  }

  connect() {
    const fp = window.flatpickr
    if (!fp) return

    if (this.fp) this.fp.destroy()

    try { fp.localize(fp.l10ns.fr) } catch(_) {}

    this.fp = fp(this.element, {
      altInput: true,
      allowInput: true,
      disableMobile: true,
      altFormat:  this.altFormatValue,
      dateFormat: this.dateFormatValue,
      minDate:    this.minDateValue || null,
      maxDate:    this.maxDateValue || null,
      mode:       this.modeValue || "single",
    })
  }

  disconnect() { if (this.fp) this.fp.destroy() }
}
