# Pin npm packages by running ./bin/importmap

# Core Rails packages
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Controllers
pin_all_from "app/javascript/controllers", under: "controllers"

# Third-party packages
pin "bootstrap", to: "bootstrap.min.js"
pin "@popperjs/core", to: "popper.js"
