<img src="https://raw.githubusercontent.com/gDelgado14/elm-antd/master/logo.svg" alt="gDelgado14/elm-antd logo" width="40%" align="right">

# Elm Ant Design

[![ELM_ANTD](https://circleci.com/gh/supermacro/elm-antd.svg?style=svg)](https://circleci.com/gh/supermacro/elm-antd) [![This project is using Percy.io for visual regression testing.](https://percy.io/static/images/percy-badge.svg)](https://percy.io/Elm-Antd-Open-Source-Project/elm-antd)

> **[view the component gallery](https://elm-antd.netlify.app)**

Bringing the amazing [Ant Design](https://ant.design) kit to Elm!


Styled entirely using `elm-css`! No external stylesheet needed. Just `elm install supermacro/elm-antd` and you're all good to go!

**Early Development Notice:**

> Elm Ant Design is not fully implemented and in a early / exploratory phase. The current API is subject to change, but because Elm is super cool 😎, any breaking changes will be released under a Major release (as per semver).

## Installation

```
elm install supermacro/elm-antd
```

## Contributing

Check out the [issues](https://github.com/supermacro/elm-antd/issues), and search for "good first issue" or "help wanted"!

**Rules of contributing:**

- If implementing any visual changes:
  - Add applicable visual tests to `./showcase/visual-tests` (visual tests are written in JavaScript)
- If implementing / changing behaviour:
  - Add applicable unit tests (unit tests are written in Elm) 


### Running the development server

`npm run dev` will boot a "component showcase" on port 3000 that you can use to sanity check the visuals and behaviour of your components.

### Running Tests

Right now the project only does visual testing. To run visual tests:

- `cd` into `showcase`
- run `visual-tests:start-server` in one process
- in another process / bash session, run `visual-tests:run-tests`

"But I don't have a `PERCY_TOKEN`". Don't worry about streaming the DOM to percy. This will be done during CI checks when you open a pull request.

What matters is that you "register" the component to be rendered onto the visual testing application.

#### Visual Testing

To boot the visual testing app, run `visual-tests:start-server`. This will boot a Elm application on port 3000, so make sure that you are not running the development server already.

Visual tests work by running a server that returns a single component. At the moment, the server does not live-reload on file change.

The UI of this Elm application is a function of the URL.

```
http://localhost:3000?component=<ABC> --> UI
```

If the application does not recognize a `component` value, it will render a default component.

#### Registering New Components To Be Rendered On The Visual Testing Application 

If you implement a brand new component, you have to "register it".

Check out `registeredComponents` at https://github.com/supermacro/elm-antd/blob/master/showcase/src/elm/VisualTests.elm


## Inspiration:

- https://github.com/aforemny/elm-mdc
- https://github.com/EdutainmentLIVE/elm-bootstrap
- https://github.com/NoRedInk/noredink-ui


