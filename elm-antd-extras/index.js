const buttons = document.querySelectorAll('.animated-btn');

buttons.forEach(btn => {
  btn.addEventListener('mouseup', function (e) {
    btn.classList.add('animated-before');
    setTimeout(() => {
      btn.classList.remove('animated-before')
    }, 1000);
  })
});