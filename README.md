# Airport Data Analysis Project

## Project Overview
This project analyzes airport data using **Microsoft Excel** & **Microsoft SQL Server Management Studio (SSMS 20)**. The dataset (`airports.xlsx`) contains details about global airports, including type, location, elevation, and scheduled services.

## 📂 Project Structure

📂 Airport-Data-Analysis
```
│── 📁 Dataset                   # Dataset storage
│── 📁 SQL Airport Analysis      # SQL queries for analysis
│── 📜 README.md                 # Project documentation
```

## 🛠️ Setup & Execution

1. Import data

- The data that I will be using for this project is an open source data from OurAirports (https://ourairports.com/data/) 
2. Data Cleaning & Preprocessing In Microsoft Excel
1. Handle Missing Values
Replace NaN in continent_code, country_code, region_code with 'UNKNOWN' to maintain consistency.
Fill missing iata_code and gps_identifier with 'N/A' since not all airports have these.
Drop rows where name, latitude, or longitude is missing (critical fields).

2. Convert Data Types
Ensure latitude & longitude are stored as FLOAT.
Convert elevation_ft to INTEGER.
Standardize has_scheduled_service to 'YES' or 'NO'.

3. Remove Duplicates
Drop duplicate rows based on airport_id (ident), name, and location (latitude, longitude).

4. Standardize Text Formatting
Convert all text columns (e.g., airport_name, city, country_code) to UPPERCASE for consistency.


2.	Exploratory Data Analysis (EDA) in Microsoft SQL Server Management Studio 20 (SSMS)

  All the SQL queries can be found here ([url](https://github.com/aimansri5/SQL/blob/main/SQL%20Airport%20Analysis.sql))




