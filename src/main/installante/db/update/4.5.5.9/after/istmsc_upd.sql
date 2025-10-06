--liquibase formatted sql
--changeset amonopoli:202303031640 runOnChange:true stripComments:false
update istmsc
   set sesso_fg_1 = decode(sesso_fg_1,'M',1,'F','2')
 where sesso_fg_1 in ('M','F')
/
update istmsc
   set sesso_fg_2 = decode(sesso_fg_2,'M',1,'F','2')
 where sesso_fg_2 in ('M','F')
/
update istmsc
   set sesso_fg_3 = decode(sesso_fg_3,'M',1,'F','2')
 where sesso_fg_3 in ('M','F')
/
update istmsc
   set sesso_fg_4 = decode(sesso_fg_4,'M',1,'F','2')
 where sesso_fg_4 in ('M','F')
/
update istmsc
   set sesso_fg_5 = decode(sesso_fg_5,'M',1,'F','2')
 where sesso_fg_5 in ('M','F')
/
