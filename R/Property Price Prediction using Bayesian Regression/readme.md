This project is part of the Applied Bayesian Statistics course at RMIT University, where I worked on building a Bayesian regression model to predict property prices in Melbourne. The assignment utilizes a fabricated dataset that was created using real data after various analyses to comply with the distribution rules of the original data.

Assignment Overview

The goal of this project is to model property prices in Melbourne using multiple predictors such as land size, number of bedrooms, bathrooms, car parks, and property type. The task involved applying expert knowledge about the relationship between these variables and the sale price. The steps of the project include:

* Prior Distributions: Specifying prior distributions based on expert knowledge for each predictor.
* Bayesian Model Implementation: Implementing the Bayesian model using R and JAGS.
* Model Diagnosis: Assessing the appropriateness of the MCMC chains and ensuring convergence.
* Prediction: Using Bayesian point estimates to predict sale prices for various properties.
* Reporting: Communicating the results through a structured written report, including an introduction, conclusion, and appendices.

**Dataset Details**

The dataset used for this analysis contains the following variables:

- SalePrice: Sale price in AUD.
- Area: Land size in m².
- Bedrooms: Number of bedrooms.
- Bathrooms: Number of bathrooms.
- CarParks: Number of car parks.
- PropertyType: Type of property (0: House, 1: Unit).

The dataset is fabricated but represents the real-world relationships between these variables, with expert knowledge provided on each predictor. The task also involved predicting sale prices based on different sets of property characteristics.

**Methodology**

The project followed these key steps:

* Model Diagram: A JAGS model diagram was created to represent the multiple linear regression setup.
* Prior Specification: Expert knowledge was used to define prior distributions for each predictor (e.g., Area: every m² increases the price by 90 AUD).
* Bayesian Inference: JAGS was used to implement the model, and MCMC diagnostics were performed to assess model convergence.
* Predictions: Sale prices for different properties were predicted using the Bayesian regression model.

Expert Knowledge Used for Prior Distributions:

Area: Each m² increase increases the sale price by 90 AUD (very strong knowledge).

Bedrooms: Each additional bedroom increases the sale price by 100,000 AUD (weak knowledge).

Bathrooms: No expert knowledge available.

CarParks: Each additional car park increases the sale price by 120,000 AUD (strong knowledge).

PropertyType: A unit is typically 150,000 AUD less than a house (very strong knowledge).

**Tools & Technologies Used**

R: For data manipulation, model implementation, and diagnostics.

JAGS: For performing Bayesian inference and running MCMC simulations.

Markdown: For writing the report and documenting the methodology.
