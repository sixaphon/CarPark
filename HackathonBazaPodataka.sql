CREATE DATABASE HackathonInteraParking
ON PRIMARY
 (Name = N'HackathonInteraParking', FILENAME = N'C:\DB\HackathonInteraParking.mdf',
  SIZE = 300MB, FILEGROWTH = 100MB)
LOG ON
 (NAME = N'HackathonInteraParking_log', FILENAME = N'C:\DB\HackathonInteraParking_log.ldf',
  SIZE = 50MB, FILEGROWTH =10%);
GO

USE HackathonInteraParking
GO

CREATE TABLE Parking
(
    ParkingID int IDENTITY(1,1) PRIMARY KEY,
    Naziv varchar(50) NOT NULL,
    CijenaPoSatu money NOT NULL DEFAULT 1.00,
    Kapacitet int NOT NULL,
    TrenutnoZauzeto int NOT NULL DEFAULT 0,
    PostojanjeKrova bit NOT NULL DEFAULT 0,
    DostupnostParkinga bit NOT NULL DEFAULT 1,
    GeoDuzina decimal(10,8) NOT NULL,
    GeoSirina decimal(10,8) NOT NULL
);


INSERT INTO Parking(Naziv, CijenaPoSatu, Kapacitet, GeoDuzina, GeoSirina)
VALUES('Intera Tehnoloski Park', 2.00, 150, 17.82149, 	43.30667)


INSERT INTO Parking(Naziv, CijenaPoSatu, Kapacitet, GeoDuzina, GeoSirina)
VALUES('Gradski Parking Mostar', 1.50, 350, 17.805080, 43.348559)


CREATE PROC PromijeniDostupnost
@Trenutno int,
@Maksimalno int
AS 
  UPDATE Parking SET DostupnostParkinga = 0
  WHERE @Trenutno >= @Maksimalno
  UPDATE Parking SET DostupnostParkinga = 1
  WHERE @Trenutno < @Maksimalno
 
  
CREATE PROCEDURE UvecajZauzetost 
@NazivParkinga nvarchar(50)
AS 
  UPDATE Parking SET TrenutnoZauzeto = TrenutnoZauzeto + 1
  WHERE Naziv = @NazivParkinga AND (SELECT Kapacitet
                                    FROM Parking
                                    WHERE @NazivParkinga = Naziv) > (SELECT TrenutnoZauzeto
                                   									 FROM Parking
                             								         WHERE @NazivParkinga = Naziv)
 EXEC PromijeniDostupnost




CREATE PROCEDURE UmanjiZauzetost 
@NazivParkinga nvarchar(50)
AS 
  UPDATE Parking SET TrenutnoZauzeto = TrenutnoZauzeto - 1
  WHERE Naziv = @NazivParkinga AND (SELECT Kapacitet
                                    FROM Parking
                                    WHERE @NazivParkinga = Naziv) > (SELECT TrenutnoZauzeto
                                   									 FROM Parking
                             								         WHERE @NazivParkinga = Naziv)
 EXEC PromijeniDostupnost


 CREATE PROC DodajKrov
 @Naziv nvarchar(50)
 AS
   UPDATE Parking SET PostojanjeKrova = 1
   WHERE @Naziv = Naziv


CREATE VIEW ParkingPodaci
AS
 SELECT Naziv, CijenaPoSatu AS "Cijena (1H)",
        Kapacitet, (Kapacitet - TrenutnoZauzeto) AS "Dostupnih mjesta",
		IIF(PostojanjeKrova = 0, 'Krov ne postji / nepoznato', 'Krov postoji') AS Pokrivenost,
		IIF(DostupnostParkinga = 0 ,'Nema slobodnih parking mjesta!', 'Ima slobodnih parking mjesta!') AS "Dostupnost Parking Mjesta",
		GeoDuzina AS "Geografska duzina",
		GeoSirina AS "Geografska sirina"
 FROM Parking

 SELECT * FROM ParkingPodaci
																	