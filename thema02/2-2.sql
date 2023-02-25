-- 1.	Geef voor alle stukken aan of het een ‘kort’, ‘gemiddeld’ of ‘lang’ stuk is volgens onderstaande definitie.
--
-- Speelduur	SpeelduurCategorie
-- Onbekend	n.v.t
-- Tussen 0 en 3	Kort
-- Tussen 3 en 5	Gemiddeld
-- Groter dan 5	Lang
SELECT * ,  
CASE    -- input expression
  WHEN speelduur BETWEEN 0 AND 3     THEN 'Kort'
  WHEN speelduur BETWEEN 3 AND 5	 THEN 'Gemiddeld'
  WHEN speelduur > 5				 THEN 'Lang'
  ELSE 'n.v.t'
END AS SpeelduurCategorie
FROM Stuk S
ORDER BY S.speelduur ASC

-- 2.	Geef per SpeelduurCategorie (volgens de definitie hierboven) aan hoeveel stukken er in deze categorie vallen
WITH SpeelduurCategorie_CTE AS (SELECT * ,  
CASE    -- input expression
  WHEN speelduur BETWEEN 0 AND 3     THEN 'Kort'
  WHEN speelduur BETWEEN 3 AND 5	 THEN 'Gemiddeld'
  WHEN speelduur > 5				 THEN 'Lang'
  ELSE 'n.v.t'
END AS SpeelduurCategorie
FROM Stuk S
)

SELECT SpeelduurCategorie, COUNT(*) AS AantalStukken
FROM SpeelduurCategorie_CTE
GROUP BY SpeelduurCategorie

-- 3.	Maak een script waarmee je de naam van de huidige dag in het nederlands krijgt, gebruik makend van CASE.
DECLARE @datum DATE = GETDATE();
SELECT CASE DATENAME(WEEKDAY, @datum)
  WHEN 'Monday'      THEN 'Maandag'
  WHEN 'Tuesday'     THEN 'Dinsdag'
  WHEN 'Wednesday'   THEN 'Woensdag'
  WHEN 'Thursday'    THEN 'Donderdag'
  WHEN 'Friday'      THEN 'Vrijdag'
  WHEN 'Saturday'    THEN 'Zaterdag'
  WHEN 'Sunday'      THEN 'Zondag'
  ELSE 'n.v.t'
END AS HuidigeDag

-- IS ZELFDE EN COMPACTER ALS
SELECT CASE 
  WHEN DATENAME(WEEKDAY, @datum) = 'Monday'      THEN 'Maandag'
  WHEN DATENAME(WEEKDAY, @datum) = 'Tuesday'     THEN 'Dinsdag'
  WHEN DATENAME(WEEKDAY, @datum) = 'Wednesday'   THEN 'Woensdag'
  WHEN DATENAME(WEEKDAY, @datum) = 'Thursday'    THEN 'Donderdag'
  WHEN DATENAME(WEEKDAY, @datum) = 'Friday'      THEN 'Vrijdag'
  WHEN DATENAME(WEEKDAY, @datum) = 'Saturday'    THEN 'Zaterdag'
  WHEN DATENAME(WEEKDAY, @datum) = 'Sunday'      THEN 'Zondag'
  ELSE 'n.v.t'
END AS HuidigeDag
SELECT @datum