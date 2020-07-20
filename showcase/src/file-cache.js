/**
 * PouchDb abstraction
 *
 * This file takes care of caching files fetched from the file-server
 */

const PouchDB = require('pouchdb-browser').default


if (process.env.NODE_ENV === 'development') {
  PouchDB.debug.enable('*');
}

const log = (info) => {
  console.log(`> file-cache: ${info}`)
}


/*
 * {
 *    [cache_namespace]: {
 *      [componentName]: fileList[]
 *    }
 * }
 */
const db = new PouchDB('elm-antd-cache')

const CACHE_NAMESPACE = process.env.COMMIT_REF || '<<development>>'
const DISABLE_CACHE = !!process.env.DISABLE_CACHE


const getCachedFiles = () =>
  db.get(CACHE_NAMESPACE)
    .catch((err) => {
      if (err.status === 404) {
        return undefined
      }

      throw err
    })


const findExamplesForComponent = async (componentName) => {
  if (DISABLE_CACHE) {
    return
  }

  const fileCache = await getCachedFiles()

  if (!fileCache) {
    return
  }

  return fileCache[componentName]
}

const saveExamplesToCache = async (componentName, examplesSourceCode) => {
  const fileCache = await getCachedFiles()
  log('Saving to file cache')

  if (!fileCache) {
    const namespacedCache = {
      _id: CACHE_NAMESPACE,
      [componentName]: examplesSourceCode,
    }

    await db.put(namespacedCache)
  } else {
    const updated = {
      _id: CACHE_NAMESPACE,
      _rev: fileCache._rev,
      [componentName]: examplesSourceCode,
    }

    await db.put(updated)
  }
}


module.exports = { findExamplesForComponent, saveExamplesToCache }

