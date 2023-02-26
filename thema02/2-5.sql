-- A.	Geef een lijst met alle bekende hardloopsters.
SELECT ATOTL.NAME
FROM ALL_TIME_OUTDOOR_TOP_LIST ATOTL
UNION
SELECT SOTL.NAME
FROM SEASON_OUTDOOR_TOP_LIST SOTL

-- B.	Welke hardloopsters staan in de ALL-TIME highscore maar hebben die tijd niet dit seizoen gelopen?
SELECT ATOTL.NAME
FROM ALL_TIME_OUTDOOR_TOP_LIST ATOTL
EXCEPT
SELECT SOTL.NAME
FROM SEASON_OUTDOOR_TOP_LIST SOTL

-- C.	Welke hardloopsters hebben dit seizoen een tijd gelopen waardoor ze in de ALL-TIME highscore lijst zijn gekomen? (veronderstel dat ze deze tijd maar 1 keer hebben gelopen).
SELECT ATOTL.NAME
FROM ALL_TIME_OUTDOOR_TOP_LIST ATOTL
INTERSECT
SELECT SOTL.NAME
FROM SEASON_OUTDOOR_TOP_LIST SOTL

-- D.	Welke hardloopsters staan maar in 1 van beide lijsten?

