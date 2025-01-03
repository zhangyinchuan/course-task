-----------------------------------------------------------------------------------------
--建表
create table users
(
    ID char(10) constraint PK_users primary key,
    Uname char(10) not null,
    Password char(10) not null
);

create table Customer
(
    Cno int constraint PK_Customer primary key,
    Cname nvarchar(20) not null,
    Csex nvarchar(8),
    Ctel int not null,
    Cadds nvarchar(50) not null,
    Ccard nvarchar(20) not null
);

create table Business
(
    Bno int constraint PK_Business primary key,
    Bname nvarchar(20) not null,
    Btel int not null,
    Badds nvarchar(50)
);

create table Staff
(
    Sno int constraint PK_Staff primary key, 
    Sname nvarchar(20) not null,
    Ssex nvarchar(8),
    Stel int not null,
    Scard nvarchar(20) not null
);

create table Goods
(
    Gno int constraint PK_Goods primary key,
    Gname nvarchar(20),
    Gtype nvarchar(40),
    Gweight nvarchar(20) not null,
    Gprice nvarchar(100) not null
);

create table Send
(
    Seno int constraint PK_Send primary key,
    Sno int constraint FK_Send1 foreign key references Staff(Sno),
    Bno int constraint FK_Send2 foreign key references Business(Bno),
    Cno int constraint FK_Send3 foreign key references Customer(Cno),
    Gno int constraint FK_Send4 foreign key references Goods(Gno),
    sitime datetime not null,
    sotime datetime not null,
    setype nvarchar(20) not null
);

drop table if exists Customer;
drop table if exists Business;
drop table if exists Staff;
drop table if exists Goods;
drop table if exists Send;
----------------------------------------------------------------------------------------
--增加约束
--唯一约束
alter table Customer
add constraint UQ_Customer1 unique(Ccard);

alter table Customer
add constraint UQ_Customer2 unique(Ctel);

alter table Staff
add constraint UQ_Staff1 unique(Scard);

alter table Staff
add constraint UQ_Staff2 unique(Stel);

alter table Business
add constraint UQ_Business1 unique(Btel);

--默认约束
alter table Customer
add constraint DF_Customer1 default('男') for Csex;

alter table Staff
add constraint DF_Staff1 default('男') for Ssex;

alter table Goods
add constraint DF_Goods1 default('隐私货物') for Gname;

alter table Goods
add constraint DF_Goods2 default('隐私货物') for Gtype;

--check 约束
alter table Customer
add constraint CK_Customer1 check(Csex in('男','女'));

alter table Staff
add constraint CK_Staff check(Ssex in('男','女'));

alter table Customer
add constraint CK_Customer2 check(Ctel between 1000000 and 999999999);

alter table Business
add constraint CK_Business1 check(Btel between 1000000 and 999999999);

alter table Staff
add constraint CK_Staff1 check(Stel between 1000000 and 999999999);

alter table Goods
add constraint CK_Goods1 check(Gweight between 1 and 1000);

alter table Customer
add constraint CK_Customer3 check(Cno between 1001 and 1999);

alter table Customer
drop constraint CK_Customer2; 

alter table Business
drop constraint CK_Business1; 

alter table Staff
drop constraint CK_Staff1;

----------------------------------------------------------------------------------------
--建立视图
--视图一客户查询
create view st_1
as
select Seno, Cname, Gname, Bname, Btel, Badds, Sname, Stel, setype, sitime, sotime 
from Business, Customer, Goods, Send, Staff 
where Staff.Sno = Send.Sno and
       Send.Bno = Business.Bno and
       Send.Cno = Customer.Cno and
       Send.Gno = Goods.Gno;
        
--视图二快递员查询
create view st_2
as
select seno, Bname, Btel, Cname, Ctel, Cadds
from Send
    join Business on send.Bno = Business.Bno
    join Customer on Send.Cno = Customer.Cno;
     
select * from st_2;

drop view if exists st_2;
----------------------------------------------------------------------------------------
--建立存储过程
--客户查询
create procedure PD_1
 @seno int
 as
 select Seno, Cname, Gname, Bname, Btel, Badds, Sname, Stel, setype, sitime, sotime
 from Business, Customer, Goods, Send, Staff
 where Staff.Sno = Send.Sno and
       Send.Bno = Business.Bno and
       Send.Cno = Customer.Cno and
       Send.Gno = Goods.Gno;
      
execute PD_1 '5001';

--快递员查询
create procedure PD_2
@seno int
as
select seno, Bname, Btel, Cname, Ctel, Cadds
from Send
    join Business on send.Bno = Business.Bno
    join Customer on Send.Cno = Customer.Cno;
     
execute PD_2 '5001';
----------------------------------------------------------------------------------------
--建立触发器
create trigger TG_1
on Staff
for insert 
as
if ((select count(Sno) from Staff) >= 1000)
begin
    -- Action to be taken when the condition is met
end;

----------------------------------------------------------------------------------------
--插入数据

insert into Customer (Cno, Cname, Csex, Ctel, Cadds, Ccard)
values ('1001', '周后金', '男', '1563464', '江西省南昌市', '6483564674643'),
       ('1002', '李佛', '男', '1896464', '美利坚合众国', '8943165464416'),
       ('1003', '白莲', '女', '1523684', '湖北省孝感市', '7853564874643');
       
insert into Business (Bno, Bname, Btel, Badds)
values ('2001', '三只河马', '6546541', '陕西省西安市'),
       ('2002', '山鸡', '2643548', '北京市'),
       ('2003', '森码', '3168578', '内蒙古自治区');
       
insert into Staff (Sno, Sname, Ssex, Stel, Scard)
values ('3001', '马印九', '男', '5464674', '674641654647'),
       ('3002', '李老八', '男', '5863674', '674616824686'),
       ('3003', '鞠魔战', '男', '6824674', '924566654646');
       
insert into Goods (Gno, Gname, Gtype, Gweight, Gprice)
values ('4001', '娃娃', '玩具', '10', '50'),
       ('4002', '三鹿奶粉', '食物', '1', '1000'),
       ('4003', '袜子', '衣物', '2', '20'),
       ('4004', '数据库系统概论', '书', '1', '35');
       
insert into Send (Seno, Bno, Sno, Cno, sitime, sotime, setype)
values ('5001', '2002', '3003', '1001', '2019/11/11', '2019/11/20', '由真快递'),
       ('5002', '2001', '3002', '1003', '2019/11/11', '2019/11/12', '动蜂快递'),
       ('5003', '2003', '3001', '1002', '2019/11/11', '2019/11/14', '原桶快递');
       
select * from st_2;
