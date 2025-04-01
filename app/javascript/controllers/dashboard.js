// Wait for Turbo to load the page
document.addEventListener("turbo:load", initializeSearch);

// Also handle regular DOM load for first page load
document.addEventListener("DOMContentLoaded", () => {
    initializeSearch();
});

function initializeSearch() {
    // Search Inventory (Bins & Categories)
    const searchInventoryInput = document.querySelector("#search-inventory");
    const searchInventoryBtn = document.querySelector("#search-inventory-btn");
    
    if (searchInventoryBtn && searchInventoryInput) {
        console.log("Bins search elements found"); // Debug log
        const handleBinSearch = () => {
            const query = searchInventoryInput.value.trim();
            window.location.href = query ? 
                `/bins?search=${encodeURIComponent(query)}` : 
                '/bins';
        };

        searchInventoryBtn.addEventListener("click", handleBinSearch);
        searchInventoryInput.addEventListener("keypress", (e) => {
            if (e.key === "Enter") {
                e.preventDefault();
                handleBinSearch();
            }
        });
    } else {
        console.log("Bins search elements not found"); // Debug log
    }

    // Search Items
    const searchItemsInput = document.querySelector("#search-items");
    const searchItemsBtn = document.querySelector("#search-items-btn");
    
    if (searchItemsBtn && searchItemsInput) {
        console.log("Items search elements found"); // Debug log
        const handleItemSearch = () => {
            const query = searchItemsInput.value.trim();
            window.location.href = query ? 
                `/items?search=${encodeURIComponent(query)}` : 
                '/items';
        };

        searchItemsBtn.addEventListener("click", handleItemSearch);
        searchItemsInput.addEventListener("keypress", (e) => {
            if (e.key === "Enter") {
                e.preventDefault();
                handleItemSearch();
            }
        });
    } else {
        console.log("Items search elements not found"); // Debug log
    }

    // Quick Categories
    const categoryTags = document.querySelectorAll(".category-tag");
    if (categoryTags.length > 0) {
        categoryTags.forEach(tag => {
            tag.addEventListener("click", () => {
                const category = tag.textContent.trim();
                window.location.href = `/bins?category=${encodeURIComponent(category)}`;
            });
        });
    }

    // Search functionality for bins
    const binSearchForm = document.querySelector('form[data-search-bins]');
    const binSearchInput = document.querySelector('input[data-search-bins-input]');
    const binSearchButton = document.querySelector('button[data-search-bins-button]');

    if (binSearchForm) {
        binSearchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const searchQuery = binSearchInput.value.trim();
            if (searchQuery) {
                window.location.href = `/bins?search=${encodeURIComponent(searchQuery)}`;
            }
        });
    }

    if (binSearchButton) {
        binSearchButton.addEventListener('click', function(e) {
            e.preventDefault();
            const searchQuery = binSearchInput.value.trim();
            if (searchQuery) {
                window.location.href = `/bins?search=${encodeURIComponent(searchQuery)}`;
            }
        });
    }

    // Items search
    const itemSearchForm = document.querySelector('form[data-search-items]');
    const itemSearchInput = document.querySelector('input[data-search-items-input]');
    const itemSearchButton = document.querySelector('button[data-search-items-button]');

    if (itemSearchForm) {
        itemSearchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const searchQuery = itemSearchInput.value.trim();
            if (searchQuery) {
                window.location.href = `/items?search=${encodeURIComponent(searchQuery)}`;
            }
        });
    }

    if (itemSearchButton) {
        itemSearchButton.addEventListener('click', function(e) {
            e.preventDefault();
            const searchQuery = itemSearchInput.value.trim();
            if (searchQuery) {
                window.location.href = `/items?search=${encodeURIComponent(searchQuery)}`;
            }
        });
    }
} 