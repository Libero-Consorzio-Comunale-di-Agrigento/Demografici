--liquibase formatted sql
--changeset amonopoli:202310061035_2 runOnChange:true stripComments:false
create or replace view ceruci_filtro
AS 
select uci.*, 'ANS' filtro 
  from civuci uci
 where cod_rec = 5 
   and atto > 0 
UNION
select uci.*, 'TUT' filtro 
  from civuci uci
 where cod_rec in (0,3,5) 
   and atto > 0 
   and natura in ('O','T','D') 
   and nvl(flag_certificabile,'S') = 'S'
UNION
select uci.*, 'OTR' filtro 
  from civuci uci
 where cod_rec in (0,3) 
   and atto > 0 
   and natura in ('O','T')     
   and nvl(flag_certificabile,'S') = 'S'
UNION
select uci.*, 'ORI' filtro 
  from civuci uci
 where cod_rec in (0,3) 
   and atto > 0 
   and natura in ('O')         
   and nvl(flag_certificabile,'S') = 'S'
UNION
select uci.*, 'OT0' filtro 
  from civuci uci
 where cod_rec in (0)   
   and atto > 0 
   and natura in ('O','T')     
UNION
select uci.*, 'OR0' filtro 
  from civuci uci
 where cod_rec in (0)   
   and atto > 0 
   and natura in ('O') 
UNION
select uci.*, 'DIV' filtro 
  from civdta dta, civuci uci
 where dta.flag_divorzio = 'S'
   and dta.id            = uci.id_civdta
   and uci.cod_rec       in (0,3) 
   and uci.atto          > 0 
/
comment on table ceruci_filtro is 'Certificazione - Atti di Unione Civile con campo Filtro'
/
