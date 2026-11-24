--liquibase formatted sql
--changeset amonopoli:202606111300_2 runAlways:true runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := '';
w_nome_ogg	varchar2(255) := 'WEB_VTPR';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE WEB_VTPR
(ANAGRAFE                                           VARCHAR2(3)
,TIPO_EVENTO                                        VARCHAR2(1)
,ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,SEQUENZA                                           NUMBER(2)
,UTENTE                                             VARCHAR2(30)
,ESITO                                              VARCHAR2(1)
,NOTE                                               VARCHAR2(2000)
,DATA_ESITO                                         DATE
,DATA_VARIAZIONE                                    DATE
,ID                                                 NUMBER(10)
,VERSION                                            NUMBER(20)
,ALLEGATO_BLOB                                      BLOB
,ALLEGATO_NOME                                      VARCHAR2(255)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
create or replace view web_vtpr_v_zk as
select web.anagrafe,
       web.tipo_evento,
       web.anno_pratica,
       web.pratica,
       web.esito,
       web.note,
       web.data_esito d_data_esito,
       web.sequenza,
       web.utente,
       web.id,
       web.allegato_blob,
       web.allegato_nome,
       sap.id ID_ANASAP
  from web_vtpr web, anasap sap
 where nvl(web.esito, ' ') in ('P', 'N')
   and web.tipo_evento = SAP.TIPO_EVENTO
   and web.anno_pratica = sap.anno_pratica
   and web.sequenza = sap.sequenza
   and web.pratica = sap.pratica
--   and web.tipo_evento = 'I'
   and sap.esito is null
/
comment on table web_vtpr_v_zk is 'Pratiche WEB - Accertamenti Vigili da Portale ADS (view)'
/
