--liquibase formatted sql
--changeset amonopoli:202503241505_2 runOnChange:true stripComments:false
declare
w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_des_ogg       varchar2(255);
w_check_db	number;

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  w_tipo_ogg := 'viw';
  w_nome_ogg := 'a_v_selezioni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE VIEW a_v_selezioni
(
     vista
    ,parametro
    ,descr_parametro
    ,progressivo
    ,dominio
    ,valore_low
    ,valore_high
    ,descr_valore
)
AS SELECT
     vele_vista,                                       
     campo,                                            
     descrizione,                                      
     progressivo,                                      
     null,                                             
     null,                                             
     null,                                             
     null                                              
FROM
    a_campi_viste_elenchi  
 where tipo in ('Q','X')
 union select null,
 null,
 null,
 0,
 dominio,
 valore_low,
 valore_high,
 nvl(descrizione,nvl(descrizione_al1,descrizione_al2))
 from a_domini_selezioni';

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
