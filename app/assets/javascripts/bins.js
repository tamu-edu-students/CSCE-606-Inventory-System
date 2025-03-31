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
  