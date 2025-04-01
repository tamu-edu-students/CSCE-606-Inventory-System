// Wait for the DOM to be ready
document.addEventListener("DOMContentLoaded", function() {
  console.log('Dashboard JS loaded');
  
  // Helper function to safely get elements
  function getElement(id) {
    return document.getElementById(id);
  }
  
  // Helper function to safely add event listeners
  function addListener(element, event, handler) {
    if (element) {
      element.addEventListener(event, handler);
    }
  }
  
  // Helper function to debounce input events
  function debounce(func, wait) {
    let timeout;
    return function() {
      const context = this;
      const args = arguments;
      clearTimeout(timeout);
      timeout = setTimeout(() => {
        func.apply(context, args);
      }, wait);
    };
  }
  
  // Set up bin search
  const binInput = getElement('search-inventory');
  const binButton = getElement('bin-search-button');
  const binSuggestions = getElement('bin-suggestions');
  
  if (binInput && binButton) {
    console.log('Bin search elements found');
    
    // Search on button click
    addListener(binButton, 'click', function() {
      const query = binInput.value.trim();
      window.location.href = '/bins' + (query ? `?search=${encodeURIComponent(query)}` : '');
    });
    
    // Search on Enter key
    addListener(binInput, 'keypress', function(e) {
      if (e.key === 'Enter') {
        e.preventDefault();
        binButton.click();
      }
    });
    
    // Set up suggestions
    if (binSuggestions) {
      addListener(binInput, 'input', debounce(function() {
        const query = binInput.value.trim();
        if (query.length < 2) {
          binSuggestions.innerHTML = '';
          binSuggestions.style.display = 'none';
          return;
        }
        
        fetch(`/bins/suggestions?query=${encodeURIComponent(query)}`)
          .then(response => response.ok ? response.json() : [])
          .then(data => {
            if (data && data.length > 0) {
              binSuggestions.innerHTML = '';
              binSuggestions.style.display = 'block';
              
              data.forEach(function(suggestion) {
                const div = document.createElement('div');
                div.className = 'suggestion-item';
                const icon = suggestion.type === 'bin' ? 'box' : 'tag';
                div.innerHTML = `<i class="fas fa-${icon} me-2"></i>${suggestion.name}`;
                
                addListener(div, 'click', function() {
                  binInput.value = suggestion.name;
                  binSuggestions.innerHTML = '';
                  binSuggestions.style.display = 'none';
                  binButton.click();
                });
                
                binSuggestions.appendChild(div);
              });
            } else {
              binSuggestions.innerHTML = '';
              binSuggestions.style.display = 'none';
            }
          })
          .catch(function(error) {
            console.error('Error fetching bin suggestions:', error);
          });
      }, 300));
      
      // Hide suggestions on click outside
      addListener(document, 'click', function(e) {
        if (binSuggestions && e.target !== binInput && !binSuggestions.contains(e.target)) {
          binSuggestions.style.display = 'none';
        }
      });
    }
  }
  
  // Set up item search
  const itemInput = getElement('search-items');
  const itemButton = getElement('item-search-button');
  const itemSuggestions = getElement('item-suggestions');
  
  if (itemInput && itemButton) {
    console.log('Item search elements found');
    
    // Search on button click
    addListener(itemButton, 'click', function() {
      const query = itemInput.value.trim();
      window.location.href = '/items' + (query ? `?search=${encodeURIComponent(query)}` : '');
    });
    
    // Search on Enter key
    addListener(itemInput, 'keypress', function(e) {
      if (e.key === 'Enter') {
        e.preventDefault();
        itemButton.click();
      }
    });
    
    // Set up suggestions
    if (itemSuggestions) {
      addListener(itemInput, 'input', debounce(function() {
        const query = itemInput.value.trim();
        if (query.length < 2) {
          itemSuggestions.innerHTML = '';
          itemSuggestions.style.display = 'none';
          return;
        }
        
        fetch(`/items/suggestions?query=${encodeURIComponent(query)}`)
          .then(response => response.ok ? response.json() : [])
          .then(data => {
            if (data && data.length > 0) {
              itemSuggestions.innerHTML = '';
              itemSuggestions.style.display = 'block';
              
              data.forEach(function(suggestion) {
                const div = document.createElement('div');
                div.className = 'suggestion-item';
                div.innerHTML = `<i class="fas fa-cube me-2"></i>${suggestion.name}`;
                
                addListener(div, 'click', function() {
                  itemInput.value = suggestion.name;
                  itemSuggestions.innerHTML = '';
                  itemSuggestions.style.display = 'none';
                  itemButton.click();
                });
                
                itemSuggestions.appendChild(div);
              });
            } else {
              itemSuggestions.innerHTML = '';
              itemSuggestions.style.display = 'none';
            }
          })
          .catch(function(error) {
            console.error('Error fetching item suggestions:', error);
          });
      }, 300));
      
      // Hide suggestions on click outside
      addListener(document, 'click', function(e) {
        if (itemSuggestions && e.target !== itemInput && !itemSuggestions.contains(e.target)) {
          itemSuggestions.style.display = 'none';
        }
      });
    }
  }
  
  // Set up category buttons
  const categoryButtons = document.querySelectorAll('.category-tag');
  if (categoryButtons.length > 0) {
    console.log('Category buttons found:', categoryButtons.length);
    categoryButtons.forEach(function(button) {
      addListener(button, 'click', function() {
        const buttonText = this.textContent.trim();
        const categoryName = buttonText.replace(/[\n\r]+|[\s]{2,}/g, ' ').trim();
        window.location.href = `/bins?category=${encodeURIComponent(categoryName)}`;
      });
    });
  }
}); 