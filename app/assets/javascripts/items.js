document.addEventListener("turbo:load", function () {
  const filterInput = document.getElementById("filterInput");
  const valueFilter = document.getElementById("valueFilter");
  const resetButton = document.getElementById("resetFilters");
  const table = document.getElementById("itemsTable");
  const rows = table
    .getElementsByTagName("tbody")[0]
    .getElementsByTagName("tr");
  const sortableHeaders = document.querySelectorAll(".sortable");

  // 🔹 SEARCH FUNCTIONALITY (FILTER BY ITEM NAME)
  filterInput.addEventListener("input", function () {
    const searchText = this.value.toLowerCase();
    filterTable(searchText, valueFilter.value);
  });

  // 🔹 FILTER BY VALUE
  valueFilter.addEventListener("input", function () {
    const searchText = filterInput.value.toLowerCase();
    filterTable(searchText, this.value);
  });

  function filterTable(searchText, value) {
    for (let row of rows) {
      let name = row
        .querySelector('[data-column="name"]')
        .textContent.toLowerCase();
      let itemValue =
        parseFloat(
          row
            .querySelector('[data-column="value"]')
            .textContent.replace(/[^0-9.]/g, "")
        ) || 0;

      let matchesSearch = name.includes(searchText);
      let matchesValue = value === "" || itemValue >= parseFloat(value);

      row.style.display = matchesSearch && matchesValue ? "" : "none";
    }
  }

  // 🔹 RESET FILTERS
  resetButton.addEventListener("click", function () {
    filterInput.value = "";
    valueFilter.value = "";
    filterTable("", "");
  });

  // 🔹 SORTING FUNCTIONALITY (Fixes Sorting on "Value" Column)
  sortableHeaders.forEach((header) => {
    header.addEventListener("click", function () {
      const column = this.getAttribute("data-column");
      const ascending = !this.classList.contains("asc");

      sortableHeaders.forEach((h) => h.classList.remove("asc", "desc"));
      this.classList.add(ascending ? "asc" : "desc");

      sortTable(column, ascending);
    });
  });

  function sortTable(column, ascending) {
    const tbody = table.querySelector("tbody");
    const rowsArray = Array.from(tbody.querySelectorAll("tr"));

    rowsArray.sort((rowA, rowB) => {
      let a = rowA
        .querySelector(`[data-column="${column}"]`)
        .textContent.trim();
      let b = rowB
        .querySelector(`[data-column="${column}"]`)
        .textContent.trim();

      // 🔹 Ensure "Value" column is sorted as a NUMBER
      if (column === "value") {
        a = parseFloat(a.replace(/[^0-9.]/g, "")) || 0;
        b = parseFloat(b.replace(/[^0-9.]/g, "")) || 0;
        return ascending ? a - b : b - a; // Proper numerical sorting
      }

      return ascending
        ? a.localeCompare(b, undefined, { numeric: true })
        : b.localeCompare(a, undefined, { numeric: true });
    });

    tbody.innerHTML = "";
    rowsArray.forEach((row) => tbody.appendChild(row));
  }
});
