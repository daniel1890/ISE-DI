-- 1.	Geef voor alle stukken het stuknr en de speelduur, als de speelduur onbekend is moet hiervoor een 0 getoond worden.
SELECT S.stuknr, ISNULL(S.speelduur, 0) AS speelduur
FROM Stuk S

-- 2.	Geef voor alle stukken het stuknr en de speelduur gesorteerd op speelduur aflopend. Alle stukken waarvoor de speelduur onbekend is (dus NULL) moeten als eerste getoond worden.
SELECT S.stuknr, S.speelduur
FROM Stuk S
ORDER BY ISNULL(S.speelduur, 1) ASC, S.speelduur ASC