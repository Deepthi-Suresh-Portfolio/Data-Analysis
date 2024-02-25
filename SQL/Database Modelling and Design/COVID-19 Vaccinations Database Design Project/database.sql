/*Create Source table*/
CREATE TABLE Source (
    source_name VARCHAR NOT NULL,
    source_website VARCHAR NOT NULL,
    PRIMARY KEY (source_name, source_website)
);

--Create Locations table
CREATE TABLE Locations (
    iso_code  NOT NULL,    
    location VARCHAR,   
    last_observation_date DATE,
    PRIMARY KEY (iso_code)
);

-- Create Vaccine table
CREATE TABLE Vaccine (
    iso_code VARCHAR NOT NULL,
    Vaccines VARCHAR NOT NULL,
    source_website VARCHAR,
    source_name VARCHAR,
    PRIMARY KEY (iso_code,Vaccines)
    FOREIGN KEY (source_website,source_name) REFERENCES Source(source_website,source_name)
    FOREIGN KEY (iso_code) REFERENCES Locations(iso_code)
);


-- Create a Date table

CREATE TABLE Date (
    Date Date NOT NULL,
    PRIMARY KEY (Date)
);

-- Create Manufacturer table
CREATE TABLE Manufacturer (
    iso_code VARCHAR NOT NULL,
    Date DATE NOT NULL,
    Vaccines VARCHAR NOT NULL,
    Total_Vaccinations DECIMAL,
    PRIMARY KEY (iso_code,Date,Vaccines)
    FOREIGN KEY (Vaccines) REFERENCES Vaccine(Vaccines)
    FOREIGN KEY (iso_code) REFERENCES Locations(iso_code)
    FOREIGN KEY (Date) REFERENCES Date(Date)
);

-- Create the age group table
CREATE TABLE Age_group (
    Age_group VARCHAR NOT NULL,
    PRIMARY KEY (Age_group)
);

--Creating Vacc_Age table
CREATE TABLE Vacc_Age (
    iso_code VARCHAR NOT NULL,
    Date DATE NOT NULL,
    Age_group VARCHAR NOT NULL,
    people_vaccinated_per_hundred DECIMAL,
    people_fully_vaccinated_per_hundred DECIMAL,
    people_with_booster_per_hundred DECIMAL,  
    PRIMARY KEY (iso_code,Date,Age_group)
    FOREIGN KEY (Age_group) REFERENCES Age_group(Age_group)
    FOREIGN KEY (iso_code) REFERENCES Locations(iso_code)
    FOREIGN KEY (Date) REFERENCES Date(Date)
);

--Creating Vaccination table
CREATE TABLE Vaccination (
    iso_code VARCHAR NOT NULL,
    Date DATE NOT NULL,
    total_vaccinations DECIMAL, 
    people_vaccinated DECIMAL, 
    people_fully_vaccinated DECIMAL, 
    total_boosters DECIMAL,	
    daily_vaccinations_raw DECIMAL, 
    daily_vaccinations DECIMAL, 
    total_vaccinations_per_hundred DECIMAL, 
    people_vaccinated_per_hundred DECIMAL, 
    people_fully_vaccinated_per_hundred DECIMAL, 
    total_boosters_per_hundred DECIMAL, 
    daily_vaccinations_per_million DECIMAL, 
    daily_people_vaccinated DECIMAL, 
    daily_people_vaccinated_per_hundred DECIMAL, 
    PRIMARY KEY (iso_code,Date)
    FOREIGN KEY (iso_code) REFERENCES Locations(iso_code)
    FOREIGN KEY (Date) REFERENCES Date(Date)
);

-- Creating country_vaccineusedbydate table
CREATE TABLE country_vaccineusedbydate (
    iso_code VARCHAR NOT NULL,
    Date DATE NOT NULL,
    Vaccines VARCHAR NOT NULL,
    PRIMARY KEY (iso_code,Date,Vaccines)
    FOREIGN KEY (Vaccines) REFERENCES Vaccine(Vaccines)
    FOREIGN KEY (iso_code) REFERENCES Locations(iso_code)
    FOREIGN KEY (Date) REFERENCES Date(Date)
);
--Creating statewise_distribution table
CREATE TABLE statewise_distribution (
    iso_code VARCHAR NOT NULL,
    Date DATE NOT NULL,
    state VARCHAR NOT NULL,
    total_vaccinations DECIMAL,
    total_distributed DECIMAL,
    people_vaccinated DECIMAL, 
    people_fully_vaccinated_per_hundred DECIMAL,
    total_vaccinations_per_hundred DECIMAL,
   people_fully_vaccinated DECIMAL,
   people_vaccinated_per_hundred DECIMAL, 
   distributed_per_hundred DECIMAL,  
   daily_vaccinations_raw DECIMAL, 
   daily_vaccinations DECIMAL,
   daily_vaccinations_per_million DECIMAL,   
    total_boosters DECIMAL,	             
    total_boosters_per_hundred DECIMAL, 
    PRIMARY KEY (iso_code,Date,state)
    FOREIGN KEY (iso_code) REFERENCES Locations(iso_code)
    FOREIGN KEY (Date) REFERENCES Date(Date)
);

-- Create the Vaccines table - NEW
CREATE TABLE Vaccine (
    Vaccines VARCHAR NOT NULL,
    PRIMARY KEY (Vaccines)
);

-- Create Vaccinebyloc table
CREATE TABLE Vaccinebyloc(
    iso_code VARCHAR NOT NULL,
    Vaccines VARCHAR NOT NULL,
    source_website VARCHAR NOT NULL,
    source_name VARCHAR NOT NULL,
    PRIMARY KEY (iso_code, Vaccines,source_name,source_website)
    FOREIGN KEY (Vaccines) REFERENCES Vaccine(Vaccines)
    FOREIGN KEY (iso_code) REFERENCES Locations(iso_code)
    FOREIGN KEY (source_name,source_website) REFERENCES Source(source_name,source_website)
);