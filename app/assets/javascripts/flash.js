document.addEventListener("turbo:load", function () {
  // Small delay to ensure DOM is updated
  setTimeout(() => {
    // ⛏ Select ALL elements with class .flash-popup (in case of multiple flash messages)
    const flashPopups = document.querySelectorAll(".flash-popup");

    flashPopups.forEach((flashPopup) => {
      console.log("Flash message found:", flashPopup.innerText); // Optional debugging

      // 🔧 Create the modal container
      const flashModal = document.createElement("div");
      flashModal.classList.add("flash-modal");

      // 🔧 Create the modal content
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

      // ✅ Remove the original hidden flash element from the DOM
      flashPopup.remove();
    });
  }, 300);
});
