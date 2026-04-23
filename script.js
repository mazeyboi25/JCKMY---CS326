const categories = ["All", "Electronics", "Clothes", "Dorm Items", "Textbooks", "Furniture"];

const products = [
  {
    id: "desk",
    title: "Dorm Desk Setup",
    category: "Electronics",
    price: "P850",
    seller: "Maya Santos",
    desc: "Laptop riser, keyboard mat, and study light bundle for compact desks.",
    art: "art-desk tall",
  },
  {
    id: "lamp",
    title: "IKEA Table Lamp",
    category: "Dorm Items",
    price: "P420",
    seller: "Zayn Malik",
    desc: "25 inches tall, best for studying and secondhand use.",
    art: "art-lamp tall",
  },
  {
    id: "chair",
    title: "Siena Lounge Chair",
    category: "Furniture",
    price: "P550",
    seller: "Ari Cruz",
    desc: "A sculptural lounge chair designed for common room corners.",
    art: "art-chair",
  },
  {
    id: "cable",
    title: "Cable Kit",
    category: "Electronics",
    price: "P150",
    seller: "Nico Tan",
    desc: "USB-C, HDMI, and charger adapters packed in a small pouch.",
    art: "art-cable",
  },
  {
    id: "books",
    title: "Textbook Set",
    category: "Textbooks",
    price: "P700",
    seller: "Lia Ramos",
    desc: "Core readings for business statistics and introductory accounting.",
    art: "art-book",
  },
  {
    id: "hoodie",
    title: "Varsity Hoodie",
    category: "Clothes",
    price: "P390",
    seller: "Ren Yu",
    desc: "Medium cotton hoodie with embroidered campus mark.",
    art: "art-clothes",
  },
];

const state = {
  view: "loginView",
  activeCategory: "All",
  query: "",
  selectedProduct: products[1],
  saved: new Set(),
  messages: [
    { side: "incoming", text: "Hey, yes. The lamp is still available." },
    { side: "outgoing", text: "Can we meet on campus?" },
    { side: "incoming", text: "Yup, near the library works." },
  ],
};

const views = [...document.querySelectorAll(".app-view")];
const nav = document.querySelector(".bottom-nav");
const navButtons = [...document.querySelectorAll("[data-nav]")];
const categoryChips = document.querySelector("#categoryChips");
const marketGrid = document.querySelector("#marketGrid");
const profileListings = document.querySelector("#profileListings");
const searchInput = document.querySelector("#searchInput");
const toast = document.querySelector("#toast");
const listingCount = document.querySelector("#listingCount");

function showToast(message) {
  toast.textContent = message;
  toast.classList.add("visible");
  window.clearTimeout(showToast.timer);
  showToast.timer = window.setTimeout(() => toast.classList.remove("visible"), 2100);
}

function goTo(viewId) {
  state.view = viewId;
  views.forEach((view) => view.classList.toggle("active", view.id === viewId));
  const isAppView = !["loginView", "otpView"].includes(viewId);
  nav.classList.toggle("visible", isAppView);
  navButtons.forEach((button) => button.classList.toggle("active", button.dataset.nav === viewId));
  if (viewId === "productView") renderProduct();
  if (viewId === "chatView") renderMessages();
  if (viewId === "profileView") renderProfile();
}

function renderCategories() {
  categoryChips.innerHTML = categories
    .map(
      (category) =>
        `<button class="chip ${category === state.activeCategory ? "active" : ""}" type="button" data-category="${category}">${category}</button>`,
    )
    .join("");
}

function productCard(product) {
  const saved = state.saved.has(product.id) ? "active" : "";
  return `
    <button class="item-card" type="button" data-product="${product.id}">
      <div class="product-art ${product.art}"></div>
      <span class="item-meta">
        <strong>${product.title}</strong>
        <span>${product.category}</span>
        <span class="price-save">
          <b>${product.price}</b>
          <span class="save-dot ${saved}" aria-hidden="true"><span class="icon icon-heart"></span></span>
        </span>
      </span>
    </button>
  `;
}

function filteredProducts() {
  return products.filter((product) => {
    const matchesCategory = state.activeCategory === "All" || product.category === state.activeCategory;
    const query = state.query.trim().toLowerCase();
    const matchesQuery =
      !query ||
      product.title.toLowerCase().includes(query) ||
      product.category.toLowerCase().includes(query) ||
      product.desc.toLowerCase().includes(query);
    return matchesCategory && matchesQuery;
  });
}

function renderProducts() {
  const items = filteredProducts();
  marketGrid.innerHTML = items.length
    ? items.map(productCard).join("")
    : `<div class="empty-state">No listings match this search.</div>`;
  listingCount.textContent = products.length.toString();
}

function renderProduct() {
  const product = state.selectedProduct;
  document.querySelector("#productTitle").textContent = product.title;
  document.querySelector("#productDesc").textContent = product.desc;
  document.querySelector("#productPrice").textContent = product.price;
  document.querySelector("#sellerName").textContent = product.seller;
  document.querySelector("#productHero").innerHTML = `<div class="product-art ${product.art}"></div>`;
  document.querySelector(".save-current").classList.toggle("active", state.saved.has(product.id));
}

function renderMessages() {
  document.querySelector("#chatTitle").textContent = state.selectedProduct.seller;
  document.querySelector("#messageList").innerHTML = state.messages
    .map((message) => `<p class="message ${message.side}">${message.text}</p>`)
    .join("");
}

function renderProfile() {
  const profileItems = products.slice(0, 4);
  profileListings.innerHTML = profileItems
    .map((product) => `<div class="product-art ${product.art}" title="${product.title}"></div>`)
    .join("");
}

function addMessage(text) {
  if (!text.trim()) return;
  state.messages.push({ side: "outgoing", text: text.trim() });
  renderMessages();
  document.querySelector("#messageInput").value = "";
  window.setTimeout(() => {
    state.messages.push({ side: "incoming", text: "Sounds good. I can reserve it for you today." });
    renderMessages();
  }, 550);
}

document.querySelector("#loginForm").addEventListener("submit", (event) => {
  event.preventDefault();
  const email = document.querySelector("#emailInput").value.trim();
  const password = document.querySelector("#passwordInput").value.trim();
  const error = document.querySelector("#loginError");
  const schoolEmail = /@(school|campus|student|university)\.edu$/i.test(email) || /\.edu$/i.test(email);

  if (!schoolEmail || !password) {
    error.textContent = "Use a school .edu email and enter your password.";
    return;
  }

  error.textContent = "";
  goTo("otpView");
});

document.querySelectorAll(".otp-grid input").forEach((input, index, inputs) => {
  input.addEventListener("input", () => {
    input.value = input.value.replace(/\D/g, "").slice(0, 1);
    if (input.value && inputs[index + 1]) inputs[index + 1].focus();
  });
});

document.querySelector("#otpForm").addEventListener("submit", (event) => {
  event.preventDefault();
  const code = [...document.querySelectorAll(".otp-grid input")].map((input) => input.value).join("");
  const error = document.querySelector("#otpError");
  if (code.length !== 4) {
    error.textContent = "Enter the 4-digit verification code.";
    return;
  }

  error.textContent = "";
  goTo("homeView");
  showToast("Verified student account");
});

document.addEventListener("click", (event) => {
  const goButton = event.target.closest("[data-go]");
  if (goButton) goTo(goButton.dataset.go);

  const navButton = event.target.closest("[data-nav]");
  if (navButton) goTo(navButton.dataset.nav);

  const categoryButton = event.target.closest("[data-category]");
  if (categoryButton) {
    state.activeCategory = categoryButton.dataset.category;
    renderCategories();
    renderProducts();
  }

  const productButton = event.target.closest("[data-product]");
  if (productButton) {
    state.selectedProduct = products.find((product) => product.id === productButton.dataset.product) || products[0];
    goTo("productView");
  }

  const quickReply = event.target.closest("[data-reply]");
  if (quickReply) addMessage(quickReply.dataset.reply);
});

searchInput.addEventListener("input", (event) => {
  state.query = event.target.value;
  renderProducts();
});

document.querySelector("#clearFilters").addEventListener("click", () => {
  state.activeCategory = "All";
  state.query = "";
  searchInput.value = "";
  renderCategories();
  renderProducts();
});

document.querySelector(".save-current").addEventListener("click", () => {
  const id = state.selectedProduct.id;
  if (state.saved.has(id)) {
    state.saved.delete(id);
    showToast("Removed from favorites");
  } else {
    state.saved.add(id);
    showToast("Added to favorites");
  }
  renderProduct();
  renderProducts();
});

document.querySelector("#buyButton").addEventListener("click", () => {
  goTo("chatView");
  addMessage(`Hi, I am interested in the ${state.selectedProduct.title}.`);
});

document.querySelector("#sellerButton").addEventListener("click", () => goTo("chatView"));

document.querySelector("#messageForm").addEventListener("submit", (event) => {
  event.preventDefault();
  addMessage(document.querySelector("#messageInput").value);
});

document.querySelector("#sellForm").addEventListener("submit", (event) => {
  event.preventDefault();
  const title = document.querySelector("#sellTitleInput").value.trim();
  const desc = document.querySelector("#sellDescInput").value.trim();
  const priceValue = document.querySelector("#sellPriceInput").value.trim().replace(/[^\d]/g, "");
  const category = document.querySelector("#sellCategoryInput").value;
  if (!title || !desc || !priceValue) return;

  products.unshift({
    id: `listing-${Date.now()}`,
    title,
    category,
    price: `P${priceValue}`,
    seller: "Maya Santos",
    desc,
    art: "art-new tall",
  });

  event.target.reset();
  state.activeCategory = "All";
  state.query = "";
  searchInput.value = "";
  renderCategories();
  renderProducts();
  goTo("homeView");
  showToast("Listing posted");
});

renderCategories();
renderProducts();
renderProfile();
