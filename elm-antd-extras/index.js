const animatedButtonClassName = '.elm-antd__animated_btn';
const animatedBeforeClassName = 'elm-antd__animated_before';

const buttons = document.querySelectorAll(animatedButtonClassName);

let timeout = null;

buttons.forEach((btn) => {
	btn.addEventListener('mousedown', function (e) {
		console.log('mousedown');
		if (timeout) {
			clearTimeout(timeout);
		}
		btn.classList.remove(animatedBeforeClassName);
	});

	btn.addEventListener('mouseup', function (e) {
		btn.classList.add(animatedBeforeClassName);
		timeout = setTimeout(() => {
			btn.classList.remove(animatedBeforeClassName);
		}, 1500);
	});
});
