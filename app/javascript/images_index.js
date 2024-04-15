document.addEventListener('turbo:load', () => {
  let currentSlide = 0;
  const slides = document.querySelectorAll('.slides img');
  const totalSlides = slides.length;
  let autoSlideInterval = null;
  // タッチイベントに関する設定
  let startX, startY, isNearEdge;
  const slider = document.querySelector('.slider');
  // 画面の端からのタッチかどうかをチェック
  const touchBorderWidth = 30; // 画面の端からの距離（ピクセル）
  
  // タッチ開始時のハンドラー
  slider.addEventListener('touchstart', function(e) {
    startX = e.touches[0].pageX;
    startY = e.touches[0].pageY;
    isNearEdge = startX < touchBorderWidth || startX > window.innerWidth - touchBorderWidth;
    if (!isNearEdge) {
      e.preventDefault();
    }
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

  slider.addEventListener('touchmove', function(e) {
    if (isNearEdge) {
      return
    }
    const moveX = e.touches[0].pageX;
    const moveY = e.touches[0].pageY;
    const diffX = startX - moveX;


    // Y方向の動きがX方向の動きより小さい場合、横スクロールと判断
    if (Math.abs(diffX) > Math.abs(startY - moveY)) {
      e.preventDefault(); // 横スクロールを防ぐ
    }
    
    if (Math.abs(diffX) > 30) {
      const offset = currentSlide * -450 - diffX;
      document.querySelector('.slides').style.transform = `translateX(${offset}px)`;
    }
  });

  document.querySelector('.prev').addEventListener('click', (e) => {
    e.stopPropagation(); // イベントの伝播を止める
    moveSlides(-1);
    restartAutoSlide();
  });

  document.querySelector('.next').addEventListener('click', (e) => {
    e.stopPropagation(); // イベントの伝播を止める
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
