-- A. Geef van het oudste stuk/stukken het stuk/stukken met de meeste bezettingsregels? Toon stuknr, titel, jaartal en aantal bezettingsregels. 
WITH OudsteStukken_CTE AS (
SELECT S.stuknr, S.titel, S.jaartal, COUNT(*) AS AantalBezettingsRegels
FROM Stuk S
	LEFT OUTER JOIN Bezettingsregel B ON S.stuknr = B.stuknr
WHERE S.jaartal = (SELECT MIN(jaartal) FROM Stuk)
GROUP BY S.stuknr, S.titel, S.jaartal
)

SELECT A_CTE.stuknr, A_CTE.titel, A_CTE.jaartal, A_CTE.AantalBezettingsRegels
FROM OudsteStukken_CTE A_CTE
WHERE A_CTE.AantalBezettingsRegels >= ALL(SELECT AantalBezettingsRegels FROM OudsteStukken_CTE)

-- B. Geef alle stukken die evenveel bezettingsregels hebben als deze oudste stuk/stukken met de meeste bezettingsregels.
WITH AlleStukken_CTE AS (
SELECT S.stuknr, S.titel, S.jaartal, COUNT(*) AS AantalBezettingsRegels
FROM Stuk S
	LEFT OUTER JOIN Bezettingsregel B ON S.stuknr = B.stuknr
GROUP BY S.stuknr, S.titel, S.jaartal
),
OudsteStukkenTwee_CTE AS (
SELECT S.stuknr, S.titel, S.jaartal, COUNT(*) AS AantalBezettingsRegels
FROM Stuk S
	LEFT OUTER JOIN Bezettingsregel B ON S.stuknr = B.stuknr
WHERE S.jaartal = (SELECT MIN(jaartal) FROM Stuk)
GROUP BY S.stuknr, S.titel, S.jaartal
)

SELECT * FROM AlleStukken_CTE A_CTE
WHERE A_CTE.AantalBezettingsRegels = (SELECT MAX(AantalBezettingsRegels) FROM OudsteStukkenTwee_CTE)