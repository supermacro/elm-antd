const PouchDB = require('pouchdb-browser').default

const FILE_SERVER_URL = process.env.FILE_SERVER_URL

if (!FILE_SERVER_URL) {
  throw new Error('Missing required environment variable `FILE_SERVER_URL`')
}

if (process.env.NODE_ENV === 'development') {
  PouchDB.debug.enable('*');
}

const db = new PouchDB('elm-antd-cache')

self.addEventListener('activate', (event) => {
  event.waitUntil(clients.claim())
})


self.addEventListener('install', function(event) {
  event.waitUntil(self.skipWaiting());
})


self.addEventListener('fetch', (event) => {
  if (event.request.url.includes(FILE_SERVER_URL)) {
    const promise = handleFileServerRequest(event)
    event.respondWith(promise)
    return
  }

  const fetchPromise = fetch(event.request)
  event.respondWith(fetchPromise)
})


/**
 * @argument event FetchEvent (https://developer.mozilla.org/en-US/docs/Web/API/FetchEvent)
 *
 * @returns Promise<Response>
 */
const handleFileServerRequest = (event) => {
  console.log('> Request to file server: ' + event.request.url)
  const url = new URL(event.request.url)
  return fetch(event.request)
}


fetch(`${FILE_SERVER_URL}/health-check`, { mode: 'cors' })
  .then((response) => {
    if (response.ok) {
      console.log('file server ready')
    } else {
      console.error('file server not ready... please set up your file server')
      console.log(response.status)
    }
  })
  .catch(() => {
    console.error('file server not ready... please set up your file server')
  })

