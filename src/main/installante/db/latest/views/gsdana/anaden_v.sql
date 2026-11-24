--liquibase formatted sql
--changeset amonopoli:202511031225 runAlways:true runOnChange:true stripComments:false
create or replace view anaden_v
as 
select den.*
-- des_com_ente
     , f_comune_al(den.COD_PRO_ENTE,den.COD_COM_ENTE,'') des_com_ente
-- sigla_pro_ente
     , f_provincia_stato_al(den.COD_PRO_ENTE,den.COD_COM_ENTE,'','S','','') sigla_pro_ente
--
     , f_PROT_tipo_ente(den.sigla) tipo_ente
  from anaden den
/
comment on table anaden_v is 'Anagrafe - Dizionario Enti (view)'
/
