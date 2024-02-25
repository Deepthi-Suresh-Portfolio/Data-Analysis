The project showcases my knowledge in the following areas:
  * Accurately, logically and ethically combine data from multiple sources to make suitable for statistical analysis and draw valid interpretations.
  * Articulate how data meets the best practice standards (e.g. tidy data principles).
  * Select, perform and justify data validation processes for raw datasets.
  * Use leading open source software (e.g. R) for reproducible, automated data processing.

The report is based on four datasets - Population and Life Expectancy (LE) for both males and females. As a part of the pre-processing the first step was to read in the data into R and then make adjustments to the data especially removing the ‘world’ observation to avoid skewness. The data was then tidied by converting the year into a variable with its own column. Then the male and female datasets of population and LE was combined using rbind. The structure of the dataset was then looked at and necessary conversion of data type was done. Then, the two data was ready to be merged using join function to form the merged dataset. Once the dataset was ready, a new derived variable called relative Life expectancy was created, which was based on the average global life expectancy.

The final data was then scanned for missing values and imputation or deletion was performed based on the variable to ensure there was no missing values. Then the dataset was checked for any outliers and the numeric variable had some outliers which were dealt by capping or Winsorising method by using a special function. 

Once the missing values are outliers are handled, the data was now ready for transformation. Several data transformation techniques were performed to identify the best one to convert the data into a normal distribution. Scaling and Centering was also performed to enhance the comparability
