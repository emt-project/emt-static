window.addEventListener('scroll', function () {
    const stickyInfoBtn = document.getElementById('sticky-info');
    const originalInfoBtn = document.getElementById('info-modal-trigger');
    const footer = document.querySelector('footer');

    if (!stickyInfoBtn || !originalInfoBtn || !footer) return;

    const originalBtnRect = originalInfoBtn.getBoundingClientRect();
    const originalBtnVisible = (
        originalBtnRect.top >= 0 &&
        originalBtnRect.left >= 0 &&
        originalBtnRect.bottom <= window.innerHeight &&
        originalBtnRect.right <= window.innerWidth
    );

    const footerRect = footer.getBoundingClientRect();
    const footerVisible = footerRect.top < window.innerHeight;

    if (!originalBtnVisible && !footerVisible) {
        // Show sticky button only if original button is NOT visible AND footer is NOT visible
        stickyInfoBtn.classList.remove('d-none');
    } else {
        stickyInfoBtn.classList.add('d-none');
    }
});