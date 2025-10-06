--liquibase formatted sql
--changeset amonopoli:202411060945 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW CERDDC_v
AS 
SELECT ddc.*
  from cerddc ddc
/
comment on table cerddc_v is 'Certificazione - Dizionario Diritti Per Certificato (view)'
/
