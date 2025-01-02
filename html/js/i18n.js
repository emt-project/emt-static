const rerender = () => {
  $("body").localize();
};

$(function () {
  i18next
    .use(i18nextHttpBackend)
    .use(i18nextBrowserLanguageDetector)
    .init(
      {
        debug: false,
        fallbackLng: "en",
        load: "languageOnly",
        backend: {
          loadPath: "locales/{{lng}}/translation.json",
        },
      },
      (err, t) => {
        if (err) return console.error(err);
        jqueryI18next.init(i18next, $, { useOptionsAttr: true });
        rerender();
      }
    );
});

var show_this_lang = localStorage.i18nextLng;
var to_show = document.querySelectorAll(`[data-mylang="${show_this_lang}"]`);
to_show.forEach(function (el) {
  el.style.removeProperty("display");
});

var hide_this_lang = localStorage.i18nextLng.includes("en") ? "de" : "en";
var to_hide = document.querySelectorAll(`[data-mylang="${hide_this_lang}"]`);
console.log(`hide ${hide_this_lang}`);
to_hide.forEach(function (el) {
  el.style.display = "none";
});

function applyLanguageClasses() {
  const selectedLang = localStorage.getItem("i18nextLng");
  const deButton = document.getElementById("lang-switch-de");
  const enButton = document.getElementById("lang-switch-en");
  const htmlElement = document.documentElement;

  if (selectedLang === "de") {
    deButton.classList.add("fs-2");
    enButton.classList.remove("fs-2");
    enButton.classList.add("fs-4");
    htmlElement.setAttribute("lang", "de");
  } else if (selectedLang === "en") {
    enButton.classList.add("fs-2");
    deButton.classList.remove("fs-2");
    deButton.classList.add("fs-4");
    htmlElement.setAttribute("lang", "en");
  }
}

// Event listener for the DE button
document
  .getElementById("lang-switch-de")
  .addEventListener("click", function () {
    localStorage.setItem("i18nextLng", "de");
    applyLanguageClasses();
    location.reload(); // Reload the page
  });

// Event listener for the EN button (for two-way switching)
document
  .getElementById("lang-switch-en")
  .addEventListener("click", function () {
    localStorage.setItem("i18nextLng", "en");
    applyLanguageClasses();
    location.reload(); // Reload the page
  });

// Apply the classes based on the stored language on page load
applyLanguageClasses();
