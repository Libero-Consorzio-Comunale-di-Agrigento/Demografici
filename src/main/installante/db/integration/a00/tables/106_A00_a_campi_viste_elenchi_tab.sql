--liquibase formatted sql
--changeset amonopoli:202503241000_6 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_campi_viste_elenchi';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_campi_viste_elenchi(
 vele_vista                      VARCHAR (30)        NOT NULL,
 campo                           VARCHAR (30)        NOT NULL,
 descrizione                     VARCHAR (30)        NOT NULL,
 descrizione_al1                 VARCHAR (30)        NULL,
 descrizione_al2                 VARCHAR (30)        NULL,
 tipo                            VARCHAR (1)         NOT NULL,
 progressivo                     NUMBER (3,0)     NOT NULL,
 valore_default                  VARCHAR (80)        NULL,
 alias                           VARCHAR (8)         NULL,
 dominio                         VARCHAR (30)        NULL,
 modulo                          VARCHAR (8)         NULL,
 numero_fk                       NUMBER (1,0)     NULL
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
     w_nome_ogg := 'CVEL_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX CVEL_PK ON A_CAMPI_VISTE_ELENCHI
(
      vele_vista ,
      campo )';

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

     w_tipo_ogg := 'idx';
     w_nome_ogg := 'CVEL_UK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX CVEL_UK ON A_CAMPI_VISTE_ELENCHI
(
      vele_vista ,
      descrizione )';

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
COMMENT ON TABLE a_campi_viste_elenchi
    IS 'Created from Entity CAMPO VISTA PER ELENCHI by A00 on 05-AUG-93'
/
COMMENT ON COLUMN a_campi_viste_elenchi.vele_vista
    IS 'Nome della vista nel database'
/
COMMENT ON COLUMN a_campi_viste_elenchi.campo
    IS 'Nome del campo della vista sul database'
/
COMMENT ON COLUMN a_campi_viste_elenchi.descrizione
    IS 'Descrizione del campo'
/
COMMENT ON COLUMN a_campi_viste_elenchi.tipo
    IS 'Tipo di utilizzo del campo'
/
COMMENT ON COLUMN a_campi_viste_elenchi.progressivo
    IS 'Progressivo di presentazione del campo'
/
COMMENT ON COLUMN a_campi_viste_elenchi.valore_default
    IS 'Valore di default del parametro'
/
COMMENT ON COLUMN a_campi_viste_elenchi.alias
    IS 'Alias relativo al contenuto del campo'
/
COMMENT ON COLUMN a_campi_viste_elenchi.dominio
    IS 'Dominio relativo al campo'
/
COMMENT ON COLUMN a_campi_viste_elenchi.modulo
    IS 'Modulo da richiamare come lista valori'
/
COMMENT ON COLUMN a_campi_viste_elenchi.numero_fk
    IS 'Numero della global.fk da riportare nel campo'
/