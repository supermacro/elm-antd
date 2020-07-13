const express = require('express')
const searcher = require('./file-searcher')
const router = express.Router()

const fileSearchValidator = (req, res, next) => {
  const commitRef = req.query.commitRef
  const fileName = req.query.fileName

  if (process.env.NODE_ENV === 'production' && !commitRef) {
    res.status(400).json({
      error: 'Missing `commitRef` query parameter'
    })
    return
  }

  if (!fileName) {
    res.status(400).json({
      error: 'Missing `fileName` query parameter'
    })
    return
  }

  next()
}

router.get('/file', fileSearchValidator, async (req, res) => {
  const commitRef = req.query.commitRef
  const fileName = req.query.fileName

  const searchResult = await searcher(fileName, commitRef)

  searchResult
    .map((base64File) => {
      res.json({ base64File })
    })
    .mapErr((errorCode) => {
      if (errorCode === 'NOT_FOUND') {
        res.sendStatus(404)
      } else if (errorCode === 'INVALID_FILE_EXTENSION') {
        res.status(400).json({
          message: 'This endpoint only accepts .elm files'
        })
      } else if (errorCode === 'INVALID_COMMIT_REF') {
        res.status(400).json({
          message: 'Invalid commit ref'
        })
      } else {
        res.sendStatus(500)
      }
    })
})

module.exports = router

