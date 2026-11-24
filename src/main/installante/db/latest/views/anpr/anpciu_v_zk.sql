--liquibase formatted sql
--changeset amonopoli:202604211310 runAlways:true runOnChange:true stripComments:false
create or replace function f_ANPR_get_note_ws
(a_id_operazione	IN	number
,a_note_ws              IN	varchar2
,a_data_invio_ws	IN	number
,a_data_reg		IN	number
)

return clob

IS

cursor sel_err is
select e.ID_OPERAZIONE
     , e.DATA_ORA       
     , e.SEQUENZA       
     , e.CODICE_ERRORE
     , e.TIPO_ERRORE    
     , e.TESTO_ERRORE   
     , e.FLAG_ANOMALIA
     , to_char(data_ora,'dd/mm/yyyy hh24:mi:ss') data_ora_char
     , decode(tipo_errore, 'I', 'I',
         decode(substr(e.testo_errore,1,15),'Informazioni su','I', e.tipo_errore)) w_tipo_errore
  from anperr e
 where id_operazione = a_id_operazione
--   and flag_anomalia is null
UNION
select a_id_operazione
     , to_date(nvl(a_data_invio_ws,a_data_reg),'j') data_ora
     , 0 sequenza
     , to_char(null) codice_errore
     , 'E'
     , 'Errore di comunicazione con ANPR (verificare log)' testo_errore
     , to_char(null) flag_anomalia
     , to_char(to_date(nvl(a_data_invio_ws,a_data_reg),'j'),'dd/mm/yyyy hh24:mi:ss') data_ora_char
     , 'E' w_tipo_errore
  from dual
 where upper(a_note_ws) like 'KO%VIS%LOG%'
 order by 2, 3
;

w_conta			number;
w_tipo_errore_prec	varchar2(1) := ' ';

w_lista_note		clob;

begin
  for rec in sel_err loop
      if w_tipo_errore_prec != rec.w_tipo_errore then
         w_conta := 0;
      end if;
      if w_conta = 0 then
         if rec.w_tipo_errore = 'E' then
            w_lista_note := 'Lista errori:';
         elsif rec.w_tipo_errore = 'W' then
            w_lista_note := w_lista_note||chr(10)||chr(10)||'Lista warning:';
         elsif rec.w_tipo_errore = 'I' then
            w_lista_note := w_lista_note||chr(10)||chr(10)||'Lista info';
         end if;
      end if;
      w_conta := w_conta + 1;
      w_lista_note := w_lista_note||chr(10)||w_conta||'. '||rec.testo_errore;

      w_tipo_errore_prec := rec.w_tipo_errore;
  end loop;
 
  w_lista_note := ltrim(w_lista_note,chr(10));
--  w_lista_note := replace(w_lista_note,chr(10),'<br/>');

  return w_lista_note;

end;
/
create or replace function f_ANPR_get_info_ws
(a_id_operazione	IN	number
,a_note_ws		IN	varchar2
,a_data_invio_ws	IN	number
,a_data_reg		IN	number
)

return clob

IS

cursor sel_err is
select e.*
     , to_char(data_ora,'dd/mm/yyyy hh24:mi:ss') data_ora_char
     , decode(tipo_errore, 'I', 'I',
         decode(substr(e.testo_errore,1,15),'Informazioni su','I', e.tipo_errore)) w_tipo_errore
  from anperr e
 where id_operazione = a_id_operazione
   and flag_anomalia is not null
UNION
select a_id_operazione
     , to_date(nvl(a_data_invio_ws,a_data_reg),'j') data_ora
     , 0 sequenza
     , to_char(null) codice_errore
     , 'I'
     , a_note_ws testo_errore
     , to_char(null) flag_anomalia
     , to_char(to_date(nvl(a_data_invio_ws,a_data_reg),'j'),'dd/mm/yyyy hh24:mi:ss') data_ora_char
     , 'I' w_tipo_errore
  from dual
 where upper(a_note_ws) like 'FORZATO%INVIO%WS%'
 order by 2, 3
;

w_conta			number;
w_tipo_errore_prec	varchar2(1) := ' ';

w_lista_info		clob;

begin
  for rec in sel_err loop
      if w_tipo_errore_prec != rec.w_tipo_errore then
         w_conta := 0;
      end if;
      if w_conta = 0 then
         if rec.w_tipo_errore = 'W' then
            w_lista_info := 'Lista warning:';
         elsif rec.w_tipo_errore = 'I' then
            w_lista_info := w_lista_info||chr(10)||chr(10)||'Lista info';
         end if;
      end if;
      w_conta := w_conta + 1;
      w_lista_info := w_lista_info||chr(10)||w_conta||'. '||rec.testo_errore;

      w_tipo_errore_prec := rec.w_tipo_errore;
  end loop;

  w_lista_info := ltrim(w_lista_info,chr(10));
  w_lista_info := replace(w_lista_info,chr(10),'<br/>');

  return w_lista_info;

end;
/
create or replace view anpciu_v_zk
AS
select ciu.* 
     , substr(ciu.archivio_rif,1,3) archivio_rif_ric
     , to_char(null) info_ws
     , decode(ciu.flag_invio_ws, '', f_ANPR_get_note_ws(ciu.id_operazione,ciu.note_ws,ciu.data_invio_ws,ciu.data_reg)) note_ws_vis
     , decode(ciu.flag_invio_ws, 'S', f_ANPR_get_info_ws(ciu.id_operazione,ciu.note_ws,ciu.data_invio_ws,ciu.data_reg)) info_ws_vis
     , to_date(ciu.data_rif,'j') d_data_rif
     , to_date(ciu.data_reg,'j') d_data_reg
     , to_date(ciu.data_invio_ws,'j') d_data_invio_ws
     , decode(upper(substr(ciu.note_ws,1,7)),'FORZATO',ciu.note_ws,f_ANPR_des_esito_ciu(ciu.esito_anpr)) des_esito_anpr
     , f_ANPR_flag_annullamento(ciu.id_operazione) flag_annullamento
     , f_ANPR_id_rif_ciu(ciu.archivio_rif, ciu.anno_rif, ciu.numero_rif, ciu.id_anadoc, ciu.id_anamsi, ciu.matricola, ciu.fascia_fam, ciu.cod_fam) id_rif
     , f_ANPR_des_evento_ciu_x_id_rif(ciu.archivio_rif,ciu.servizio,ciu.tipo_operazione,
         f_ANPR_id_rif_ciu(ciu.archivio_rif, ciu.anno_rif, ciu.numero_rif, ciu.id_anadoc, ciu.id_anamsi, ciu.matricola, ciu.fascia_fam, ciu.cod_fam),
         ciu.matricola, ciu.fascia_fam, ciu.cod_fam, '') DES_EVENTO
     , f_ANPR_des_evento_ciu_x_id_rif(ciu.archivio_rif,ciu.servizio,ciu.tipo_operazione,
         f_ANPR_id_rif_ciu(ciu.archivio_rif, ciu.anno_rif, ciu.numero_rif, ciu.id_anadoc, ciu.id_anamsi, ciu.matricola, ciu.fascia_fam, ciu.cod_fam),
         ciu.matricola, ciu.fascia_fam, ciu.cod_fam, 'DETTAGLIO') DES_EVENTO_DETTAGLIO
     , to_number(
        f_ANPR_des_evento_ciu_x_id_rif(ciu.archivio_rif,ciu.servizio,ciu.tipo_operazione,
         f_ANPR_id_rif_ciu(ciu.archivio_rif, ciu.anno_rif, ciu.numero_rif, ciu.id_anadoc, ciu.id_anamsi, ciu.matricola, ciu.fascia_fam, ciu.cod_fam),
         ciu.matricola, ciu.fascia_fam, ciu.cod_fam, 'ID_ANATPR')) ID_ANATPR
  from anpciu ciu
 where archivio_rif in ('MOV','MSI','DOC')
/
comment on table anpciu_v_zk is 'ANPR - Comunicazioni in Uscita (view) - ZK'
/
