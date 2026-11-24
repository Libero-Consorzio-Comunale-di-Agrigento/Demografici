--liquibase formatted sql
--changeset amonopoli:202410231430 runAlways:true runOnChange:true stripComments:false
create or replace view cerdce_v
AS
select dce.*
     , f_CER_descrizione_estesa_dce(dce.descrizione)
         ||' ['||dce.cod_certificato||']' descrizione_estesa
     , decode(dce.competenza, 'SC', decode(dce.codice_anpr, 'S1', 1, 'S6', 1, 'S2', 2, 'S7', 2, 'S3', 3, 'S4', 3)) tipo_certificato_ansc
  from cerdce dce
/
comment on table cerdce_v is 'Certificazione - Certificati (view)'
/
