                                                                 # Created DataBase 
Create Database AviationProject;

																 # Use Database
Use AviationProject;

                                                                 # Create table
CREATE TABLE DATA1 (
    UniqueID VARCHAR(111) PRIMARY KEY,
    AirlineID INT,
    TailNum VARCHAR(111),
    FlightDate DATE,
    OriginCityName VARCHAR(111),
    DestCityName VARCHAR(111),
    DepTime VARCHAR(111)
);

																# Loaded Data File :
LOAD DATA INFILE 'DATA1(SQL).csv' INTO TABLE DATA1 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Select * from DATA1;

                                                                # Create table :
CREATE TABLE DATA2 (
    UniqueID VARCHAR(111) PRIMARY KEY,
    AirlineID INT,
    TailNum VARCHAR(111),
    ArrTime VARCHAR(111),
    Cancelled INT,
    Distance INT
);

                                                                # Loaded Data File :
LOAD DATA INFILE 'DATA2(SQL).csv' INTO TABLE DATA2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Select * from DATA2;


# KPI 1 : Weekday Vs Weekend total flights

SELECT 
    WeekdayOrWeekend, COUNT(WeekdayOrWeekend) AS TotalFlights
FROM
    (SELECT 
        CASE
                WHEN DAYNAME(FlightDate) = 'Sunday' THEN 'WeekEnd'
                WHEN DAYNAME(FlightDate) = 'Saturday' THEN 'WeekEnd'
                ELSE 'WeekDay'
            END AS 'WeekdayOrWeekend'
    FROM
        data1) AS Subquery
GROUP BY WeekdayOrWeekend;


# KPI 2 : Number of cancelled flights for Honolulu, HI (OriginCityName) 

SELECT 
    a.OriginCityName, SUM(b.cancelled) AS TotalCancelled
FROM
    data1 a
        INNER JOIN
    data2 b ON b.UniqueID = a.UniqueID
WHERE
    a.OriginCityName = 'Honolulu, HI'
GROUP BY a.OriginCityName;



# KPI 3 : Week wise statistics of arrival of flights from Manchester and departure of flights to Manchester

SELECT 
    a.OriginCityName,
    WEEK(a.flightdate),
    COUNT(DISTINCT a.DepTime),
    COUNT(DISTINCT b.ArrTime)
FROM
    data1 a
        INNER JOIN
    data2 b ON b.uniqueid = a.uniqueid
WHERE
    a.OriginCityName = 'Manchester, NH'
GROUP BY WEEK(a.FlightDate);



# KPI 4 : Total distance covered by N190AA on 20th January.

SELECT 
    B.flightdate, A.tailnum, SUM(A.Distance) as Total_Distances
FROM
    data2 A
        INNER JOIN
    Data1 B ON B.UniqueID = A.UniqueID
WHERE
    B.tailnum = 'N190AA'
        AND B.flightdate = '2017-01-20'
GROUP BY A.TailNum;