document.addEventListener("DOMContentLoaded", function () {
    const binsContainer = document.querySelector(".bins-container");
    const categoryFilter = document.getElementById("categoryFilter");
    const sortByNameBtn = document.getElementById("sortByName");
    let isAscending = true;
  
    // Sorting by Name
    sortByNameBtn.addEventListener("click", function () {
      const bins = Array.from(binsContainer.children);
      bins.sort((a, b) => {
        // Get the bin name from the link inside the title
        const nameA = a.querySelector(".bin-title .bin-link").textContent.trim();
        const nameB = b.querySelector(".bin-title .bin-link").textContent.trim();
        return isAscending ? 
          nameA.localeCompare(nameB) : 
          nameB.localeCompare(nameA);
      });
  
      // Clear and re-append sorted bins
      binsContainer.innerHTML = "";
      bins.forEach(bin => binsContainer.appendChild(bin));
      
      // Toggle sort direction
      isAscending = !isAscending;
      sortByNameBtn.innerHTML = `Sort by Name ${isAscending ? '↑' : '↓'}`;
    });
  
    // Filtering by Category
    categoryFilter.addEventListener("change", function () {
      const selectedCategory = this.value;
      const bins = binsContainer.children;
      let visibleCount = 0;
      
      // Debug: Log the selected category
      console.log("Selected category:", selectedCategory);
      
      Array.from(bins).forEach(bin => {
        const binCategory = bin.dataset.category;
        // Debug: Log each bin's category
        console.log("Bin category:", binCategory);
        
        // Case-insensitive comparison
        const shouldShow = selectedCategory === "" || 
                          binCategory.toLowerCase() === selectedCategory.toLowerCase();
        
        bin.style.display = shouldShow ? "" : "none";
        if (shouldShow) visibleCount++;
      });

      // Show/hide no results message
      const noResultsMessage = document.querySelector(".no-results-message");
      if (visibleCount === 0) {
        if (!noResultsMessage) {
          const message = document.createElement("div");
          message.className = "alert alert-info no-results-message";
          message.innerHTML = '<i class="fas fa-info-circle me-2"></i>No bins found in this category';
          binsContainer.parentNode.insertBefore(message, binsContainer);
        }
      } else if (noResultsMessage) {
        noResultsMessage.remove();
      }
    });
});

document.addEventListener('turbo:load', function() {
  // Log dropdown functionality
  const logTrigger = document.getElementById('log-trigger');
  const logDropdown = document.getElementById('log-dropdown-content');

  if (logTrigger && logDropdown) {
    logTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      logDropdown.classList.toggle('show');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
      if (!logTrigger.contains(e.target) && !logDropdown.contains(e.target)) {
        logDropdown.classList.remove('show');
      }
    });
  }

  // Sale dropdown functionality
  const saleTrigger = document.getElementById('sale-trigger');
  const saleDropdown = document.getElementById('sale-dropdown-content');

  if (saleTrigger && saleDropdown) {
    saleTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      saleDropdown.classList.toggle('show');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
      if (!saleTrigger.contains(e.target) && !saleDropdown.contains(e.target)) {
        saleDropdown.classList.remove('show');
      }
    });
  }

  // Profile dropdown functionality
  const profileTrigger = document.getElementById('profile-trigger');
  const profileDropdown = document.getElementById('profile-dropdown-content');

  if (profileTrigger && profileDropdown) {
    profileTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      profileDropdown.classList.toggle('show');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
      if (!profileTrigger.contains(e.target) && !profileDropdown.contains(e.target)) {
        profileDropdown.classList.remove('show');
      }
    });
  }

  // Bin filter functionality
  const binFilter = document.getElementById('binFilter');
  const binCards = document.querySelectorAll('.bin-card');

  if (binFilter && binCards.length > 0) {
    binFilter.addEventListener('change', function() {
      const selectedCategory = this.value.toLowerCase();
      
      binCards.forEach(bin => {
        const binCategory = bin.dataset.category.toLowerCase();
        if (selectedCategory === '' || binCategory === selectedCategory) {
          bin.style.display = '';
        } else {
          bin.style.display = 'none';
        }
      });

      // Show/hide no results message
      const visibleBins = document.querySelectorAll('.bin-card[style=""]').length;
      const noResultsMessage = document.getElementById('noResultsMessage');
      if (noResultsMessage) {
        noResultsMessage.style.display = visibleBins === 0 ? 'block' : 'none';
      }
    });
  }

  // Bin sort functionality
  const binSort = document.getElementById('binSort');
  const binContainer = document.querySelector('.row');

  if (binSort && binContainer) {
    binSort.addEventListener('change', function() {
      const bins = Array.from(binCards);
      const sortBy = this.value;

      bins.sort((a, b) => {
        switch(sortBy) {
          case 'name':
            return a.dataset.name.localeCompare(b.dataset.name);
          case 'category':
            return a.dataset.category.localeCompare(b.dataset.category);
          case 'items':
            return parseInt(b.dataset.items) - parseInt(a.dataset.items);
          default:
            return 0;
        }
      });

      bins.forEach(bin => binContainer.appendChild(bin));
    });
  }

  // Delete confirmation
  const deleteForms = document.querySelectorAll('form[data-custom-confirm]');
  deleteForms.forEach(form => {
    form.addEventListener('submit', function(e) {
      if (!confirm(this.dataset.customConfirm)) {
        e.preventDefault();
      }
    });
  });
});
  