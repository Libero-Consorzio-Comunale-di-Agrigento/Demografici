--liquibase formatted sql
--changeset amonopoli:202209201030_3 runOnChange:true stripComments:false
create or replace function f_SCSW_data_source_xml
(a_tipo_atto      	IN	number		-- 1,2,3,4,5,6,7,8,9,-4,-9 (dato di civcom)
,a_ufficio        	IN	number
,a_anno           	IN	number
,a_atto           	IN	number
,a_parte          	IN	number
,a_serie          	IN	varchar2
,a_formula        	IN 	varchar2
,a_d_data_reg       	IN	varchar2
,a_sequenza       	IN	number
,a_codice_co      	IN	number
,a_terminalista   	IN	varchar2
)

return CLOB

IS

w_tipo_atto_nb		number;		-- 0 (x formule) / 1,2,3,4,5,-4 (x atti)
w_tipo_atto     	number;		-- 1,2,3,4,5-4 (x formule - x ricerca su civdfa)
w_data_reg_j      	number;
w_comune         	varchar2(255); 	-- <comune_utente>
w_data           	varchar2(255); 	-- <data_odierna>
w_comune_data    	varchar2(255); 	-- <comune_utente>, <data_odierna>
w_terminalista		varchar2(255);

w_des_comunicazione	varchar2(255);

w_connessione_jndi	varchar2(255) := 'de4gsdzk';

w_separatore     	varchar2(255) := '';

w_session_id		number := f_tabrep_terminale();

w_count    		number;

w_sql				varchar2(32767);--clob;
w_sql_campi_def     		varchar2(32767);--clob;
w_sql_campi_def_1     		varchar2(32767);--clob;
w_sql_campi_def_2     		varchar2(32767);--clob;
w_sql_campi_qry     		varchar2(32767);--clob;
w_sql_campi_qry_1     		varchar2(32767);--clob;
w_sql_campi_qry_2     		varchar2(32767);--clob;
w_sql_query     		varchar2(32767);--clob;
w_sql_query_1     		varchar2(32767);--clob;
w_sql_query_2     		varchar2(32767);--clob;

w_result_100			varchar2(32767);--clob;
w_result_campi_def		varchar2(32767);--clob;
w_result_campi_def_1		varchar2(32767);--clob;
w_result_campi_def_2		varchar2(32767);--clob;
w_result_campi_qry		varchar2(32767);--clob;
w_result_campi_qry_1		varchar2(32767);--clob;
w_result_campi_qry_2		varchar2(32767);--clob;
w_result_query			varchar2(32767);--clob;
w_result_query_1		varchar2(32767);--clob;
w_result_query_2		varchar2(32767);--clob;

w_query_logo			varchar2(255);
w_query_from			varchar2(255);

w_sql_drop_viw			varchar2(32767);
	
w_result			clob;

w_operazione_log		varchar2(255) := 'f_SCSW_data_source_xml';
w_note_log			varchar2(4000);
w_modulo_rif_log			varchar2(255) := 'CIV';
w_id_rif_log			varchar2(255) := f_CIV_get_id_atto(a_tipo_atto, a_ufficio, a_anno, a_parte, a_serie, a_atto);
w_return_log			number;

begin
  if a_formula is not null then
     w_tipo_atto_nb := 0;
     if a_tipo_atto in (6,7,8) then
        w_tipo_atto := 2;
     elsif a_tipo_atto = 9 then
        w_tipo_atto := 4;
     elsif a_tipo_atto = -9 then
        w_tipo_atto := -4;
     else
        w_tipo_atto := a_tipo_atto;
     end if;
  else
     w_tipo_atto_nb := a_tipo_atto;
     w_tipo_atto    := a_tipo_atto;
  end if;

-- dbms_output.put_line('a_tipo_atto '||a_tipo_atto);
-- dbms_output.put_line('w_tipo_atto_nb '||w_tipo_atto_nb);
-- dbms_output.put_line('w_tipo_atto '||w_tipo_atto);
-- dbms_output.put_line('a_ufficio '||a_ufficio);
-- dbms_output.put_line('a_anno '||a_anno);
-- dbms_output.put_line('a_atto '||a_atto);
-- dbms_output.put_line('a_parte '||a_parte);
-- dbms_output.put_line('a_serie '||a_serie);
-- dbms_output.put_line('a_formula '||a_formula);
-- dbms_output.put_line('a_d_data_reg '||a_d_data_reg);
-- dbms_output.put_line('a_sequenza '||a_sequenza);
-- dbms_output.put_line('a_codice_co '||a_codice_co);
-- dbms_output.put_line('a_terminalista '||a_terminalista);

  w_data_reg_j   := to_char(to_date(a_d_data_reg,'dd/mm/yyyy'),'j');
-- dbms_output.put_line('w_data_reg_j '||w_data_reg_j);
  w_comune       := f_get_comune_cliente('DES_COM');
  w_data         := to_char(sysdate,'dd/mm/yyyy');
  w_comune_data  := w_comune||', '||w_data;
  w_terminalista := f_get_nome_terminalista(a_terminalista);
-- dbms_output.put_line('w_terminalista '||w_terminalista);

-- dbms_output.put_line('prima di p_scsw_riga_intesta_viw');
  p_SCSW_riga_intesta_viw(w_tipo_atto_nb,w_separatore);
-- dbms_output.put_line('prima di p_scsw_riga_dati_viw');
  p_SCSW_riga_dati_viw(w_terminalista,w_comune_data,w_comune,w_data,w_tipo_atto_nb,a_tipo_atto,w_tipo_atto,a_formula,a_codice_co,a_ufficio,a_anno,a_atto,a_parte,a_serie,w_data_reg_j,a_sequenza,w_separatore);

  begin
    select nvl(max(colno),0) into w_count
      from col
     where tname = 'SCSW_'||w_session_id||'_INT'
    ;
  end;

  if w_count = 0 then goto fine; end if;
  goto xml_documentRoot;

<< xml_row >>
-- dbms_output.put_line('xml_row');
  w_result := '<row>';

  w_sql := 'select ';
  for i in 1..w_count loop
      w_sql := w_sql||'''<f>''||i.INT_'||to_char(i)||'||''</f>''||';
      w_sql := w_sql||'''<v>''||v.VAL_'||to_char(i)||'||''</v>''';
      if mod(i,50) = 0 then
         w_sql := w_sql||chr(10)||' from SCSW_'||w_session_id||'_int i, SCSW_'||w_session_id||'_val v'||chr(10);

         begin
           execute immediate w_sql into w_result_100;
         end;
         w_result := w_result||chr(10)||w_result_100;
         w_sql := 'select ';
      else
         w_sql := w_sql||'||chr(10)||'||chr(10);
      end if;
  end loop;

  if w_sql is not null then
     w_sql := rtrim(rtrim(w_sql,chr(10)),'||chr(10)||');
     w_sql := w_sql||chr(10)||' from SCSW_'||w_session_id||'_int i, SCSW_'||w_session_id||'_val v'||chr(10);
  end if;

  if w_sql is not null then
     begin
       execute immediate w_sql into w_result_100;
     end;
     w_result := w_result||chr(10)||w_result_100;
  end if;
  w_result := replace(w_result,'<f>','<fieldValue><field>');
  w_result := replace(w_result,'</f>','</field>');
  w_result := replace(w_result,'<v>','<value>');
  w_result := replace(w_result,'</v>','</value></fieldValue>');

  w_result := w_result||chr(10)||'<row>';

  w_sql := 'drop view SCSW_'||w_session_id||'_int';
  begin
    execute immediate w_sql;
  end;
  w_sql := 'drop view SCSW_'||w_session_id||'_val';
  begin
    execute immediate w_sql;
  end;

  goto fine;

<< xml_documentRoot >>
-- dbms_output.put_line('xml_documetRoot');
  w_result := '<?xml version="1.0" encoding="UTF-8"?>';
  w_result := w_result||'<documentRoot>'||chr(10);
  w_result := w_result||'<descrizione>Test</descrizione>'||chr(10);
  w_result := w_result||'<connections>'||chr(10);
  w_result := w_result||'<connectionJNDI>jdbc/'||w_connessione_jndi||'</connectionJNDI>'||chr(10);
  w_result := w_result||'</connections>'||chr(10);
  w_result := w_result||'<definitions>'||chr(10);

  w_sql_campi_def   := 'select ';
  w_sql_campi_def_1 := 'select ';
  w_sql_campi_def_2 := 'select ';
  w_sql_campi_qry   := 'select ';
  w_sql_campi_qry_1 := 'select ';
  w_sql_campi_qry_2 := 'select ';
  w_sql_query       := 'select ''select ''||';
  w_sql_query_1     := 'select ''select ''||';
  w_sql_query_2     := 'select ';
  for i in 1..w_count loop
      w_sql_campi_def := w_sql_campi_def||'''<f>''||i.INT_'||to_char(i)||'||''</f>''||chr(10)||';
      if i <= 70 then
         w_sql_campi_def_1 := w_sql_campi_def_1||'''<f>''||i.INT_'||to_char(i)||'||''</f>''||chr(10)||';
      else
         w_sql_campi_def_2 := w_sql_campi_def_2||'''<f>''||i.INT_'||to_char(i)||'||''</f>''||chr(10)||';
      end if;

      w_sql_campi_qry := w_sql_campi_qry||'i.INT_'||to_char(i)||'||'',''||';
      if i <= 70 then
         w_sql_campi_qry_1 := w_sql_campi_qry_1||'i.INT_'||to_char(i)||'||'',''||';
      else
         w_sql_campi_qry_2 := w_sql_campi_qry_2||'i.INT_'||to_char(i)||'||'',''||';
      end if;

      w_sql_query   := w_sql_query||'''v.VAL_'||to_char(i)||' AS ''||'||'i.INT_'||to_char(i)||'||'',''||chr(10)||';
      if i <= 70 then
         w_sql_query_1   := w_sql_query_1||'''v.VAL_'||to_char(i)||' AS ''||'||'i.INT_'||to_char(i)||'||'',''||chr(10)||';
      else
         w_sql_query_2   := w_sql_query_2||'''v.VAL_'||to_char(i)||' AS ''||'||'i.INT_'||to_char(i)||'||'',''||chr(10)||';
      end if;
  end loop;

  if w_sql_campi_def is not null then
     w_sql_campi_def   := rtrim(w_sql_campi_def,'|');
     w_sql_campi_def   := w_sql_campi_def||' from SCSW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_def_1 := substr(w_sql_campi_def_1,1,length(w_sql_campi_def_1)-2);
     w_sql_campi_def_1 := w_sql_campi_def_1||' from SCSW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_def_2 := substr(w_sql_campi_def_2,1,length(w_sql_campi_def_2)-2);
     w_sql_campi_def_2 := w_sql_campi_def_2||' from SCSW_'||w_session_id||'_int i'||chr(10);
  end if;

  if w_sql_campi_qry is not null then
     w_sql_campi_qry   := rtrim(w_sql_campi_qry,''',''||');
     w_sql_campi_qry   := w_sql_campi_qry||' from SCSW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_qry_1 := substr(w_sql_campi_qry_1,1,length(w_sql_campi_qry_1)-7);
     w_sql_campi_qry_1 := w_sql_campi_qry_1||' from SCSW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_qry_2 := substr(w_sql_campi_qry_2,1,length(w_sql_campi_qry_2)-7);
     w_sql_campi_qry_2 := w_sql_campi_qry_2||' from SCSW_'||w_session_id||'_int i'||chr(10);
  end if;

  if w_sql_query is not null then
     w_sql_query   := substr(w_sql_query,1,length(w_sql_query)-16)||'||chr(10)';
     w_sql_query   := w_sql_query||'||'' from SCSW_'||w_session_id||'_val v'' from SCSW_'||w_session_id||'_int i'||chr(10);
     w_sql_query_1 := substr(w_sql_query_1,1,length(w_sql_query_1)-2);
     w_sql_query_1 := w_sql_query_1||' from SCSW_'||w_session_id||'_int i'||chr(10);
     w_sql_query_2 := substr(w_sql_query_2,1,length(w_sql_query_2)-16)||'||chr(10)';
     w_sql_query_2 := w_sql_query_2||'||'' from SCSW_'||w_session_id||'_val v'' from SCSW_'||w_session_id||'_int i'||chr(10);
  end if;

  if w_sql_campi_def is not null then
     begin
--       execute immediate w_sql_campi_def into w_result_campi_def;
       execute immediate w_sql_campi_def_1 into w_result_campi_def_1;
       execute immediate w_sql_campi_def_2 into w_result_campi_def_2;
     exception
       when others then
            w_note_log    := sqlerrm;
--            w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, '', w_modulo_rif_log, w_id_rif_log);
     end;

     w_result_campi_def := w_result_campi_def_1||w_result_campi_def_2;
     w_result_campi_def := replace(w_result_campi_def,'<f>','<metaDato><nomeSimbolico>');
     w_result_campi_def := replace(w_result_campi_def,'</f>','</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
--
-- AMonopoli - 10/11/2021
-- . metadato LOGO_CIV_NULL: aggiunto x dirottare il campo estratto dalla vista _VAL
-- . metadato LOGO_CIV     : modifica del dataType da "string" a "image"
--
     w_result_campi_def := replace(w_result_campi_def,'<metaDato><nomeSimbolico>LOGO_CIV</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                                        '<metaDato><nomeSimbolico>LOGO_CIV_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                                        '<metaDato><nomeSimbolico>LOGO_CIV</nomeSimbolico><tipo>image</tipo><descrizione>xx</descrizione><path/></metaDato>');
  end if;

  if w_sql_campi_qry is not null then
     begin
--       execute immediate w_sql_campi_qry into w_result_campi_qry;
       execute immediate w_sql_campi_qry_1 into w_result_campi_qry_1;
       execute immediate w_sql_campi_qry_2 into w_result_campi_qry_2;
     exception
       when others then
            w_note_log    := sqlerrm;
--            w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, '', w_modulo_rif_log, w_id_rif_log);
     end;

     w_result_campi_qry := w_result_campi_qry_1||w_result_campi_qry_2;
--
-- AMonopoli - 10/11/2021
-- . metadato LOGO_CIV_NULL: aggiunto x dirottare il campo estratto dalla vista _VAL
--
     w_result_campi_qry := replace(w_result_campi_qry,'LOGO_CIV,','LOGO_CIV_NULL,LOGO_CIV,');
  end if;

  if w_sql_query is not null then
     begin
--       execute immediate w_sql_query into w_result_query;
       execute immediate w_sql_query_1 into w_result_query_1;
       execute immediate w_sql_query_2 into w_result_query_2;
     exception
       when others then
            w_note_log    := sqlerrm;
--            w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, '', w_modulo_rif_log, w_id_rif_log);
     end;
  end if;

  w_result_query := w_result_query_1||w_result_query_2;
  w_result_query := replace(w_result_query,'AS LOGO_CIV','AS LOGO_CIV_NULL');
--  w_query_logo   := ', (select inp.allegato_blob from arcinp inp where inp.parametro = ''LOGO_CIV'') AS LOGO_CIV'||chr(10)||
--                      ' from SCSW_'||w_session_id||'_val v';
--  w_query_from   := ' from SCSW_'||w_session_id||'_val v';
  w_query_logo   := ', inp.allegato_blob AS LOGO_CIV'||chr(10)||
                      'from arcinp inp, SCSW_'||w_session_id||'_val v'||chr(10)||
                      'where inp.parametro = ''LOGO_CIV''';
  w_query_from   := ' from SCSW_'||w_session_id||'_val v';
  w_result_query := replace(w_result_query,w_query_from,w_query_logo);

-- dbms_output.put_line('prima di w_result_def');
  w_result := w_result||w_result_campi_def;
  w_result := w_result||'</definitions>'||chr(10);
  w_result := w_result||'<queryes>'||chr(10);
  w_result := w_result||'<query id="dati"'||chr(10);
  w_result := w_result||'help_query_alias="d"'||chr(10);
  w_result := w_result||'help_field_aliases="'||w_result_campi_qry||'">'||chr(10);
-- dbms_output.put_line('prima di w_result_query');
  w_result := w_result||w_result_query||chr(10);
  w_result := w_result||'</query>'||chr(10);
  w_result := w_result||'</queryes>'||chr(10);
  w_result := w_result||'<staticData />'||chr(10);
  w_result := w_result||'</documentRoot>';

--
-- AMonopoli: modifica variabili "INVIO_xxx" per eliminazione del prefisso "INVIO_"
--            perchè gli alias superano la lunghezza limite di 30 caratteri
--
  w_result := replace(w_result,'INVIO_','');

  w_sql_drop_viw := 'drop view SCSW_'||w_session_id||'_int'||chr(10);
  begin
    execute immediate w_sql_drop_viw;
  end;

  goto fine;

<< fine >>
  begin
    select codice_co||' - '||descrizione
      into w_des_comunicazione
      from civdco
     where codice_co = a_codice_co
    ;
  exception
    when others then
         w_des_comunicazione := '';
  end;

  w_note_log   := w_des_comunicazione;
  w_return_log := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result, w_modulo_rif_log, w_id_rif_log);

  return w_result;

end;
/
