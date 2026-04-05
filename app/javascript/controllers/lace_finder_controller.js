import { Controller } from "@hotwired/stimulus"

// Controls the lace finder upload form UX:
//  - Shows a live image preview once a file is chosen
//  - Enables the submit button only when a file is selected
//  - Shows a loading spinner while the form is submitting
//  - Allows the user to remove the selected photo and start over
export default class extends Controller {
  static targets = [
    "fileInput",
    "dropzone",
    "preview",
    "previewImg",
    "submitBtn",
    "loading",
    "actions"
  ]

  connect() {
    // Submit button is disabled until a file is chosen
    this.submitBtnTarget.disabled = true
  }

  previewImage(event) {
    const file = event.target.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewImgTarget.src       = e.target.result
      this.previewTarget.style.display  = "flex"
      this.dropzoneTarget.style.display = "none"
      this.submitBtnTarget.disabled     = false
    }
    reader.readAsDataURL(file)
  }

  clearImage() {
    this.fileInputTarget.value        = ""
    this.previewImgTarget.src         = ""
    this.previewTarget.style.display  = "none"
    this.dropzoneTarget.style.display = "flex"
    this.submitBtnTarget.disabled     = true
  }

  submitStart() {
    this.actionsTarget.style.display = "none"
    this.loadingTarget.style.display = "flex"
    this.submitBtnTarget.disabled    = true
  }

  // Called by turbo:submit-end — restores UI if the server returned an error
  submitEnd(event) {
    if (!event.detail.success) {
      this.actionsTarget.style.display = "block"
      this.loadingTarget.style.display = "none"
      this.submitBtnTarget.disabled    = false
    }
  }
}
