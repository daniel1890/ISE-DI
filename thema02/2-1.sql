-- 1.	Geef stuknr en titel van elk stuk waar een piano in meespeelt.
-- zonder EXISTS
SELECT DISTINCT S.stuknr, S.titel 
FROM Stuk S
WHERE S.stuknr IN
	(
	SELECT stuknr FROM Instrument I
		INNER JOIN Bezettingsregel B ON B.instrumentnaam = I.instrumentnaam
	WHERE I.instrumentnaam = 'piano'
	)

-- met EXISTS
SELECT DISTINCT S.stuknr, S.titel 
FROM Stuk S
WHERE EXISTS
	(
	SELECT *
	FROM Instrument I
		INNER JOIN Bezettingsregel B ON B.instrumentnaam = I.instrumentnaam
	WHERE stuknr = S.stuknr
	AND I.instrumentnaam = 'piano'
	)

-- 2.	Geef stuknr en titel voor elk stuk waar géén piano in meespeelt.
SELECT DISTINCT S.stuknr, S.titel 
FROM Stuk S
WHERE NOT EXISTS
	(
	SELECT *
	FROM Instrument I
		INNER JOIN Bezettingsregel B ON B.instrumentnaam = I.instrumentnaam
	WHERE stuknr = S.stuknr
	AND I.instrumentnaam = 'piano'
	)

-- 3.	Geef instrumenten (instrumentnaam + toonhoogte) die niet worden gebruikt.
INSERT INTO Instrument
VALUES ('bongo', '');

DELETE FROM Instrument
WHERE instrumentnaam = 'bongo'

SELECT I.instrumentnaam, I.toonhoogte
FROM Instrument I
WHERE NOT EXISTS
	(
	SELECT * FROM Bezettingsregel B
		INNER JOIN Instrument Ins ON B.instrumentnaam = I.instrumentnaam
	WHERE Ins.instrumentnaam = I.instrumentnaam
	)


-- 4.	Geef componistId en naam van iedere componist die meer dan 1 stuk heeft gecomponeerd.
SELECT C.componistId, C.naam
FROM Componist C
WHERE EXISTS
	(
	SELECT Comp.componistId, COUNT(*)
	FROM Componist Comp
		INNER JOIN Stuk S ON Comp.componistId = S.componistId
	GROUP BY Comp.componistId
	HAVING Comp.componistId = C.componistId
	AND COUNT(*) > 1
	)

-- 5.	Geef alle originele stukken waar geen bewerkingen van zijn.
SELECT *
FROM Stuk S
WHERE NOT EXISTS
	(
	SELECT *
	FROM Stuk St
		INNER JOIN Stuk StukCover ON St.stuknr = StukCover.stuknrOrigineel
	WHERE St.stuknr = S.stuknr
	)

-- 6.	Geef de drie oudste stukken (zonder top te gebruiken).


-- 7.	Is er een stuk waarin alle instrumenten meespelen?
SELECT DISTINCT B.instrumentnaam
FROM Bezettingsregel B

SELECT DISTINCT I.instrumentnaam
FROM Instrument I

-- 8.	(Geen EXISTS) Maak een lijst van stukken, gesorteerd op lengte, en zorg voor een rangnummer (waarbij stukken van gelijke lengte hetzelfde rangnummer krijgen).
SELECT *, RANK() OVER (ORDER BY speelduur) AS rank
FROM Stuk S
ORDER BY S.speelduur ASC

-- 9.	Geef een query voor de volgende informatiebehoefte:
-- Geef geordende paren van stukken die precies dezelfde bezetting hebben. Ook als beide stukken geen bezettingsregels hebben. 
