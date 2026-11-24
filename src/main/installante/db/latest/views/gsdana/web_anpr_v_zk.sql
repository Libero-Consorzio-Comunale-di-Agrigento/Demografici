--liquibase formatted sql
--changeset amonopoli:202606111300_1 runAlways:true runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := '';
w_nome_ogg	varchar2(255) := 'WEB_ANPR';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE WEB_ANPR
(ID                                                 NUMBER(10)
,MATRICOLA_DIC                                      NUMBER
,DICHIARANTE                                        VARCHAR2(511)
,COD_FAM_PROV                                       NUMBER
,COD_FAM_DEST                                       NUMBER
,COD_VIA                                            NUMBER
,NUM_CIV                                            NUMBER
,SUFFISSO                                           VARCHAR2
,INTERNO                                            NUMBER
,PIANO                                              VARCHAR2
,SCALA                                              VARCHAR2
,DATA_INOLTRO                                       DATE
,DATA_EVENTO                                        DATE
,ANNO_PRATICA                                       VARCHAR2(255)
,PRATICA                                            VARCHAR2(255)
,UTENTE                                             VARCHAR2(8)
,NOTE                                               VARCHAR2(270)
,STATO_AVANZAMENTO                                  NUMBER
,INDIRIZZO_WEB                                      VARCHAR2(1029)
,TELEFONO                                           VARCHAR2(513)
,TIPO                                               VARCHAR2
,FLAG_INOLTRO                                       CHAR(1)
,COGNOME_AGG                                        VARCHAR2(255)
,NOME_AGG                                           VARCHAR2(255)
,DATA_NASCITA_AGG                                   DATE
,VERSION                                            NUMBER
,ALLEGATO_BLOB                                      BLOB
,ALLEGATO_NOME                                      VARCHAR2(255)
,TIPO_EVENTO                                        VARCHAR2(255)
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
create or replace view web_anpr_v_zk
AS
select web.id,
       'RES' anagrafe,
       web.tipo_evento,
       web.anno_pratica,
       web.pratica,
       web.data_inoltro d_data_inoltro,
       web.utente,
       web.flag_inoltro,
       web.matricola_dic,
       translate(web.dichiarante,'/',' ') dichiarante,
       web.cod_fam_prov,
       web.indirizzo_web,
       web.telefono,
       web.note
  from web_anpr web
 where web.anno_pratica is null
   and web.pratica      is null
   and web.flag_inoltro = 'S'
/
comment on table web_anpr_v_zk is 'Pratiche WEB - Pratiche da Portale ANPR (view)'
/
