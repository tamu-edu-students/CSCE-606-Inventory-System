document.addEventListener('turbo:load', function() {
    const logTrigger = document.getElementById('log-trigger');
    const dropdownContent = document.getElementById('log-dropdown-content');
   
    if (logTrigger && dropdownContent) {
      // Toggle dropdown when clicking log link
      logTrigger.addEventListener('click', function(e) {
        e.preventDefault();
        dropdownContent.classList.toggle('active');
      });
  
      // Close dropdown when clicking outside
      document.addEventListener('click', function(e) {
        if (!logTrigger.contains(e.target) && !dropdownContent.contains(e.target)) {
          dropdownContent.classList.remove('active');
        }
      });
  
      // Prevent dropdown from closing when clicking inside it
      dropdownContent.addEventListener('click', function(e) {
        e.stopPropagation();
      });
    }

    // Sale dropdown functionality
    const saleTrigger = document.getElementById('sale-trigger');
    const saleDropdownContent = document.getElementById('sale-dropdown-content');
   
    if (saleTrigger && saleDropdownContent) {
        saleTrigger.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            saleDropdownContent.classList.toggle('active');
            console.log(saleDropdownContent.classList);
        });
  
        document.addEventListener('click', function(e) {
            if (!saleTrigger.contains(e.target) && !saleDropdownContent.contains(e.target)) {
                saleDropdownContent.classList.remove('active');
            }
        });
  
        saleDropdownContent.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    }
  });
