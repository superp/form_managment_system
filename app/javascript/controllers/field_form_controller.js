import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stringValidations", "integerValidations", "datetimeValidations"]
  static values = { currentType: String }

  connect() {
    this.toggleValidations()
  }

  fieldTypeChanged(event) {
    this.currentTypeValue = event.target.value
    this.toggleValidations()
  }

  toggleValidations() {
    // Hide all validation sections
    this.stringValidationsTarget.style.display = "none"
    this.integerValidationsTarget.style.display = "none"
    this.datetimeValidationsTarget.style.display = "none"

    // Show relevant section based on field type
    switch (this.currentTypeValue) {
      case "string":
        this.stringValidationsTarget.style.display = "block"
        break
      case "integer":
        this.integerValidationsTarget.style.display = "block"
        break
      case "datetime":
        this.datetimeValidationsTarget.style.display = "block"
        break
    }
  }
}
