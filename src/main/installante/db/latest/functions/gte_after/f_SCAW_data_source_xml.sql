--liquibase formatted sql
--changeset amonopoli:202605081300_3 runOnChange:true stripComments:false
create or replace function f_SCAW_data_source_xml
(a_anagrafe		IN	varchar2
,a_tipo_evento		IN	varchar2
,a_anno_pratica		IN	number
,a_pratica		IN	number
,a_id_anacom		IN	number
,a_cod_utente		IN	varchar2
)

return clob

IS

w_anagrafe		varchar2(255) := a_anagrafe;
w_tipo_evento		varchar2(255) := a_tipo_evento;
w_anno_pratica		number := a_anno_pratica;
w_pratica		number := a_pratica;
w_id_anacom		number := a_id_anacom;
w_separatore		varchar2(255) := rtrim(f_valore_inp('SCAW_SEP',1,10,'X',''));
w_cod_utente		varchar2(255) := a_cod_utente;

w_anno_progr_mov    	number;
w_numero_progr_mov  	number;
w_matricola         	number;
w_cod_mov           	number;
w_cod_eve           	number;
w_data_reg          	number;
w_ente_lp           	number;	
w_modello           	varchar2(255);
w_stampa_terminalista 	varchar2(255) := 'S';
w_nome_terminalista   	varchar2(255);

w_anno_pratica_eve	number;
w_pratica_eve		number;

w_session_id		number := f_tabrep_terminale();

w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_check_db	number;

w_count    			number;
w_sql      			clob;

w_result_100   			clob;
w_result      			clob;

w_connessione_jndi		varchar2(255) := 'de4gsdzk';

w_sql_campi_def     		clob;
w_sql_campi_def_1     		clob;
w_sql_campi_def_2     		clob;
w_sql_campi_def_3     		clob;
w_sql_campi_qry     		clob;
w_sql_campi_qry_1     		clob;
w_sql_campi_qry_2     		clob;
w_sql_campi_qry_3     		clob;
w_sql_query     		clob;
w_sql_query_1     		clob;
w_sql_query_2     		clob;
w_sql_query_3     		clob;

w_result_campi_def		clob;
w_result_campi_def_1		clob;
w_result_campi_def_2		clob;
w_result_campi_def_3		clob;
w_result_campi_qry		clob;
w_result_campi_qry_1		clob;
w_result_campi_qry_2		clob;
w_result_campi_qry_3		clob;
w_result_query			clob;
w_result_query_1		clob;
w_result_query_2		clob;
w_result_query_3		clob;

w_sql_drop_viw			varchar2(32767);

w_query_logo			clob; --varchar2(255);
w_query_from			clob; --varchar2(255);

w_operazione_log		varchar2(255) := 'f_SCAW_data_source_xml';
w_note_log			varchar2(4000);
w_modulo_rif_log		varchar2(255);
w_id_rif_log			varchar2(255) := f_ANA_get_id_pratica(a_anagrafe,a_tipo_evento,a_anno_pratica,a_pratica);
w_return_log			number;

begin

  w_tipo_ogg := 'tab';
  w_nome_ogg := 'SCAW_'||w_session_id||'_INT';
  w_check_db := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,'');

-- dbms_output.put_line(w_nome_ogg||' - w_check_db: '||w_check_db);
  if w_check_db = 0 then
     w_modulo_rif_log := 'ANA';

     if a_id_anacom is null then
        goto fine;
     end if;

     begin
       select com.anno_progr, com.numero_progr, com.matricola, 
              com.cod_mov, com.cod_eve, com.data_reg,
              com.ente_lp, substr(com.comunicazione,6)
         into w_anno_progr_mov, w_numero_progr_mov, w_matricola, 
              w_cod_mov, w_cod_eve, w_data_reg,
              w_ente_lp, w_modello
         from anacom com
        where id = a_id_anacom
       ;
       w_nome_terminalista := f_get_nome_terminalista(a_cod_utente);
     exception
       when others then 
            goto fine;
     end;

-- dbms_output.put_line('prima di riga_intesta_viw');
     p_SCAW_riga_intesta_viw(w_separatore);
-- dbms_output.put_line('prima di riga_dati_viw');
     p_SCAW_riga_dati_viw(w_anno_progr_mov, w_numero_progr_mov, w_matricola,
                          w_anno_pratica, w_pratica, w_cod_mov, w_cod_eve, w_data_reg, 
                          w_ente_lp, w_modello, w_stampa_terminalista, w_nome_terminalista, w_separatore,
                          w_anno_pratica_eve, w_pratica_eve);
-- dbms_output.put_line('dopo di riga_dati_viw');

  end if;

  begin
    select nvl(max(colno),0) into w_count
      from col
     where tname = 'SCAW_'||w_session_id||'_INT'
    ;
  end;

  if w_count = 0 then goto fine; end if;

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
  w_sql_campi_def_3 := 'select ';
  w_sql_campi_qry   := 'select ';
  w_sql_campi_qry_1 := 'select ';
  w_sql_campi_qry_2 := 'select ';
  w_sql_campi_qry_3 := 'select ';
  w_sql_query       := 'select ''select ''||';
  w_sql_query_1     := 'select ''select ''||';
  w_sql_query_2     := 'select ';
  w_sql_query_3     := '';

  for i in 1..w_count loop
      w_sql_campi_def := w_sql_campi_def||'''<f>''||i.INT_'||to_char(i)||'||''</f>''||chr(10)||';
      if i <= 100 then
         w_sql_campi_def_1 := w_sql_campi_def_1||'''<f>''||i.INT_'||to_char(i)||'||''</f>''||chr(10)||';
      elsif i between 101 and 200 then
         w_sql_campi_def_2 := w_sql_campi_def_2||'''<f>''||i.INT_'||to_char(i)||'||''</f>''||chr(10)||';
      else
         w_sql_campi_def_3 := w_sql_campi_def_3||'''<f>''||i.INT_'||to_char(i)||'||''</f>''||chr(10)||';
      end if;

      w_sql_campi_qry := w_sql_campi_qry||'i.INT_'||to_char(i)||'||'',''||';
      if i <= 100 then
         w_sql_campi_qry_1 := w_sql_campi_qry_1||'i.INT_'||to_char(i)||'||'',''||';
      elsif i between 101 and 200 then
         w_sql_campi_qry_2 := w_sql_campi_qry_2||'i.INT_'||to_char(i)||'||'',''||';
      else
         w_sql_campi_qry_3 := w_sql_campi_qry_3||'i.INT_'||to_char(i)||'||'',''||';
      end if;

      w_sql_query   := w_sql_query||'''v.VAL_'||to_char(i)||' AS ''||'||'i.INT_'||to_char(i)||'||'',''||chr(10)||';
      if i <= 100 then
         w_sql_query_1   := w_sql_query_1||'''v.VAL_'||to_char(i)||' AS ''||'||'i.INT_'||to_char(i)||'||'',''||chr(10)||';
      elsif i between 101 and 200 then
         w_sql_query_2   := w_sql_query_2||'''v.VAL_'||to_char(i)||' AS ''||'||'i.INT_'||to_char(i)||'||'',''||chr(10)||';
      else
         if i = 201 then
            w_sql_query_3 := 'select ';
         end if;
         w_sql_query_3   := w_sql_query_3||'''v.VAL_'||to_char(i)||' AS ''||'||'i.INT_'||to_char(i)||'||'',''||chr(10)||';
      end if;
  end loop;

  if w_sql_campi_def is not null then
     w_sql_campi_def   := rtrim(w_sql_campi_def,'|');
     w_sql_campi_def   := w_sql_campi_def||' from SCAW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_def_1 := substr(w_sql_campi_def_1,1,length(w_sql_campi_def_1)-2);
     w_sql_campi_def_1 := w_sql_campi_def_1||' from SCAW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_def_2 := substr(w_sql_campi_def_2,1,length(w_sql_campi_def_2)-2);
     w_sql_campi_def_2 := w_sql_campi_def_2||' from SCAW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_def_3 := substr(w_sql_campi_def_3,1,length(w_sql_campi_def_3)-2);
     w_sql_campi_def_3 := w_sql_campi_def_3||' from SCAW_'||w_session_id||'_int i'||chr(10);
  end if;

  if w_sql_campi_qry is not null then
     w_sql_campi_qry   := rtrim(w_sql_campi_qry,''',''||');
     w_sql_campi_qry   := w_sql_campi_qry||' from SCAW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_qry_1 := substr(w_sql_campi_qry_1,1,length(w_sql_campi_qry_1)-7);
     w_sql_campi_qry_1 := w_sql_campi_qry_1||' from SCAW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_qry_2 := substr(w_sql_campi_qry_2,1,length(w_sql_campi_qry_2)-7);
     w_sql_campi_qry_2 := w_sql_campi_qry_2||' from SCAW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_qry_3 := substr(w_sql_campi_qry_3,1,length(w_sql_campi_qry_3)-7);
     w_sql_campi_qry_3 := w_sql_campi_qry_3||' from SCAW_'||w_session_id||'_int i'||chr(10);
  end if;

  if w_sql_query is not null then
     w_sql_query   := substr(w_sql_query,1,length(w_sql_query)-16)||'||chr(10)';
     w_sql_query   := w_sql_query||'||'' from SCAW_'||w_session_id||'_val v'' from SCAW_'||w_session_id||'_int i'||chr(10);
     w_sql_query_1 := substr(w_sql_query_1,1,length(w_sql_query_1)-2);
     w_sql_query_1 := w_sql_query_1||' from SCAW_'||w_session_id||'_int i'||chr(10);
     if w_sql_query_3 is null then
        w_sql_query_2 := substr(w_sql_query_2,1,length(w_sql_query_2)-16)||'||chr(10)';
        w_sql_query_2 := w_sql_query_2||'||'' from SCAW_'||w_session_id||'_val v'' from SCAW_'||w_session_id||'_int i'||chr(10);
     else
        w_sql_query_2 := substr(w_sql_query_2,1,length(w_sql_query_2)-2);
        w_sql_query_2 := w_sql_query_2||' from SCAW_'||w_session_id||'_int i'||chr(10);
     end if;
     w_sql_query_3 := substr(w_sql_query_3,1,length(w_sql_query_3)-16)||'||chr(10)';
     w_sql_query_3 := w_sql_query_3||'||'' from SCAW_'||w_session_id||'_val v'' from SCAW_'||w_session_id||'_int i'||chr(10);
  end if;

  if w_sql_campi_def is not null then
     w_note_log    := 'w_sql_campi_def';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_def, w_modulo_rif_log, w_session_id);
     w_note_log    := 'w_sql_campi_def_1';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_def_1, w_modulo_rif_log, w_session_id);
     w_note_log    := 'w_sql_campi_def_2';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_def_2, w_modulo_rif_log, w_session_id);
     w_note_log    := 'w_sql_campi_def_3';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_def_3, w_modulo_rif_log, w_session_id);

     begin
--       execute immediate w_sql_campi_def into w_result_campi_def;
       execute immediate w_sql_campi_def_1 into w_result_campi_def_1;
       execute immediate w_sql_campi_def_2 into w_result_campi_def_2;
       execute immediate w_sql_campi_def_3 into w_result_campi_def_3;
     exception
       when others then
            w_note_log    := sqlerrm;
--            w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, '', w_modulo_rif_log, w_session_id);
     end;

     w_result_campi_def := w_result_campi_def_1||w_result_campi_def_2||w_result_campi_def_3;
     w_result_campi_def := replace(w_result_campi_def,'<f>','<metaDato><nomeSimbolico>');
     w_result_campi_def := replace(w_result_campi_def,'</f>','</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');

--
-- 11/05/2026 (AMonopoli)
-- . gestione del doppio metaDato (anche nella versione _NULL) per tutte le variabili relative a sotto-modelli)
--
--
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_2</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_2_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_2</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_3</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_3_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_3</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_4</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_4_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_4</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_5</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_5_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_5</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');

     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_CI_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_CI_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_CI_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_LP_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_LP_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_LP_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_PS_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_PS_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_PS_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_PT_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_PT_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_PT_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');

     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>URNE_CINERARIE</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>URNE_CINERARIE_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>URNE_CINERARIE</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');

--
-- 01/12/2025 (AMonopoli)
-- . metadato LOGO_ANA_NULL: aggiunto x dirottare il campo estratto dalla vista _VAL
-- . metadato LOGO_ANA     : modifica del dataType da "string" a "image"
--
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>LOGO_ANA</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>LOGO_ANA_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>LOGO_ANA</nomeSimbolico><tipo>image</tipo><descrizione>xx</descrizione><path/></metaDato>');


     if w_sql_campi_qry is not null then
        w_note_log    := 'w_sql_campi_qry';
--        w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_qry, w_modulo_rif_log, w_session_id);
        w_note_log    := 'w_sql_campi_qry_1';  
--        w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_qry_1, w_modulo_rif_log, w_session_id);
        w_note_log    := 'w_sql_campi_qry_2';
--        w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_qry_2, w_modulo_rif_log, w_session_id);
        w_note_log    := 'w_sql_campi_qry_3';
--        w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_qry_3, w_modulo_rif_log, w_session_id);
        begin
--          execute immediate w_sql_campi_qry into w_result_campi_qry;
          execute immediate w_sql_campi_qry_1 into w_result_campi_qry_1;
          execute immediate w_sql_campi_qry_2 into w_result_campi_qry_2;
          execute immediate w_sql_campi_qry_3 into w_result_campi_qry_3;
        exception
          when others then
               w_note_log    := sqlerrm;
--               w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, '', w_modulo_rif_log, w_session_id);
        end;

        w_result_campi_qry := w_result_campi_qry_1||w_result_campi_qry_2||w_result_campi_qry_3;
--
-- 01/12/2025 (AMonopoli)
-- . gestione del doppio metaDato (anche nella versione _NULL) per tutte le variabili relative a sotto-modelli)
--
        w_result_campi_qry := replace(w_result_campi_qry,'FAM_1,','FAM_1_NULL,FAM_1,');
        w_result_campi_qry := replace(w_result_campi_qry,'FAM_2,','FAM_2_NULL,FAM_2,');
        w_result_campi_qry := replace(w_result_campi_qry,'FAM_3,','FAM_3_NULL,FAM_3,');
        w_result_campi_qry := replace(w_result_campi_qry,'FAM_4,','FAM_3_NULL,FAM_4,');
        w_result_campi_qry := replace(w_result_campi_qry,'FAM_5,','FAM_3_NULL,FAM_5,');

        w_result_campi_qry := replace(w_result_campi_qry,'DOC_1,','DOC_1_NULL,DOC_1,');
        w_result_campi_qry := replace(w_result_campi_qry,'DOC_CI_1,','DOC_CI_1_NULL,DOC_CI_1,');
        w_result_campi_qry := replace(w_result_campi_qry,'DOC_LP_1,','DOC_LP_1_NULL,DOC_LP_1,');
        w_result_campi_qry := replace(w_result_campi_qry,'DOC_PS_1,','DOC_PS_1_NULL,DOC_PS_1,');
        w_result_campi_qry := replace(w_result_campi_qry,'DOC_PT_1,','DOC_PT_1_NULL,DOC_PT_1,');

        w_result_campi_qry := replace(w_result_campi_qry,'URNE_CINERARIE','URNE_CINERARIE_NULL,URNE_CINERARIE,');

--
-- 11/05/2026 (AMonopoli)
-- . metadato LOGO_ANA_NULL: aggiunto x dirottare il campo estratto dalla vista _VAL
--
        w_result_campi_qry := replace(w_result_campi_qry,'LOGO_ANA,','LOGO_ANA_NULL,LOGO_ANA,');
     end if;

     if w_sql_query is not null then
        w_note_log    := 'w_sql_query';
--        w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_query, w_modulo_rif_log, w_session_id);
        w_note_log    := 'w_sql_query_1';
--        w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_query_1, w_modulo_rif_log, w_session_id);
        w_note_log    := 'w_sql_query_2';
--        w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_query_2, w_modulo_rif_log, w_session_id);
        w_note_log    := 'w_sql_query_3';
--        w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_query_3, w_modulo_rif_log, w_session_id);
        begin
--          execute immediate w_sql_query into w_result_query;
          execute immediate w_sql_query_1 into w_result_query_1;
          execute immediate w_sql_query_2 into w_result_query_2;
          execute immediate w_sql_query_3 into w_result_query_3;
        exception
          when others then
               w_note_log    := sqlerrm;
--               w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, '', w_modulo_rif_log, w_session_id);
        end;
     end if;

     w_result_query := w_result_query_1||w_result_query_2||w_result_query_3;
--     w_note_log    := 'w_result_query - pre';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result_query, w_modulo_rif_log, w_session_id);

     w_result_query := replace(w_result_query,'AS FAM_1,','AS FAM_1_NULL,');
     w_result_query := replace(w_result_query,'AS FAM_2,','AS FAM_2_NULL,');
     w_result_query := replace(w_result_query,'AS FAM_3,','AS FAM_3_NULL,');
     w_result_query := replace(w_result_query,'AS FAM_4,','AS FAM_4_NULL,');
     w_result_query := replace(w_result_query,'AS FAM_5,','AS FAM_5_NULL,');
   
     w_result_query := replace(w_result_query,'AS DOC_1,','AS DOC_1_NULL,');
     w_result_query := replace(w_result_query,'AS DOC_CI_1,','AS DOC_CI_1_NULL,');
     w_result_query := replace(w_result_query,'AS DOC_LP_1,','AS DOC_LP_1_NULL,');
     w_result_query := replace(w_result_query,'AS DOC_PS_1,','AS DOC_PS_1_NULL,');
     w_result_query := replace(w_result_query,'AS DOC_PT_1,','AS DOC_PT_1_NULL,');

     w_result_query := replace(w_result_query,'AS URNE_CINERARIE,','AS URNE_CINERARIE_NULL,');

     w_result_query := replace(w_result_query,'AS LOGO_ANA','AS LOGO_ANA_NULL');

     w_query_logo := w_query_logo||
                       ', f_SCAW_catalogo_FAM('''||w_cod_eve||''','''||w_cod_mov||''','''','''||w_data_reg||''','''||w_anno_pratica_eve||''','''||w_pratica_eve||''',''1'') AS FAM_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_FAM('''||w_cod_eve||''','''||w_cod_mov||''','''','''||w_data_reg||''','''||w_anno_pratica_eve||''','''||w_pratica_eve||''',''2'') AS FAM_2';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_FAM('''||w_cod_eve||''','''||w_cod_mov||''','''','''||w_data_reg||''','''||w_anno_pratica_eve||''','''||w_pratica_eve||''',''3'') AS FAM_3';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_FAM('''||w_cod_eve||''','''||w_cod_mov||''','''','''||w_data_reg||''','''||w_anno_pratica_eve||''','''||w_pratica_eve||''',''4'') AS FAM_4';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_FAM('''||w_cod_eve||''','''||w_cod_mov||''','''','''||w_data_reg||''','''||w_anno_pratica_eve||''','''||w_pratica_eve||''',''5'') AS FAM_5';
 

     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_DOC('''||w_matricola||''',''XX'','''',''1'') AS DOC_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_DOC('''||w_matricola||''',''CI'','''',''1'') AS DOC_CI_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_DOC('''||w_matricola||''',''LP'','''||w_ente_lp||''',''1'') AS DOC_LP_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_DOC('''||w_matricola||''',''PS'','''',''1'') AS DOC_PS_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_DOC('''||w_matricola||''',''PTCC'','''',''1'') AS DOC_PT_1';

     w_query_logo := w_query_logo||chr(10)||
                       ', f_SCAW_catalogo_AUC('''||w_matricola||''',''1'') AS URNE_CINERARIE';

     w_query_logo := w_query_logo||chr(10)||
                       ', inp.allegato_blob AS LOGO_ANA';

     w_query_logo := w_query_logo||chr(10)||
                       'from arcinp inp, SCAW_'||w_session_id||'_val v'||chr(10)||
                       'where inp.parametro = ''LOGO_ANA''';
  end if;

  w_query_from   := ' from SCAW_'||w_session_id||'_val v';
  w_result_query := replace(w_result_query,w_query_from,w_query_logo);
--  w_note_log    := 'w_result_query - post';
--  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result_query, w_modulo_rif_log, w_session_id);

  w_result := w_result||w_result_campi_def;
  w_result := w_result||'</definitions>'||chr(10);
  w_result := w_result||'<queryes>'||chr(10);
  w_result := w_result||'<query id="dati"'||chr(10);
  w_result := w_result||'help_query_alias="d"'||chr(10);
  w_result := w_result||'help_field_aliases="'||w_result_campi_qry||'">'||chr(10);

  w_result := w_result||w_result_query||chr(10);
  w_result := w_result||'</query>'||chr(10);
  w_result := w_result||'</queryes>'||chr(10);
  w_result := w_result||'<staticData />'||chr(10);
  w_result := w_result||'</documentRoot>';

  w_sql_drop_viw := 'drop view SCAW_'||w_session_id||'_int'||chr(10);
  begin
    execute immediate w_sql_drop_viw;
  end;

  w_note_log    := w_anagrafe||' - '||w_tipo_evento||' - '||w_anno_pratica||' - '||w_pratica;
  if w_matricola is not null then
     w_note_log := w_note_log||' (matr. '||w_matricola||')';
  end if;
  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result, w_modulo_rif_log, w_id_rif_log);

  goto fine;

<< fine >>

  return w_result;

end;
/
