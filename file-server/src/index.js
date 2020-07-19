const express = require('express')
const helmet = require('helmet')
const cors = require('cors')
const routes = require('./routes')

const app = express()

app.use(helmet())
app.use(cors())

app.use(routes)

app.get('/health-check', (_, res) => {
  res.sendStatus(200)
})

const mode = process.env.NODE_ENV === 'production'
  ? 'production'
  : 'development'

app.listen(8080, () => {
  console.log(`Listening on port 8080 in ${mode} mode`)
})
