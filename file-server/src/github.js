const github = require('octonode')
const { SHOWCASE_ELM_SRC_DIR } = require('./constants')


const client = github.client()
const repo = client.repo('supermacro/elm-antd')

/**
 * {
 *   [commitHash]: {
 *       [componentName]: Array<{ fileContents: base64EncodedFile, fileName: string }>
 *   }
 * }
 */
const fileCache = {}

const saveExamplesToFileCache = (component, commitRef, files) => {
  const cachedFilesForCommit = fileCache[commitRef]

  if (cachedFilesForCommit) {
    cachedFilesForCommit[commitRef] = {
      ...cachedFilesForCommit,
      [component]: files
    }
  } else {
    fileCache[commitRef] = {
      [component]: files
    }
  }
}

const getComponentExamplesFromCache = (component, commitRef) => {
  const cachedFilesForCommit = fileCache[commitRef]
  if (cachedFilesForCommit) {
    return cachedFilesForCommit[component]
  }
}


const createDirectoryPath = (component) => 
  `${SHOWCASE_ELM_SRC_DIR}/Routes/${component}Component`


const createFullFilePath = (component, fileName) =>
  `${createDirectoryPath(component)}/${fileName}`


const getFileFromRepo = (fullFilePath, commitRef) => new Promise((resolve, reject) => {
  repo.contents(fullFilePath, commitRef, (err, data, headers) => {
    if (err) {
      reject(err)
    } else {
      // Github chunks the base64 encoded file into
      // <Carriage_Return> delimited lines
      resolve(data.content.split('\n').join(''))
    }
  })
})

// Get the filenames of the examples for a given component
//
// Returns Promise<string[]>
const getFileNamesFromDirectory = (component, commitRef) => new Promise((resolve, reject) => {
  const fullPath = createDirectoryPath(component)
  repo.contents(fullPath, commitRef, (err, data) => {
    if (err) {
      reject(err)
    } else {
      resolve(data.map(({ name }) => name))
    }
  })
})


const getExampleFilesForComponent = (component, commitRef) => {
  const cachedExamples = getComponentExamplesFromCache(component, commitRef)

  if (cachedExamples) {
    return Promise.resolve(cachedExamples)
  }

  return getFileNamesFromDirectory(component, commitRef)
    .then((files) =>
      Promise.all(files.map(
        (fileName) => {
          const fullFilePath = createFullFilePath(component, fileName)
          return getFileFromRepo(fullFilePath, commitRef)
            .then((base64FileContents) => ({ fileName, base64File: base64FileContents }))
        }
      ))
    )
    .then((result) => {
      saveExamplesToFileCache(component, commitRef, result)

      return result
    })
}

module.exports = { getExampleFilesForComponent }

