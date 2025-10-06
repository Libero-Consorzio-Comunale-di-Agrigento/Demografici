--liquibase formatted sql
--changeset vmigliore:202411281638 runOnChange:true stripComments:false
create or replace view CIVCTA_V as
select cta.*
     , cta.descrizione || decode(dta_v.flag_ansc, '', ' [NON USATO IN ANSC]') descrizione_estesa
     , dta_v.flag_ansc                                                        flag_ansc
from (select distinct id_civcta, flag_ansc from civdta where flag_ansc = 'S') dta_v
   , civcta cta
where dta_v.id_civcta (+) = cta.id
/
comment on table CIVCTA_V is 'Stato Civile - Categorie Tipo di Atto (view)'
/
