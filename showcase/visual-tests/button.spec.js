import { visit } from './test-utils'

describe('Button', () => {
  const simpleButton = 'SimpleButton'
  describe(simpleButton, () => {
    it('Renders correctly', () => {
      visit(simpleButton, cy)

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

      cy.visit(appUrl)
      cy.get('button').rightclick()
      cy.percySnapshot(snapshotTag)
    })
  })

  const primaryButton = 'PrimaryButton'
  describe(primaryButton, () => {
    it('Renders correctly', () => {
      visit(primaryButton, cy)
      cy.percySnapshot(primaryButton)
    })
  })


  const dashedButton = 'DashedButton'
  describe(dashedButton, () => {
    it('Renders correctly', () => {
      visit(dashedButton, cy)
      cy.percySnapshot(dashedButton)
    })
  })

  const textButton = 'TextButton'
  describe(textButton, () => {
    it('Renders correctly', () => {
      visit(textButton, cy)
      cy.percySnapshot(textButton)
    })
  })
})

