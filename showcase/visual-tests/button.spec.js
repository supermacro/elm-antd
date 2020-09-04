import { visit, checkCorrectComponentRendered  } from './test-utils'

describe('Button', () => {
  const buttons = [
    'SimpleButton',
    'PrimaryButton',
    'DashedButton',
    'TextButton',
    'LinkButton',
    'DisabledPrimaryButton',
    'PrimaryButtonWithIcon',
  ]

  buttons.forEach((btn) => {
    describe(btn, () => {
      it('Renders Correctly', () => {
        visit(btn, cy)

        checkCorrectComponentRendered(btn, cy)

        cy.percySnapshot(btn)
      })

      // Cannot trigger :hover CSS States via cypress
      // Also, I do not agree with workarounds that are
      // Chrome/Chromium specific, as Firefox and IE Edge
      // shoul also be taken into consideration.
      //
      // https://github.com/cypress-io/cypress/issues/10
      // https://github.com/supermacro/elm-antd/issues/18
      it.skip('Renders hover styles correctly', () => {
        const snapshotTag = `${btn}-hover`

        visit(btn, cy)

        checkCorrectComponentRendered(btn, cy)

        cy.get('button').rightclick()
        cy.percySnapshot()
      })
    })
  })
})

