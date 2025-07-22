
document.addEventListener("DOMContentLoaded", () => {
  fetch("https://homygo.eu/api/v1/news/voyage")
    .then((response) => response.json())
    .then((data) => {
      const list = document.getElementById("news-list");
      data.articles.forEach((article) => {
        const item = document.createElement("li");
        item.innerHTML = `<a href="${article.url}" target="_blank">${article.title}</a>`;
        list.appendChild(item);
      });
    })
    .catch((error) => {
      console.error("Erreur de chargement des actualités :", error);
    });
});
