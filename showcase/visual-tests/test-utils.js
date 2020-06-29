
export const visit = (componentName, cy) => {
  cy.visit(`http://localhost:3000?component=${componentName}`)
}

