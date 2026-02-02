import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["requiredCheckbox", "requiredField", "fieldToEnable"]

  connect() {
    this.requiredCheckboxTargets.forEach(cb =>
      cb.addEventListener("change", () => this.updateFieldToEnableState())
    )

    this.requiredFieldTargets.forEach(f =>
      f.addEventListener("input",   () => this.updateFieldToEnableState())
    )

    this.updateFieldToEnableState()
  }

  updateFieldToEnableState() {
    const requiredCheckboxOk = this.requiredCheckboxTargets.length === 0
      || this.requiredCheckboxTargets.some(cb => cb.checked)

    const requiredFieldOk = this.requiredFieldTargets.length === 0
      || this.requiredFieldTargets.every(f => f.value.trim() !== "")

    this.fieldToEnableTarget.disabled = !(requiredCheckboxOk && requiredFieldOk)
  }
}
