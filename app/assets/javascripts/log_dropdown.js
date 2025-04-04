document.addEventListener('turbo:load', function() {
  // Get all popup elements
  const logTrigger = document.getElementById('log-trigger');
  const logContent = document.getElementById('log-dropdown-content');
  const saleTrigger = document.getElementById('sale-trigger');
  const saleContent = document.getElementById('sale-dropdown-content');
  const overlay = document.getElementById('popup-overlay');

  // Function to close all popups
  function closeAllPopups() {
    const allPopups = document.querySelectorAll('.popup-content');
    allPopups.forEach(popup => popup.classList.remove('active'));
    overlay.classList.remove('active');
  }

  // Function to toggle a specific popup
  function togglePopup(popupContent) {
    const isActive = popupContent.classList.contains('active');

    // Close all popups first
    closeAllPopups();

    // If the clicked popup wasn't active, open it
    if (!isActive) {
      popupContent.classList.add('active');
      overlay.classList.add('active');
    }
  }

  // Set up LOG dropdown
  if (logTrigger && logContent) {
    // Toggle dropdown when clicking log link
    logTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      togglePopup(logContent);
    });

    // Set up close button
    const logCloseBtn = logContent.querySelector('.close-popup');
    if (logCloseBtn) {
      logCloseBtn.addEventListener('click', closeAllPopups);
    }
  }

  // Set up SALE dropdown
  if (saleTrigger && saleContent) {
    saleTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      togglePopup(saleContent);
    });

    // Set up close button
    const saleCloseBtn = saleContent.querySelector('.close-popup');
    if (saleCloseBtn) {
      saleCloseBtn.addEventListener('click', closeAllPopups);
    }
  }

  // Close popups when clicking on overlay
  if (overlay) {
    overlay.addEventListener('click', closeAllPopups);
  }

  // Close popups when clicking outside
  document.addEventListener('click', function(e) {
    const isClickInsidePopup = Array.from(document.querySelectorAll('.popup-content')).some(popup => popup.contains(e.target));
    const isClickOnTrigger = e.target.id === 'log-trigger' || e.target.id === 'sale-trigger' || e.target.id === 'profile-trigger';

    if (!isClickInsidePopup && !isClickOnTrigger) {
      closeAllPopups();
    }
  });

  // Prevent popup from closing when clicking inside it
  document.querySelectorAll('.popup-content').forEach(popup => {
    popup.addEventListener('click', function(e) {
      e.stopPropagation();
    });
  });
});
