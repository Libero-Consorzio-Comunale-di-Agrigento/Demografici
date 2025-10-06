--liquibase formatted sql
--changeset snocca:202309271659 runOnChange:true stripComments:false
update civdta dta set flag_pregresso = 'S' 
 where dta.tipo_atto = 2 
   and dta.id_civcta in (select cta.id from civcta cta where cta.tipo_atto = dta.tipo_atto and cta.flag_pregresso = 'S');
   
update civdta dta set flag_pregresso = 'S' 
 where dta.tipo_atto = 5 
   and dta.id_civcta in (select cta.id from civcta cta where cta.tipo_atto = dta.tipo_atto and cta.flag_pregresso = 'S');   