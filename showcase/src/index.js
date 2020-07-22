const VISUAL_TESTING_MODE = process.env.APP_MODE === 'visual_testing'

if (VISUAL_TESTING_MODE) {
  const { Elm } = require('./elm/VisualTests.elm');

  Elm.VisualTests.init()
} else {
  const Elm = require('./elm/Showcase.elm').Elm;

  // the JS version of Maybe a
  // is a | null
  // undefined does not constitute a Maybe value
  const maybeCommitHash = process.env.COMMIT_REF || null

  const app = Elm.Showcase.init({
    flags: {
      commitHash: maybeCommitHash,
      fileServerUrl: process.env.FILE_SERVER_URL
    }
  });

  app.ports.copySourceToClipboard.subscribe((src) => {
    navigator.clipboard.writeText(src)
  })

  if ('serviceWorker' in navigator) {
    console.log('Registering service worker ... ')
    navigator.serviceWorker.register('/sw.js').then((reg) => {
      if (reg.installing) {
        console.log('> Service worker installing')
      } else if (reg.waiting) {
        console.log('> Service worker installed')
      } else if (reg.active) {
        console.log('> Service worker active')
      }
    }).catch((e) => {
      console.log('Service worker registration failed with ' + e)
    })
  }
}

