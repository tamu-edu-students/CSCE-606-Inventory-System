document.addEventListener("DOMContentLoaded", function () {
    const binsContainer = document.querySelector(".bins-container");
    const categoryFilter = document.getElementById("categoryFilter");
    const sortByNameBtn = document.getElementById("sortByName");
  
    // Sorting by Name
    sortByNameBtn.addEventListener("click", function () {
      const bins = Array.from(binsContainer.children);
      bins.sort((a, b) => {
        const nameA = a.dataset.name;
        const nameB = b.dataset.name;
        return nameA.localeCompare(nameB);
      });
  
      binsContainer.innerHTML = "";
      bins.forEach(bin => binsContainer.appendChild(bin));
    });
  
    // Filtering by Category
    categoryFilter.addEventListener("change", function () {
      const selectedCategory = this.value.toLowerCase();
      Array.from(binsContainer.children).forEach(bin => {
        const binCategory = bin.dataset.category;
        bin.style.display = (selectedCategory === "" || binCategory === selectedCategory) ? "" : "none";
      });
    });
  });
  