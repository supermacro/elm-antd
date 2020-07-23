const fs = require('fs')
const { ok, err, ResultAsync } = require('neverthrow')
const util = require('util')
const github = require('./github')
const { SHOWCASE_ELM_SRC_DIR } = require('./constants')

const currentWorkingDirectory = process.cwd()
const showcaseElmPath = currentWorkingDirectory.replace('file-server', SHOWCASE_ELM_SRC_DIR)



const readFile_ = util.promisify(fs.readFile)
const readDir_ = util.promisify(fs.readdir)


// currently assuming readFile never fails
// But realistically should also return a ResultAsync
const readFile = (filePath) => readFile_(filePath, 'utf8')


const readDir = (dirPath) =>
  ResultAsync.fromPromise(
    readDir_(dirPath),
    (error) => {
      if (error.message.includes('no such file or directory')) {
        return 'NOT_FOUND'
      }
      console.log('>> Read Dir Error')
      console.log(error)
      return 'UNKNOWN'
    }
  )



const base64EncodeFile = (file) =>
  Buffer.from(file, 'utf8').toString('base64')


const generateComponentDirectory = (component) =>
  `${showcaseElmPath}/Routes/${component}Component`


// returns ResultAsync<Base64String[], String>
const fileSystemSearcher = async (component) => {
  const pathToComponentExampleFilesDirectory = generateComponentDirectory(component)

  return readDir(pathToComponentExampleFilesDirectory)
    .map(
      (fileNames) =>
        Promise.all(
          fileNames
            .map((f) =>
              readFile(`${pathToComponentExampleFilesDirectory}/${f}`)
                .then((rawFile) => ({ fileName: f, contents: rawFile }))
            )
        )
    )
    .map((rawFiles) =>
      rawFiles.map(({ fileName, contents}) => ({ fileName, base64File: base64EncodeFile(contents) }))
    )
}


const githubSearcher = (component, commitRef) => {
    return github.getExampleFilesForComponent(component, commitRef)
    .then(ok)
    .catch((e) => {
      if (e.message.includes('No commit found for the ref')) {
        return err('INVALID_COMMIT_REF')
      } else if (e.message === 'Not Found') {
        return err('NOT_FOUND')
      }

      console.warn(e)

      return err('UNKNOWN')
    })
}


const searcher = process.env.NODE_ENV === 'production'
  ? githubSearcher
  : fileSystemSearcher


module.exports = searcher

