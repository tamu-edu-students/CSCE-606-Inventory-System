document.addEventListener("turbo:load", function () {
  // 🟢 (1) Existing flash popup logic (you already have this)
  setTimeout(() => {
    const flashPopups = document.querySelectorAll(".flash-popup");

    flashPopups.forEach((flashPopup) => {
      const flashModal = document.createElement("div");
      flashModal.classList.add("flash-modal");

      const flashContent = document.createElement("div");
      flashContent.classList.add("flash-content");

      const message = document.createElement("p");
      message.innerText = flashPopup.innerText;

      const closeButton = document.createElement("button");
      closeButton.innerText = "OK";
      closeButton.classList.add("flash-close-btn");
      closeButton.addEventListener("click", function () {
        flashModal.remove();
      });

      flashContent.appendChild(message);
      flashContent.appendChild(closeButton);
      flashModal.appendChild(flashContent);
      document.body.appendChild(flashModal);

      flashPopup.remove();
    });
  }, 300);

  // 🛑 (2) MISSING: Intercept delete form submissions!
  document.querySelectorAll("form[data-custom-confirm]").forEach((form) => {
    form.addEventListener("submit", function (event) {
      event.preventDefault(); // stop default behavior

      const message = form.dataset.customConfirm;

      showConfirmationModal(message, () => {
        form.submit(); // resume after confirmation
      });
    });
  });
});

// === SHARED CONFIRMATION MODAL FUNCTION ===
function showConfirmationModal(message, onConfirm) {
  console.log("Showing confirmation modal", message); // Optional debugging
  const confirmModal = document.createElement("div");
  confirmModal.classList.add("flash-modal");

  const confirmContent = document.createElement("div");
  confirmContent.classList.add("flash-content");

  const msg = document.createElement("p");
  msg.innerText = message;

  const btnConfirm = document.createElement("button");
  btnConfirm.innerText = "Yes";
  btnConfirm.classList.add("flash-close-btn");
  btnConfirm.style.marginRight = "10px";
  btnConfirm.addEventListener("click", () => {
    confirmModal.remove();
    onConfirm(); // Proceed with form submit
  });

  const btnCancel = document.createElement("button");
  btnCancel.innerText = "Cancel";
  btnCancel.classList.add("flash-close-btn");
  btnCancel.addEventListener("click", () => {
    confirmModal.remove();
  });

  confirmContent.appendChild(msg);
  confirmContent.appendChild(btnConfirm);
  confirmContent.appendChild(btnCancel);
  confirmModal.appendChild(confirmContent);
  document.body.appendChild(confirmModal);
}
