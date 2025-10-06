--liquibase formatted sql
--changeset amonopoli:202503251300_3 runOnChange:true
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
  w_nome_ogg := 'comuni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

    w_sql := 'drop table comuni';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  end if;

  w_tipo_ogg := 'viw';
  w_nome_ogg := 'comuni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

    w_sql := 'drop view comuni';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  end if;

  w_tipo_ogg := 'syn';
  w_nome_ogg := 'comuni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

    w_sql := 'drop synonym comuni';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  end if;

  w_tipo_ogg := '';
  w_nome_ogg := 'comuni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create or replace view COMUNI as
select COMU.provincia_stato         COD_PROVINCIA
     , COMU.comune                  COD_COMUNE
     , COMU.denominazione           DESCRIZIONE
     , COMU.denominazione_al1       DESCRIZIONE_AL1
     , COMU.denominazione_al2       DESCRIZIONE_AL2
     , COMU.denominazione_breve     DESCRIZIONE_BREVE
     , COMU.denominazione_breve_al1 DESCRIZIONE_BREVE_AL1
     , COMU.denominazione_breve_al2 DESCRIZIONE_BREVE_AL2
     , COMU.CAPOLUOGO_PROVINCIA
     , COMU.CAP
     , COMU.provincia_tribunale     COD_PROVINCIA_TRIBUNALE
     , COMU.comune_tribunale        COD_COMUNE_TRIBUNALE
     , COMU.provincia_distretto     COD_PROVINCIA_DISTRETTO
     , COMU.comune_distretto        COD_COMUNE_DISTRETTO
     , COMU.DATA_SOPPRESSIONE       
     , COMU.provincia_fusione       COD_PROVINCIA_FUSIONE
     , COMU.comune_fusione          COD_COMUNE_FUSIONE
     , COMU.sigla_cfis              CODICE_CATASTO
     , COMU.CONSOLATO
     , COMU.TIPO_CONSOLATO
     , decode( sign(comu.provincia_stato - 199)
             , -1, prov.sigla
                 , stte.sigla
             )                      SIGLA_PROVINCIA
     , PROV.denominazione           DENOMINAZIONE_PROVINCIA
     , PROV.REGIONE
     , REGI.denominazione           DENOMINAZIONE_REGIONE
  from A_REGIONI         REGI
     , A_STATI_TERRITORI STTE
     , A_PROVINCIE       PROV
     , A_COMUNI          COMU
 where REGI.REGIONE          (+) = PROV.REGIONE
   and PROV.PROVINCIA        (+) = COMU.PROVINCIA_STATO
   and STTE.STATO_TERRITORIO (+) = COMU.PROVINCIA_STATO';

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
