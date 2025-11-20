document.addEventListener('DOMContentLoaded', function() {
    const toggle = document.getElementById('theme-toggle');
    toggle.addEventListener('click', function() {
        document.body.classList.toggle('dark-mode');
    });
});
