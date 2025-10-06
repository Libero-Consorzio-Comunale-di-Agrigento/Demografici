--liquibase formatted sql
--changeset amonopoli:202410231430 runAlways:true runOnChange:true stripComments:false
create or replace view cerdce_v
AS
select dce.*
     , f_CER_descrizione_estesa_dce(dce.descrizione)
         ||' ['||dce.cod_certificato||']' descrizione_estesa
  from cerdce dce
/
comment on table cerdce_v is 'Certificazione - Certificati (view)'
/
