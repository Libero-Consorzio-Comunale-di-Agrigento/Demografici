--liquibase formatted sql
--changeset amonopoli:202310061035_4 runOnChange:true stripComments:false
create or replace view cernas_filtro
AS 
select nas.*, 'ANS' filtro 
  from civnas nas
 where cod_rec = 5
   and atto > 0 
UNION
select nas.*, 'TUT' filtro 
  from civnas nas
 where cod_rec in (0,3,5) 
   and atto > 0 
   and natura in ('O','T','D') 
   and nvl(flag_certificabile,'S') = 'S'
UNION
select nas.*, 'OTR' filtro 
  from civnas nas
 where cod_rec in (0,3) 
   and atto > 0 
   and natura in ('O','T')     
   and nvl(flag_certificabile,'S') = 'S'
UNION
select nas.*, 'ORI' filtro 
  from civnas nas
 where cod_rec in (0,3) 
   and atto > 0 
   and natura in ('O')         
   and nvl(flag_certificabile,'S') = 'S'
UNION
select nas.*, 'OT0' filtro 
  from civnas nas
 where cod_rec in (0)   
   and atto > 0 
   and natura in ('O','T')     
UNION
select nas.*, 'OR0' filtro 
  from civnas nas
 where cod_rec in (0)   
   and atto > 0 
   and natura in ('O') 
/
comment on table cernas_filtro is 'Certificazione - Atti di Nascita con campo Filtro'
/
