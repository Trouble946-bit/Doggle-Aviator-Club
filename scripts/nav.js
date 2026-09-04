document.addEventListener('DOMContentLoaded', function() {
  const toggle = document.querySelector('.nav-toggle');
  const navContainer = document.querySelector('.nav-container');
  if (!toggle || !navContainer) return;

  function closeNav() {
    navContainer.classList.remove('open');
    toggle.setAttribute('aria-expanded', 'false');
  }

  toggle.addEventListener('click', function(e) {
    const isOpen = navContainer.classList.toggle('open');
    toggle.setAttribute('aria-expanded', isOpen);
  });

  // Close when clicking outside or when selecting a link
  document.addEventListener('click', function(e) {
    if (!navContainer.classList.contains('open')) return;
    const target = e.target;
    if (toggle.contains(target)) return; // clicking the toggle
    if (!navContainer.contains(target)) { closeNav(); return; }
    if (target.closest('.nav-menu')) { closeNav(); }
  }, { passive: true });

  // Close with Escape key
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' && navContainer.classList.contains('open')) closeNav();
  });
});
