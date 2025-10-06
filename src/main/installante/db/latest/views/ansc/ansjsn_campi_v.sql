--liquibase formatted sql
--changeset amonopoli:202306291245 runAlways:true runOnChange:true stripComments:false
create or replace view ansjsn_campi_v
AS
select f_ANSC_get_albero_JSN(jsn_s.id,'') albero_sezione,
       f_ANSC_get_albero_JSN('',jsn_c.id) albero_campo,
       jsn_c.*,
       jsn_s.livello livello_sezione,
       jsn_s.id_padre id_padre_sezione,
       jsn_s.sequenza sequenza_sezione,
       jsn_s.sezione campo_sezione,
       jsn_s.campo_db campo_db_sezione,
       jsn_s.vista_db vista_db_sezione,
       jsn_s.servizio,
       jsn_s.tipo_atto,
       jsn_s.usecase
  from ansjsn_campi jsn_c
     , ansjsn_sezioni jsn_s
 where jsn_c.id_sezione (+) = jsn_s.id 
/
comment on table ansjsn_campi_v is 'ANSC - Configurazione Campi per richieste JSON (view)'
/
