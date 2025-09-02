// app/javascript/controllers/address_autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static values = { apiKey: String }
  static targets = ["container", "address"]

  connect() {
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,postcode,locality,neighborhood,address",
      placeholder: "Search",
      marker: false
    })

    // Injecte l'UI du geocoder dans le conteneur (qui a le style .form-control)
    this.geocoder.addTo(this.containerTarget)

    // Met à jour le champ caché soumis par le formulaire
    this.geocoder.on("result", (event) => this.#setInputValue(event))
    this.geocoder.on("clear", () => this.#clearInputValue())
  }

  #setInputValue(event) {
    this.addressTarget.value = event.result["place_name"]
  }

  #clearInputValue() {
    this.addressTarget.value = ""
  }

  disconnect() {
    if (this.geocoder && this.geocoder.onRemove) this.geocoder.onRemove()
  }
}
