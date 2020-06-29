'use strict';

const VISUAL_TESTING_MODE = process.env.APP_MODE === 'visual_testing'

if (VISUAL_TESTING_MODE) {
  const { Elm } = require('./elm/VisualTests.elm');

  Elm.VisualTests.init()
} else {
  const Elm = require('./elm/Showcase.elm').Elm;

  const app = Elm.Showcase.init();

  app.ports.copySourceToClipboard.subscribe((src) => {
    navigator.clipboard.writeText(src)
  })
}

