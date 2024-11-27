# 《数据库概论》实验一：用SQL进行数据操作 实验报告

姓名：刘思远	学号：221220067	联系方式：480469140@qq.com

## 实验环境

操作系统为Windows 11，软件版本为mysql-community-8.0.26.0

## 实验过程

**1.使用模式匹配即可表达出符合要求的`description`**

SQL语句：

```sql
SELECT COUNT(*) As speciesCount FROM species
    WHERE description LIKE "%this%";
```

![image-20241022142741644](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022142741644.png)

**2.将`player`和`phonemon`两个表进行自然连接，筛选出username是`Cook`或`Hughes`的元组，然后按照`username`分组即可计算出总能量**

SQL语句：

```sql
SELECT pl.username AS username, SUM(ph.power) AS totalPhonemonPower
FROM player pl, phonemon ph
WHERE pl.id = ph.player AND pl.username in ('Cook', 'Hughes')
GROUP BY pl.username;
```

![image-20241022142806178](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022142806178.png)

**3.将team和player表自然连接，连接后按照team.id分组，运用`COUNT(*)`计算即可**

SQL语句：

```sql
SELECT team.title, COUNT(*) AS numberOfPlayers 
FROM team, player
WHERE team.id = player.team
GROUP BY team.id
ORDER BY numberOfPlayers DESC
```

![image-20241022142821032](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022142821032.png)

**4.将`species`和`type`表格自然连接，然后进行筛选即可**

SQL语句：

```sql
SELECT sp.id AS idSpecies, sp.title
FROM species sp, type t
WHERE (sp.type1 = t.id AND t.title = 'Grass') OR (sp.type2 = t.id AND t.title = 'Grass')
```

![image-20241022142839189](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022142839189.png)

**5.即找不在买过食物的玩家列表里的玩家，使用`NOT IN`结构即可**

SQL语句：

```sql
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
```

![image-20241022142901282](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022142901282.png)

**6.将player、purchase和item自然连接即可，根据level进行分组，并使用`SUM`函数计算金额总和**

SQL语句：

```sql
SELECT level, SUM(purchase.quantity * (item.price)) AS totalAmountSpentByAllPlayersAtLevel
FROM purchase, item, player
WHERE purchase.item = item.id AND player.id = purchase.player
GROUP BY player.level
ORDER BY totalAmountSpentByAllPlayersAtLevel DESC
```

![image-20241022142914399](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022142914399.png)

**7.首先把purchase和item表格自然连接，然后按照item.id分组，计算每组有几个purchase条目，然后把等于最大的筛选出来**

SQL语句：

```sql
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
```

![image-20241022142929682](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022142929682.png)

**8.把purchase、player、item表格自然连接起来，然后按照player.id分组，找到组内`DISTINCT item.id`的总数等于食物种类数的**

SQL语句：

```sql
SELECT pl.id AS playerID, username, COUNT(DISTINCT it.id) AS numberDistinctFoodItemsPurchased
FROM player pl, purchase pu, item it
WHERE pl.id = pu.player AND it.type = 'F' AND it.id = pu.item
GROUP BY pl.id
HAVING numberDistinctFoodItemsPurchased = (
    SELECT COUNT(item2.id) 
    FROM item item2
    WHERE item2.type = 'F'
);
```

![image-20241022142949497](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022142949497.png)

**9.将两个phonemon表格自然连接，为确保配对不重复，使用ph1.id < ph2.id来进行去重。选择欧式距离等于最小距离的即可**

SQL语句：

```sql
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
```

![image-20241022143003788](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022143003788.png)

**10.将player、phonemon、type和species表格自然连接，按照`player.id`和`type.id`分组，从中选出`DISTINCT species.id`数量等于相应type总species数量的组即可**

SQL语句：

```sql
SELECT player.username AS username, type.title AS typeTitle
FROM player, phonemon, type, species
WHERE player.id = phonemon.player AND phonemon.species = species.id AND (species.type1 = type.id OR species.type2 = type.id)
GROUP BY player.id, type.id
HAVING COUNT(DISTINCT species.id) = ALL(
    SELECT COUNT(*)
    FROM species, type
    WHERE (species.type1 = type.id OR species.type2 = type.id) AND type.title = typeTitle
)
```

![image-20241022143017126](C:\Users\syliu\AppData\Roaming\Typora\typora-user-images\image-20241022143017126.png)

## 实验中遇到的困难及解决办法

1. 在写第10题的时候，总是输出不了结果。经检查发现，在HAVING子句里面，忘记限制了COUNT的部分只能是`type.title`等于分组的`title`。

2. “可获取的食物”这一说法及其完整题干确实有点表意不清，即使说明之后也有点让人捉摸不透，希望以后手册的表述可以更加语义明确一点~

   



