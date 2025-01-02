# Developing reporting system
# 1. Deepthi Suresh -S3991481
# 2. Completed until DI level
# 3. Date error handling.
import sys
import datetime


class Books:
    """
    Class to support more information about books. Each book will have an ID, name, type, the number of copies in the
    library, the maximum number of days it can be borrowed free of charge, and the late charge per each day if it is
    borrowed more than the maximum free days.
    """

    def __init__(self, book_id, name, type, no_copies, late_charge, max_days):
        self.__book_id = book_id
        self.__type = type
        self.__no_copies = no_copies
        self.__max_days = max_days
        self.__name = name
        self.__late_charge = late_charge

        if self.type.lower() == "f":  # Error handling for max days. All textbooks have the same maximum borrowing
            # days, which is 14 days by default. The fiction books have different maximum borrowing days, but always
            # be larger than 14 days.
            try:
                if max_days > 14:
                    self.__max_days = max_days
                else:
                    raise Exception("maximum days of a fiction should be greater than 14")
            except Exception as e:
                print(f"maximum days of the fiction {book_id, name} should be greater than 14")
                exit()
        if self.type.lower() == "t":
            try:
                if max_days <= 14 and max_days >= 0:
                    self.__max_days = max_days
                else:
                    raise Exception("maximum days should be greater than 0 but less than 14 for textbooks")
            except Exception as e:
                print(f" maximum days should be greater than 0 but less than 14 for {book_id, name} textbook")
                exit()

        try:  # error handling for a type of book. There are two types of books: Textbook and Fiction
            if type.lower() == "t" or type.lower() == "f":
                self.__type = type
            else:
                raise Exception(
                    "types of books can only be Textbook and Fiction.")  # raises an error if any other type is entered
        except Exception as e:
            print("types of books can only be Textbook and Fiction.")

        try:  # error handling for no of copies
            if no_copies >= 0:
                self.__no_copies = no_copies
            else:
                raise Exception("no_copies should be greater than or equal to 0")
        except Exception as e:
            print(" No of copies should be an integer greater than or equal to 0")

        try:  # error handling for late charges
            if late_charge >= 0:
                self.__late_charge = late_charge
            else:
                raise Exception("late_charge should be greater than 0")
        except Exception as e:
            print(" late_charge should be an integer greater than or equal to 0")

    # defining getter and setter methods
    @property
    def book_id(self):
        return self.__book_id

    @book_id.setter
    def book_id(self, book_id):
        self.__book_id = book_id

    @property
    def name(self):
        return self.__name

    @name.setter
    def name(self, name):
        self.__name = name

    @property
    def type(self):
        return self.__type

    @type.setter
    def type(self, type):
        try:
            if type.lower() == "t" or type.lower() == "f":
                self.__type = type
            else:
                raise Exception(
                    "types of books can only be Textbook and Fiction.")  # raises an error if any other type is entered
        except Exception as e:
            print("types of books can only be Textbook and Fiction.")

    @property
    def no_copies(self):
        return self.__no_copies

    @no_copies.setter
    def no_copies(self, no_copies):
        try:
            if no_copies >= 0:
                self.__no_copies = no_copies
            else:
                raise Exception("no_copies should be greater than 0")
        except Exception as e:
            print(" No of copies should be an integer greater than or equal to 0")

    @property
    def max_days(self):
        return self.__max_days

    @max_days.setter
    def max_days(self, max_days):
        if self.type.lower() == "f":
            try:
                if max_days > 14:
                    self.__max_days = max_days
                else:
                    raise Exception("maximum days of a fiction should be greater than 14")
            except Exception as e:
                print(f"maximum days of a fiction {self.book_id, self.name} should be greater than 14")
                exit()
        if self.type.lower() == "t":
            try:
                if max_days <= 14 and max_days >= 0:
                    self.__max_days = max_days
                else:
                    raise Exception("maximum days should be greater than 0 but less than 14 for textbooks")
            except Exception as e:
                print(f"maximum days should be greater than 0 but less than 14 for {self.book_id, self.name} textbook")
                exit()

    @property
    def late_charge(self):
        return self.__late_charge

    @late_charge.setter
    def late_charge(self, late_charge):

        try:
            if late_charge >= 0:
                self.__late_charge = late_charge
            else:
                raise Exception("late_charge should be greater than 0")
        except Exception as e:
            print(" late_charge should be an integer greater than or equal to 0")

    def __str__(self):  # to display in a set format
        return f"{self.book_id},{self.name},{self.type},{self.no_copies},{self.late_charge},{self.max_days} "

    def __repr__(self):
        return self.__str__()


class Members:
    """
    Members class to store information on the members.
    """

    def __init__(self, member_id, first_name, last_name, DOB, member_type):
        self.__first_name = first_name
        self.__last_name = last_name
        self.__DOB = DOB
        self.__member_type = member_type
        self.__member_id = member_id

        try:
            if member_type.lower() in ["standard", "premium"]:  # two types of members: Standard and Premium
                self.__member_type = member_type
            else:
                raise ValueError("Membership can only be Standard or Premium")
        except ValueError as e:
            print(e)

        try:
            self.__DOB = datetime.datetime.strptime(DOB, "%m/%d/%Y")
        except ValueError:
            raise ValueError(DOB + " must be in the format MM-DD-YYYY")


    # developing setter and getter methods
    @property
    def member_id(self):
        return self.__member_id

    @member_id.setter
    def member_id(self, member_id):
        self.__member_id = member_id

    @property
    def first_name(self):
        return self.__first_name

    @first_name.setter
    def first_name(self, first_name):
        self.__first_name = first_name

    @property
    def last_name(self):
        return self.__last_name

    @last_name.setter
    def last_name(self, last_name):
        self.__last_name = last_name

    @property
    def DOB(self):
        return self.__DOB.strftime("%d-%b-%Y")  # to remove the time component

    @DOB.setter
    def DOB(self, DOB):
        try:
            self.__DOB = datetime.datetime.strptime(DOB, "%d/%m/%Y")
        except ValueError:
            print(f"{DOB} must be in the format DD-MM-YYYY")

    @property
    def member_type(self):
        return self.__member_type

    @member_type.setter
    def member_type(self, member_type):
        try:
            if member_type.lower() in ["standard", "premium"]:
                self.__member_type = member_type
            else:
                raise ValueError("Membership can only be Standard or Premium")
        except ValueError as e:
            print(e)

    def __str__(self):
        return f"{self.member_id},{self.first_name},{self.last_name},{self.DOB},{self.member_type}"

    def __repr__(self):
        return self.__str__()


class Records:
    """
    Class records takes in variables from the Books and Members class, and contains all the methods to print the
    output of all three tables into the console and the file.

    """
    book_details = {}  # a dictionary containing the member ids, books id, no of days it was borrowed.reserved by each
    # member. A dictionary has been used to collect all the information on the books as it is mutable and can be
    # called at a later stage for adding more information about the books
    bookid_list = []  # A list containing book ids - A list is used for its mutable properties
    memberid_list = []  # A list containing member ids - A list is used for its mutable properties
    member_list = []  # A list containing member objects - A list is used for its mutable properties
    book_list = []  # A list containing book objects - A list is used for its mutable properties

    def read_records(self, file_name):
        """
        A method to read data from the record file specified in the command line, which stores the number of days
        various books have been borrowed by some members of a library (record file). When the member only reserves
        the book, the data field after the colon corresponding to the member will be R.
        :param file_name:
        :return: Records table
        """
        file = open(file_name, "r")
        line = file.readline()
        while line:  # reading the file line by line
            fields_from_line = line.strip().split(",")
            bookid = fields_from_line[0]  # collating a list of books
            for book in self.bookid_list:  # checking if the book already exists in the bookid list
                if bookid == book:
                    return book
            self.bookid_list.append(bookid)  # adding the books to the bookid list

            md = fields_from_line[1:]  # creating new members
            for i in md:
                md_split = i.strip().split(":")
                memberid = md_split[0].strip()
                borrowdays = md_split[1].strip()
                if memberid not in self.memberid_list:  # adding the memberids from the file to the memberid list
                    self.memberid_list.append(memberid)  # collating a list of members
                self.book_details.update({(bookid, memberid): borrowdays})  # creating a dictionary to connect the
                # books, members and the borrow status.
                # A dictionary is used here so that all 3 elements can be linked together.
            line = file.readline()
        file.close()
        self.display_records()  # display of the record table

    def read_books(self, file_name):
        """
        A method to read data from the book file specified in the command line. The book file will have more
        information of the books, includes the book IDs, names, types, the number of copies in the library,
        the maximum number of borrowing days, and the late charge.
        :param file_name:
        """

        file = open(file_name, "r")
        line = file.readline()
        while line:
            fields_from_line = line.strip().split(",")
            bookid = fields_from_line[0].strip()
            bookname = fields_from_line[1].strip()
            booktype = fields_from_line[2].lower().strip()
            # print(booktype)
            copies = int(fields_from_line[3].strip())
            days = int(fields_from_line[4].strip())
            charge = float(fields_from_line[5].strip())
            new_book = Books(bookid, bookname, booktype, copies, charge, days)
            self.book_list.append(new_book)
            line = file.readline()
        file.close()
        self.display_book()

    def read_members(self, file_name):
        """
        read the member file. The file includes the member's first names, last names, the day of birth, and the member
        types.
        :param file_name:
        """
        file = open(file_name, "r")
        line = file.readline()
        while line:
            fields_from_line = line.strip().split(",")
            # print(fields_from_line)
            mid = fields_from_line[0].strip()
            mfirstname = fields_from_line[1].strip()
            mlastname = fields_from_line[2].lower().strip()
            mdob = fields_from_line[3].strip()
            mtype = fields_from_line[4].strip()
            member = Members(mid, mfirstname, mlastname, mdob, mtype)
            self.member_list.append(member)
            line = file.readline()
        file.close()
        self.display_members()

    def display_records(self):
        """
        A method to display a table showing the number of days the books have been borrowed by the members of the
        library, and two sentences showing the total number of books and members, and the average number of days the
        books have been borrowed.
        :return: Records table
        """
        with open('reports.txt', 'a') as file:
            def write_and_print(*args):  # *args to avoid positional error because of join
                """
                A method to print the output to the console as well as the report text file
                """
                text = " ".join(map(str, args))  # converting to string
                print(text)
                file.write(text + '\n')

            write_and_print("RECORDS")
            write_and_print("-" * (int(len(self.bookid_list) + 4) * 10))
            header = "| {:<10}".format("Member") + " ".join(
                "{:^14.5}".format(str(i).strip()) for i in self.bookid_list) + "|".format("")
            write_and_print(header)
            write_and_print("-" * (int(len(self.bookid_list) + 4) * 10))
            for member in self.memberid_list:
                table_member = [str(member)]  # manually creating each row for the table my using a list for each member

                # In the table, if a book is not borrowed or reserved by a member, then the data field at that location
                # has an ‘xx’ symbol.On the other hand, if the book has been reserved by a member, the data field at
                # that location is shown as a double dash (--).
                for book in self.bookid_list:
                    borrow = self.book_details.get((book, member))
                    if borrow is None:
                        borrow = "xx"
                    if borrow.lower() == "r":
                        borrow = "--"
                    table_member.append("{:>10}".format(borrow))
                write_and_print("|", '\t'.join(table_member), "{:^6}".format("|"))
            write_and_print("-" * (int(len(self.bookid_list) + 4) * 10))

            write_and_print("RECORDS SUMMARY")
            member_number = len(self.memberid_list)
            book_number = len(self.bookid_list)
            write_and_print(f"There are {member_number} members and {book_number} books")

            # Calculating the average
            j = 0
            count = 0
            for i in self.book_details.values():
                if i != "R":
                    j += int(i)
                    count += 1
            average = round(j / count, 2)
            write_and_print(f"The average number of borrow days is {average} (days)")

    def check_recordfile(self):
        """
        When the program starts, it looks for the files record file in the local directory. If found, the data will
        be read into the program accordingly. If any file is missing, the program will quit gracefully with an error
        message indicating the corresponding file is missing.
        """

        try:  # try-except method used for error handling if the file is not found
            if len(sys.argv) > 1:
                file_name = sys.argv[1]
                self.read_records(file_name)
                if len(sys.argv) > 2:
                    file_name = sys.argv[2]
                    self.read_books(file_name)
                    if len(sys.argv) > 3:
                        file_name = sys.argv[3]
                        self.read_members(file_name)
                    else:
                        print("members file not found. [Usage:] python my_record.py <record file>")
                        exit()
                else:
                    print("book file not found. [Usage:] python my_record.py <record file>")
                    exit()
            else:
                print("No records file found. [Usage:] python my_record.py <record file>")
                exit()

        except (FileNotFoundError, IndexError) as e:
            print(f"{file_name}.txt File not found [Usage:] python my_record.py <record file>")

    def display_book(self):
        """
        A method to print the book information table to the screen as well as to the reports.txt file.Includes some
        useful statistics that'd calculate don the book data. the Book IDs column shows the IDs of the books,
        the Name column shows the book names, the Type column shows the types of the books (Textbook for textbooks,
        and Fiction for fiction), the Ncopy column shows the number of copies of the books in the library,
        the Maxday column shows the maximum number of days the books can be borrowed free of charge, and the Lcharge
        shows the charge per day once a book is borrowed more than the maximum free days. The Nborrow column shows
        the number of members borrowing the books. The Nreserve column shows the number of members reserving the
        books. The Range column shows the minimum and maximum number of days the books have been borrowed by the
        members.
        :return: Books information table
        """

        with open('reports.txt', 'a') as file:
            def write_and_print(text):
                """
                A method to print the output to the console as well as the report text file
                """
                print(text)
                file.write(text + '\n')

            # Print the header
            header = f"{'| Book_IDs':<10}\t{'Name':>10}\t{'Type':>15}\t{'Ncopy':>10}\t{'Maxday':>10}\t{'Lcharge':>10}\t{'Nborrow':>10}\t{'Nreserve':>10}\t{'Range ':>10}\t{'|':>5}"
            write_and_print("\n BOOK INFORMATION")
            write_and_print("-" * (int(len(header)) + 50))
            write_and_print(header)
            write_and_print("-" * (int(len(header)) + 50))

            # Compute some useful statistics, e.g., the number of borrowing
            # members, the number of reservations, the range of borrowing days by the members.
            book_max = {}
            book_min = {}

            # Calculate the range (max and min borrow days)
            for book in self.bookid_list:
                max_days = 0
                min_days = 1000  # assuming max no of days a book can be borrowed is 1000
                for member in self.memberid_list:
                    borrow = self.book_details.get((book, member))  # get the no of days each book is borrowed for
                    if borrow is not None and borrow.lower() != "r":
                        if int(borrow) > max_days:
                            max_days = int(borrow)
                            book_max[book] = max_days
                        if int(borrow) < min_days:
                            min_days = int(borrow)
                            book_min[book] = min_days

            # Calculate nborrow
            count_dict = {}  # A dictionary is used here to collect only the bookid and the nborrow data. this allows
            # us to match the bookid to the borrow days, which is not possiblt with a list or sets
            for i in self.bookid_list:  # calculating n borrow
                count = 0
                for (item1, item2), key in self.book_details.items():
                    if i == item1 and key != "R":
                        count += 1
                count_dict[i] = count

            # Calculate reserve days
            reserve_dict = {}  # A dictionary is used here to collect only the book id and the reserve data. This
            # allows us to match the book id to the count of reserve days, which is not possible with a list or sets
            for i in self.bookid_list:
                count = 0
                for (item1, item2), key in self.book_details.items():
                    if i == item1 and key == "R":
                        count += 1
                reserve_dict[i] = count

            # Print the final table
            for i in self.book_list:
                nborrow = count_dict.get(i.book_id, 0)
                reserve = reserve_dict.get(i.book_id, 0)
                maximum = book_max.get(i.book_id, 0)
                minimum = book_min.get(i.book_id, 0)
                if i.type.lower() == "t":
                    book_type = "textbook"
                if i.type.lower() == "f":
                    book_type = "fiction"
                line = f"{'|'} {i.book_id:<10}\t{i.name:>10}\t{book_type:>15}\t{i.no_copies:>10}\t{i.max_days:>10}\t{i.late_charge:>10}\t{nborrow:>10}\t{reserve:>10}\t{minimum:>10}-{maximum}\t{'|':>5}"
                write_and_print(line)

            write_and_print("-" * (int(len(header)) + 50))

            # The first sentence indicates the most popular book, i.e., the books with the greatest number of members
            # borrowing and reserving. The second sentence indicates the book with the longest days
            # borrowed by the members.

            # Calculate the most popular book
            popular_days = 0
            name = ""
            for i in count_dict:
                for j in reserve_dict:
                    if i == j:
                        popular = int(count_dict.get(i)) + int(reserve_dict.get(j))
                        if popular > popular_days:
                            popular_days = popular
                            for book in self.book_list:
                                if book.book_id == i:
                                    name = book.name

            write_and_print("\n BOOK SUMMARY")
            write_and_print(f"The most popular book is {name}")

            # Calculate the book with the longest borrow days
            days = 0
            maxborrow = ""
            for book in self.book_list:
                for i in book_max:
                    if book.book_id == i:
                        if int(book_max.get(book.book_id)) > int(days):
                            days = int(book_max.get(book.book_id))
                            maxborrow = book.name

            write_and_print(f"The book {maxborrow} has the longest borrow days ({days} days) ")

    def display_members(self):
        """
        A method to display the member information and useful statistics such as e.g., the number of textbooks they
        are borrowing or reserving, the number of fictions they are borrowing or reserving, and the average number of
        days they have borrowed books
        :return: member information table
        """
        with open('reports.txt', 'a') as file:
            def write_and_print(text):
                """
                A method to print the output to the console as well as the report text file
                """
                print(text)
                file.write(text + '\n')

            header = f"{'| Member IDs':<10}\t{'FName':<10}\t{'LName':<15}\t{'Type':>15}\t{'DOB':>15}\t{'Ntextbook':>10}\t{'Nfiction':>10}\t{'Average':>10}\t{'|':>5}"
            write_and_print("\n MEMBER INFORMATION")
            write_and_print("-" * (int(len(header)) + 40))
            write_and_print(header)
            write_and_print("-" * (int(len(header)) + 40))

            # computing useful statistics e.g., the number
            # of textbooks they are borrowing or reserving, the number of fictions they are borrowing or reserving,
            # and the average number of days they have borrowed books

            textbook_borrow = {}  # empty dictionary to catch all the members and the no of books borrowed/reserved by
            # the book type
            fiction_borrow = {}  # empty dictionary to catch all the members and the no of books borrowed/reserved by
            # the book type
            average_days = {}  # empty dictionary to catch all the members and the average borrowing days
            total_borrow = {}  # empty dictionary to catch all the members and the total borrowing no of books
            # borrowed/reserved

            for member in self.member_list:  # calculating no of books borrowed/reserved
                count_t = 0
                count_f = 0
                borrow_days = 0
                count_books = 0

                # calculating no of textbooks and fictions borrowed by each member
                for book in self.book_list:
                    value = self.book_details.get((book.book_id, member.member_id))
                    if book.type.lower() == "t":
                        if value is not None:
                            count_t += 1
                    if book.type.lower() == "f":
                        if value is not None:
                            count_f += 1
                    if value is not None and value.lower() != "r":  # total no of books
                        borrow_days += float(value)
                        count_books += 1

                borrow = count_t + count_f
                avg = round(borrow_days / count_books, 2)
                average_days[member.member_id] = avg
                total_borrow[member.member_id] = borrow  # total no of textbooks and fiction by each member

                # The standard members can only borrow or reserve 1 textbook and 2 fictions at one time. The premium
                # members can borrow or reserve 2 textbooks and 3 fictions at one time.

                if member.member_type.lower() == "standard":
                    if count_t > 1 or count_f > 2:
                        textbook_borrow[member.member_id] = f"{count_t}!"
                    else:
                        textbook_borrow[member.member_id] = count_t

                elif member.member_type.lower() == "premium":
                    if count_t > 2 or count_f > 3:
                        textbook_borrow[member.member_id] = f"{count_t}!"
                    else:
                        textbook_borrow[member.member_id] = count_t

                fiction_borrow[member.member_id] = count_f

            # Print the final table
            # In the member table, the FName column shows the members’ first names, the LName column shows
            # the members’ last names, the Type column shows the types of the members, the DOB column shows
            # the days of birth of the members, The Ntextbook column shows the number of textbooks being
            # borrowed/reserved. The Nfiction column shows the number of fictions being borrowed/reserved by
            # the members. The Average column shows the average number of borrowing days of the members.

            for i in self.member_list:
                Ntextbook = textbook_borrow.get(i.member_id)
                Nfiction = fiction_borrow.get(i.member_id)
                average = average_days.get(i.member_id)
                line = f"{'|'} {i.member_id:<10}\t{i.first_name:<10}\t{i.last_name:<15}\t{i.member_type:>15}\t{i.DOB:>15}\t{Ntextbook:>10}\t{Nfiction:>10}\t{average:>10.2f}\t{'|':>5}"  # \t{reserve:>10}\t{minimum:>10}-{maximum}
                write_and_print(line)
            write_and_print("-" * (int(len(header)) + 40))

            write_and_print("\n MEMBER SUMMARY")

            # calculation for member with the least average number of borrowing days.
            def key_of_min(d):
                return min(d, key=d.get)

            key = key_of_min(average_days)
            minval = min(average_days.values())

            for member in self.member_list:
                if key in member.member_id:
                    name = f"{member.first_name} {member.last_name}"

            # calculation for the most active member (the member with the highest number of borrowing/reserving books)
            def key_of_max(d):
                return max(d, key=d.get)

            key_1 = key_of_max(total_borrow)
            maxval = max(total_borrow.values())

            for member in self.member_list:
                if key_1 in member.member_id:
                    name_1 = f"{member.first_name} {member.last_name}"

            write_and_print(f"The most active members are: {name_1} with {maxval} books borrowed/reserved")
            write_and_print(f"The member with the least average number of borrowing days is {name} with {minval} days")


class Main(Records):
    """
    The main class of the program that runs all the methods/classes. Creates a record object and calls the
    check_recordfile method to display the records,books and member information table based on the input in the
    command line
    """

    @staticmethod
    def execute():
        record_1 = Records()
        record_1.check_recordfile()


main_1 = Main()
main_1.execute()

# analysis/reflection
# The design process started with writing down the functional requirements of the program. Based
# on this, the 3 empty classes were developed. Initial work was done on the records class and the method to display
# the records information table based on Books class and Members class. The variables for the members and books class
# were then developed based on the requirement. One design decision to be made at this point was whether to place the
# method to read and display the member and information tables in their respective classes or to put them under the
# record class. I made the design choice to put them under the records class as it was more accessible and concise.
# Then as I progressed, I worked on setting up getter and setter methods for Books and Members class. One major
# challenge that I faced was in connecting the three files as the information required was spread across to order to
# compute the various statistics required for the information table.To solve this issue, extensive use of lists and
# dictionaries have been done to capture different combinations of the data blocks. Another challenge was in printing
# the output to both the screen and the reports.txt file. I had to research a fair amount to find information on
# write and print function as the regular print/write to file function would only do one of it at a time. Each
# information table was created and tested before I moved on to the next part.For the methods that are dependent on
# other classes/method. It was important to draw out the order in which each class/method needed to be coded. Error
# handling was only done as one of the last few steps. While and for loops have been used extensively to go find
# the data for each member and book combination. Overall, the project was completed iteratively, and improvements were
# made step by step which required extensive planning and # attention to detail.


#References
# The references below has been used as base to build up on in this assignment.These have helped in identifying the syntax for certain functions.
# GeeksforGeeks. (2024b, May 10). args and kwargs in Python. GeeksforGeeks. https://www.geeksforgeeks.org/args-kwargs-python/
#Find the key of the min or max value in a Python dictionary. (2024, May 8). 30 Seconds of Code. https://www.30secondsofcode.org/python/s/key-of-min-max/#:~:text=Key%20of%20the%20minimum%20value,value%20in%20a%20given%20dictionary.
# How to do multiple arguments to map function where one remains the same. (n.d.). Stack Overflow. https://stackoverflow.com/questions/10834960/how-to-do-multiple-arguments-to-map-function-where-one-remains-the-same
#GeeksforGeeks. (2024a, February 26). Ways to save Python terminal output to a text File. GeeksforGeeks. https://www.geeksforgeeks.org/ways-to-save-python-terminal-output-to-a-text-file/
# How to run Python script on terminal? (n.d.). Stack Overflow. https://stackoverflow.com/questions/21492214/how-to-run-python-script-on-terminal
#GeeksforGeeks. (2019, December 27). How to use sys.argv in Python. GeeksforGeeks. https://www.geeksforgeeks.org/how-to-use-sys-argv-in-python/
# Printing table in python without modules. (n.d.). Stack Overflow. https://stackoverflow.com/questions/44201249/printing-table-in-python-without-modules
# GeeksforGeeks. (2023, April 27). Python  Get the first key in dictionary. GeeksforGeeks. https://www.geeksforgeeks.org/python-get-the-first-key-in-dictionary/