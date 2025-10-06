--liquibase formatted sql
--changeset amonopoli:202503240850_1 runOnChange:false stripComments:false
declare
w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_des_ogg       varchar2(255);
w_check_db	number;

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
<< tab_com >>
  w_tipo_ogg := 'tab';
  w_nome_ogg := 'COM';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_SI_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create table COM
(
  COD_PROVINCIA     NUMBER(3) not null,
  COD_COMUNE        NUMBER(3) not null,
  DESCRIZIONE       VARCHAR2(30),
  CAP               NUMBER(5),
  TRIBUNALE         NUMBER(6),
  USL               NUMBER(4),
  REGIONE           NUMBER(3),
  FASCIA_ALTI       NUMBER(1),
  SIGLA_PROVINCIA   VARCHAR2(3),
  CODICE_CATASTO    VARCHAR2(4),
  DATA_ULT_AGG      NUMBER(7),
  UTENTE_ULT_AGG    VARCHAR2(8),
  DESCRIZIONE_AL1   VARCHAR2(60),
  DESCRIZIONE_AL2   VARCHAR2(30),
  COD_CONSOLATO     NUMBER(5),
  CEE               VARCHAR2(1),
  TIPO_CONSOLATO    NUMBER(2),
  COD_TERRITORIO    NUMBER(3),
  DATA_SOPPRESSIONE NUMBER(7),
  COD_PRO_FUSIONE   NUMBER(3),
  COD_COM_FUSIONE   NUMBER(3),
  DATA_ISTITUZIONE  NUMBER(8)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_idxcom >>
     w_tipo_ogg	:= 'idx';
     w_nome_ogg	:= 'IDXCOM';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db	:= f_SI_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
        w_sql := 'create unique index IDXCOM on COM (COD_PROVINCIA, COD_COMUNE)';

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

<< idx_idx2com >>
     w_tipo_ogg	:= 'idx';
     w_nome_ogg	:= 'IDX2COM';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db	:= f_SI_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
        w_sql := 'create index IDX2COM on COM (DESCRIZIONE)';

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

<< idx_idx3com >>
     w_tipo_ogg	:= 'idx';
     w_nome_ogg	:= 'IDX3COM';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db	:= f_SI_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
        w_sql := 'create index IDX3COM on COM (CODICE_CATASTO)';

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

<< idx_idx10com >>
     w_tipo_ogg	:= 'idx';
     w_nome_ogg	:= 'IDX10COM';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db	:= f_SI_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
        w_sql := 'create index IDX10COM on COM (TRIBUNALE)';

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

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
comment on table COM is 'Comuni e Stati Esteri'
/

