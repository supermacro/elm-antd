const github = require('octonode')



const client = github.client()
const repo = client.repo('supermacro/elm-antd')

/**
 * {
 *   [commitHash]: {
 *       [filePath]: base64EncodedFile
 *   }
 * }
 */
const fileCache = {}

const saveToFileCache = (pathToShowcaseFile, commitRef, base64EncodedFile) => {
  const cachedFilesForCommit = fileCache[commitRef]

  if (cachedFilesForCommit) {
    cachedFilesForCommit[commitRef] = {
      ...cachedFilesForCommit,
      [pathToShowcaseFile]: base64EncodedFile
    }
  } else {
    fileCache[commitRef] = {
      [pathToShowcaseFile]: base64EncodedFile
    }
  }
}

const getFileFromCache = (pathToShowcaseFile, commitRef) => {
  const cachedFilesForCommit = fileCache[commitRef]
  if (cachedFilesForCommit) {
    return cachedFilesForCommit[pathToShowcaseFile]
  }
}

const getFileFromRepo = (pathToShowcaseFile, commitRef) => new Promise((resolve, reject) => {
  // We need a cache, otherwise we'll quickly use up github's unauthenticated quota
  const cachedFile = getFileFromCache(pathToShowcaseFile, commitRef)

  if (cachedFile) {
    resolve(cachedFile)
    return
  }

  // The root of the search tree is assumed to be 'showcase/src/elm'
  const fullPath = `showcase/src/elm/${pathToShowcaseFile}`
  repo.contents(fullPath, commitRef, (err, data, headers) => {
    if (err) {
      reject(err)
    } else {
      saveToFileCache(pathToShowcaseFile, commitRef, data.content)
      resolve(data.content)
    }
  })
})

module.exports = { getFileFromRepo }
