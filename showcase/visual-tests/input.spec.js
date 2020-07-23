import { visit, checkCorrectComponentRendered  } from './test-utils'

describe('Input', () => {
  const inputs = [
    'SimpleInput',
  ]

  inputs.forEach((input) => {
    describe(input, () => {
      it('Renders Correctly', () => {
        visit(input, cy)

        checkCorrectComponentRendered(input, cy)

        cy.percySnapshot(input)
      })

      it('Has correct active state', () => {
        const snapshotTag = `${input}-active`
        visit(input, cy)

        checkCorrectComponentRendered(input, cy)

        cy.get('input').click()

        cy.percySnapshot(snapshotTag)
      })
    })
  })
})

