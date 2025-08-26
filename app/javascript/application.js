// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

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
  const toggle = () => (document.body.classList.contains("fab-open") ? close() : open());

  fab.addEventListener("click", toggle);
  backdrop.addEventListener("click", close);
  document.addEventListener("keydown", (e) => e.key === "Escape" && close());
  menu.addEventListener("click", (e) => e.target.closest("[data-action='fab-close']") && close());
}

function initNavbarSearch() {
  // On prend le premier composant trouvé (si tu en as plusieurs, on peut faire un loop)
  const searchBtn = document.querySelector("[data-action='toggle-search']");
  const searchBox = document.querySelector(".search-box");
  if (!searchBtn || !searchBox) return;

  // évite les doubles bindings lors de navigations Turbo
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

// appelles existants
document.addEventListener("turbo:load", initFab);
document.addEventListener("DOMContentLoaded", initFab);

// 👇 ajoute ces deux lignes
document.addEventListener("turbo:load", initNavbarSearch);
document.addEventListener("DOMContentLoaded", initNavbarSearch);


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

document.addEventListener("turbo:load", initAvatarPreview);
