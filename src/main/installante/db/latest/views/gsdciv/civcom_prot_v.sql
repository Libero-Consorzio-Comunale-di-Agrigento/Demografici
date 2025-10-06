--liquibase formatted sql
--changeset amonopoli:202503311610 runOnChange:true stripComments:false
create or replace view civcom_prot_v
AS
select com_p.*
     , f_PROT_oggetto('CIVCOM',com_p.id,'INFO') oggetto_info
  from civcom_prot com_p
/
COMMENT ON TABLE civcom_prot_v IS 'Stato Civile - Comunicazioni da protocollare (view)'
/
 