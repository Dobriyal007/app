// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Application } from "@hotwired/turbo-rails"
import "@hotwired/turbo-rails"
// Turbo.disableDriveByDefault();
import "controllers"

const application = Application.start()

application.debug = false
window.Stimulus = application

Turbo.session.drive = false

export { application }
