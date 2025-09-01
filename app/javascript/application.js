// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

// Code pour les FAB (Floating Action Button)

function initFab() {
  const fab = document.getElementById("fabToggle");
  const menu = document.getElementById("fabMenu");
  const backdrop = document.getElementById("fabBackdrop");
  if (!fab || !menu || !backdrop) return;

  const open = () => {
    document.body.classList.add("fab-open");
    fab.setAttribute("aria-expanded", "true");
    menu.setAttribute("aria-hidden", "false");
  };

  const close = () => {
    document.body.classList.remove("fab-open");
    fab.setAttribute("aria-expanded", "false");
    menu.setAttribute("aria-hidden", "true");
  };

  const toggle = () => (
    document.body.classList.contains("fab-open") ? close() : open()
  );

  fab.addEventListener("click", toggle);
  backdrop.addEventListener("click", close);
  document.addEventListener("keydown", (e) => e.key === "Escape" && close());
  menu.addEventListener("click", (e) => e.target.closest("[data-action='fab-close']") && close());
}

// Code pour les recherches dans la navbar

function initNavbarSearch() {
  const searchBtn = document.querySelector("[data-action='toggle-search']");
  const searchBox = document.querySelector(".search-box");
  if (!searchBtn || !searchBox) return;

  if (searchBtn.dataset.initialized === "true") return;
  searchBtn.dataset.initialized = "true";

  const toggle = () => {
    const active = searchBox.classList.toggle("active");
    searchBox.setAttribute("aria-hidden", active ? "false" : "true");

    if (active) {
      const input = searchBox.querySelector(".search-input");
      setTimeout(() => input && input.focus(), 0);
    }
  };

  searchBtn.addEventListener("click", toggle);
}

// Code pour l'avatar

function initAvatarPreview() {
  const input = document.getElementById("user_avatar");
  if (!input) return;
  if (input.dataset.initialized === "true") return;
  input.dataset.initialized = "true";

  const frame = input.closest(".card-body")?.querySelector(".avatar-frame");
  if (!frame) return;

  const placeholder = frame.querySelector("#avatarPlaceholder");
  let img = frame.querySelector("#avatarPreview");

  input.addEventListener("change", (e) => {
    const file = e.target.files && e.target.files[0];
    if (!file) return;

    const url = URL.createObjectURL(file);

    if (!img) {
      img = new Image();
      img.id = "avatarPreview";
      img.className = "avatar-img";
      frame.appendChild(img);
    }

    img.src = url;
    if (placeholder) placeholder.remove();
    frame.classList.remove("is-empty");
  });
}

//Code des alertes pour qu'elles disparaissent au bout de 3s

function initFlashAlerts() {
  const alerts = document.querySelectorAll('.alert');
  if (!alerts.length) return;

  alerts.forEach((alert) => {
    if (alert.dataset.initialized === "true") return;
    alert.dataset.initialized = "true";

    setTimeout(() => {
      const bsAlert = new bootstrap.Alert(alert);
      bsAlert.close();
    }, 3000);
  });
}

// Tous les addEventListener

document.addEventListener("turbo:load", initFab);
document.addEventListener("DOMContentLoaded", initFab);

document.addEventListener("turbo:load", initNavbarSearch);
document.addEventListener("DOMContentLoaded", initNavbarSearch);

document.addEventListener("turbo:load", initAvatarPreview);
document.addEventListener("turbo:load", initFlashAlerts);
