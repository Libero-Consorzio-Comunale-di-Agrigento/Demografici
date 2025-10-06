--liquibase formatted sql
--changeset snocca:202212061701 runOnChange:true
create or replace function f_CIV_testo_formula_chiusura
(a_formula		IN	varchar2
,a_tipo_atto		IN	number
,a_anno			IN	number
,a_parte		IN	number
,a_serie		IN	varchar2
,a_numero_atti		IN	number
,a_atto_min		IN	number
,a_data_reg_min		IN	varchar2
,a_atto_max		IN	number
,a_data_reg_max		IN	varchar2
,a_autorita		IN	varchar2
,a_ordinanza_del	IN	varchar2
,a_data_ordinanza	IN	varchar2
,a_data_restituzione	IN	varchar2
,a_data_chiusura	IN	varchar2
)

return clob

IS

w_des_tipo_atto   varchar2(255);
w_des_parte       varchar2(255);
w_des_numero_atti varchar2(255);
w_comune_utente   varchar2(255);
w_data_chiusura   varchar2(255);

w_testo           clob;

begin
  if a_tipo_atto = 1 then
     w_des_tipo_atto := 'CITTADINANZA';
  elsif a_tipo_atto = 2 then
     w_des_tipo_atto := 'NASCITA';
  elsif a_tipo_atto = 4 then
     w_des_tipo_atto := 'MATRIMONIO';
  elsif a_tipo_atto = -4 then
     w_des_tipo_atto := 'UNIONE CIVILE';
  elsif a_tipo_atto = 5 then
     w_des_tipo_atto := 'MORTE';
  end if;

  if a_parte = 1 then
     w_des_parte := 'prima';
  elsif a_parte = 2 then
     w_des_parte := 'seconda';
  end if;

  if nvl(a_numero_atti,0) = 0 then
     w_des_numero_atti := 'ZERO';
  else
     w_des_numero_atti := a_numero_atti;
  end if;

  w_comune_utente := f_get_comune_cliente('DES_COM');

  if a_data_chiusura like '01/01%' then
     w_data_chiusura := 'primo gennaio '||substr(a_data_chiusura,7,4);
  else
     w_data_chiusura := a_data_chiusura;
  end if;

  if a_formula in ('201','202','203') then
     if a_tipo_atto = 1 then
        w_testo := 'Questo registro degli atti di '||w_des_tipo_atto;
     elsif a_tipo_atto = -4 then
        w_testo := 'Questa '||w_des_parte||' parte del registro degli atti di '||w_des_tipo_atto;
     else
        if nvl(a_serie, 'X') = 'X' then
          w_testo := 'Questa '||w_des_parte||' parte del registro degli atti di '||w_des_tipo_atto;
        else
          w_testo := 'Questa '||w_des_parte||' parte, serie '||upper(a_serie)||' del registro degli atti di '||w_des_tipo_atto;
        end if;
     end if;

  elsif a_formula in ('205','206') then
     w_testo := 'Il presente registro degli atti di '||w_des_tipo_atto;

  else
     w_testo := '';
     goto fine;
  end if;

  w_testo := w_testo||' per l''anno '||a_anno;

  if a_formula = '206' then
     w_testo := w_testo||' nel quale sono stati';
  else
     w_testo := w_testo||' sul quale sono';
  end if;

  if a_formula = '203' then
     w_testo := w_testo||' fino ad oggi';
  end if;

  w_testo := w_testo||' iscritti '||w_des_numero_atti||' atti,';

  if a_formula = '206' then
     w_testo := w_testo||' e che gia'' fu chiuso con lo stesso numero di atti,';
     w_testo := w_testo||' addi'' '||to_char(sysdate,'dd/mm/yyyy');
     w_testo := w_testo||' per essere rimesso a '||a_autorita;
     w_testo := w_testo||' come da ordinanza del '||a_ordinanza_del; 
     w_testo := w_testo||' in data '||a_data_ordinanza;
     w_testo := w_testo||' viene oggi definitivamente chiuso,';
     w_testo := w_testo||' perche'' restituito a questo Ufficio di Stato Civile';
     w_testo := w_testo||' soltanto addi'' '||a_data_restituzione;
     w_testo := w_testo||' con avvertenza che gli atti successivi per l''anno '||a_anno;
     w_testo := w_testo||' sono raccolti nell''apposito registro suppletivo.';

  else
     w_testo := w_testo||' il primo portante la data del '||nvl(a_data_reg_min, '---');

     if a_formula = '205' then
        if a_atto_min is null then
          w_testo := w_testo||' ed il numero d''ordine ---,';
        else
          w_testo := w_testo||' ed il numero d''ordine '||a_atto_min||',';
        end if;
     end if;

     w_testo := w_testo||' e l''ultimo la data del '||nvl(a_data_reg_max, '---')||' ';

     if a_formula = '205' then
        if a_atto_max is null then
          w_testo := w_testo||' ed il numero d''ordine ---,';
        else
          w_testo := w_testo||' ed il numero d''ordine '||a_atto_max||',';
        end if;
        w_testo := w_testo||' e che servi'' di  supplemento al registro analogo,';
        w_testo := w_testo||' trasportato all''Ufficio del '||a_autorita;
        w_testo := w_testo||' come da ordinanza del '||a_ordinanza_del;
        w_testo := w_testo||' in data '||a_data_ordinanza;
     end if;

     if a_formula = '202' then
        w_testo := w_testo||'ed al quale segue un supplemento';
        w_testo := w_testo||' per giungere alla fine dell''anno in corso,';
     end if;

     if a_tipo_atto = 1 then
        w_testo := w_testo||' e'' stato oggi chiuso';
     else
        w_testo := w_testo||' e'' stata oggi chiusa';
     end if;

     if a_formula = '203' then
        w_testo := w_testo||' in via straordinaria dal sottoscritto, essendone stato '||
                   'ordinato il trasporto nell''ufficio del '||a_autorita||' '||
                   'con ordinanza del '||a_ordinanza_del||' in data '||a_data_ordinanza||' '||
                   'e cio''';
     else
        w_testo := w_testo||' dal sottoscritto Ufficiale dello Stato Civile del Comune di '||w_comune_utente;
     end if;

     w_testo := w_testo||' a norma degli artt. 1 e segg. del decreto del Ministro dell''Interno del 27 Febbraio 2001.';
  end if;

  w_testo := w_testo||chr(10);
  w_testo := w_testo||'Cosi'' fatto in '||w_comune_utente||' il giorno '||w_data_chiusura||'.';
  w_testo := w_testo||chr(10);
  w_testo := w_testo||'L''UFFICIALE DELLO STATO CIVILE';
  w_testo := w_testo||chr(10);
  w_testo := w_testo||'_______________________________';

<< fine >>
  return w_testo;

end;
/
