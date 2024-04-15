document.addEventListener('turbo:load', () => {
  let currentSlide = 0;
  const slides = document.querySelectorAll('.slides img');
  const totalSlides = slides.length;
  let autoSlideInterval = null;
  // タッチイベントに関する設定
  let startX;
  const slider = document.querySelector('.slider');

  // タッチ開始時のハンドラー
  slider.addEventListener('touchstart', function(e) {
    startX = e.touches[0].pageX;
  });

  // タッチ終了時のハンドラー
  slider.addEventListener('touchend', function(e) {
    const endX = e.changedTouches[0].pageX;
    if (startX - endX > 30) { // 右から左へのフリック
      moveSlides(1);
    } else if (startX - endX < -30) { // 左から右へのフリック
      moveSlides(-1);
    }
    restartAutoSlide();
  });  

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
