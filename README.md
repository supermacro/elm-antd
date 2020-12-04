<img src="https://raw.githubusercontent.com/gDelgado14/elm-antd/master/logo.svg" alt="gDelgado14/elm-antd logo" width="40%" align="right">

# Elm Ant Design

[![ELM_ANTD](https://circleci.com/gh/supermacro/elm-antd.svg?style=svg)](https://circleci.com/gh/supermacro/elm-antd) [![This project is using Percy.io for visual regression testing.](https://percy.io/static/images/percy-badge.svg)](https://percy.io/Elm-Antd-Open-Source-Project/elm-antd)

> **[Component Gallery](https://elm-antd.netlify.app)**

> **[API Documentation](https://package.elm-lang.org/packages/supermacro/elm-antd/latest/)**

Bringing the amazing [Ant Design](https://ant.design) kit to Elm!


Styled entirely using `elm-css`! No external stylesheet needed. Just `elm install supermacro/elm-antd` and you're all good to go!

**Early Development Notice:**

> Elm Ant Design is not fully implemented and in a early / exploratory phase. The current API is subject to change, but because Elm is super cool 😎, any breaking changes will be released under a Major release (as per semver).

## Installation

```
elm install supermacro/elm-antd
```

## Usage

#### Render stylesheet at the root of your Elm project

Elm Antd has a stylesheet implemented in Elm that you must hook up at the root of your elm project. You must use one of `Ant.Css.defaultStyles` or `Ant.Css.createThemedStyles customTheme` (see [official docs](https://package.elm-lang.org/packages/supermacro/elm-antd/latest/) to learn about theming). 


```elm
import Ant.Css

view : Model -> Html Msg
view model =
    div []
      [ Ant.Css.defaultStyles
      , viewApp model
      ]
```

#### Apply Normalize Css

Elm Ant Design is built with normalize.css as its blank canvas.

You should add normalize.css to your project or else the components may not look as expected.

You have three options:

- Add normalize.css as a `link` tag to your html directly

```html
<link href="https://pagecdn.io/lib/normalize/8.0.1/normalize.min.css" rel="stylesheet" crossorigin="anonymous"  >
```

- Add normizlize.css as a Elm module using [elm-css-modern-normalize](https://package.elm-lang.org/packages/hmsk/elm-css-modern-normalize/latest)

```elm
import Css.ModernNormalize as ModernNormalize

view : Model -> Html Msg
view _ =
    [ ModernNormalize.globalHtml
    , Ant.Css.defaultStyles
      -- Your application view comes here
    ]

```

- Use a bundler for NodeJS to load normalize into your app at build-time.

npm module Link: https://www.npmjs.com/package/normalize

```javascript
require('normalize')
```

#### [Optional] - Add Extra animations

There are additional animations you can add to your `elm-antd` project by adding JS event handlers to your app.

You can add them in one of two ways:

- Add the following `script` tag to the `head` of your html file:

```html
<script src="https://cdn.jsdelivr.net/npm/elm-antd-extras@1.0.0/index.js"></script>
```

- install `elm-antd-extras` npm package and use a bundling tool like webpack, gulp, etc in order to include the code into your html file

## Contributing

Want to help out?

- Check out the [issues](https://github.com/supermacro/elm-antd/issues), and search for "good first issue" or "help wanted"! 
- Check out the [CONTRIBUTING](https://github.com/supermacro/elm-antd/blob/master/CONTRIBUTING.md) doc 

## Inspiration:

- https://github.com/aforemny/elm-mdc
- https://github.com/EdutainmentLIVE/elm-bootstrap
- https://github.com/NoRedInk/noredink-ui


