--liquibase formatted sql
--changeset amonopoli:202606081530_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANADCE';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table ANADCE
(ANAGRAFE                                           VARCHAR2(3)
,CODICE                                             NUMBER(4)
,DESCRIZIONE                                        VARCHAR2(40)
,COD_MOV                                            NUMBER(2)
,COD_EVE                                            NUMBER(2)
,TIPO_EVENTO                                        VARCHAR2(1)
,COD_VARIAZIONE                                     VARCHAR2(1)
,FLAG_TPR                                           VARCHAR2(1)
,TIPO_EVENTO_TPR                                    VARCHAR2(1)
,DES_EVENTO_TPR                                     VARCHAR2(30)
,SEQ_EVENTO_TPR                                     NUMBER(2)
,FLAG_ISTAT                                         VARCHAR2(1)
,TIPO_EVENTO_ISTAT                                  VARCHAR2(1)
,FLAG_APR4                                          VARCHAR2(1)
,TIPO_RICHIESTA_APR4                                VARCHAR2(1)
,RICHIESTA_APR4                                     NUMBER(1)
,PROVVEDIMENTO_APR4                                 NUMBER(1)
,MOTIVO_APR4                                        VARCHAR2(30)
,FLAG_R01                                           VARCHAR2(1)
,FLAG_AIRE01                                        VARCHAR2(1)
,INIZIATIVA_AIRE01                                  NUMBER(1)
,ISCRIZIONE_AIRE01                                  VARCHAR2(1)
,MOTIVO_AIRE01                                      VARCHAR2(3)
,INDIVIDUAZIONE_AIRE01                              NUMBER(1)
,FLAG_ELE                                           VARCHAR2(1)
,MOTIVO_ELE                                         NUMBER(2)
,MOTIVO_GPO                                         NUMBER(2)
,MOTIVO_PSE                                         NUMBER(2)
,MOTIVO_SCR                                         NUMBER(2)
,SIGLA_VANA                                         VARCHAR2(20)
,DESCRIZIONE_CER                                    VARCHAR2(255)
,DESCRIZIONE_M                                      VARCHAR2(60)
,DESCRIZIONE_F                                      VARCHAR2(60)
,FLAG_PRELIMINARE                                   VARCHAR2(60)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'create unique index idx1anadce on anadce (codice)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'create unique index idx2anadce on anadce (anagrafe, cod_mov, cod_eve, tipo_evento, cod_variazione)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'create index idx3anadce on anadce (anagrafe, cod_mov, cod_eve)';

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
comment on table anadce is 'Anagrafe - Dizionario Codici Evento e Relazioni'
/
