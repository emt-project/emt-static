document.addEventListener('DOMContentLoaded', function () {
    const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]');
    const popovers = [];

    popoverTriggerList.forEach(el => {
        const popover = new bootstrap.Popover(el, {
            html: true,
            placement: 'bottom',
            trigger: 'manual', // manual instead of 'focus' for full control
            customClass: 'custom-popover',
            content: () => {
                let parts = [];
                let current = el;
                while (current && current !== document.body) {
                    if (current.hasAttribute('data-bs-content')) {
                        parts.unshift(current.getAttribute('data-bs-content'));
                    }
                    current = current.parentElement;
                }
                return parts.join('<br>');
            }
        });

        popovers.push({ el, popover });


        const togglePopover = (e) => {
            e.preventDefault();
            e.stopPropagation();
            popovers.forEach(({ el: otherEl, popover: otherPopover }) => {
                if (otherEl !== el) {
                    otherPopover.hide();
                }
            });
            const isVisible = el.getAttribute('aria-describedby');
            if (isVisible) {
                popover.hide();
            } else {
                popover.show();
            }
        };

        let hideTimeout;
        // === HOVER ===
        el.addEventListener('mouseover', (e) => {
            e.stopPropagation();
            clearTimeout(hideTimeout);
            popover.show();
        });

        el.addEventListener('mouseout', (e) => {
            e.stopPropagation();
            hideTimeout = setTimeout(() => popover.hide(), 50);
        });


        // === KEYBOARD ===
        el.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                togglePopover(e);
            }
        });

        // === TOUCH ===
        el.addEventListener('touchend', togglePopover);
    });


    // Hide popovers on outside interaction
    document.addEventListener('click', () => {
        popovers.forEach(({ popover }) => popover.hide());
    });
    document.addEventListener('touchstart', () => {
        popovers.forEach(({ popover }) => popover.hide());
    });
    document.addEventListener('focusin', (e) => {
        if (![...popoverTriggerList].includes(e.target)) {
            popovers.forEach(({ popover }) => popover.hide());
        }
           });
    });
