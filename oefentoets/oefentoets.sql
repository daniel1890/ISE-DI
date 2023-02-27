-- Vraag 1 (30 pnt) - EXISTS, EXCEPT, INTERSECT, UNION
-- Gegeven de volgende informatiebehoefte:
--
-- Geef een lijst van alle instrumenten (instrumentnaam en toonhoogte) die wel door studenten bespeeld worden maar niet in de bezetting van een stuk voorkomen.
--
-- Toon het instrumentnaam en toonhoogte.
--
-- a.	[15 pt] Geef een query, voor deze informatiebehoefte, die gebruik gemaakt van één of meerdere EXISTS operatoren.  
--
-- Het gebruik van common table expressions (CTE) of van één of meerdere set operatoren EXCEPT, INTERSECT of UNION is niet toegestaan.
SELECT I.instrumentnaam, I.toonhoogte
FROM Instrument I
WHERE EXISTS
	(
	SELECT * 
	FROM StudentInstrument SI
	WHERE SI.instrumentnaam = I.instrumentnaam
	AND SI.toonhoogte = I.toonhoogte
	)
AND NOT EXISTS
	(
	SELECT *
	FROM Bezettingsregel B
	WHERE B.instrumentnaam = I.instrumentnaam
	AND B.toonhoogte = I.toonhoogte
	)

-- b.	[15 pt] Geef een query, voor deze informatiebehoefte, die gebruik gemaakt van één of meerdere set operatoren EXCEPT, INTERSECT of UNION. 
-- 
-- Het gebruik van common table expressions (CTE) of van één of meerdere EXISTS operatoren is niet toegestaan.
SELECT SI.instrumentnaam, SI.toonhoogte 
FROM StudentInstrument SI
	INNER JOIN Instrument I ON SI.instrumentnaam = I.instrumentnaam
EXCEPT
SELECT B.instrumentnaam, B.toonhoogte 
FROM Bezettingsregel B
	INNER JOIN Instrument I ON B.instrumentnaam = I.instrumentnaam

-- Vraag 2 (30 pnt) - WINDOW FUNCTIONS, CTE
--
-- a.	[15 pt] Gegeven de volgende informatiebehoefte:
-- Geef een lijst van alle stukken die uitgevoerd worden en geef ze een rangnummer per jaar. De eerste voorstelling (uitvoering van een stuk) in dat jaar krijgt rangnummer (=voorstellingnr) 1, de tweede voorstelling krijgt rangnummer 2 enzovoorts.
--
-- Geef een query, voor deze informatiebehoefte, die gebruik gemaakt van één of meerdere Window functions.
-- Het resultaat moet er als volgt uit zien:
--
-- stuknr	datumtijdUitvoering	jaar	voorstellingnr
-- 2	2014-12-24 00:00:00.000	2014	1
-- 3	2015-01-01 00:00:00.000	2015	1
-- 12	2015-12-06 00:00:00.000	2015	2
-- 9	2015-12-31 00:00:00.000	2015	3
-- 15	2016-01-01 00:00:00.000	2016	1
SELECT S.stuknr, US.datumtijdUitvoering, YEAR(US.datumtijdUitvoering) AS jaar, RANK() OVER (PARTITION BY YEAR(US.datumtijdUitvoering) ORDER BY US.datumtijdUitvoering ASC) AS voortstellingnr
FROM Stuk S
	INNER JOIN UitvoeringStuk US ON S.stuknr = US.stuknr

-- b.	[15 pt] Gegeven de volgende informatiebehoefte:
-- Geef een lijst van alle stukken die uitgevoerd worden en toon van iedere uitvoering het verschil in dagen met de vorige uitvoering van datzelfde stuk.
--
-- Geef een query, voor deze informatiebehoefte, die gebruik gemaakt van één of meerdere Window functions en een CTE operator. 
--
-- Het resultaat moet er als volgt uit zien (gebaseerd op testdata van hieronder):
-- 
-- stuknr	datumtijdUitvoering	dagenverschil
-- 2	2014-12-24 00:00:00.000	NULL
-- 2	2015-04-17 00:00:00.000	114
-- 2	2015-09-03 00:00:00.000	139
-- 2	2015-09-08 00:00:00.000	5
-- ..	..	..

BEGIN TRANSACTION
INSERT INTO Componist VALUES (11, 'John Adams', '1947-02-15', 1);
ROLLBACK TRANSACTION

BEGIN TRANSACTION
INSERT INTO uitvoeringstuk (stuknr, datumtijduitvoering)
VALUES	(2, '20150417'),
		(2, '20150903'),
		(2, '20150908')

SELECT S.stuknr, US.datumtijdUitvoering, DATEDIFF(DAY,LAG(US.datumtijdUitvoering, 1) OVER (ORDER BY US.datumtijdUitvoering), US.datumtijdUitvoering) AS dagenverschil
FROM Stuk S
	INNER JOIN UitvoeringStuk US ON S.stuknr = US.stuknr

ROLLBACK TRANSACTION
