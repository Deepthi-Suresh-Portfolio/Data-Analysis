The objective is to develop a Python program with the Object-Oriented Programming paradigm, named my_record.py, that can read data from files and perform some operations.

The project is to implement the required functionalities in the Object-Oriented (OO) style with at least three classes: Records, Book, and Member.

Requirements

* your program can read data from the record file specified in the command line, which stores the number of days various books have been borrowed by some members of a library (record file).
* your program should create a Records object, call its method read_records(record_file_name) to load all the data from the record file, and then call the display_records() method to display the number of days all the books have been borrowed in the required format
* display a table showing the number of days the books have been borrowed by the members of the library, and two sentences showing the total number of books and members, and the average number of days the books have been borrowed.
* apart from the ID, each book will have a name, type, the number of copies in the library, the maximum number of days it can be borrowed free of charge, and the late charge per each day if it is borrowed more than the maximum free days.
* A book should have a method to compute some useful statistics, e.g., the number of borrowing members, the number of reservations, the range of borrowing days by the members
* print the book information table on screen and save the book information into a file name reports.txt.
* your program can support two types of members: Standard and Premium. The standard members can only borrow or reserve 1 textbook and 2 fictions at one time. The premium members can borrow or reserve 2 textbooks and 3 fictions at one time.
* In the member table, the FName column shows the members’ first names, the LName column shows the members’ last names, the Type column shows the types of the members, the DOB column shows the days of birth of the members, The Ntextbook column shows the number of textbooks being borrowed/reserved. The Nfiction column shows the number of fictions being borrowed/reserved by the members. The Average column shows the average number of borrowing days of the members.  
