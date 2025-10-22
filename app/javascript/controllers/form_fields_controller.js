import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fieldList"]
  static values = { nextPosition: Number, availableFields: Array }

  connect() {
    this.nextPositionValue = this.fieldListTarget.children.length + 1
    this.updatePositions()
  }

  addField(event) {
    event.preventDefault()

    // Create a new form field entry using Rails nested attributes
    const newFieldElement = this.createFieldElement()
    this.fieldListTarget.appendChild(newFieldElement)
    this.nextPositionValue++
    this.updatePositions()
  }

  removeField(event) {
    event.preventDefault()
    const item = event.target.closest('.form-field-item')
    const destroyCheckbox = item.querySelector('.destroy-checkbox')

    if (destroyCheckbox) {
      // Mark for destruction using Rails nested attributes
      destroyCheckbox.checked = true
      item.style.display = 'none'
    } else {
      // Remove from DOM if it's a new item
      item.remove()
    }
    this.updatePositions()
  }

  updatePositions() {
    // Auto-assign positions if not manually set
    const items = this.fieldListTarget.querySelectorAll('.form-field-item:not([style*="display: none"])')
    items.forEach((item, index) => {
      const positionInput = item.querySelector('.position-input')
      if (positionInput && !positionInput.value) {
        positionInput.value = index + 1
      }
    })
  }

  createFieldElement() {
    const fieldElement = document.createElement('div')
    fieldElement.className = 'form-field-item'

    // Get the current timestamp for unique field names
    const timestamp = Date.now()

    fieldElement.innerHTML = `
      <div class="field-selection">
        <label>Field:</label>
        <select name="form[form_fields_attributes][${timestamp}][field_id]" class="field-select">
          <option value="">Select a field</option>
          ${this.getFieldOptions()}
        </select>
      </div>
      <div class="field-position">
        <label>Position:</label>
        <input type="number" name="form[form_fields_attributes][${timestamp}][position]" min="1" class="position-input" value="${this.nextPositionValue}">
      </div>
      <div class="field-controls">
        <input type="checkbox" name="form[form_fields_attributes][${timestamp}][_destroy]" class="destroy-checkbox">
        <label>Remove</label>
      </div>
    `

    return fieldElement
  }

  getFieldOptions() {
    return this.availableFieldsValue.map(field =>
      `<option value="${field.id}">${field.name} (${field.field_type})</option>`
    ).join('')
  }
}
