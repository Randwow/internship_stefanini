USE master
IF EXISTS ( 
SELECT 1
FROM sys.databases
WHERE name = 'cofeDB' 
) 

BEGIN
      ALTER DATABASE cofeDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
      DROP DATABASE  cofeDB
END 
GO
USE master 
      GO
IF NOT EXISTS ( SELECT 1 FROM sys.databases WHERE name = 'cofeDB' )

      CREATE DATABASE cofeDB

      GO
USE cofeDB

-- Cook: name
-- Ingredient: name, price
-- Dish: name, description, price, estimated cooking time (int minutes)

CREATE TABLE Cooks (
	Id_cook				INT PRIMARY KEY , 
	cook_name			VARCHAR(30) NOT NULL,
	cook_last_name		VARCHAR(30) NOT NULL,
	number_of_deshes	INT DEFAULT 0
)
CREATE TABLE Visitor (
	Id_visitor			INT PRIMARY KEY, 
	Id_booking			INT NOT NULL,
	Visitor_name		VARCHAR(30) NOT NULL,
	Visitor_lastname	VARCHAR(30) NOT NULL,
)
CREATE TABLE Dishes (
	Id_dish				INT PRIMARY KEY , 
	Dish_description	VARCHAR(150) NOT NULL,
	Dish_price			INT ,
	Dish_cooking_time	INT DEFAULT 10,
	Dish_name			VARCHAR(150) NOT NULL,
)
CREATE TABLE Booking (
	Id_booking			INT PRIMARY KEY,
	Id_dish				INT ,
	Waiter_name			VARCHAR(30) NOT NULL,
	FOREIGN KEY (Id_booking) REFERENCES Visitor(Id_visitor)
)
CREATE TABLE Dishes_Booking(
	Id_dish				INT FOREIGN KEY REFERENCES Dishes(Id_dish),
	Id_booking			INT FOREIGN KEY REFERENCES Booking(Id_booking),
	Id_cook				INT FOREIGN KEY REFERENCES Cooks(Id_cook),
	Time_of_booking		DATETIME DEFAULT GETDATE(),
	PRIMARY KEY (Id_dish, Id_booking, Time_of_booking,Id_cook)
)

CREATE TABLE Ingredients (
	Id_ingredient		INT PRIMARY KEY, 
	Id_dish				INT NOT NULL , 
	Ingredient_name		VARCHAR(30) NOT NULL,
	Ingredient_price	INT NOT NULL,
	FOREIGN KEY (Id_dish) REFERENCES Dishes(Id_dish)
)


INSERT INTO Cooks (Id_cook, cook_name, cook_last_name) VALUES 
	(1, 'John', 'Smith'),
	(2, 'Oliver', 'Johnson'),
	(3, 'David', 'Williams'),
	(4, 'Nick', 'Brown'),
	(5, 'Antoni', 'Jones');

INSERT INTO Visitor(Id_visitor, Id_booking, Visitor_name, Visitor_lastname) VALUES 
	(1, 1, 'John', 'Smith'),
	(2, 2, 'Oliver', 'Johnson'),
	(3, 3, 'David', 'Williams'),
	(4, 4, 'Nick', 'Brown'),
	(5, 5, 'Antoni', 'Jones');
INSERT INTO Booking(Id_booking, Waiter_name) VALUES
	(1, 'John'),
	(2, 'Oliver'),
	(3, 'Nick'),
	(4, 'Smith' ),
	(5, 'Antoni');
INSERT INTO Dishes(Id_dish, Dish_price, Dish_description, Dish_name) VALUES 
(1, 100, 'ITS VERY TASTY DISH', 'Fried potato'),
(2, 200, 'ITS VERY TASTY DISH', 'Fish'),
(3, 250, 'ITS VERY TASTY DISH', 'Meat'),
(4, 90, 'ITS VERY TASTY DISH', 'Salat'),
(5, 150, 'ITS VERY TASTY DISH', 'Paste');
INSERT INTO Ingredients(Id_ingredient, Id_dish, Ingredient_name,Ingredient_price) VALUES
(1, 1, 'Potatoes', 100),
(2, 2, 'Fish', 150),
(3, 3, 'Meat', 200),
(4, 4, 'Tomatoes', 40),
(5, 5, 'Paste', 100),
(6, 4, 'cucumbers', 30);
INSERT INTO Dishes_Booking(Id_booking, Id_dish, Id_cook) VALUES 
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(1, 4, 4),
(2, 1, 5);

GO
--Расчет стоимости блюд
UPDATE Dishes SET Dish_price = (SELECT SUM(Ingredient_price)*1.2 FROM Ingredients WHERE Ingredients.Id_dish = Dishes.Id_dish)
--Вывод на экран всех блюд 
SELECT * FROM Dishes
--Вывести на экран информацию о счете посетителя с ID = 1
 SELECT  Booking.Id_booking, Booking.Waiter_name, Dishes.Dish_name, Dishes_Booking.Time_of_booking, Dishes.Dish_price, Dishes.Dish_cooking_time
FROM Booking
INNER JOIN Dishes_Booking ON Booking.Id_booking=Dishes_Booking.Id_booking AND Booking.Id_booking = 1 INNER JOIN Dishes ON Dishes_Booking.Id_dish = Dishes.Id_dish;
--Подсчитать сумму заказа с определенным айди
 SELECT  SUM(Dish_price) AS Total_Price FROM Dishes INNER JOIN Dishes_Booking ON (Dishes.Id_dish = Dishes_Booking.Id_dish and Dishes_Booking.Id_booking = 1);
--1)Написать триггер который не даст возможность добавления блюда поварам если у них больше 5 блюд 
--DROP TRIGGER Prohibiting_Attribute_Updates 
--GO

IF EXISTS (SELECT * FROM sys.objects WHERE [name] = N'Prohibiting_Attribute_Updates_More_Than_5' AND [type] = 'TR')
BEGIN
      DROP TRIGGER [dbo].[trg];
END;
GO
CREATE TRIGGER Prohibiting_Attribute_Updates_More_Than_5 
ON Cooks
FOR UPDATE
AS
BEGIN 
IF((SELECT MIN(number_of_deshes) FROM Cooks) = 6)
BEGIN
ROLLBACK TRANSACTION
RAISERROR ('No cooks available', 16, 1)
END
END
GO
SELECT * FROM Cooks

UPDATE Cooks SET number_of_deshes = number_of_deshes+1 ;

UPDATE Cooks SET number_of_deshes = 0 ;
-- Транзакция добавления блюда повару 
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
UPDATE Cooks WITH(TABLOCK) SET number_of_deshes += 1  WHERE number_of_deshes = (SELECT MIN(number_of_deshes) FROM Cooks)   
--WAITFOR DELAY '00:00:10' 
COMMIT TRANSACTION
PRINT 'SUCCESS'
PRINT 'transaction commited'


SELECT * FROM Cooks

