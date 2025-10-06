--liquibase formatted sql
--changeset amonopoli:202503241000_28 runOnChange:false stripComments:false
declare
w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_des_ogg       varchar2(255);
w_check_db	number;

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  w_tipo_ogg := 'tab';
  w_nome_ogg := 'a_indici_aiuto';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_indici_aiuto(
 ambiente                        VARCHAR (8)         NOT NULL,
 progressivo                     NUMBER (7,0)     NOT NULL,
 keyword                         VARCHAR (60)        NULL,
 keyword_al1                     VARCHAR (60)        NULL,
 keyword_al2                     VARCHAR (60)        NULL,
 ambiente_help                   VARCHAR (8)         NOT NULL,
 tipo_oggetto                    VARCHAR (1)         NOT NULL,
 modulo                          VARCHAR (8)         NOT NULL,
 blocco                          VARCHAR (30)        NOT NULL,
 oggetto                         VARCHAR (30)        NOT NULL
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'INHE_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX INHE_PK ON A_INDICI_AIUTO
(
      ambiente ,
      progressivo )';

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
COMMENT ON TABLE a_indici_aiuto
    IS 'Created from Entity INDICE PER AIUTO by A00 on 07-JAN-94'
/
COMMENT ON COLUMN a_indici_aiuto.ambiente
    IS 'Codice dell''area di ambiente o dello standard'
/
COMMENT ON COLUMN a_indici_aiuto.keyword
    IS 'Parola chiave per l''individuazione di un testo di aiuto'
/
COMMENT ON COLUMN a_indici_aiuto.tipo_oggetto
    IS 'Tipo di oggetto documentato'
/
COMMENT ON COLUMN a_indici_aiuto.ambiente_help
    IS 'Codice dell''ambiente applicativo'
/
COMMENT ON COLUMN a_indici_aiuto.modulo
    IS 'Codice della voce di menu'''
/
COMMENT ON COLUMN a_indici_aiuto.blocco
    IS 'Nome del blocco in cui si trova il campo documentato'
/
COMMENT ON COLUMN a_indici_aiuto.oggetto
    IS 'Nome dell''oggetto documentato se campo o voce di menu'''
/
