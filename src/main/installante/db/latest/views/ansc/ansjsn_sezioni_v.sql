--liquibase formatted sql
--changeset amonopoli:202304261741_2 runAlways:true runOnChange:true stripComments:false
create or replace view ansjsn_sezioni_v
AS
select jsn_s.*,
       f_ANSC_flag_esiste_campo_jsn(jsn_s.id) flag_esiste_campo,
       nvl(jsn_s.servizio,'XXXX')||nvl(jsn_s.tipo_atto,0)||lpad(nvl(jsn_s.usecase,0),10,'0') id_lista
  from ansjsn_sezioni jsn_s
 where nvl(servizio,'XXXX') != 'R013'
UNION
select jsn_s.*,
       f_ANSC_flag_esiste_campo_jsn(jsn_s.id) flag_esiste_campo,
       nvl(jsn_s.servizio,'XXXX')||nvl(jsn_s.tipo_atto,0)||lpad(nvl(jsn_s.usecase,0),10,'0') id_lista
  from ansjsn_sezioni jsn_s
 where nvl(servizio,'XXXX') = 'R013'
   and nvl(usecase,0) = 0
UNION
select jsn_s.ID
     , 'R013' servizio
     , jsn_s.TIPO_ATTO
     , decode(jsn_s.SEZIONE,'evento','eventoModificato',jsn_s.sezione) sezione
     , jsn_s.LIVELLO
     , jsn_s.SEQUENZA
     , jsn_s.ID_PADRE
     , jsn_s.FLAG_ARRAY
     , jsn_s.VISTA_DB
     , decode(jsn_s.PARAMETRO_VISTA_DB,'idRif','pkAtto',jsn_s.parametro_vista_db) parametro_vista_db
     , jsn_s.CAMPO_DB
     , jsn_s.FLAG_OTP_FIRMA
     , jsn_s.USECASES_ESCLUSI
     , jsn_s.USECASE                
     , f_ANSC_flag_esiste_campo_jsn(jsn_s.id) flag_esiste_campo
     , nvl(jsn_s.servizio,'XXXX')||nvl(jsn_s.tipo_atto,0)||lpad(nvl(jsn_s.usecase,0),10,'0') id_lista
  from ansjsn_sezioni jsn_s
 where nvl(servizio,'XXXX') = 'R009_V'
   and sezione              != 'datiAnnotazione'
   and nvl(usecase,0)       > 0
/
comment on table ansjsn_sezioni_v is 'ANSC - Configurazione Sezioni per richieste JSON (view)'
/
