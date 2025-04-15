document.addEventListener('DOMContentLoaded', function() {
  console.log('Profile dropdown script loaded');
  
  const profileTrigger = document.getElementById('profile-trigger');
  const dropdownContent = document.getElementById('profile-dropdown-content');
 
  if (profileTrigger && dropdownContent) {
    console.log('Profile dropdown elements found');
    
    // Toggle dropdown when clicking profile icon
    profileTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      dropdownContent.classList.toggle('active');
      console.log('Profile dropdown toggled:', dropdownContent.classList.contains('active'));
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
  } else {
    console.log('Profile dropdown elements not found');
  }
});