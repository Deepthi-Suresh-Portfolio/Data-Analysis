# Developing a management system for a pharmacy
# 1. Deepthi Suresh -S3991481
# 2. Fully completed upto part 3(3); partially attempted part 3(4)
# 3. haven't completed part 3 question 4 for displaying customer order history

# A dictionary has been used to collect all the information on the products as it is mutable and can be called
# at a later stage for adding more information about the products
Products_Price = {"vitaminC": [12.0, False], "vitaminE": [14.5, False],
                  "coldTablet": [6.4, False], "vaccine": [32.6, True],
                  "fragrance": [25.0, False]}  # Creating a dictionary of products and its prices with the requirement
# of prescription
Products_Price_lower = dict((k.lower(), v) for k, v in  # (Thakur, 2020)[3]
                            Products_Price.items())  # converting all product names into lowercase to avoid any case


# sensitive errors


def add_or_update_products():  # For option 2 in the menu
    """
    Use to update the existing products or add new products into the Products_price dictionary
    required inputs are product name price dr_prescription in Y or N separated by a whitespace
    handles invalid product,quantity price and  prescription errors
    """
    while True:  # While loop is used here so that if there are any errors the user is asked to enter the entire list
        # again until its all valid
        product_details = input("Please enter the product information (name price dr_prescription (Y or N): ").lower()
        product_details = [p.strip() for p in product_details.split(
            ',')]  # to strip the whitespaces and split the list by "," (Mr_Chimp, 2010)[1]
        exists_price = 0
        length = len(product_details)
        # for loop checks for each item that is entered by the user and checks if it is valid or not.
        # if it is valid then it adds the product to the product_price_lower dictionary
        for i in product_details:  # for checking valid quantities
            product_info = [p.strip() for p in i.split()]  # (Mr_Chimp, 2010)[1]
            try:
                price = float(product_info[1].strip())
                if price > 0:
                    exists_price += 1
            except ValueError:  # in case non-integer values are entered
                continue
        if exists_price == length:
            exists_prescription = 0
            for i in product_details:  # for checking valid prescription
                product_info = [p.strip() for p in i.split()]  # (Mr_Chimp, 2010)[1]
                prescription = product_info[2].lower()
                if prescription == "n" or prescription == "y":
                    exists_prescription += 1
                else:
                    break

            if exists_prescription == length:
                for i in product_details:  # for checking valid quantities
                    product_info = [p.strip() for p in i.split()]  # (Mr_Chimp, 2010)[1]
                    product_name = product_info[0]  # from the list entered by the user
                    product_price = product_info[1]
                    if product_info[2] == "y":
                        Product_prescription = True  # converting y or N to boolean for easy calculations in future
                        # and reduces errors
                    else:
                        Product_prescription = False
                    Products_Price_lower.update({product_name: [product_price, Product_prescription]})
                break  # breaks the prescription loop
            else:
                print("enter valid prescription (Y or N)")
        else:
            print("Invalid price entered. Please enter numbers greater than 0")
    print(Products_Price_lower)

    main_menu()


# A dictionary has been used to collect all the information on the products as it is mutable and can be called
# at a later stage for adding more information about the products
Customers = {"Kate": 20, "Tom": 32}  # 7 Creating a customer and rewards dictionary
Customers_lower = dict((n.lower(), m) for n, m in  # (Thakur, 2020)[3]
                       Customers.items())  # converting all customers names into lowercase to avoid any


# case-sensitive errors


def customer_existing():  # For printing existing customers required for the menu option
    """
    Displays the name and the reward points of existing customers stored in the Customers_lower dictionary
    """
    # For loop is used to circle through all the customers in the Customers_lower dictionary and display details of
    # each customer
    for i, j in Customers_lower.items():
        print(f'''Customer {i} has {j} reward points''')
    main_menu()


def display_products():  # For printing existing products required for the menu option
    """
    Displays all the existing products and its price and prescription requirements stored in the Products_Price_lower
    dictionary :return:
    """
    print(f'''{"Product Name".ljust(15)} {"Unit Price".center(15)} {"Requires Prescription".rjust(25)}''')  # rjust,
    # center and ljust is used for alignment while displaying the output
    for i, j in Products_Price_lower.items():  # For loop is used to circle through all the products in the
        # Products_Price_lower dictionary and display details of each product
        if j[1] == True:  # checking if the prescription returns True or False and converting it to Yes and No for
            # easy readability
            product_prescription = "Yes"
        else:
            product_prescription = "No"
        print(f''' {i.ljust(15)} {str(j[0]).center(15)} {str(product_prescription).rjust(25)}''')  # using the same
        # alignment settings as earlier
    main_menu()


def exit_program():
    """ To exit the program and display the main menu"""
    print("Exiting the program")
    exit()
    # main_menu()


def make_purchase():  # For making a purchase option of the menu
    """Function to call when the user wants to log a purchase. the function handles invalid,quantity, product name"""
    while True:  # if the entered name contains any other characters other than alphabets, print an error and ask the
        # user to enter valid name
        customer_name = input("Enter customer's name").strip().lower()  # 1 Entering customer's name
        if customer_name.isalpha():  # to check if there are numbers in the name
            break
        else:
            print("customer's name should contain only alphabets")

    while True:  # if the entered product name is not in the product_price_lower dictionary then print an error and
        # ask the user to enter valid product
        product_name = input(
            "Enter the name of the product the customer chooses").lower().split(',')  # split the list based on ","
        # (Vishal, 2023)[2]
        product_name = [x.strip() for x in product_name]  # to strip the whitespaces (Mr_Chimp, 2010)[1]
        exists = 0  # Dummy variable used to break the loop
        length = len(product_name)
        for i in product_name:  # using a for loop to check if each product in the list exists in the
            # Products_Price_lower dictionary
            if i in Products_Price_lower:  # if the product exists then add 1 to the dummy variable exists
                exists += 1
        if exists == int(
                length):  # if the value in exists matches the length of the list, it means that all products are valid
            while True:  # input and checking for valid quantity.The user is prompted until they enter a valid quantity
                Quantity_input = input("Enter the quantity of the {} ordered by the customer".format(
                    product_name)).strip().split(',')  # quantity of the product ordered (Vishal, 2023)[2]
                exists = 0  # Dummy variable used to break the loop
                length = len(Quantity_input)
                try:  # to avoid Value Errors which might occur in case of non integer values are entered
                    for i in Quantity_input:
                        Quantity = int(i)  # quantity entered should be an integer
                        if Quantity > 0:  # handles negative or 0 as quantity
                            exists += 1  # if the product exists then add 1 to the dummy variable exists
                except ValueError:  # in case non-integer values are entered
                    print("Invalid Quantity entered. Please enter numbers greater than 0")
                    continue
                if exists == length:  # if the value in exists matches the length of the list, it means that all
                    # quantities are valid
                    break  # breaks the quantity loop
                else:
                    print("Invalid Quantity entered. Please enter an integer greater than 0")

            purchased_products = dict(zip(product_name, Quantity_input))  # creating a dictionary for purchased
            # products and quantity entered
            for item in list(purchased_products.keys()):  # using a for loop to check if each product in the list
                # exists in the Products_Price_lower dictionary and then check in the Products_Price_lower dictionary
                # if they need prescription
                if Products_Price_lower[item][1] == True:  # checking if the products need a prescription to purchase
                    while True:  # While loops prompts the user until they enter a valid input
                        have_prescription = input(
                            "Does the customer have a doctor's prescription? (Enter Y or N) ").strip()
                        if have_prescription.lower() == "y":  # checking if the customer has a prescription
                            break  # if there is a prescription then continue
                        if have_prescription.lower() == "n":
                            print("The {} cant be purchased".format(item))  # format option is used to personalise the
                            # input message displayed t the user with the products they have purchased
                            del purchased_products[item]  # deleting the item from the purchased products dictionary
                            # so the rest of the item can be purchased (user248237, 2011)[4]
                            break  # breaks the prescription loop
                        else:
                            print("Invalid input. Enter Y or N")

            break  # breaks the product loop

        else:
            print("Invalid product name")

    Total_Cost = 0  # 4 Calculating Total Cost = product’s unit * product quantity.
    for pro, qty in purchased_products.items():  # for loop to loop through and calculate total cost for all the
        # products purchased by the customer
        Total_Cost += float(qty) * Products_Price_lower[pro][0]  # quantity converted to float to match the data types
    Earned_rewards = round(Total_Cost)  # rewards for the current purchase based on rounding the total costs

    # Updating and redeeming the reward points for the existing customers
    if customer_name in Customers_lower:
        current_rewards = Customers_lower[customer_name]  # calculating the existing rewards of the customer
        if current_rewards >= 100:  # if the customer has more than 100 points convert every 100 points into 10$
            discount = current_rewards // 100 * 10
            Total_Cost = Total_Cost - discount  # Calculating the new total cost after discount
            New_rewards = current_rewards - current_rewards // 100 * 100 + Earned_rewards  # new rewards after
            # redemption and adding the rewards earned in the current purchase
            Customers_lower.update({customer_name: New_rewards})  # updating the customer dictionary with the new points
        else:
            New_rewards = current_rewards + Earned_rewards  # when the customer doesn't have more than 100 points
            Customers_lower.update({customer_name: New_rewards})
    else:
        Customers_lower.update({customer_name: Earned_rewards})  # when the customer is new to the system

    def print_receipt():  # 6 Function to display the receipt
        """
        Displaying the receipt with the purchase details along with the Total Cost and Earned rewards
        """
        print(f'''
            {"-" * 40}
            {"Receipt".center(40)}
            {"-" * 40}
            Name: {customer_name}''')
        for i, k in purchased_products.items():
            print(f'''
            Product: {i}
            Unit Price: {Products_Price_lower[i][0]:.2f} (AUD)
            Quantity: {k}
            {"-" * 40}''')
        print(f'''
            Total cost: {Total_Cost:.2f} (AUD)
            Earned reward:{Earned_rewards}
            Total reward: {Customers_lower[customer_name]}
            ''')

    print_receipt()

    order_history = {}  # updates this dictionary with the customers purchase details
    order_history = order_history.update({customer_name: [purchased_products, Total_Cost, Earned_rewards]})

    main_menu()


def customer_history():
    """
    displays the order history of the customers
    """
    while True:  # if the entered name contains any other characters other than alphabets, print an error
        customer_name = input("Enter customer's name").strip().lower()  # 1 Entering customer's name
        if customer_name.isalpha():  # checking for invalid inputs
            break
        else:
            print("customer's name should contain only alphabets")


def main_menu():  # creating a menu with the following options for the user to input
    """
    # creating a menu with the following options for the user to input. Also validates the choice made by the user and
    prompts again in case of invalid input
    """
    while True:
        print(f'''
        Welcome to the RMIT pharmacy!

        {"*" * 50}
        You can choose from the following options:
        1. Make a purchase"
        2. Add/Update information of a product
        3. Display existing customers
        4. Display existing products
        5. Display a customer order history
        0. Exit the program"
        {"*" * 50}
        ''')

        while True:  # While loop to ensure the customer is asked until they enter a valid menu option number
            choice = input("Choose one option").strip()
            try:
                choice = int(choice)  # checking for non integer values
                if choice in range(0, 6):  # there are 6 options in the menu
                    break
                else:
                    print("Enter a valid number from the options in the menu")
            except ValueError:  # in case non-integer values are entered
                print("Invalid number entered. Please enter option from the menu")

        # If function to return the appropriate function based on the users choice
        if choice == 1:
            make_purchase()
        elif choice == 2:
            add_or_update_products()
        elif choice == 3:
            customer_existing()
        elif choice == 4:
            display_products()
        elif choice == 5:
            customer_history()
        elif choice == 0:
            exit_program()


main_menu()

# Analysis

# The design of the process started with creating a rough draft on the functional requirements of part one.
# The variables for the input functions were first created and then the data type i.e. dictionaries,list etc. were
# identified for each group such as products, customers etc. For this project I have used more dictionaries and lists
# in order to ensure that these can be updated in the future if required as dictionaries and lists are mutable. In
# order to avoid any case-sensitivity error I maintained a lower case version of these dictionaries which could be
# easily compared to the lower version of the inputs from the user. I started off by creating the make_purchase
# function which was the major chunk of the code followed by the other functions required for the options in the
# menu. Multiple error handling/exceptions were performed for each function including Value error, inputs not present
# in the dictionary, negative or 0 quantity and price, non-alpha customer names etc. with try-except method and
# if-else statement in while loops. While and For loops have been used extensively in this project to address the
# invalid inputs and to iterate through the multiple dictionaries and lists used in this project.All the functions
# were created separately and tested before compiling into an if-elif-else statement for when the user inputs a
# choice for the menu. One of the challenge I faced was calculating the rewards for the existing customers and
# creating an if condition for when they have more than 100 points. But with some research and study, I figured out a
# way to solve the issue, it was to use a nested loop and if statement combination. Another was, creating and displaying
# the order history of the customers. Overall, the project was completed iteratively by building on more
# functionality in each function before compiling it into a fully working pharmacy management system which required
# extensive planning and attention to detail .


# References
# The references below has been used as base to build up on in this assignment.These have helped in identifying the syntax for certain functions.
# 1. [1] Mr_Chimp, “How to split by comma and Strip White Spaces in python?,” Stack Overflow, https://stackoverflow.com/questions/4071396/how-to-split-by-comma-and-strip-white-spaces-in-python (accessed Apr. 21, 2024).
# 2. [1] Vishal, “Python take a list as input from a user,” PYnative, https://pynative.com/python-accept-list-input-from-user/ (accessed Apr. 21, 2024).
# 3 [1] A. Thakur, “How to convert python dictionary keys/values to lowercase?,” Tutorialspoint, https://www.tutorialspoint.com/How-to-convert-Python-dictionary-keys-values-to-lowercase (accessed Apr. 21, 2024).
# 4 [1] user248237user248237 et al., “How do I delete items from a dictionary while iterating over it?,” Stack Overflow, https://stackoverflow.com/questions/5384914/how-do-i-delete-items-from-a-dictionary-while-iterating-over-it (accessed Apr. 21, 2024).
