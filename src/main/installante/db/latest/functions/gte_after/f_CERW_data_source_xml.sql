--liquibase formatted sql
--changeset amonopoli:202410171155_3 runOnChange:true stripComments:false
create or replace function f_CERW_data_source_xml
(a_session_id       in       varchar2)

return clob

IS

-- 
-- 08/10/2024 (AM)
-- la function viene utilizzata:
-- 1. dalla certificazione da portale: 
--    viene eseguita con le viste già create (procedure ..._viw).
--    prende in input la session_id oracle passata del package che si occupa dell'elaborazione
-- 2. dalla certificazione zk:
--    prende in input l'id_emissione del certificazione (campo calcolato: anno_emissione||lpad(progr_emissione,6,'0')
--    in questo caso le viste di riferimento (procedure ..._viw) vengono create all'interno di questa stessa function
--

cursor sel_cer is
select inc.*
     , cem.cod_certificato
     , cem.cognome_nome
     , decode(cem.data_storico,'','','SI') storico
     , cem.data_storico data_storico
     , dce.tipo_archivio
     , ana.fascia fascia_ana
  from anaana ana
     , cerdce dce
     , cercem cem
     , cerinc_v inc
 where ana.matricola (+)   = inc.matricola
   and dce.cod_certificato = cem.cod_certificato
   and cem.anno_emissione  = inc.anno_emissione
   and cem.progr_emissione = inc.progr_emissione
   and inc.id_emissione    = a_session_id
;

w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_check_db	number;

w_tipo_archivio		number;
w_matricola		number;
w_ufficio		number;
w_anno			number;
w_atto			number;
w_parte			number;
w_serie			varchar2(255);
w_storico		varchar2(255);
w_data_cert_j		number;
w_cod_certificato	varchar2(255);
w_progr_emissione	number;
w_anno_emissione	number;
w_cognome_nome		varchar2(255);
w_fascia_ana		number;
w_session_id		number := a_session_id;

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

w_operazione_log		varchar2(255) := 'f_CERW_data_source_xml';
w_note_log			varchar2(4000);
w_modulo_rif_log		varchar2(255);
w_id_rif_log			varchar2(255);
w_return_log			number;

begin
--  p_CERW_riga_intesta_viw(p_tipo_archivio,'');
--  p_CERW_riga_intesta_viw(0,'');
--
--  p_CERW_riga_dati_viw(p_tipo_archivio, rec_cerinc.matricola, rec_cerinc.ufficio, rec_cerinc.anno, rec_cerinc.atto, rec_cerinc.parte, rec_cerinc.serie,
--                       p_storico, p_data_cert, p_cod_certificato,
--                       rec_cerinc.progr_emissione, rec_cerinc.anno_emissione,
--                       w_session_id, '', '');
--  p_CERW_riga_dati_viw(0,114395,'','','','','','','','CRE',248,2020,'','','');

  if a_session_id like to_char(sysdate,'yyyy')||'%' and length(a_session_id) = 10 then
     goto certificazione_zk;
  else
     goto xml_row;
  end if;

<< certificazione_zk >>     
  w_tipo_ogg := 'tab';
  w_nome_ogg := 'CERW_'||w_session_id||'_INT';
  w_check_db := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,'');

-- dbms_output.put_line(w_nome_ogg||' - w_check_db: '||w_check_db);
  if w_check_db = 0 then
     w_modulo_rif_log := 'CER';
     for rec in sel_cer loop
-- dbms_output.put_line('dentro for loop sel_cer');
         w_tipo_archivio   := nvl(rec.tipo_archivio,-1);
         w_matricola       := nvl(rec.matricola,-1);
         w_ufficio         := nvl(rec.ufficio,-1);
         w_anno            := nvl(rec.anno,-1);
         w_atto            := nvl(rec.atto,-1);
         w_parte           := rec.parte;
         w_serie           := rec.serie;
         w_storico         := rec.storico;
         w_data_cert_j     := rec.data_storico;
         w_cod_certificato := rec.cod_certificato;
         w_progr_emissione := rec.progr_emissione;
         w_anno_emissione  := rec.anno_emissione;
         w_cognome_nome    := rec.cognome_nome;
         w_fascia_ana      := nvl(rec.fascia_ana,-1);

         w_session_id      := f_tabrep_terminale();
     end loop;

-- dbms_output.put_line('prima di riga_intesta_viw');
     p_CERW_riga_intesta_viw(w_tipo_archivio,'');
-- dbms_output.put_line('prima di riga_dati_viw');
     p_CERW_riga_dati_viw(w_tipo_archivio, w_matricola, w_ufficio, w_anno, w_atto, w_parte, w_serie,
                          w_storico, w_data_cert_j, w_cod_certificato,
                          w_progr_emissione, w_anno_emissione,
                          w_session_id, '', '');
-- dbms_output.put_line('dopo di riga_dati_viw');

     goto xml_documentRoot;
  end if;

<< xml_row >>
  w_modulo_rif_log := 'WEB';

  begin
    select nvl(max(colno),0) into w_count
      from col
     where tname = 'CERW_'||w_session_id||'_INT'
    ;
  end;

-- dbms_output.put_line('w_count: '||w_count);
  if w_count = 0 then 
--     w_note_log    := 'CERW_'||w_session_id||'_INT - NON trovata';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result, w_modulo_rif_log, a_session_id);
     goto fine; 
  else
--     w_note_log    := 'CERW_'||w_session_id||'_INT - trovata';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result, w_modulo_rif_log, a_session_id);
     null;
  end if;

  for i in 1..w_count loop
      if i = 1 then
         w_sql := 'select ''<row>''||chr(10)||'||chr(10);
      elsif i > 1 and mod(i,50) = 1 then
         w_sql := 'select ';
      end if;
      w_sql := w_sql||'''<f>''||i.INT_'||to_char(i)||'||''</f>''||';
      w_sql := w_sql||'''<v>''||v.VAL_'||to_char(i)||'||''</v>''';
      if mod(i,50) = 0 then
         w_sql := w_sql||'from CERW_'||w_session_id||'_int i, CERW_'||w_session_id||'_val v'||chr(10);
         begin
           execute immediate w_sql into w_result_100;
         end;
         w_result := w_result||chr(10)||w_result_100;
      else
         w_sql := w_sql||'||chr(10)||'||chr(10);
      end if;
  end loop;

  if w_sql is not null then
     w_sql := w_sql||'''</row>'''||chr(10);
     w_sql := w_sql||'from CERW_'||w_session_id||'_int i, CERW_'||w_session_id||'_val v'||chr(10);
  end if;

--  w_note_log    := 'w_sql';
--  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql, w_modulo_rif_log, a_session_id);

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

  w_sql_drop_viw := 'drop view CERW_'||w_session_id||'_int';
  begin
    execute immediate w_sql_drop_viw;
  end;

  w_sql_drop_viw := 'drop view CERW_'||w_session_id||'_val';
  begin
    execute immediate w_sql_drop_viw;
  end;

  w_note_log    := 'w_session: '||w_session_id;
  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result, w_modulo_rif_log, a_session_id);

  goto fine;

<< xml_documentRoot >>
  begin
    select nvl(max(colno),0) into w_count
      from col
     where tname = 'CERW_'||w_session_id||'_INT'
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
     w_sql_campi_def   := w_sql_campi_def||' from CERW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_def_1 := substr(w_sql_campi_def_1,1,length(w_sql_campi_def_1)-2);
     w_sql_campi_def_1 := w_sql_campi_def_1||' from CERW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_def_2 := substr(w_sql_campi_def_2,1,length(w_sql_campi_def_2)-2);
     w_sql_campi_def_2 := w_sql_campi_def_2||' from CERW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_def_3 := substr(w_sql_campi_def_3,1,length(w_sql_campi_def_3)-2);
     w_sql_campi_def_3 := w_sql_campi_def_3||' from CERW_'||w_session_id||'_int i'||chr(10);
  end if;

  if w_sql_campi_qry is not null then
     w_sql_campi_qry   := rtrim(w_sql_campi_qry,''',''||');
     w_sql_campi_qry   := w_sql_campi_qry||' from CERW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_qry_1 := substr(w_sql_campi_qry_1,1,length(w_sql_campi_qry_1)-7);
     w_sql_campi_qry_1 := w_sql_campi_qry_1||' from CERW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_qry_2 := substr(w_sql_campi_qry_2,1,length(w_sql_campi_qry_2)-7);
     w_sql_campi_qry_2 := w_sql_campi_qry_2||' from CERW_'||w_session_id||'_int i'||chr(10);
     w_sql_campi_qry_3 := substr(w_sql_campi_qry_3,1,length(w_sql_campi_qry_3)-7);
     w_sql_campi_qry_3 := w_sql_campi_qry_3||' from CERW_'||w_session_id||'_int i'||chr(10);
  end if;

  if w_sql_query is not null then
     w_sql_query   := substr(w_sql_query,1,length(w_sql_query)-16)||'||chr(10)';
     w_sql_query   := w_sql_query||'||'' from CERW_'||w_session_id||'_val v'' from CERW_'||w_session_id||'_int i'||chr(10);
     w_sql_query_1 := substr(w_sql_query_1,1,length(w_sql_query_1)-2);
     w_sql_query_1 := w_sql_query_1||' from CERW_'||w_session_id||'_int i'||chr(10);
     if w_sql_query_3 is null then
        w_sql_query_2 := substr(w_sql_query_2,1,length(w_sql_query_2)-16)||'||chr(10)';
        w_sql_query_2 := w_sql_query_2||'||'' from CERW_'||w_session_id||'_val v'' from CERW_'||w_session_id||'_int i'||chr(10);
     else
        w_sql_query_2 := substr(w_sql_query_2,1,length(w_sql_query_2)-2);
        w_sql_query_2 := w_sql_query_2||' from CERW_'||w_session_id||'_int i'||chr(10);
     end if;
     w_sql_query_3 := substr(w_sql_query_3,1,length(w_sql_query_3)-16)||'||chr(10)';
     w_sql_query_3 := w_sql_query_3||'||'' from CERW_'||w_session_id||'_val v'' from CERW_'||w_session_id||'_int i'||chr(10);
  end if;

  if w_sql_campi_def is not null then
     w_note_log    := 'w_sql_campi_def';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_def, w_modulo_rif_log, a_session_id);
     w_note_log    := 'w_sql_campi_def_1';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_def_1, w_modulo_rif_log, a_session_id);
     w_note_log    := 'w_sql_campi_def_2';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_def_2, w_modulo_rif_log, a_session_id);
     w_note_log    := 'w_sql_campi_def_3';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_def_3, w_modulo_rif_log, a_session_id);

     begin
--       execute immediate w_sql_campi_def into w_result_campi_def;
       execute immediate w_sql_campi_def_1 into w_result_campi_def_1;
       execute immediate w_sql_campi_def_2 into w_result_campi_def_2;
       execute immediate w_sql_campi_def_3 into w_result_campi_def_3;
     exception
       when others then
            w_note_log    := sqlerrm;
--            w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, '', w_modulo_rif_log, a_session_id);
     end;

     w_result_campi_def := w_result_campi_def_1||w_result_campi_def_2||w_result_campi_def_3;
     w_result_campi_def := replace(w_result_campi_def,'<f>','<metaDato><nomeSimbolico>');
     w_result_campi_def := replace(w_result_campi_def,'</f>','</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');

--
-- 09/10/2024 (AMonopoli)
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
                             '<metaDato><nomeSimbolico>FAM_6</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_6_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_6</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_7</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_7_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_7</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_8</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_8_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_8</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_9</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_9_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_9</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_10</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_10_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_10</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_11</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_11_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_11</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_12</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_12_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_12</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_13</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_13_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_13</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_14</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_14_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_14</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_15</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_15_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_15</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_16</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_16_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_16</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_17</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_17_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_17</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_18</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_18_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_18</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_19</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_19_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_19</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_1_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_1_MIN_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_1_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_2_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_2_MIN_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_2_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_3_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_3_MIN_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_3_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_4_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_4_MIN_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_4_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FAM_5_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FAM_5_MIN_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FAM_5_MIN</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_PT_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_PT_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_PT_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_PT_2</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_PT_2_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_PT_2</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_CC_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_CC_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_CC_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>DOC_CC_2</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>DOC_CC_2_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>DOC_CC_2</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>EVENTI_ANAGRAFE</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>EVENTI_ANAGRAFE_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>EVENTI_ANAGRAFE</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>EVENTI_STATO_CIVILE</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>EVENTI_STATO_CIVILE_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>EVENTI_STATO_CIVILE</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>URNE_CINERARIE</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>URNE_CINERARIE_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>URNE_CINERARIE</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');

     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>ANNOTAZIONI_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>ANNOTAZIONI_1_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>ANNOTAZIONI_1</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>ANNOTAZIONI_2</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>ANNOTAZIONI_2_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>ANNOTAZIONI_2</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>ANNOTAZIONI_3</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>ANNOTAZIONI_3_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>ANNOTAZIONI_3</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>');

--
-- 16/10/2024 (AMonopoli)
-- . metadato FOTO_CIE_NULL: aggiunto x dirottare il campo estratto dalla vista _VAL
-- . metadato FOTO_CIE     : modifica del dataType da "string" a "image"
--
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>FOTO_CIE</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>FOTO_CIE_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>FOTO_CIE</nomeSimbolico><tipo>image</tipo><descrizione>xx</descrizione><path/></metaDato>');

--
-- 10/11/2021 (AMonopoli)
-- . metadato LOGO_CER_NULL: aggiunto x dirottare il campo estratto dalla vista _VAL
-- . metadato LOGO_CER     : modifica del dataType da "string" a "image"
--
     w_result_campi_def := replace(w_result_campi_def,
                             '<metaDato><nomeSimbolico>LOGO_CER</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>',
                                '<metaDato><nomeSimbolico>LOGO_CER_NULL</nomeSimbolico><tipo>string</tipo><descrizione>xx</descrizione><path/></metaDato>'||chr(10)||
                                '<metaDato><nomeSimbolico>LOGO_CER</nomeSimbolico><tipo>image</tipo><descrizione>xx</descrizione><path/></metaDato>');

  end if;

  if w_sql_campi_qry is not null then
     w_note_log    := 'w_sql_campi_qry';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_qry, w_modulo_rif_log, a_session_id);
     w_note_log    := 'w_sql_campi_qry_1';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_qry_1, w_modulo_rif_log, a_session_id);
     w_note_log    := 'w_sql_campi_qry_2';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_qry_2, w_modulo_rif_log, a_session_id);
     w_note_log    := 'w_sql_campi_qry_3';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_campi_qry_3, w_modulo_rif_log, a_session_id);
     begin
--       execute immediate w_sql_campi_qry into w_result_campi_qry;
       execute immediate w_sql_campi_qry_1 into w_result_campi_qry_1;
       execute immediate w_sql_campi_qry_2 into w_result_campi_qry_2;
       execute immediate w_sql_campi_qry_3 into w_result_campi_qry_3;
     exception
       when others then
            w_note_log    := sqlerrm;
--            w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, '', w_modulo_rif_log, a_session_id);
     end;

     w_result_campi_qry := w_result_campi_qry_1||w_result_campi_qry_2||w_result_campi_qry_3;
--
-- 09/10/2024 (AMonopoli)
-- . gestione del doppio metaDato (anche nella versione _NULL) per tutte le variabili relative a sotto-modelli)
--
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_1,','FAM_1_NULL,FAM_1,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_2,','FAM_2_NULL,FAM_2,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_3,','FAM_3_NULL,FAM_3,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_4,','FAM_4_NULL,FAM_4,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_5,','FAM_5_NULL,FAM_5,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_6,','FAM_6_NULL,FAM_6,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_7,','FAM_7_NULL,FAM_7,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_8,','FAM_8_NULL,FAM_8,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_9,','FAM_9_NULL,FAM_9,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_10,','FAM_10_NULL,FAM_10,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_11,','FAM_11_NULL,FAM_11,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_12,','FAM_12_NULL,FAM_12,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_13,','FAM_13_NULL,FAM_13,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_14,','FAM_14_NULL,FAM_14,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_15,','FAM_15_NULL,FAM_15,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_16,','FAM_16_NULL,FAM_16,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_17,','FAM_17_NULL,FAM_17,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_18,','FAM_18_NULL,FAM_18,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_19,','FAM_19_NULL,FAM_19,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_1_MIN,','FAM_1_MIN_NULL,FAM_1_MIN,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_2_MIN,','FAM_2_MIN_NULL,FAM_2_MIN,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_3_MIN,','FAM_3_MIN_NULL,FAM_3_MIN,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_4_MIN,','FAM_4_MIN_NULL,FAM_4_MIN,');
     w_result_campi_qry := replace(w_result_campi_qry,'FAM_5_MIN,','FAM_5_MIN_NULL,FAM_5_MIN,');
     w_result_campi_qry := replace(w_result_campi_qry,'DOC_1,','DOC_1_NULL,DOC_1,');
     w_result_campi_qry := replace(w_result_campi_qry,'DOC_PT_1,','DOC_PT_1_NULL,DOC_PT_1,');
     w_result_campi_qry := replace(w_result_campi_qry,'DOC_PT_2,','DOC_PT_2_NULL,DOC_PT_2,');
     w_result_campi_qry := replace(w_result_campi_qry,'DOC_CC_1,','DOC_CC_1_NULL,DOC_CC_1,');
     w_result_campi_qry := replace(w_result_campi_qry,'DOC_CC_2,','DOC_CC_2_NULL,DOC_CC_2,');
     w_result_campi_qry := replace(w_result_campi_qry,'EVENTI_ANAGRAFE,','EVENTI_ANAGRAFE_NULL,EVENTI_ANAGRAFE,');
     w_result_campi_qry := replace(w_result_campi_qry,'EVENTI_STATO_CIVILE,','EVENTI_STATO_CIVILE_NULL,EVENTI_STATO_CIVILE,');
     w_result_campi_qry := replace(w_result_campi_qry,'URNE_CINERARIE,','URNE_CINERARIE_NULL,URNE_CINERARIE,');

     w_result_campi_qry := replace(w_result_campi_qry,'ANNOTAZIONI_1,','ANNOTAZIONI_1_NULL,ANNOTAZIONI_1,');
     w_result_campi_qry := replace(w_result_campi_qry,'ANNOTAZIONI_2,','ANNOTAZIONI_2_NULL,ANNOTAZIONI_2,');
     w_result_campi_qry := replace(w_result_campi_qry,'ANNOTAZIONI_3,','ANNOTAZIONI_3_NULL,ANNOTAZIONI_3,');

--
-- 16/10/2024 (AMonopoli)
-- . metadato FOTO_CIE_NULL: aggiunto x dirottare il campo estratto dalla vista _VAL
--
     w_result_campi_qry := replace(w_result_campi_qry,'FOTO_CIE,','FOTO_CIE_NULL,FOTO_CIE,');

--
-- 10/11/2021 (AMonopoli)
-- . metadato LOGO_CER_NULL: aggiunto x dirottare il campo estratto dalla vista _VAL
--
     w_result_campi_qry := replace(w_result_campi_qry,'LOGO_CER,','LOGO_CER_NULL,LOGO_CER,');
  end if;

  if w_sql_query is not null then
     w_note_log    := 'w_sql_query';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_query, w_modulo_rif_log, a_session_id);
     w_note_log    := 'w_sql_query_1';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_query_1, w_modulo_rif_log, a_session_id);
     w_note_log    := 'w_sql_query_2';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_query_2, w_modulo_rif_log, a_session_id);
     w_note_log    := 'w_sql_query_3';
--     w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_query_3, w_modulo_rif_log, a_session_id);
     begin
--       execute immediate w_sql_query into w_result_query;
       execute immediate w_sql_query_1 into w_result_query_1;
       execute immediate w_sql_query_2 into w_result_query_2;
       execute immediate w_sql_query_3 into w_result_query_3;
     exception
       when others then
            w_note_log    := sqlerrm;
--            w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, '', w_modulo_rif_log, a_session_id);
     end;
  end if;

  w_result_query := w_result_query_1||w_result_query_2||w_result_query_3;
--  w_note_log    := 'w_result_query - pre';
--  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result_query, w_modulo_rif_log, a_session_id);

  w_result_query := replace(w_result_query,'AS FAM_1,','AS FAM_1_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_2,','AS FAM_2_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_3,','AS FAM_3_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_4,','AS FAM_4_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_5,','AS FAM_5_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_6,','AS FAM_6_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_7,','AS FAM_7_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_8,','AS FAM_8_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_9,','AS FAM_9_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_10,','AS FAM_10_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_11,','AS FAM_11_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_12,','AS FAM_12_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_13,','AS FAM_13_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_14,','AS FAM_14_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_15,','AS FAM_15_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_16,','AS FAM_16_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_17,','AS FAM_17_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_18,','AS FAM_18_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_19,','AS FAM_19_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_1_MIN,','AS FAM_1_MIN_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_2_MIN,','AS FAM_2_MIN_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_3_MIN,','AS FAM_3_MIN_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_4_MIN,','AS FAM_4_MIN_NULL,');
  w_result_query := replace(w_result_query,'AS FAM_5_MIN,','AS FAM_5_MIN_NULL,');
  w_result_query := replace(w_result_query,'AS DOC_1,','AS DOC_1_NULL,');
  w_result_query := replace(w_result_query,'AS DOC_PT_1,','AS DOC_PT_1_NULL,');
  w_result_query := replace(w_result_query,'AS DOC_PT_2,','AS DOC_PT_2_NULL,');
  w_result_query := replace(w_result_query,'AS DOC_CC_1,','AS DOC_CC_1_NULL,');
  w_result_query := replace(w_result_query,'AS DOC_CC_2,','AS DOC_CC_2_NULL,');
  w_result_query := replace(w_result_query,'AS EVENTI_ANAGRAFE,','AS EVENTI_ANAGRAFE_NULL,');
  w_result_query := replace(w_result_query,'AS EVENTI_STATO_CIVILE,','AS EVENTI_STATO_CIVILE_NULL,');
  w_result_query := replace(w_result_query,'AS URNE_CINERARIE,','AS URNE_CINERARIE_NULL,');
  w_result_query := replace(w_result_query,'AS FOTO_CIE','AS FOTO_CIE_NULL');

  w_result_query := replace(w_result_query,'AS ANNOTAZIONI_1,','AS ANNOTAZIONI_1_NULL,');
  w_result_query := replace(w_result_query,'AS ANNOTAZIONI_2,','AS ANNOTAZIONI_2_NULL,');
  w_result_query := replace(w_result_query,'AS ANNOTAZIONI_3,','AS ANNOTAZIONI_3_NULL,');

  w_result_query := replace(w_result_query,'AS LOGO_CER','AS LOGO_CER_NULL');

  if w_tipo_archivio = 0 then
     w_data_cert_j := nvl(w_data_cert_j,to_char(sysdate,'j'));
     w_query_logo := w_query_logo||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),1) AS FAM_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),2) AS FAM_2';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),3) AS FAM_3';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),4) AS FAM_4';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),5) AS FAM_5';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),6) AS FAM_6';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),7) AS FAM_7';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),8) AS FAM_8';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),9) AS FAM_9';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),10) AS FAM_10';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),11) AS FAM_11';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),12) AS FAM_12';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),13) AS FAM_13';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),14) AS FAM_14';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),15) AS FAM_15';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),16) AS FAM_16';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),17) AS FAM_17';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),18) AS FAM_18';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),19) AS FAM_19';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_MIN_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),1) AS FAM_1_MIN';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_MIN_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),2) AS FAM_2_MIN';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_MIN_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),3) AS FAM_3_MIN';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_MIN_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),4) AS FAM_4_MIN';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_FAM_MIN_zk('||w_matricola||','''','||w_fascia_ana||',to_date('''||w_data_cert_j||''',''j''),5) AS FAM_5_MIN';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_DOC('||w_matricola||',''XX'',1) AS DOC_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_DOC('||w_matricola||',''PT'',1) AS DOC_PT_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_DOC('||w_matricola||',''PT'',2) AS DOC_PT_2';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_DOC('||w_matricola||',''CC'',1) AS DOC_CC_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_DOC('||w_matricola||',''CC'',2) AS DOC_CC_2';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_EVE('||w_matricola||',1) AS EVENTI_ANAGRAFE';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_ESC('||w_matricola||',1) AS EVENTI_STATO_CIVILE';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_AUC('||w_matricola||',1) AS URNE_CINERARIE';
     w_query_logo := w_query_logo||chr(10)||
                       ', (select dcn.foto_cie from anadcn dcn where matricola = '||w_matricola||' and rownum = 1) AS FOTO_CIE';
     w_query_logo := w_query_logo||chr(10)||
                       ', inp.allegato_blob AS LOGO_CER';

     w_query_logo := w_query_logo||chr(10)||
                         'from arcinp inp, CERW_'||w_session_id||'_val v'||chr(10)||
                         'where inp.parametro = ''LOGO_CER''';

  elsif w_tipo_archivio = 6 then
     w_query_logo := w_query_logo||', to_char(null) AS FAM_1';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_2';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_3';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_4';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_5';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_6';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_7';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_8';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_9';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_10';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_11';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_12';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_13';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_14';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_15';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_16';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_17';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_18';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_19';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_1_MIN';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_2_MIN';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_3_MIN';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_4_MIN';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FAM_5_MIN';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS DOC_1';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS DOC_PT_1';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS DOC_PT_2';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS DOC_CC_1';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS DOC_CC_2';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS EVENTI_ANAGRAFE';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS EVENTI_STATO_CIVILE';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS URNE_CINERARIE';
     w_query_logo := w_query_logo||chr(10)||', to_char(null) AS FOTO_CIE';
     w_query_logo := w_query_logo||chr(10)||', inp.allegato_blob AS LOGO_CER';

     w_query_logo := w_query_logo||chr(10)||
                       'from arcinp inp, CERW_'||w_session_id||'_val v'||chr(10)||
                       'where inp.parametro = ''LOGO_CER''';
  else
     w_query_logo := w_query_logo||
                       ', f_CERW_catalogo_ANN('||w_tipo_archivio||','||w_ufficio||','||w_anno||','||w_atto||','''||w_parte||''','''||w_serie||''',1) AS ANNOTAZIONI_1';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_ANN('||w_tipo_archivio||','||w_ufficio||','||w_anno||','||w_atto||','''||w_parte||''','''||w_serie||''',2) AS ANNOTAZIONI_2';
     w_query_logo := w_query_logo||chr(10)||
                       ', f_CERW_catalogo_ANN('||w_tipo_archivio||','||w_ufficio||','||w_anno||','||w_atto||','''||w_parte||''','''||w_serie||''',3) AS ANNOTAZIONI_3';
     w_query_logo := w_query_logo||chr(10)||
                       ', inp.allegato_blob AS LOGO_CER';

     w_query_logo := w_query_logo||chr(10)||
                       'from arcinp inp, CERW_'||w_session_id||'_val v'||chr(10)||
                       'where inp.parametro = ''LOGO_CER''';
  end if;

  w_query_from   := ' from CERW_'||w_session_id||'_val v';
  w_result_query := replace(w_result_query,w_query_from,w_query_logo);
--  w_note_log    := 'w_result_query - post';
--  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result_query, w_modulo_rif_log, a_session_id);

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

  w_sql_drop_viw := 'drop view CERW_'||w_session_id||'_int'||chr(10);
  begin
    execute immediate w_sql_drop_viw;
  end;

  w_note_log    := w_cod_certificato||' - '||w_cognome_nome||' ('||w_progr_emissione||'/'||w_anno_emissione||')';
  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_result, w_modulo_rif_log, a_session_id);

  goto fine;

<< fine >>

  return w_result;

end;
/
