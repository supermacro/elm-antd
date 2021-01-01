/**
 * Scratchpad / Sandbox
 *
 * used for testing & debugging & designing
 */

const github = require('octonode')

const client = github.client()
const repo = client.repo('supermacro/elm-antd')

const commitRef = undefined

repo.contents('showcase/src/elm/Routes/ButtonComponent', commitRef, (err, data) => {
  if (err) {
    console.log('> err: ' + err)
  } else {
    console.log('> data: ' + data)
  }
})

