const express = require('express')
const searcher = require('./file-searcher')
const router = express.Router()

const validateRequest = (req, res, next) => {
  const commitRef = req.query.commitRef

  if (process.env.NODE_ENV === 'production' && !commitRef) {
    res.status(400).json({
      error: 'Missing `commitRef` query parameter'
    })
    return
  }

  next()
}


router.get('/example-files/:component', validateRequest, async (req, res) => {
  const commitRef = req.query.commitRef
  const component = req.params.component

  const searchResult = await searcher(component, commitRef)

  searchResult
    .map((files) => {
      res.json(files)
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

