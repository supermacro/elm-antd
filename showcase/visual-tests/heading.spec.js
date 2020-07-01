import { visit, checkCorrectComponentRendered   } from './test-utils'

describe('Heading', () => {
  const simpleHeading = 'SimpleHeading'
  describe(simpleHeading, () => {
    it('Renders correctly', () => {
      visit(simpleHeading, cy)

      checkCorrectComponentRendered(simpleHeading, cy)

      cy.percySnapshot(simpleHeading)
    })
  })
})

