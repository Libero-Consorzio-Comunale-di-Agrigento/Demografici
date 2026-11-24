--liquibase formatted sql
--changeset amonopoli:202606111625 runAlways:true runOnChange:true stripComments:false
create or replace view anacom_prot_v
AS
select com_p.*
     , f_PROT_oggetto('ANACOM',com_p.id,'INFO') oggetto_info
  from anacom_prot com_p
/
COMMENT ON TABLE anacom_prot_v IS 'Anagrafe - Comunicazioni da protocollare (view)'
/
