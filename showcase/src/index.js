'use strict';

const Elm = require('./elm/Showcase.elm').Elm;


const app = Elm.Showcase.init();

app.ports.copySourceToClipboard.subscribe((src) => {
  navigator.clipboard.writeText(src)
})
