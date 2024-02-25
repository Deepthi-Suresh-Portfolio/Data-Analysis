The objective of this project is to use SQL for querying a relational database and analyse different database models for different applications. Following tasks are performed:
  * identifying functional dependencies
  * identifying Primary keys and Foreign keys
  * decompose into relations in 3NF
  
**Part A Relational Database design**

Consider the Customer database of the ABC big bank, which keeps data for customers and employees.
 1. A customer has a unique customer number (CustNo) and is also described by name, phone number, address, DateOfBirth and EmailAddress. Email addresses may be shared by customers (eg spouse).
 2. An account is identified by a unique account number (AccNo).
 3. A branch has a unique branch BSB(RegisterBranchBSB) and has an address (BranchAddress).
 4. A customer can open several accounts and an account is made by only one customer.
 5. A customer can own several bank account types, and a bank account type can belong to several customers. A bank account type is identified by a number (TypeID) and has a type name.
 6. A customer account has one service employee (EmpNo)..
 7. A service employee works in one branch, but they can be responsible for several customer accounts

** Part B Library DB - User requirements**


 1.Display the title, subtitle and Edition of books which are published in OXFORD. The output should have column headings “Title”, “Subtitle”, “Edition” and “Place” (and matching case). (12 rows)
 2. Compute the total number of book copies for each book. Output the bookdescid together with its total number of book copies, in decreasing order of total number of book copies. (413 rows)
 3. Display the bookdescid, title, subtitle, edition and place of books which have not been borrowed by any person. There should not be any duplicate records in your result. 
  a. Write your query using the JOIN operator.
  b. Write your query using an IN sub query.
 4. Are there authors in the “Author” role who have written more than 1 book? Display the authorID, firstName, middleName and lastName of these authors and the number of books.
 5. The dates in relation “borrow” are stored as REAL type data in Julian Days. You can use the built-in date() function to convert the real value into date format. For example, to find out a duedate as YYYY-MM-DD format you can use date(duedate). Find out the books that are returned after the due dates. Display book title, date of return, due date, and how many days were delayed from the due date. Display the dates in YYYY-MM-DD format. 
 6. Find out the publishers who have never edited any books (in the “Editor” role). Display the full name of publishers, ordered alphabetically by the full name of publishers.
 7. Find out the persons who authored books on the subject of “Artificial Intelligence”. Display author name (first and last names, separated by a space) under the column heading of "Author", book title, book subject, and published year. 
 8. Find all OTHER books borrowed by the persons who borrowed the book with title ‘COMPUTER SCIENCE’. Display the title, “Borrower Name” (first name and last name), and date of borrow of OTHER books by the same borrower(s). Display the dates in YYYY-MM-DD format. 
 8. Find out how many times each book has been borrowed. Display the book bookdescid, titles, the year of publication along with the number times it has been borrowed, ordered from most borrowed to least. Do not include books that have never been borrowed.
 
