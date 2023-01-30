-- 1.	Geef voor elk klassiek stuk het stuknr, de titel en de naam van de componist.

SELECT S.stuknr, S.titel, C.naam
FROM Stuk S
LEFT OUTER JOIN Componist C
ON S.componistId = C.componistId
WHERE S.genrenaam = 'klassiek'

-- 2.	Welke stukken zijn gecomponeerd door een muziekschooldocent? Geef van de betreffende stukken het stuknr, de titel, de naam van de componist en de naam van de muziekschool.

SELECT S.stuknr, S.titel, C.naam, M.naam
FROM Stuk S
LEFT OUTER JOIN Componist C
ON S.componistId = C.componistId
LEFT OUTER JOIN Muziekschool M
ON C.schoolId = M.schoolId
WHERE C.schoolId IS NOT NULL

-- 3.	Bij welke stukken (geef stuknr en titel) bestaat de bezetting uit ondermeer een saxofoon?  Opmerking: Gebruik een subquery.

SELECT S.stuknr, S.titel 
FROM Stuk S
WHERE S.stuknr IN 
(
SELECT B.stuknr FROM
Bezettingsregel B
WHERE B.instrumentnaam = 'saxofoon'
)

-- 4.	Bij welke stukken wordt de saxofoon niet gebruikt?

SELECT S.stuknr, S.titel 
FROM Stuk S
WHERE S.stuknr NOT IN 
(
SELECT B.stuknr FROM
Bezettingsregel B
WHERE B.instrumentnaam = 'saxofoon'
)

-- 5.	Bij welke jazzstukken worden twee of meer verschillende instrumenten gebruikt?

SELECT *
FROM Stuk S
WHERE S.genrenaam = 'jazz'
AND S.stuknr IN
(
SELECT COUNT(*) AS AantalInstrumenten FROM
Bezettingsregel B
GROUP BY B.stuknr
HAVING COUNT(*) > 0
)

-- 6.	Geef het aantal originele muziekstukken per componist. Ook componisten met nul originele stukken dienen te worden getoond.

SELECT C.naam, C.componistId, COUNT(*) AS AantalMuziekstukken FROM
Componist C
LEFT OUTER JOIN
Stuk S
ON C.componistId = S.componistId
GROUP BY C.naam, C.componistId
