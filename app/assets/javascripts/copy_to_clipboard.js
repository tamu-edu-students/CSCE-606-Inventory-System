function copyToClipboard(button) {
  const input = button.parentElement.querySelector("input");

  if (!input) {
    console.error("No input field found to copy.");
    return;
  }

  const valueToCopy = input.value;

  navigator.clipboard
    .writeText(valueToCopy)
    .then(() => {
      console.log("Copied:", valueToCopy);

      // Change the icon to a checkmark
      const icon = button.querySelector("i");
      if (icon) {
        icon.classList.remove("fa-copy");
        icon.classList.add("fa-check");
      }

      // Restore the copy icon after 2 seconds
      setTimeout(() => {
        if (icon) {
          icon.classList.remove("fa-check");
          icon.classList.add("fa-copy");
        }
      }, 2000);
    })
    .catch((err) => {
      console.error("Failed to copy text: ", err);
    });
}
