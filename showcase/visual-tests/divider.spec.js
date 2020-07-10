import { visit, checkCorrectComponentRendered  } from './test-utils'

describe('Divider', () => {
  const dividers = [
    'SimpleDivider',
    'DashedDivider',
    'VerticalDivider'
  ]

  dividers.forEach((divider) => {
    describe(divider, () => {
      it('Renders Correctly', () => {
        visit(divider, cy)

        checkCorrectComponentRendered(divider, cy)

        cy.percySnapshot(divider)
      })
    })
  })
})

