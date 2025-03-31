document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById("locationSearch");
    const locationCards = document.querySelectorAll(".location-card");
    const noMessage = document.getElementById("noLocationsMessage");
  
    searchInput.addEventListener("input", () => {
      const query = searchInput.value.toLowerCase();
      let matches = 0;
  
      locationCards.forEach(card => {
        const name = card.dataset.name;
        const show = name.includes(query);
        card.style.display = show ? "" : "none";
        if (show) matches++;
      });
  
      noMessage.style.display = matches === 0 ? "block" : "none";
    });
  });

var editModal = document.getElementById("editLocationModal");
var deleteModal = document.getElementById("deleteLocationModal");
var warningModal = document.getElementById("warningModal"); // New warning modal

var editForm = document.getElementById('editLocationForm');
var deleteForm = document.getElementById('deleteLocationForm');

var editSpan = editModal.querySelector(".close");
var deleteSpan = deleteModal.querySelector(".close");
var warningSpan = warningModal.querySelector(".close");
var warningOk = document.getElementById("warningOkButton");
var noButton = document.getElementById("noButton");

// Close handlers
editSpan.onclick = () => editModal.style.display = "none";
deleteSpan.onclick = () => deleteModal.style.display = "none";
warningSpan.onclick = () => warningModal.style.display = "none";
noButton.onclick = () => deleteModal.style.display = "none";
warningOk.onclick = () => warningModal.style.display = "none";

window.onclick = function(event) {
if (event.target === editModal) editModal.style.display = "none";
if (event.target === deleteModal) deleteModal.style.display = "none";
if (event.target === warningModal) warningModal.style.display = "none";
};

document.querySelectorAll('.editLocationBtn').forEach(button => {
button.onclick = function() {
    var locationId = this.getAttribute('data-location-id');
    editForm.action = '/locations/' + locationId;
    editModal.style.display = "block";
};
});

document.querySelectorAll('.deleteLocationBtn').forEach(button => {
button.onclick = function() {
    var locationId = this.getAttribute('data-location-id');
    var bins = parseInt(this.getAttribute('data-bins'), 10);
    var items = parseInt(this.getAttribute('data-items'), 10);

    if (bins > 0 || items > 0) {
    // Show warning if there are bins or items
    warningModal.style.display = "block";
    } else {
    // Proceed with delete confirmation
    deleteForm.action = '/locations/' + locationId;
    deleteModal.style.display = "block";
    }
};
});


document.addEventListener("DOMContentLoaded", () => {
    const addBtn = document.querySelector(".addLocationBtn");
    const addModal = document.getElementById("addLocationModal");
    const closeBtn = addModal.querySelector(".close");
  
    addBtn.addEventListener("click", () => {
      addModal.style.display = "block";
    });
  
    closeBtn.addEventListener("click", () => {
      addModal.style.display = "none";
    });
  
    window.addEventListener("click", (event) => {
      if (event.target === addModal) {
        addModal.style.display = "none";
      }
    });
  });
  