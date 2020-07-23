# Contributing To Elm Antd

**Rules of contributing:**

- If implementing any visual changes:
  - Add applicable visual tests to `./showcase/visual-tests` (visual tests are written in JavaScript)
- If implementing / changing behaviour:
  - Add applicable unit tests (unit tests are written in Elm) 
- **If you're adding a brand new component**, make sure to add it to the list of `exposed-modules` within `elm.json`. 

### Project Structure

- `src/Ant`: Contains the actual Elm Antd components that can be used by a user
- `tests`: Unit tests for components
- `showcase`: Contains the component showcase (https://elm-antd.netlify.app/)
  - `/tests`: Unit tests for component showcase
  - `/visual-tests`: Visual regression / UI tests for the components in `src/Ant`
    - The reason that these tests live here is because I am leveraging the existing showcase application when doing UI tests. The app gets booted into "visual testing mode" using `showcase/src/elm/VisualTests.elm`
- `file-server`: NodeJS web application that is used to fetch source code from either your file system (local development) or github (production)



### Running the development server

`npm run dev` will boot a "component showcase" on port 3000 that you can use to sanity check the visuals and behaviour of your components.

### Running Tests

#### Unit Testing

Unit tests ensure that things **behave** as expected, and prevent behavioural regressions.

Make sure you have `elm-test` globally installed.

To run tests, run `elm-test` to run tests for the components in `src/Ant`


#### Visual Testing

Visual tests ensure that things **look** as expected, and prevent visual regressions.

Visual tests work by running a server that returns a single component. At the moment, the server does not live-reload on file change.

The UI of this Elm application is a function of the URL.

```
http://localhost:3000?component=<ABC> --> UI
```

To run visual tests:

- `cd` into `showcase`
- run `visual-tests:start-server` in one process
  - This will boot a Elm application on port 3000, so make sure that you are not running the development server already.
- in another process / bash session, run `visual-tests:run-tests`

When you run the tests, you'll see that you don't have a `PERCY_TOKEN`. Don't worry about streaming the DOM to percy. This will be done during CI checks when you open a pull request.

What matters is that you "register" the component to be rendered onto the visual testing application.

If the application does not recognize a `component` value, it will render a default component.

#### Registering New Components To Be Rendered On The Visual Testing Application 

If you implement a brand new component, or new visual functionality, you have to "register" a new component.

Check out `registeredComponents` at https://github.com/supermacro/elm-antd/blob/master/showcase/src/elm/VisualTests.elm

