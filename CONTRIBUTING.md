# Contributing To Elm Antd

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


