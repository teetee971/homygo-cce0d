
window.onload = function() {
  const audio = document.getElementById('introSound');
  document.body.addEventListener('click', () => {
    audio.play();
    setTimeout(() => {
      window.location.href = "/index.html";
    }, 3000);
  }, { once: true });
};
