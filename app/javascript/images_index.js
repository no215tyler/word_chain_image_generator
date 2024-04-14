document.addEventListener('turbo:load', () => {
  let currentSlide = 0;
  const slides = document.querySelectorAll('.slides img');
  const totalSlides = slides.length;
  let autoSlideInterval = null;

  document.querySelector('.prev').addEventListener('click', () => {
    moveSlides(-1);
    restartAutoSlide();
  });

  document.querySelector('.next').addEventListener('click', () => {
    moveSlides(1);
    restartAutoSlide();
  });

  function moveSlides(step) {
    currentSlide = (currentSlide + step + totalSlides) % totalSlides;
    const offset = currentSlide * -450; // 画像の幅に基づく
    document.querySelector('.slides').style.transform = `translateX(${offset}px)`;
  }

  function startAutoSlide() {
    autoSlideInterval = setInterval(function() {
      moveSlides(1);
    }, 3000); 
  }

  function restartAutoSlide() {
    if (autoSlideInterval) clearInterval(autoSlideInterval);
  }

  startAutoSlide();
})
