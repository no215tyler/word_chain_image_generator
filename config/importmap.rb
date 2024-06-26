# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "game", to: "game.js"
pin "romajiToHiraganaMap", to: "romajiToHiraganaMap.js"
pin "kana_conversion", to: "kana_conversion.js"
pin "images_index", to: "images_index.js"
pin "hamburger", to: "hamburger.js"
