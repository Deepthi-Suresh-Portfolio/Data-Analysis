This project involves the following tasks:
* investigate and understand a publicly available dataset,
* design a conceptual model for storing the dataset in a relational database,
* apply normalisation techniques to improve the model,
* build the database according to the design and import the data into your database, and
* develop SQL queries in response to a set of requirements for CRUD (create, read, update and delete) operations on the database that was built.


Dataset: A Global Database of COVID-19 Vaccinations. Further details about this dataset are available in the article available through the following URL: https://www.nature.com/articles/s41562-021-01122-8.

A live version of the vaccination dataset and documentation are available in a public GitHub repository at https://github.com/owid/covid-19-data/tree/master/public/data/vaccinations.

The following files are being used for the project:

<img width="796" alt="image" src="https://github.com/Deepthi-Suresh-Portfolio/Data-Analysis/assets/160568228/630cac88-9699-41d0-ab72-6a97cc3c932c">

Model.pdf file shows: 
  * the Database ER Diagram along with the assumptions
  * Explanation of normalisation challenges and the resulting changes.
  * Database schema.

Database.sql file contains all the SQL statements necessary to create all the database relations and their corresponding integrity constraints as per the proposed design

Vaccinations.db is the database file which contains all the data that is stored in the CSV files named in Table

Queries.sql containing all the queries developed for the tasks to investigate the data in various ways.

    Task D.1 List the country that has more than average number of people taking vaccines in each observation day recorded in the dataset among all countries.
    Task D.2 Find the countries with more than the average cumulative numbers of COVID-19 doses administered by each country
    Task D.3 Produce a list of countries with the vaccine types being taken in each country. For a country that has taken in multiple vaccine types, the result set is required to show several tuples reporting each vaccine types in a separate tuple.
    Task D.4 Produce a report showing the biggest total number of vaccines administered in each country according to each data source (i.e., each unique URL). Order the result set by source name (URL).
    Task D.5 How do various countries compare in the speed of their vaccine administration? Produce a report that lists all the observation weeks in 2021 and 2022, and then for each week, list the total number of people fully vaccinated in each one of the 4 countries used in this assignment.
    
Queries.pdf contains the following :
  * The SQL query
  * a snapshot of the first 10 results of the query
  * Data visualisation represented as a graph or chart that presents the results in a meaningful and easy to understand manner.




