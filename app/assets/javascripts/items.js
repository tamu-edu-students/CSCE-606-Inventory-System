document.addEventListener("DOMContentLoaded", () => {
  const filterInput = document.getElementById("filterInput");
  const valueFilter = document.getElementById("valueFilter");
  const resetButton = document.getElementById("resetFilters");
  const itemCards = document.querySelectorAll(".item-card");
  const noResultsMessage = document.getElementById("noResultsMessage");


  function filterItems() {
    const nameQuery = filterInput.value.toLowerCase();
    const valueQuery = parseFloat(valueFilter.value);

    itemCards.forEach(card => {
      const name = card.getAttribute("data-name");
      const value = parseFloat(card.getAttribute("data-value"));

      const matchesName = name.includes(nameQuery);
      const matchesValue = isNaN(valueQuery) || value <= valueQuery;

      if (matchesName && matchesValue) {
        card.style.display = "";
      } else {
        card.style.display = "none";
      }
    });
    const anyVisible = Array.from(itemCards).some(card => card.style.display !== "none");
    noResultsMessage.style.display = anyVisible ? "none" : "block";
  }

  filterInput.addEventListener("input", filterItems);
  valueFilter.addEventListener("input", filterItems);

  resetButton.addEventListener("click", () => {
    filterInput.value = "";
    valueFilter.value = "";
    itemCards.forEach(card => card.style.display = "");
  });
});
