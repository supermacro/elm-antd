const ELM_ANTD_CSS_PREFIX = 'elm-antd'

const animatedButtonClassName = `.${ELM_ANTD_CSS_PREFIX}__animated_btn`;
const animatedBeforeClassName = `${ELM_ANTD_CSS_PREFIX}__animated_before`;

const buttons = document.querySelectorAll(animatedButtonClassName);

let timeout = null;

buttons.forEach((btn) => {
	btn.addEventListener('mousedown', function (e) {
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



/////////////////////////////////////////////////////
// Inputs
//

// need to listen for:
//  - focusin
//  - focusout

const inputs = document.querySelectorAll('div.elm-antd__input-root > input')

const activeInputClass = `${ELM_ANTD_CSS_PREFIX}__input-active`

inputs.forEach((input) => {
  const parentDiv = input.parentNode

  input.addEventListener('focusin', () => {
    parentDiv.classList.add(activeInputClass)
  }) 

  input.addEventListener('focusout', () => {
    parentDiv.classList.remove(activeInputClass)
  })
})

