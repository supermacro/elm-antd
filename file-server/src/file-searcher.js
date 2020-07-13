const fs = require('fs')
const { ok, err } = require('neverthrow')
const github = require('./github')

const currentWorkingDirectory = process.cwd()
const showcaseElmPath = currentWorkingDirectory.replace('file-server', 'showcase/src/elm')


const readFile = (path) => new Promise((resolve, reject) => {
  fs.readFile(path, 'utf8', (err, data) => {
    if (err) {
      reject(err)
    } else {
      resolve(data)
    }
  })
})


const base64EncodeFile = (file) =>
  Buffer.from(file, 'utf-8').toString('base64')


const fileSystemSearcher = (fileNameWithPath) => {
  if (!fileNameWithPath.endsWith('.elm')) {
    return err('INVALID_FILE_EXTENSION')
  }

  const pathToElmFile = showcaseElmPath + `/${fileNameWithPath}`

  return readFile(pathToElmFile)
    .then(base64EncodeFile)
    .then(ok)
    .catch((e) => {
      if (e.message.includes('ENOENT: no such file or directory')) {
        return err('NOT_FOUND')
      } else {
        console.warn(e)
        return err('UNKNOWN')
      }
    })
}


const githubSearcher = (fileNameWithPath, commitRef) => {
  if (!fileNameWithPath.endsWith('.elm')) {
    return err('INVALID_FILE_EXTENSION')
  }

  return github.getFileFromRepo(fileNameWithPath, commitRef)
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

