--liquibase formatted sql
--changeset amonopoli:202511030835_2 runOnChange:true stripComments:false
delete anpt42
/
-- 0 - NON CERTIFICABILE
-- 1 - CERTIFICABILITA PARZIALE (SOLO RESIDENZA E STATO DI FAMIGLIA)
-- 2 - CERTIFICABILITA COMPLETA
-- 3 - SOGGETTO NON ISCRIVIBILE
-- 4 - INTERDETTO SOTTOPOSTO A TUTELA
insert into anpt42 (codice, descrizione)
values ('0', 'NON CERTIFICABILE')
/
insert into anpt42 (codice, descrizione)
values ('1', 'CERTIFICABILITA PARZIALE (SOLO RESIDENZA E STATO DI FAMIGLIA)')
/
insert into anpt42 (codice, descrizione)
values ('2', 'CERTIFICABILITA COMPLETA')
/
insert into anpt42 (codice, descrizione)
values ('3', 'SOGGETTO NON ISCRIVIBILE')
/
insert into anpt42 (codice, descrizione)
values ('4', 'INTERDETTO SOTTOPOSTO A TUTELA')
/
