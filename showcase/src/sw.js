const { findExamplesForComponent, saveExamplesToCache } = require('./file-cache')

const FILE_SERVER_URL = process.env.FILE_SERVER_URL

if (!FILE_SERVER_URL) {
  throw new Error('Missing required environment variable `FILE_SERVER_URL`')
}

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
const handleFileServerRequest = async (event) => {
  console.log('> Request to file server: ' + event.request.url)
  const url = new URL(event.request.url)
  const isRequestToGetFile = url.pathname.includes('example-files') && event.request.method === 'GET'

  if (!isRequestToGetFile) {
    return fetch(event.request)
  }

  const filePathRegex = /\/example-files\/(\w+)/g

  const [, componentName] = filePathRegex.exec(url.pathname)

  const cachedFiles = await findExamplesForComponent(componentName)

  if (cachedFiles) {
    const rawData = new Blob([ JSON.stringify(cachedFiles) ])
    const response = new Response(rawData, {
      status: 200,
      type: 'application/json',
    })

    return response
  }

  const response = await fetch(event.request)
  const cloned = response.clone()
  const componentExamples = await cloned.json()

  await saveExamplesToCache(componentName, componentExamples)

  return response 
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

