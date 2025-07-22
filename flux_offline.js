
document.addEventListener("DOMContentLoaded", () => {
  const data = {
    articles: [
      { title: "Vols vers les Antilles : les prix chutent cette semaine", url: "#" },
      { title: "Nouveaux ferrys vers Marie-Galante dès août", url: "#" },
      { title: "Grève à l’aéroport de Pointe-à-Pitre : perturbations à prévoir", url: "#" },
      { title: "Hébergement local : la tendance des écolodges en hausse", url: "#" },
      { title: "Top 5 des plages secrètes en Guadeloupe en 2025", url: "#" }
    ]
  };

  const list = document.getElementById("news-list");
  data.articles.forEach((article) => {
    const item = document.createElement("li");
    item.innerHTML = `<a href="\${article.url}" target="_blank">\${article.title}</a>`;
    list.appendChild(item);
  });
});
