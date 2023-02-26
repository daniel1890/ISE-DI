-- A.	Geef de lijst met hardloopsters uit de ALL-TIME highscore en geef ze een rangnummer gebaseerd op de gelopen tijd.
SELECT *, RANK() OVER (ORDER BY result ASC) AS Rangnummer
FROM ALL_TIME_OUTDOOR_TOP_LIST
ORDER BY result ASC

-- B.	Geef de lijst met hardloopsters uit de ALL-TIME highscore en geef voor iedere hardloopster het verschil met de snelste tijd weer. De output moet er ls volgt uitzien:
-- RESULT	NAME	DIFF
-- 21.34	Florence GRIFFITH-JOYNER (USA)	0.00
-- 21.62	Marion JONES (USA)	0.28
-- 21.63	Dafne SCHIPPERS (NED)	0.29
-- 21.64	Merlene OTTEY (JAM)	0.30
-- 21.66	Elaine THOMPSON (JAM)	0.32
-- 21.69	Allyson FELIX (USA)	0.35
-- 21.71	Heike DRECHSLER (GDR)	0.37
-- 21.71	Marita KOCH (GDR)	0.37
-- 21.72	Grace JACKSON (JAM)	0.38
-- 21.72	Gwen TORRENCE (USA)	0.38
SELECT *, CAST(result AS decimal(10,2)) - FIRST_VALUE(CAST(result AS decimal(10,2))) OVER (ORDER BY result ASC) AS DIFF
FROM ALL_TIME_OUTDOOR_TOP_LIST
ORDER BY result ASC

-- C.	Geef de lijst met hardloopsters uit de ALL-TIME highscore en geef voor iedere hardloopster het verschil in tijd met de vorige hardloopster weer. De output moet er ls volgt uitzien:
-- RESULT	NAME	DIFF
-- 21.34	Florence GRIFFITH-JOYNER (USA)	NULL
-- 21.62	Marion JONES (USA)	0.28
-- 21.63	Dafne SCHIPPERS (NED)	0.01
-- 21.64	Merlene OTTEY (JAM)	0.01
-- 21.66	Elaine THOMPSON (JAM)	0.02
-- 21.69	Allyson FELIX (USA)	0.03
-- 21.71	Heike DRECHSLER (GDR)	0.02
-- 21.71	Marita KOCH (GDR)	0.00
-- 21.72	Grace JACKSON (JAM)	0.01
-- 21.72	Gwen TORRENCE (USA)	0.00
SELECT *, CAST(result AS decimal(10,2)) - CAST(LAG(result, 1) OVER (ORDER BY result) AS decimal(10,2)) AS DIFF
FROM ALL_TIME_OUTDOOR_TOP_LIST
ORDER BY result ASC