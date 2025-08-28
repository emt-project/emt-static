document.addEventListener('DOMContentLoaded', function () {
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  tooltipTriggerList.forEach(el => {
    new bootstrap.Tooltip(el, {
      html: true,
      title: () => {
        let parts = [];
        let current = el;
        while (current && current !== document.body) {
          if (current.hasAttribute('data-bs-title') || current.hasAttribute('title')) {
            parts.unshift(current.getAttribute('data-bs-title') || current.getAttribute('title'));
          }
          current = current.parentElement;
        }
        return parts.join('<br>');
      }
    });

    // Suppress parent tooltips when a child is hovered
    el.addEventListener('show.bs.tooltip', () => {
      let parent = el.parentElement;
      while (parent && parent !== document.body) {
        if (bootstrap.Tooltip.getInstance(parent)) {
          console.log(bootstrap.Tooltip.getInstance(parent))
          bootstrap.Tooltip.getInstance(parent).hide();
        }
        parent = parent.parentElement;
      }
    });

// almost works, except when hovering over a child (without having hovered over the parent first) the parent shows
  })  })