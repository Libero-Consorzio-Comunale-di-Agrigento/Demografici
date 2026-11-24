--liquibase formatted sql
--changeset amonopoli:202310061035_1 runOnChange:true stripComments:false
create or replace view cermor_filtro
AS 
select mor.*, 'ANS' filtro 
  from civmor mor
 where cod_rec = 5
   and atto > 0 
UNION
select mor.*, 'TUT' filtro 
  from civmor mor
 where cod_rec in (0,3,5) 
   and atto > 0 
   and natura in ('O','T','D') 
   and nvl(flag_certificabile,'S') = 'S'
UNION
select mor.*, 'OTR' filtro 
  from civmor mor
 where cod_rec in (0,3) 
   and atto > 0 
   and natura in ('O','T')     
   and nvl(flag_certificabile,'S') = 'S'
UNION
select mor.*, 'ORI' filtro 
  from civmor mor
 where cod_rec in (0,3) 
   and atto > 0 
   and natura in ('O')         
   and nvl(flag_certificabile,'S') = 'S'
UNION
select mor.*, 'OT0' filtro 
  from civmor mor
 where cod_rec in (0)   
   and atto > 0 
   and natura in ('O','T')     
UNION
select mor.*, 'OR0' filtro 
  from civmor mor
 where cod_rec in (0)   
   and atto > 0 
   and natura in ('O') 
/
comment on table cermor_filtro is 'Certificazione - Atti di Morte con campo Filtro'
/
