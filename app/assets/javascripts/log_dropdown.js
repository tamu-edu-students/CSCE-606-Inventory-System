document.addEventListener('DOMContentLoaded', function() {
    console.log('Log dropdown script loaded');
    
    const logTrigger = document.getElementById('log-trigger');
    const dropdownContent = document.getElementById('log-dropdown-content');
   
    if (logTrigger && dropdownContent) {
      console.log('Log dropdown elements found');
      
      // Toggle dropdown when clicking log link
      logTrigger.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        dropdownContent.classList.toggle('active');
        console.log('Log dropdown toggled:', dropdownContent.classList.contains('active'));
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
    } else {
      console.log('Log dropdown elements not found');
    }

    // Sale dropdown functionality
    const saleTrigger = document.getElementById('sale-trigger');
    const saleDropdownContent = document.getElementById('sale-dropdown-content');
   
    if (saleTrigger && saleDropdownContent) {
        console.log('Sale dropdown elements found');
        
        saleTrigger.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            saleDropdownContent.classList.toggle('active');
            console.log('Sale dropdown toggled:', saleDropdownContent.classList.contains('active'));
        });
  
        document.addEventListener('click', function(e) {
            if (!saleTrigger.contains(e.target) && !saleDropdownContent.contains(e.target)) {
                saleDropdownContent.classList.remove('active');
            }
        });
  
        saleDropdownContent.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    } else {
      console.log('Sale dropdown elements not found');
    }
});
