document.addEventListener('turbo:load', function() {
  const profileTrigger = document.getElementById('profile-trigger');
  const dropdownContent = document.getElementById('profile-dropdown-content');
 
  if (profileTrigger && dropdownContent) {
    // Toggle dropdown when clicking profile icon
    profileTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      dropdownContent.classList.toggle('active');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
      if (!profileTrigger.contains(e.target) && !dropdownContent.contains(e.target)) {
        dropdownContent.classList.remove('active');
      }
    });

    // Prevent dropdown from closing when clicking inside it
    dropdownContent.addEventListener('click', function(e) {
      e.stopPropagation();
    });
  }
});