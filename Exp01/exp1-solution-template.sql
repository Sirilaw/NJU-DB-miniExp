-- 姓名：刘思远
-- 学号：221220067
-- 提交前请确保本次实验独立完成，若有参考请注明并致谢。

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1
SELECT COUNT(*) As speciesCount FROM species
    WHERE description LIKE "%this%";
-- END Q1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2
SELECT pl.username AS username, SUM(ph.power) AS totalPhonemonPower
FROM player pl, phonemon ph
WHERE pl.id = ph.player AND pl.username in ('Cook', 'Hughes')
GROUP BY pl.username;
-- END Q2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3
SELECT team.title, COUNT(*) AS numberOfPlayers 
FROM team, player
WHERE team.id = player.team
GROUP BY team.id
ORDER BY numberOfPlayers DESC
-- END Q3

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4
SELECT sp.id AS idSpecies, sp.title
FROM species sp, type t
WHERE (sp.type1 = t.id AND t.title = 'Grass') OR (sp.type2 = t.id AND t.title = 'Grass')
-- END Q4

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5
SELECT pl.id AS idPlayer, pl.username AS username
FROM player pl
WHERE pl.id NOT IN (
    SELECT DISTINCT pur.player
    FROM purchase pur
    WHERE pur.item IN (
        SELECT item.id 
        FROM item
        WHERE type = 'F'
    )
)
-- END Q5

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6
SELECT level, SUM(purchase.quantity * (item.price)) AS totalAmountSpentByAllPlayersAtLevel
FROM purchase, item, player
WHERE purchase.item = item.id AND player.id = purchase.player
GROUP BY player.level
ORDER BY totalAmountSpentByAllPlayersAtLevel DESC
-- END Q6

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7
SELECT item.id AS item, title AS title, COUNT(purchase.id) AS numTimesPurchased
FROM item, purchase
WHERE purchase.item = item.id
GROUP BY item.id
HAVING COUNT(purchase.id) = (
    SELECT MAX(itemCount)
    FROM (
        SELECT COUNT(p.id) AS itemCount
        FROM purchase p 
        GROUP BY p.item
    ) AS PurchaseCounts
)
-- END Q7

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8
SELECT pl.id AS playerID, username, COUNT(DISTINCT it.id) AS numberDistinctFoodItemsPurchased
FROM player pl, purchase pu, item it
WHERE pl.id = pu.player AND it.type = 'F' AND it.id = pu.item
GROUP BY pl.id
HAVING numberDistinctFoodItemsPurchased = (
    SELECT COUNT(item2.id) 
    FROM item item2
    WHERE item2.type = 'F'
);
-- END Q8

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9
SELECT COUNT(*) AS numberOfPhonemonPairs, distanceX
FROM (
    SELECT ROUND(SQRT(POW(ph1.latitude - ph2.latitude, 2) + POW(ph1.longitude - ph2.longitude, 2))*100, 2) AS distanceX
    FROM phonemon ph1, phonemon ph2
    WHERE ph1.id > ph2.id 
) AS distances
WHERE distanceX = (
    SELECT MIN(ROUND(SQRT(POW(ph1.latitude - ph2.latitude, 2) + POW(ph1.longitude - ph2.longitude, 2))*100, 2))
    FROM phonemon ph1, phonemon ph2
    WHERE ph1.id > ph2.id
);
-- END Q9

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10
SELECT player.username AS username, type.title AS typeTitle
FROM player, phonemon, type, species
WHERE player.id = phonemon.player AND phonemon.species = species.id AND (species.type1 = type.id OR species.type2 = type.id)
GROUP BY player.id, type.id
HAVING COUNT(DISTINCT species.id) = ALL(
    SELECT COUNT(*)
    FROM species, type
    WHERE (species.type1 = type.id OR species.type2 = type.id) AND type.title = typeTitle
)
-- END Q10
