import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["binsInput", "binsButton", "itemsInput", "itemsButton"]

    connect() {
        console.log("Dashboard controller connected")
        this.setupSuggestions()
    }

    searchBins(event) {
        if (event.type === "keypress" && event.key !== "Enter") return
        event.preventDefault()
        
        console.log("Searching bins...")
        const query = this.binsInputTarget.value.trim()
        window.location.href = query ? 
            `/bins?search=${encodeURIComponent(query)}` : 
            '/bins'
    }

    searchItems(event) {
        if (event.type === "keypress" && event.key !== "Enter") return
        event.preventDefault()
        
        console.log("Searching items...")
        const query = this.itemsInputTarget.value.trim()
        window.location.href = query ? 
            `/items?search=${encodeURIComponent(query)}` : 
            '/items'
    }

    searchByCategory(event) {
        const category = event.currentTarget.textContent.trim()
        console.log("Searching by category:", category)
        window.location.href = `/bins?category=${encodeURIComponent(category)}`
    }
    
    setupSuggestions() {
        const binInput = this.binsInputTarget
        const binSuggestionsContainer = document.getElementById('bin-suggestions')
        const itemInput = this.itemsInputTarget
        const itemSuggestionsContainer = document.getElementById('item-suggestions')
        
        console.log("Setting up suggestions:", 
                    { binInput, binSuggestionsContainer, itemInput, itemSuggestionsContainer })
        
        if (binInput && binSuggestionsContainer) {
            binInput.addEventListener('input', this.debounce(() => {
                const query = binInput.value.trim()
                if (query.length < 2) {
                    binSuggestionsContainer.innerHTML = ''
                    binSuggestionsContainer.style.display = 'none'
                    return
                }
                
                console.log('Fetching bin suggestions for:', query)
                
                fetch(`/bins/suggestions?query=${encodeURIComponent(query)}`)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error(`HTTP error! Status: ${response.status}`)
                        }
                        return response.json()
                    })
                    .then(data => {
                        console.log('Received bin suggestions:', data)
                        if (data && data.length > 0) {
                            binSuggestionsContainer.innerHTML = ''
                            binSuggestionsContainer.style.display = 'block'
                            
                            data.forEach(suggestion => {
                                const div = document.createElement('div')
                                div.className = 'suggestion-item'
                                
                                const icon = suggestion.type === 'bin' ? 'box' : 'tag'
                                div.innerHTML = `<i class="fas fa-${icon} me-2"></i>${suggestion.name}`
                                
                                div.addEventListener('click', () => {
                                    binInput.value = suggestion.name
                                    binSuggestionsContainer.style.display = 'none'
                                    
                                    // Trigger search
                                    const searchEvent = new Event('click')
                                    const searchBtn = document.querySelector('[data-action="click->dashboard#searchBins"]')
                                    if (searchBtn) searchBtn.dispatchEvent(searchEvent)
                                })
                                
                                binSuggestionsContainer.appendChild(div)
                            })
                        } else {
                            binSuggestionsContainer.innerHTML = ''
                            binSuggestionsContainer.style.display = 'none'
                        }
                    })
                    .catch(error => {
                        console.error('Error fetching bin suggestions:', error)
                        binSuggestionsContainer.innerHTML = ''
                        binSuggestionsContainer.style.display = 'none'
                    })
            }, 300))
            
            // Hide suggestions when clicking outside
            document.addEventListener('click', (e) => {
                if (e.target !== binInput && !binSuggestionsContainer.contains(e.target)) {
                    binSuggestionsContainer.style.display = 'none'
                }
            })
        }
        
        if (itemInput && itemSuggestionsContainer) {
            itemInput.addEventListener('input', this.debounce(() => {
                const query = itemInput.value.trim()
                if (query.length < 2) {
                    itemSuggestionsContainer.innerHTML = ''
                    itemSuggestionsContainer.style.display = 'none'
                    return
                }
                
                console.log('Fetching item suggestions for:', query)
                
                fetch(`/items/suggestions?query=${encodeURIComponent(query)}`)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error(`HTTP error! Status: ${response.status}`)
                        }
                        return response.json()
                    })
                    .then(data => {
                        console.log('Received item suggestions:', data)
                        if (data && data.length > 0) {
                            itemSuggestionsContainer.innerHTML = ''
                            itemSuggestionsContainer.style.display = 'block'
                            
                            data.forEach(suggestion => {
                                const div = document.createElement('div')
                                div.className = 'suggestion-item'
                                div.innerHTML = `<i class="fas fa-cube me-2"></i>${suggestion.name}`
                                
                                div.addEventListener('click', () => {
                                    itemInput.value = suggestion.name
                                    itemSuggestionsContainer.style.display = 'none'
                                    
                                    // Trigger search
                                    const searchEvent = new Event('click')
                                    const searchBtn = document.querySelector('[data-action="click->dashboard#searchItems"]')
                                    if (searchBtn) searchBtn.dispatchEvent(searchEvent)
                                })
                                
                                itemSuggestionsContainer.appendChild(div)
                            })
                        } else {
                            itemSuggestionsContainer.innerHTML = ''
                            itemSuggestionsContainer.style.display = 'none'
                        }
                    })
                    .catch(error => {
                        console.error('Error fetching item suggestions:', error)
                        itemSuggestionsContainer.innerHTML = ''
                        itemSuggestionsContainer.style.display = 'none'
                    })
            }, 300))
            
            // Hide suggestions when clicking outside
            document.addEventListener('click', (e) => {
                if (e.target !== itemInput && !itemSuggestionsContainer.contains(e.target)) {
                    itemSuggestionsContainer.style.display = 'none'
                }
            })
        }
    }
    
    debounce(func, wait) {
        let timeout
        return function() {
            const context = this
            const args = arguments
            clearTimeout(timeout)
            timeout = setTimeout(() => {
                func.apply(context, args)
            }, wait)
        }
    }
} 