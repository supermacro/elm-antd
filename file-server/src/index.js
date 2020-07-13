const express = require('express')
const helmet = require('helmet')
const routes = require('./routes')

const app = express()

app.use(helmet())

app.use(routes)

app.get('/health-check', (_, res) => {
  res.sendStatus(200)
})

app.listen(8080, () => {
  console.log('Listening on port 8080')
})
