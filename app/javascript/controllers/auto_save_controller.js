import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"

// Connects to data-controller="auto-save"
export default class extends Controller {
  static targets = ['input']
  static values = {
    exerciseSetId: Number
  }

  connect() {
    this.inputTargets.forEach((input) => {
      input.addEventListener("change", () => {
        const attributeName = input.dataset.autoSaveAttributeName

        this.updateAttribute(attributeName, input.value)
      })
    })
  }

  async updateAttribute(name, value) {
    await patch(`/exercise_sets/${this.exerciseSetIdValue}`, {
      body: JSON.stringify({ exercise_set: { [name]: value}})
    })
  }
}
