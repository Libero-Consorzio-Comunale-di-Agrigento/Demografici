--liquibase formatted sql
--changeset amonopoli:202310061035_3 runOnChange:true stripComments:false
create or replace view cermat_filtro
AS 
select mat.*, 'ANS' filtro 
  from civmat mat
 where cod_rec = 5
   and atto > 0 
UNION
select mat.*, 'TUT' filtro 
  from civmat mat
 where cod_rec in (0,3,5) 
   and atto > 0 
   and natura in ('O','T','D') 
   and nvl(flag_certificabile,'S') = 'S'
UNION
select mat.*, 'OTR' filtro 
  from civmat mat
 where cod_rec in (0,3) 
   and atto > 0 
   and natura in ('O','T')     
   and nvl(flag_certificabile,'S') = 'S'
UNION
select mat.*, 'ORI' filtro 
  from civmat mat
 where cod_rec in (0,3) 
   and atto > 0 
   and natura in ('O')         
   and nvl(flag_certificabile,'S') = 'S'
UNION
select mat.*, 'OT0' filtro 
  from civmat mat
 where cod_rec in (0)   
   and atto > 0 
   and natura in ('O','T')     
UNION
select mat.*, 'OR0' filtro 
  from civmat mat
 where cod_rec in (0)   
   and atto > 0 
   and natura in ('O') 
UNION
select mat.*, 'DIV' filtro 
  from civdta dta, civmat mat
 where dta.flag_divorzio = 'S'
   and dta.id            = mat.id_civdta
   and mat.cod_rec       in (0,3) 
   and mat.atto          > 0 
/
comment on table cermat_filtro is 'Certificazione - Atti di Matirmonio con campo Filtro'
/
