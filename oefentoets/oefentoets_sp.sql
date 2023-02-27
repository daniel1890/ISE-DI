-- Vraag 3 (20 pnt) – STORED PROCEDURES
-- 
-- Muziekscholen willen de volgende business rule invoeren: 
-- 
-- Voor een stuk moet altijd een titel worden vastgelegd.
--
-- Schrijf een stored procedure die gebruikt moet worden voor het 
-- toevoegen van een nieuw stuk, waarbij het volgende gedrag moet worden gerealiseerd:
-- 
-- •	als het toe te voegen stuk een bewerking betreft en de titel ontbreekt in de aanroep van deze stored procedure, dan moet de titel van het origineel van deze bewerking worden overgenomen
-- 
-- •	als het toe te voegen stuk een origineel stuk betreft en de titel ontbreekt in de aanroep van de stored procedure dan mag en record niet worden toegevoegd en moet de volgende foutmelding getoond worden:
-- 'Registreren van een nieuw origineel stuk zonder titel is niet toegestaan'.

-- Je hoeft geen rekening te houden met andere (reeds aanwezige) constraints, maar zorg wel dat de oplossing een adequate foutafhandeling heeft. 
DROP PROCEDURE IF EXISTS procInsertStuk
GO
CREATE PROCEDURE procInsertStuk(
 @stuknr 	NUMERIC(5,0),
 @componistId NUMERIC(4,0),
 @titel 	VARCHAR(20),
 @stuknrOrigineel NUMERIC(5,0), 	--bij NULL is het een origineel, 
									--bij NOT NULL is het een bewerking
 @genrenaam 	VARCHAR(10),
 @niveaucode 	CHAR(1),
 @speelduur 	NUMERIC(3,1),
 @jaartal 	NUMERIC(4,0))
AS
BEGIN
    SET NOCOUNT ON -- optimalisatie
    BEGIN TRY
		IF @titel IS NULL AND @stuknrOrigineel IS NOT NULL
			BEGIN 
				SET @titel = (SELECT titel FROM Stuk WHERE stuknr = @stuknrOrigineel)
			END
		IF @titel IS NULL AND @stuknrOrigineel IS NULL 
        BEGIN
            ;THROW 50001, 'Registreren van een nieuw origineel stuk zonder titel is niet toegestaan', 1
        END
        	INSERT INTO Stuk
			VALUES(@stuknr, @componistId, @titel, @stuknrOrigineel, @genrenaam, @niveaucode, @speelduur, @jaartal)
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END

--Testen
BEGIN TRANSACTION --bewerking zonder titel, dan overnemen titel van origineel
EXECUTE procInsertStuk @stuknr=99,@componistId=10,@titel=NULL,@stuknrOrigineel=1,@genrenaam='jazz',@niveaucode=NULL,@speelduur=4.5,@jaartal=2021
SELECT * FROM stuk WHERE stuknr = 99 --moet resulteren in
--stuknr|componistId|titel    |stuknrOrigineel|genrenaam|niveaucode|speelduur|jaartal
--    99|         10|Blue bird|              1|     jazz|      NULL|      4.5|   2021
ROLLBACK TRANSACTION

BEGIN TRANSACTION --bewerking met titel, dan deze titel opslaan
EXECUTE procInsertStuk @stuknr=99,@componistId=10,@titel='Dummy',@stuknrOrigineel=1,@genrenaam='jazz',@niveaucode=NULL,@speelduur=4.5,@jaartal=2021
SELECT * FROM stuk WHERE stuknr = 99 --moet resulteren in
--stuknr|componistId|titel    |stuknrOrigineel|genrenaam|niveaucode|speelduur|jaartal
--    99|         10|Dummy    |              1|     jazz|      NULL|      4.5|   2021
ROLLBACK TRANSACTION

BEGIN TRANSACTION --origineel met titel, deze zo dan ook opslaan
EXECUTE procInsertStuk @stuknr=99,@componistId=10,@titel='Dummy',@stuknrOrigineel=NULL,@genrenaam='jazz',@niveaucode=NULL,@speelduur=4.5,@jaartal=2021
SELECT * FROM stuk WHERE stuknr = 99 --moet resulteren in
--stuknr|componistId|titel    |stuknrOrigineel|genrenaam|niveaucode|speelduur|jaartal
--    99|         10|Dummy    |           NULL|     jazz|      NULL|      4.5|   2021
ROLLBACK TRANSACTION

BEGIN TRANSACTION --origineel zonder titel, moet leiden tot foutmelding
EXECUTE procInsertStuk @stuknr=99,@componistId=10,@titel=NULL,@stuknrOrigineel=NULL,@genrenaam='jazz',@niveaucode=NULL,@speelduur=4.5,@jaartal=2021
--moet resulteren in de foutmelding 'Registreren van een nieuw origineel stuk zonder titel is niet toegestaan.'
ROLLBACK TRANSACTION