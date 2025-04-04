document.addEventListener('turbo:load', function() {
  const profileTrigger = document.getElementById('profile-trigger');
  const profileContent = document.getElementById('profile-dropdown-content');
  const overlay = document.getElementById('popup-overlay');

  // Function to close profile popup
  function closeProfilePopup() {
    if (profileContent) {
      profileContent.classList.remove('active');
    }
    if (overlay) {
      overlay.classList.remove('active');
    }
  }

  // Function to toggle profile popup
  function toggleProfilePopup() {
    const isActive = profileContent.classList.contains('active');

    // Close first if it's open
    closeProfilePopup();

    // If it wasn't active, open it
    if (!isActive) {
      profileContent.classList.add('active');
      overlay.classList.add('active');
    }
  }

  if (profileTrigger && profileContent) {
    // Toggle dropdown when clicking profile icon
    profileTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      toggleProfilePopup();
    });

    // Set up close button
    const profileCloseBtn = profileContent.querySelector('.close-popup');
    if (profileCloseBtn) {
      profileCloseBtn.addEventListener('click', closeProfilePopup);
    }

    // Prevent dropdown from closing when clicking inside it
    profileContent.addEventListener('click', function(e) {
      e.stopPropagation();
    });
  }

  // Close when clicking on overlay (if not already handled in log_dropdown.js)
  if (overlay) {
    overlay.addEventListener('click', closeProfilePopup);
  }
});