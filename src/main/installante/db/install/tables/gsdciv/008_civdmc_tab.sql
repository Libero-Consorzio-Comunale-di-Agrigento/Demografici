--liquibase formatted sql
--changeset amonopoli:202307031515 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'CIVDMC';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create table civdmc
(ID                                                 NUMBER(10)
,DESCRIZIONE                                        VARCHAR2(300)
,ID_CIVCTA                                          NUMBER(10)
,FLAG_DOCUMENTO_IDENTITA                            VARCHAR2(1)
,FLAG_PUBBLICO_IMPIEGO                              VARCHAR2(1)
,FLAG_ASCENDENTE                                    VARCHAR2(1)
,FLAG_RICORRENTE                                    VARCHAR2(1)
,FLAG_RICONOSCIMENTO                                VARCHAR2(1)
,FLAG_PADRE                                         VARCHAR2(1)
,FLAG_MADRE                                         VARCHAR2(1)
,FLAG_ENTE_ESTERO                                   VARCHAR2(1)
,TIPO_RICHIESTA                                     VARCHAR2(3)
,FLAG_RESIDENZA                                     VARCHAR2(1)
,FLAG_ACCERTAMENTO                                  VARCHAR2(1)
,FLAG_AUTORITA                                      VARCHAR2(1)
,FLAG_ESTREMI_GIURAMENTO                            VARCHAR2(1)
,FLAG_CONSOLATO                                     VARCHAR2(1)
,FLAG_CAMBIO_GENERALITA                             VARCHAR2(1)
,FLAG_MINORE                                        VARCHAR2(1)
,FLAG_ANNOTAZIONE                                   VARCHAR2(1)
,FLAG_ESTREMI_RICONOSCIMENTO                        VARCHAR2(1)
,TIPO_ATTO                                          NUMBER(1)
,FLAG_ESTREMI_ATTO_NASCITA                          VARCHAR2(1)
,FLAG_CAMBIO_GENERALITA_OBBL                        VARCHAR2(1)
,FLAG_TIPO_RICHIESTA_TRAS                           VARCHAR2(1)
,FLAG_TIPO_RICHIESTA_TRAS_OBBL                      VARCHAR2(1)
,FLAG_AUTORITA_ESTREMI                              VARCHAR2(1)
,FLAG_NAZ_PADRE_MADRE_OBBL                          VARCHAR2(1)
,FLAG_DATA_TRASCRIZIONE_OBBL                        VARCHAR2(1)
)
';

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
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'CIVDMC_PK';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table CIVDMC
  add constraint CIVDMC_PK primary key (ID)
  using index';

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
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'CIVDMC_CIVCTA_FK';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table CIVDMC
  add constraint CIVDMC_CIVCTA_FK foreign key (ID_CIVCTA)
  references CIVCTA (ID)';

begin
execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
end;

     w_sql := 'create index CIVDMC_CIVCTA_FK on CIVDMC (ID_CIVCTA)';

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
comment on table civdmc is 'Stato Civile - Motivi Cittadinanza'
/
