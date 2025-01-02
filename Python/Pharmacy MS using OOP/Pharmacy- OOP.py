# Developing a management system for pharmacy
# 1. Deepthi Suresh -S3991481
# 2. Completed until credit level, and some DI part iii(reward rate for basic customers), iv(discount rate)
# 3. product names cannot be entered, only customer names
class Customer:
    """
        Customer class is the parent class used to create the different types of customer like VIP and Basic
        """

    def __init__(self, Cust_ID, cust_name, reward):
        self.__Cust_ID = Cust_ID
        if not cust_name.isalpha():
            raise ValueError("Name should only contain alphabetic characters")  # If anything other than alphabets
            # are entered it will raise an error
        self.__cust_name = cust_name
        self.__reward = reward

# developing getter and setter methods for the variables
    @property
    def Cust_ID(self):
        return self.__Cust_ID  # no setter methods for ID as ID ideally shouldn't be changed (A design decision)

    @property
    def cust_name(self):
        return self.__cust_name

    @property
    def reward(self):
        return self.__reward

    @cust_name.setter
    def cust_name(self, cust_name):
        if cust_name.isalpha():
            self.__cust_name = cust_name
        else:
            raise ValueError("Name should only contain alphabetic characters")  # If anything other than alphabets are
    # entered it will raise an error

    @reward.setter
    def reward(self, reward):
        if isinstance(reward, (int, float)):  # isinstance is used here to ensure the reward values are integers or
            # floats
            self.__reward = reward
        else:
            raise ValueError("Reward should only contain numeric characters")  # If anything other than numbers are
            # entered it will raise an error

    def get_reward(self):
        pass

    def get_discount(self):
        pass

    def update_reward(self):
        pass

    def display_info(self):
        pass

# -------------------------------------------------------------------------------------------------------

# The Basic customer class is inheriting the Customer class as all the features/properties of the parent class is
# required in the child class. super() is used for this purpose


class BasicCustomer(Customer):
    """
    A child class of Customer class - created for Basic customers. Includes methods to get and update the rewards and
    display the customer information. All Basic customers have a flat reward rate of 100% when making a purchase
    """
    def __init__(self, Cust_ID, cust_name, reward, reward_rate=1.0, Total_cost=0, customer_type="Basic"):  #
        # reward_rate=1.0, Total_cost=0 are the default rates
        super().__init__(Cust_ID, cust_name, reward)
        self.__reward_rate = reward_rate
        self.__Total_cost = Total_cost
        self.__customer_type = customer_type

    def __str__(self):  # __str__ and __repr__ are used so that the class objects are displayed in the set format
        return (f"ID: {self.Cust_ID}, Name: {self.cust_name}, Rate: {self.reward_rate}, Rewards: {self.reward},"
                f"Customer_Type = {self.__customer_type} ")

    def __repr__(self):
        return self.__str__()

# developing getter and setter methods for the variables
    @property
    def reward_rate(self):
        return self.__reward_rate

    # developing setter methods for the reward rate
    @reward_rate.setter
    def reward_rate(self, reward_rate):
        if isinstance(reward_rate, (int, float)):
            self.__reward_rate = reward_rate
        else:
            raise ValueError("Reward rate should only contain numeric characters")  # Input Error Handling

    def get_reward(self, Total_cost):  # calculate reward based on the total cost
        """
        A method get_reward, which takes the total cost and returns the reward. The reward is rounded.
        It also updates the rewards in the customer file
        :param Total_cost:
        :return: New reward amount
        """

        self.Total_cost = Total_cost
        new_reward = round(self.Total_cost * self.reward_rate)
        self.update_reward(new_reward)
        return new_reward

    def update_reward(self, value):  # Increase the reward by the new value
        """
        To directly increase the customers reward.
        :param value:
        :return: Reward
        """
        self.reward += value
        return self.reward

    def display_info(self):
        """
        Display the Basic customer's information in terms of ID, name and rewards
        :return: ID, name and rewards
        """
        print(f' Customer ID : {self.Cust_ID}')
        print(f' Customer Name : {self.cust_name}')
        print(f' Customer rewards : {self.reward}')

# -------------------------------------------------------------------------------------------------------


class VIPCustomer(Customer):  # inheriting the Customer class
    """
    A child class of Customer class - created for VIP customers. A VIP customer not just receives the reward but also
    gets a discount for the purchase Includes methods to get and update the rewards, discounts and display the
    customer information. Default reward rates of 100% and discount rates of 8%
    """
    def __init__(self, Cust_ID, cust_name, reward, discount=0.08, reward_rate=1.0, Total_cost=0, discount_amount=0, customer_type="VIP"):
        super().__init__(Cust_ID, cust_name, reward)
        self.__reward_rate = reward_rate
        self.__discount = discount
        self.__Total_cost = Total_cost
        self.__discount_amount = discount_amount
        self.__customer_type = customer_type

    def __str__(self):  # to display in a set format
        return (f"ID: {self.Cust_ID}, Name: {self.cust_name}, Rate: {self.reward_rate}, Rewards: {self.reward}, "
                f"Discount rate {self.discount}, Customer_Type = {self.__customer_type} ")

    def __repr__(self):
        return self.__str__()

    # developing setter and getter methods for the variables

    @property  # getter method
    def discount_amount(self):
        return self.__discount_amount

    @discount_amount.setter
    def discount_amount(self, discount_amount):
        if isinstance(discount_amount, (int, float)):
            self.__discount_amount = discount_amount
        else:
            raise ValueError("Discount amount should only contain numeric characters")

    @property  # getter method
    def discount(self):
        return self.__discount

    # developing setter methods for the discount
    @discount.setter
    def discount(self, discount):
        if isinstance(discount, (int, float)):
            self.__discount = discount
        else:
            raise ValueError("Discount rate should only contain numeric characters")

    @property
    def reward_rate(self):
        return self.__reward_rate

    # developing setter methods for the reward rate
    @reward_rate.setter
    def reward_rate(self, reward_rate):
        if isinstance(reward_rate, (int, float)):
            self.__reward_rate = reward_rate
        else:
            raise ValueError("Reward rate should only contain numeric characters")

    @property  # getter method
    def Total_cost(self):
        return self.__Total_cost

    # developing setter methods for the total cost
    @Total_cost.setter
    def Total_cost(self, Total_cost):
        if isinstance(Total_cost, (int, float)):
            self.__Total_cost = Total_cost
        else:
            raise ValueError("Total cost should only contain numeric characters")

    def get_discount(self, Total_cost):
        """
        A method which takes the total cost and calculates the discount amount based on the discount rate and
        calculate the total cost after discount
        :param Total_cost:
        :return: new_Total_cost
        """
        self.Total_cost = Total_cost
        discount_amount = Total_cost * self.discount
        self.discount_amount = discount_amount  # updating the original discount variable
        new_Total_cost = Total_cost - discount_amount
        self.get_reward(new_Total_cost)
        return new_Total_cost

    def get_reward(self, new_Total_cost):
        """
        Takes in the total cost after discount and calculates the rewards(rounded).
        :param new_Total_cost:
        :return: new_rewards
        """
        self.new_Total_cost = new_Total_cost
        new_rewards = round(self.new_Total_cost * self.reward_rate)
        self.update_reward(new_rewards)
        return new_rewards

    def update_reward(self, new_rewards):
        """
        A method update_reward which takes a value and increase the attribute reward with that value.
        :param new_rewards:
        :return:
        """
        self.reward += new_rewards
        return self.reward

    def display_info(self):
        """
        A method display_info that prints the values of the VIPCustomer attributes

        """
        print(f' Customer ID : {self.Cust_ID}')
        print(f' Customer Name : {self.cust_name}')
        print(f' Customer rewards : {self.reward}')
        print(f' Customer reward rate : {self.reward_rate}')
        print(f' Customer Total Cost : {self.Total_cost}')
        print(f' Customer discount rate : {self.discount}')
        print(f' Customer discount Amount : {self.discount_amount}')
        print(f' Customer Total Cost after discount : {self.new_Total_cost}')


# -------------------------------------------------------------------------------------------------------
# Custom exceptions are created to handle errors arising out of user input in price and prescription
class PriceError(Exception):
    pass


class PrescriptionError(Exception):
    pass


class QuantityError(Exception):
    pass


class Product:
    """
    This class is to keep track of information on different products that the pharmacy offers
    """
    def __init__(self, prod_ID, prod_name, price, dr_prescription):
        self.__prod_ID = prod_ID
        if not prod_name.isalpha():
            raise ValueError("Name should only contain alphabetic characters")  # Error handling for product name
        self.__prod_name = prod_name
        self.__price = price
        if price >= 0:
            self.__price = price
        else:
            raise PriceError("Price should be greater than 0")  # Error handling for price.Price should be greater
            # than 0
        self.__dr_prescription = str(dr_prescription)

        try:  # try-except statement is used here to handle multiple different errors that could arise in this scenario
            if str(dr_prescription).lower() == "y" or str(dr_prescription).lower() == "n":
                self.__dr_prescription = dr_prescription.lower()
            else:
                raise PrescriptionError("Should only contain y or n as inputs")
        except (SyntaxError, AttributeError, ValueError):
            print("Should only contain y or n as inputs")

    def __str__(self):
        return f"ID: {self.prod_ID}, Name: {self.prod_name}, Unit Price: {self.price}, Prescription: {self.__dr_prescription}"

    def __repr__(self):
        return self.__str__()

    # developing setter and getter methods for the variables with error handling statements.
    @property
    def prod_ID(self):
        return self.__prod_ID

    @property
    def prod_name(self):
        return self.__prod_name

    @prod_name.setter
    def prod_name(self, prod_name):
        if prod_name.isalpha():
            self.__prod_name = prod_name
        else:
            raise ValueError("Name should only contain alphabetic characters")

    @property
    def price(self):
        return self.__price

    @price.setter
    def price(self, price):
        if not str(price).isnumeric():
            raise PriceError("Price should only contain numbers greater than 0")
        else:
            if price >= 0:
                self.__price = price

    @property
    def dr_prescription(self):
        return self.__dr_prescription

    @dr_prescription.setter
    def dr_prescription(self, dr_prescription):
        try:
            if str(dr_prescription).lower() == "y" or str(dr_prescription).lower() == "n":
                self.__dr_prescription = dr_prescription.lower()

            else:
                raise ValueError("Should only contain y or n as inputs")
        except (SyntaxError, AttributeError, ValueError):
            print("Should only contain y or n as inputs")

    def display_info(self):
        """
        A method display_info that prints the values of the Product attributes

        """
        print(f' Product ID : {self.prod_ID}')
        print(f' Product Name : {self.prod_name}')
        print(f' Product price : {self.price}')
        print(f' Product prescription : {self.dr_prescription}')


# -------------------------------------------------------------------------------------------------------

class Bundle:
    """ Each bundle has a unique ID and name """
    def __init__(self, bundle_ID, prod_name, price, dr_prescription, bundle_products):
        self.__bundle_ID = bundle_ID
        self.__prod_name = prod_name
        self.__price = price
        self.__dr_prescription = dr_prescription
        self.__bundle_products = bundle_products

    def __str__(self):
        return f"ID: {self.bundle_ID}, Name: {self.prod_name}, Total Price: {self.price}, Prescription: {self.dr_prescription}, Bundle: {self.__bundle_products}"

    def __repr__(self):
        return self.__str__()

    # developing setter and getter methods
    @property
    def bundle_ID(self):
        return self.__bundle_ID

    @property
    def prod_name(self):
        return self.__prod_name

    @prod_name.setter
    def prod_name(self, prod_name):
        self.__prod_name = prod_name

    @property
    def price(self):
        return self.__price

    @price.setter
    def price(self, price):
        if not str(price).isnumeric():
            raise PriceError("Price should only contain numbers greater than 0")
        else:
            if price >= 0:
                self.__price = price

    @property
    def dr_prescription(self):
        return self.__dr_prescription

    @dr_prescription.setter
    def dr_prescription(self, dr_prescription):
        try:
            if str(dr_prescription).lower() == "y" or str(dr_prescription).lower() == "n":
                self.__dr_prescription = dr_prescription.lower()

            else:
                raise ValueError("Should only contain y or n as inputs")
        except (SyntaxError, AttributeError, ValueError):
            print("Should only contain y or n as inputs")


class Orders:
    """This class is to store a customer's purchase information"""

    def __init__(self, customer, product, quantity):
        self.__customer = customer
        self.__product = product
        self.__quantity = quantity
        if quantity >= 0:
            self.__quantity = quantity
        else:
            raise QuantityError("quantity should be greater than 0")
        self.__customer = customer
        self.__product = product

# developing getter and setter methods
    @property
    def get_customer(self):
        return self.__customer

    @property
    def get_product(self):
        return self.__product

    @property
    def get_quantity(self):
        return self.__quantity

    def compute_cost(self):
        """
        A method compute_cost that returns the original total cost (the cost before the discount), the discount,
        the final total cost (the cost after the discount), and the reward. This method is also used to display
        different receipts for different customers.
        """

        if isinstance(self.get_product, Bundle):
            price = self.get_product.price
        else:
            price = self.get_product.price

# Based on the customer type, different receipts and different discounts, rewards are calculated, so an isinstance
        # method checks if the customer is VIP or Basic
        original_cost = self.get_quantity * price
        if isinstance(self.get_customer, VIPCustomer):
            new_cost = VIPCustomer.get_discount(self.get_customer, original_cost)
            discount_amount = self.get_customer.discount_amount  # Since get_discount method done on the previous step
            # updates the discount amount in the customer file, this step calls for the discount amount directly
            reward = self.get_customer.reward
            # generating a receipt for Basic customer
            print(f'''
                                {"-" * 40}
                                {"Receipt".center(40)}
                                {"-" * 40}
                                Name: {self.get_customer.cust_name}
                                Product: {self.get_product.prod_name}
                                Unit Price: {price}
                                Quantity: {self.get_quantity}

                                {"-" * 40}
                                Original Cost: {original_cost:.2f} (AUD)
                                Discount:{discount_amount:.2f} (AUD)
                                Total cost: {new_cost:.2f} (AUD)
                                Earned reward:{self.get_customer.get_reward(new_cost)}
                                Total reward : {reward}

                                     ''')
        else:
            if isinstance(self.get_customer, BasicCustomer):
                BasicCustomer.get_reward(self.get_customer, original_cost)
                reward = self.get_customer.reward
                # return original_cost, reward
            print(f'''
                                {"-" * 40}
                                {"Receipt".center(40)}
                                {"-" * 40}
                                Name: {self.get_customer.cust_name}
                                Product: {self.get_product.prod_name}
                                Unit Price: {price}
                                Quantity: {self.get_quantity}

                                {"-" * 40}
            
                                Total cost: {original_cost:.2f} (AUD)
                                Earned reward:{self.get_customer.get_reward(original_cost)}
                                Total reward : {reward}
                        
                         ''')


class Records:
    """ central data repository of the program. contains details about the customer,products and bundles """
    customers_list = []  # empty list to capture all the customers from the file /new customers added to the program
    product_list = []  # empty list to capture all the products from the file /new products added to the program
    bundle_list = []  # empty list to capture all the bundles from the file /new bundles added to the program
    # A list is used because multiple objects need to be stored, and it needs to be editable in the future

    def read_customers(self, file_name):
        """
        This method takes in a file name and then read and add the customers in this file to the customer list of the
        class.
        :param file_name:
        """
        file = open(file_name, "r")
        line = file.readline()
        while line:
            fields_from_line = line.strip().split(",")
            if fields_from_line[0].lower().startswith("b"):
                file_ID = fields_from_line[0].strip()
                file_name = fields_from_line[1].strip()
                file_rate = float(fields_from_line[2].strip())
                file_rewards = float(fields_from_line[3].strip())
                new_basic = BasicCustomer(file_ID, file_name, file_rewards, file_rate)
                self.customers_list.append(new_basic)
            else:
                file_ID = fields_from_line[0].strip()
                file_name = fields_from_line[1].strip()
                file_rate = float(fields_from_line[2].strip())
                file_rewards = float(fields_from_line[4].strip())
                file_discount = float(fields_from_line[3].strip())
                new_VIP = VIPCustomer(file_ID, file_name, file_rewards, file_discount, file_rate)
                self.customers_list.append(new_VIP)
            line = file.readline()
        file.close()

    def read_products(self, filename):
        """
        This method takes in a file name and can read and add the products stored in that file to the product list of
        the class.
        :param filename:
        """
        file = open(filename, "r")
        line = file.readline()
        while line:
            fields_from_line = line.strip().split(",")
            file_ID = fields_from_line[0].strip()

            # If the statement below is used to distinguish between products and bundles. Products that start with a
            # "p" in the product ID are regular products, and those that start with 'b' are bundles
            if file_ID.lower().startswith("p"):
                file_name = fields_from_line[1].strip()
                file_price = float(fields_from_line[2].strip())
                file_dr_prescription = fields_from_line[3].strip()
                new_product = Product(file_ID, file_name, file_price, file_dr_prescription)
                self.product_list.append(new_product)

            if file_ID.lower().startswith("b"):
                file_name = fields_from_line[1].strip()
                file_bundle = fields_from_line[2:]

                price = 0
                for i in file_bundle:  # For statement is used to loop around the products in the bundle and find the
                    # price of each product and sum it to find the total price
                    product = self.find_product(i)
                    if product is not None:
                        price += product.price
                    else:
                        print(f"Product with ID {i} not found in bundle.")
                        return
                file_price = round(0.80 * price, 2)  # calculation for the price of a bundle. Bundles are priced at
                # 80% of the total price

                file_prescription = "n"
                for i in file_bundle:  # For statement is used to loop around the products in the bundle and find the
                    # prescription requirement of each individual product
                    prescription_1 = self.find_product(i).dr_prescription
                    if prescription_1.lower() == "y":  # if any of the products require a prescription, then
                        # the bundle can only be purchased with a prescription
                        file_prescription = "y"
                        break

                new_bundle = Bundle(file_ID, file_name, file_price, file_prescription, file_bundle)  # creating a new bundle object
                self.bundle_list.append(new_bundle)  # adding the new bundle to the bundle list
            line = file.readline()  # reads the next line in the file
        file.close()

    def list_products(self):
        """This method can display the information of existing products on screen. The method list_products will
        display the product ID, product name, and the unit price"""
        for prod in self.product_list:
            print(prod)
        for bundle in self.bundle_list:
            print(bundle)

    def list_customers(self):
        """These methods can display the information of existing customers on screen. The method list_customers will
            display the customer ID, name, the reward rate, the discount rate
            (for VIP customers), and the reward"""
        for cust in self.customers_list:
            print(cust)

    def find_customer(self, enter_id_name):
        """This method takes in a search value (can be either a name or an ID of a customer),
        searches through the list of customers and then return the corresponding customer if found or
        return None if not found."""
        ids = []
        names = []
        for cust in self.customers_list:
            ids.append(cust.Cust_ID)
            names.append(cust.cust_name)
            if enter_id_name.lower() == cust.Cust_ID.lower() or enter_id_name.lower() == cust.cust_name.lower():
                return cust
        if enter_id_name.lower() not in [x.lower() for x in ids] or enter_id_name.lower() not in [x.lower() for x in names]:
            return None

    def find_product(self, enter_id):
        """This method takes in a search value (can be an ID of a product),
            searches through the list of products and then returns the corresponding product if found or
            return None if not found."""
        ids = []
        if enter_id.lower().strip().startswith("p"):
            for prod in self.product_list:
                ids.append(prod.prod_ID)
                if enter_id.lower().strip() == prod.prod_ID.lower().strip():
                    return prod
        if enter_id.lower().strip().startswith("b"):
            for bundle in self.bundle_list:
                ids.append(bundle.bundle_ID.lower())
                if enter_id.lower().strip() == bundle.bundle_ID.lower().strip():
                    return bundle
        if enter_id.lower() not in ids:
            print("The product/bundle does not exist")
            return None

    def check_prescription(self, product):
        """This method takes in a product, and it looks at whether it requires a prescription. If the product/bundle
        requires a prescription, then it asks the user whether the customer has a prescription. If they don't, then the
        customer cannot purchase the product"""
        if product is not None:
            if product.dr_prescription.lower() == "n":
                return product
            if product.dr_prescription.lower() == "y":
                while True:
                    pres = input(" Does the customer have a prescription y/n?")
                    try:
                        if pres.lower().strip() == "y":
                            # break
                            return product
                        elif pres.lower().strip() == "n":
                            print("The product cannot be purchased without prescription")
                            Operations.main_menu(self)
                        else:
                            raise PrescriptionError("Input should only be 'y' or 'n'.")
                    except PrescriptionError as e:
                        print(e)
                    except (SyntaxError, AttributeError, ValueError):
                        print("Should only contain y or n as inputs")


class Operations(Records):
    """This class can be considered the main class of the program that supports a menu"""

    def check_file(self):
        """
        When the program starts, it looks for the files customers.txt (the customer file) and products.txt
        (the product file) in the local directory. If found, the data will be read into the program accordingly. If any
        file is missing, the program will quit gracefully with an error message indicating the corresponding file is
        missing.
        """
        cust_file = "customers.txt"
        prod_file = "products.txt"

        try:  # try-except method used for error handling
            self.read_customers(cust_file)
            self.read_products(prod_file)
            self.main_menu()
        except FileNotFoundError:
            print("File not found")
            self.exit_program()

    def make_purchase(self):
        customer_id = input("Enter customer ID or name").strip()
        customer = self.find_customer(customer_id)

        # If the customer is a new customer, the program will add the information of that customer into the data
        # collection
        if customer is None:  # if the customer doesn't exist, then create a new customer and add them to the customer
            # list
            while True:
                new_name = input("enter customer name").strip()
                try:
                    if new_name.isalpha() is True:
                        break
                    else:
                        raise ValueError("Name should only contain alphabetic characters.Try again!")
                except ValueError:
                    print("Name should only contain alphabetic characters.Try again!")

            new_reward = 0
            customer = BasicCustomer(customer_id, new_name, new_reward)  # Any new customer will be registered as a
            # Basic customer.
            Records.customers_list.append(customer)  # Adding the customer to the customer list in the Records class

        if isinstance(customer, BasicCustomer):  # print out the customer type for existing customers
            print("Customer Type : basic")
        else:
            print("Customer Type : VIP")

        while True:  # While loop is used here so that if there are any errors, the user is asked to enter the
            # product again until its a valid product
            product_id = input("Enter product ID").strip()
            product = self.find_product(product_id)
            if product is not None:
                break

        product = self.check_prescription(product)  # if the product exists, then check for prescription

        while True:  # While loop is used here so that if there are any errors, the user is asked to enter the
            # quantity again until its a valid quantity i.e greater than 0
            try:
                quantity_bought = int(input("Enter quantity").strip())
                if quantity_bought > 0:
                    break
                else:
                    print("Quantity should be greater than 0")
            except ValueError:
                print("Invalid input. Please enter a numeric value.")

        order = Orders(customer, product, quantity_bought)  # creating a new order based on the input that the user gave
        order.compute_cost()  # computing the total costs for the products

    def exit_program(self):
        """ To exit the program"""
        print("Exiting the program")
        exit()

    def adjust_rewardrate_basic(self):
        """ to adjust the reward rate of all Basic customers. This adjustment will affect all Basic customers in all
        future orders."""
        while True:
            try:
                new_rate = float(input("Enter new reward rate for customers").strip())
                if new_rate > 0:
                    break
                else:
                    print("reward rate should be greater than 0")
            except ValueError:
                print("Invalid input. Please enter a numeric value.")
        BasicCustomer.reward_rate = new_rate
        print(f"the reward rate is updated to {new_rate}")

    def adjust_discountrate_VIP(self):
        while True:
            name_id = input("Enter customer name or ID: ").strip()
            customer = self.find_customer(name_id)
            if isinstance(customer, VIPCustomer):
                while True:
                    try:
                        new_discount = float(input(f"Enter new discount rate for {name_id} customers").strip())
                        if new_discount > 0:
                            customer.discount = new_discount
                            print("The VIP discount is updated")
                            break
                        else:
                            print("discount rate should be greater than 0")
                    except ValueError:
                        print("Invalid input. Please enter a numeric value.")
                break

            else:
                 print("Customer is not a VIP customer or does not exist.")

    def main_menu(self):  # creating a menu with the following options for the user to input
        """
        # creating a menu with the following options for the user to input. Also validates the choice made by the
        user and prompts again in case of invalid input
        """
        while True:
            print(f'''
            Welcome to the RMIT pharmacy!

            {"*" * 50}
            You can choose from the following options:
            1. Make a purchase
            2. Display existing customers
            3. Display existing products
            4. Adjust the reward rate of all Basic customers
            5. Adjust the discount rate of a VIP customer
            0. Exit the program"
            {"*" * 50}
            ''')

            while True:  # While loop to ensure the customer is asked until they enter a valid menu option number
                choice = input("Choose one option").strip()
                try:
                    choice = int(choice)  # checking for non-integer values
                    if choice in range(0, 6):  # there are 5 options in the menu
                        break
                    else:
                        print("Enter a valid number from the options in the menu")
                except ValueError:  # in case non-integer values are entered
                    print("Invalid number entered. Please enter option from the menu")

            # If function to return the appropriate function based on the user's choice
            if choice == 1:
                self.make_purchase()
            elif choice == 2:
                self.list_customers()
            elif choice == 3:
                self.list_products()
            elif choice == 4:
                self.adjust_rewardrate_basic()
            elif choice == 5:
                self.adjust_discountrate_VIP()
            elif choice == 0:
                self.exit_program()


operations_1 = Operations()
operations_1.check_file()
operations_1.main_menu()


# The design of the project started with creating the main classes of a project and identifying the methods required
# under each class. Then variables for each class were set up before actually defining the methods t These variables
# were often edited to take into account the requirements for each method. For the methods that are dependent on
# other classes/method. It was important to draw out the order in which each class/method needed to be coded Each
# class.method was tested individually before going to the next class/method. Error handling was only done as one of
# the last few steps. Multiple error handling/exceptions were performed for each function including Value error,
# File not found, inputs not present in the product/customer list, negative or 0 quantity and price,
# non-alpha customer names etc. with try-except method and if-else statement in while loops. While and For loops have
# been used extensively in this project to address the invalid inputs and to iterate through the multiple items in
# the lists used in this project. I also ensured that getter/setter methods were set up for all the variables except
# for ID. I made a design choice that ID shouldn't be changed once it is loaded into the system. Apart from this,
# the inheritance of classes like Basic and VIP customer classes was worked out based on the methods that had to be
# set up for each class. One of the major challenges I faced was making edits to the class to take into
# account the additional requirements. This required changes in not only multiple methods in one class but also in
# different classes. Many times, these methods were dependent on multiple other methods. Changing one would break
# the link in others. It took some research to figure out how to link the method in two different classes and call
# objects in two different class. Another was to create the bundles and add the product names in the find_product
#  method, especially for the bundles. Overall, the project was completed iteratively by building one class and method
# at a time before compiling it into a fully working pharmacy management system which required extensive planning and
# attention to detail.

# References
# The references below has been used as base to build up on in this assignment.These have helped in
# identifying the syntax for certain functions. 1. [1] Mr_Chimp, “How to split by comma and Strip White Spaces in
# python?,” Stack Overflow, https://stackoverflow.com/questions/4071396/how-to-split-by-comma-and-strip-white-spaces
# -in-python (accessed Apr. 21, 2024).

