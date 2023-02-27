-- Vraag 4 (20 pts) - TRIGGERS
-- 
-- Muziekscholen willen de volgende business rule invoeren:
--
-- Er mogen maximaal twee componisten werkzaam zijn voor dezelfde muziekschool.
--
-- Voorbeeld: 
-- Muziekschool 1 en 2 hebben (volgens de originele populatie) momenteel twee componisten werkzaam. Er mogen dus niet meer componisten werkzaam zijn bij deze scholen. 
--
-- Om de rule te bewaken moet een trigger geschreven worden. Als de business rule overtreden wordt moet de volgende foutmelding worden gegeven:
--
-- 'De muziekschool heeft reeds twee componisten.'
--
-- Je hoeft geen rekening te houden met andere (reeds aanwezige) constraints, maar zorg dat de oplossing een adequate foutafhandeling heeft.

DROP TRIGGER IF EXISTS trgComponist
GO
CREATE TRIGGER trgComponist ON Componist
AFTER INSERT, UPDATE
AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN 
    SET NOCOUNT ON -- optimalisatie
    BEGIN TRY
        IF (SELECT COUNT(*) AS AantalComponisten FROM INSERTED I INNER JOIN Componist C ON I.schoolId = C.schoolId) > 2
        BEGIN
            ;THROW 50001, 'De muziekschool heeft reeds twee componisten.', 1
        END
    END TRY 
    BEGIN CATCH
        ;THROW  
    END CATCH
END

--TEST 1: mag niet slagen, deze muziekschool heeft reeds twee componisten
BEGIN TRANSACTION
INSERT INTO Componist VALUES (11, 'John Adams', '1947-02-15', 1);
ROLLBACK TRANSACTION

--TEST 2: mag wel slagen, deze muziekschool heeft nog geen componisten
BEGIN TRANSACTION
INSERT INTO Componist VALUES (11, 'John Adams', '1947-02-15', 3);
ROLLBACK TRANSACTION

--TEST 3: mag niet slagen, een van beide muziekscholen heeft teveel componisten 
BEGIN TRANSACTION
INSERT INTO Componist 
VALUES	(11, 'John Adams', '1947-02-15', 1), 
		(12, 'Benjamin Britten', '1913-11-22', 3)
ROLLBACK TRANSACTION
