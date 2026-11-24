--liquibase formatted sql
--changeset amonopoli:202606101450_1 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'ANAEVE';
w_nome_col      varchar2(255) := 'FLAG_METRICO';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table anaeve
add
(FLAG_METRICO                                  VARCHAR2(1)
,PROGR_SNC                                     VARCHAR2(10)
,FLAG_LETTERA                                  VARCHAR2(1)
,FLAG_ESPONENTE                                VARCHAR2(1)
,FLAG_NUI                                      VARCHAR2(1)
,NUI                                           VARCHAR2(10)
,COLORE                                        VARCHAR2(10)
,CORTE                                         VARCHAR2(10)
,INTERNO2                                      NUMBER(4)
,SUB_INTERNO2                                  VARCHAR2(3)
,SECONDARIO                                    VARCHAR2(10)
,SCALA_ESTERNA                                 VARCHAR2(10)
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
alter table anaeve
modify
(civico_esterno varchar2(100)
,civico_interno varchar2(100)
)
/
