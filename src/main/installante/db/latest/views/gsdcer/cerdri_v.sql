--liquibase formatted sql
--changeset amonopoli:202410231435 runAlways:true runOnChange:true stripComments:false
create or replace view cerdri_v
AS
select dri.*
     , rtrim(dri.descrizione_1||' '||dri.descrizione_2)||' ['||dri.cod_ri||']' descrizione_estesa
     , rtrim(dri.descr_stampa_1||' '||dri.descr_stampa_2) descr_stampa_estesa
     , ctc.sigla sigla_categoria
  from cerctc ctc
     , cerdri dri
 where ctc.id (+) = dri.id_cerctc
/
comment on table cerdri_v is 'Certificazione - Modalità di Rilascio (view)'
/
