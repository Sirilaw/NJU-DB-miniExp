-- Active: 1729493413842@@localhost@3306@orderdb
-- 姓名：刘思远
-- 学号：221220067
-- 提交前请确保本次实验独立完成，若有参考请注明并致谢。

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1.1
drop procedure if exists GenerateProductOrder;
delimiter $$
create procedure GenerateProductOrder(in productName Varchar(40))
begin
	select customer.customerNo, customer.customerName, ordermaster.orderNo, orderdetail.quantity, orderdetail.price
	from product, customer, ordermaster, orderdetail
	where  product.productName = productName and product.productNo = orderdetail.productNo and customer.customerNo = ordermaster.customerNo and ordermaster.orderNo = orderdetail.orderNo
    order by orderdetail.price desc;
end$$
delimiter ;
call GenerateProductOrder('32M DRAM');
-- END Q1.1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1.2
drop procedure if exists getEmployeeInfo;
delimiter $$
create procedure getEmployeeInfo(in eeno Char(8))
begin 
select e2.employeeNo, e2.employeeName, e2.gender, e2.hireDate, e2.department
from employee e1, employee e2
where e1.employeeNo = eeno and e2.hireDate < e1.hireDate and e1.department = e2.department;
end$$
delimiter ;
call getEmployeeInfo('E2008005');
-- END Q1.2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2.1
drop function if exists getAvgPrice;
delimiter $$
create function getAvgPrice(goodName Varchar(40)) returns float
deterministic
begin 
declare result float;
select  sum(quantity * price) / sum(quantity) into result
from product, orderdetail, ordermaster
where product.productName = goodName and product.productNo = orderdetail.productNo and ordermaster.orderNo = orderdetail.orderNo
group by product.productName;
return result;
end $$
delimiter ;
select product.productName, getAvgPrice(product.productName) as avgPrice
from product;
-- END Q2.1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2.2
drop function if exists totalSale;
delimiter $$
create function totalSale(productNo Char(9)) returns int
deterministic
begin
declare result int;
select sum(orderdetail.quantity) into result
from product, orderdetail
where product.productNo = productNo and orderdetail.productNo = product.productNo;
return result;
end$$
delimiter ;
select productNo, productName, totalSale(productNo) 
from product
where totalSale(productNo) > 4;
-- END Q2.2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3.1
drop trigger if exists insertSet;
delimiter $$
create trigger insertSet before insert on product for each row
begin 
if new.productPrice > 1000 then 
	set new.productPrice = 1000;
end if;
end $$
delimiter $$
insert product values('E2024001', '1', '内存', '999');
insert product values('E2024002', '2', '存储器', '1001');
select * from product where productNo like 'E2024%';
delete from product where productNo like 'E2024%';
-- END Q3.1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3.2
drop trigger if exists salaryUpdate;
delimiter $$
create trigger salaryUpdate before insert on ordermaster for each row
begin
declare preSalary float;
set preSalary = (select employee.salary from employee where employeeNo = new.employeeNo);
if (select hireDate from employee where employeeNo = new.employeeNo) < '19920101' then
	update employee set salary = preSalary * 1.05 * 1.03 where employeeNo = new.employeeNo;
else 
	update employee set salary = preSalary * 1.05 where employeeNo = new.employeeNo;
end if;
end $$
delimiter ;
insert Employee values('E2024001','哈登','M','19921001','111',null,  '20241125','业务科','职员',5000);
insert Employee values('E2024002','威少','M','19911001','222',null,  '19911231','财务科','会计',5000);
insert OrderMaster values('20240001','C20060002','E2024001','20241126',0.00,'1');
insert OrderMaster values('20240002','C20050001','E2024002','20241126',0.00,'2');
select employeeNo, hireDate, salary
from employee
where employeeNo like 'E2024%';
SET FOREIGN_KEY_CHECKS = 0;
delete from employee where employeeNo like 'E2024%';
SET FOREIGN_KEY_CHECKS = 1;
delete from ordermaster where orderNo like '2024%';
-- END Q3.2


