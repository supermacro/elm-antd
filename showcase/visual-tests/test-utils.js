
/**
 * @param componentName string
 * @param cy Cypress
 */
export const visit = (componentName, cy) => {
  cy.visit(`http://localhost:3000?component=${componentName}`)
}

/**
 * Checks that the value passed into the `component`
 * URL query param corresponds to a "registered" component
 *
 * @param componentName string
 * @param cy Cypress
 */
export const checkCorrectComponentRendered = (componentName, cy) => {
  cy.title({ timeout: 1000 }).should('eq', `Visual Tests - ${componentName}`)
}

