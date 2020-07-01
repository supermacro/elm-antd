import { visit, checkCorrectComponentRendered  } from './test-utils'

describe('Button', () => {
  const simpleButton = 'SimpleButton'
  describe(simpleButton, () => {
    it('Renders correctly', () => {
      visit(simpleButton, cy)

      checkCorrectComponentRendered(simpleButton, cy)

      cy.percySnapshot(simpleButton)
    })

    // Cannot trigger :hover CSS States via cypress
    // Also, I do not agree with workarounds that are
    // Chrome/Chromium specific, as Firefox and IE Edge
    // shoul also be taken into consideration.
    //
    // https://github.com/cypress-io/cypress/issues/10
    it.skip('Renders hover button with correct styles', () => {
      const snapshotTag = `${simpleButton}-hover`

      visit(simpleButton, cy)

      checkCorrectComponentRendered(simpleButton, cy)

      cy.get('button').rightclick()
      cy.percySnapshot(snapshotTag)
    })
  })

  const primaryButton = 'PrimaryButton'
  describe(primaryButton, () => {
    it('Renders correctly', () => {
      visit(primaryButton, cy)

      checkCorrectComponentRendered(primaryButton, cy)

      cy.percySnapshot(primaryButton)
    })
  })


  const dashedButton = 'DashedButton'
  describe(dashedButton, () => {
    it('Renders correctly', () => {
      visit(dashedButton, cy)

      checkCorrectComponentRendered(dashedButton, cy)

      cy.percySnapshot(dashedButton)
    })
  })

  const textButton = 'TextButton'
  describe(textButton, () => {
    it('Renders correctly', () => {
      visit(textButton, cy)

      checkCorrectComponentRendered(textButton, cy)

      cy.percySnapshot(textButton)
    })
  })

  const linkButton = 'LinkButton'
  describe(linkButton, () => {
    it('Renders correctly', () => {
      visit(linkButton, cy)

      checkCorrectComponentRendered(linkButton, cy)

      cy.percySnapshot(linkButton)
    })
  })
})

