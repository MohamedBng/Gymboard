import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    options: Array,
    inputName: String,
    placeholder: String,
    label: String
  }

  connect() {
    this.buildStructure()
    this.buildList()
    this.updateTriggerBadges()
    this.outsideClickListener = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.outsideClickListener)
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickListener)
  }

  toggle() {
    if (this.listElement) this.listElement.classList.toggle("hidden")
  }

  close() {
    if (this.listElement) this.listElement.classList.add("hidden")
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  buildStructure() {
    this.element.innerHTML = ""

    if (this.labelValue) {
      const label = document.createElement("label")
      label.className = "label label-text label-xs"
      label.textContent = this.labelValue
      this.element.appendChild(label)
    }

    this.triggerElement = document.createElement("div")
    this.triggerElement.className =
      "w-full max-w-xs mb-1 cursor-pointer rounded-lg border border-base-300 bg-base-100 px-3 py-2 min-h-[3rem] flex flex-wrap items-center gap-2"

    this.triggerElement.addEventListener("click", (event) => {
      event.stopPropagation()
      this.toggle()
    })

    this.element.appendChild(this.triggerElement)

    const wrapper = document.createElement("div")
    wrapper.className = "max-w-xs"

    this.listElement = document.createElement("div")
    this.listElement.className =
      "w-full border border-base-300 rounded-lg bg-base-100 max-h-48 overflow-y-auto divide-y divide-base-200 hidden"

    this.listElement.addEventListener("click", (event) => {
      event.stopPropagation()
    })

    wrapper.appendChild(this.listElement)
    this.element.appendChild(wrapper)
  }

  buildList() {
    if (!this.listElement) return

    this.listElement.innerHTML = ""

    this.optionsValue.forEach((option) => {
      const row = document.createElement("label")
      row.className =
        "flex items-center justify-between px-3 py-2 cursor-pointer hover:bg-base-200"

      const left = document.createElement("div")
      left.className = "flex items-center space-x-3"

      const name = document.createElement("div")
      name.className = "text-sm font-medium"
      name.textContent = option.label
      left.appendChild(name)

      const checkbox = document.createElement("input")
      checkbox.type = "checkbox"
      checkbox.className = "checkbox checkbox-accent"
      checkbox.name = this.inputNameValue
      checkbox.value = option.id
      checkbox.dataset.label = option.label

      checkbox.addEventListener("change", () => this.updateTriggerBadges())

      row.appendChild(left)
      row.appendChild(checkbox)
      this.listElement.appendChild(row)
    })
  }

  updateTriggerBadges() {
    if (!this.listElement || !this.triggerElement) return

    const checked = Array.from(
      this.listElement.querySelectorAll('input[type="checkbox"]:checked')
    )

    this.triggerElement.innerHTML = ""

    if (checked.length === 0) {
      const placeholder = document.createElement("span")
      placeholder.className = "text-sm text-base-content/60"
      placeholder.textContent = this.placeholderValue || ""
      this.triggerElement.appendChild(placeholder)
      return
    }

    checked.forEach((cb) => {
      const badge = document.createElement("span")
      badge.className =
        "inline-flex items-center rounded-full bg-base-200 px-3 py-1 text-sm text-base-content"
      badge.textContent = cb.dataset.label
      this.triggerElement.appendChild(badge)
    })
  }
}
