--liquibase formatted sql
--changeset amonopoli:202602031425_1 runOnChange:true stripComments:false
create or replace function f_SDIR_des_diritto
(a_anno_emissione	IN	number
,a_progr_emissione	IN	number
,a_cod_diritto		IN	number
,a_modalita_rilascio	IN	number
)

return varchar2

IS

w_des_diritto_def	varchar2(255);
w_des_diritto		varchar2(255);

begin
  if a_cod_diritto = 1 then
     w_des_diritto_def := 'Diritti Segreteria';
  elsif a_cod_diritto = 2 then
     w_des_diritto_def := 'Diritti Stato Civ.';
  elsif a_cod_diritto = 3 then
     w_des_diritto_def := 'Carta d''Identita''';
  elsif a_cod_diritto = 4 then
     w_des_diritto_def := 'Rimborso Stampati';
  elsif a_cod_diritto = 9 then
     w_des_diritto_def := 'Bollo';
  end if;

  if a_cod_diritto is not null then
     if a_cod_diritto = 9 then
        begin
          select dtd.descrizione
            into w_des_diritto
            from cerdtd dtd, cerdri dri
           where dtd.fascia_tariffaria = dri.fascia_tariffaria
             and dtd.cod_diritto       = a_cod_diritto
             and dri.cod_ri            = a_modalita_rilascio
          ;
       exception
         when others then
              w_des_diritto := w_des_diritto_def;
       end;

     else
        begin
          select dtd.descrizione
            into w_des_diritto
            from cerdtd dtd, cercdc cdc
           where dtd.fascia_tariffaria = cdc.fascia_tariffaria
             and dtd.cod_diritto       = cdc.cod_diritto
             and cdc.cod_diritto       = a_cod_diritto
             and cdc.anno_emissione    = a_anno_emissione
             and cdc.progr_emissione   = a_progr_emissione
          ;
       exception
         when others then
              w_des_diritto := w_des_diritto_def;
       end;
     end if;
  end if;

  return w_des_diritto;

end;
/
create or replace view cersce_v
	(d_data, terminalista, certificato, tipo_pagamento,
         cod_segreteria, des_segreteria, sum_segreteria, count_segreteria,
         cod_carta_identita, des_carta_identita, sum_carta_identita, count_carta_identita,
         cod_stato_civile, des_stato_civile, sum_stato_civile, count_stato_civile,
         cod_rimborso_st, des_rimborso_st, sum_rimborso_st, count_rimborso_st,
         cod_bollo, des_bollo, sum_bollo, count_bollo,
         cod_diversi_1, des_diversi_1, sum_diversi_1, count_diversi_1,
         cod_diversi_2, des_diversi_2, sum_diversi_2, count_diversi_2,
	 count_esenti, count_validi, count_annullati, count_generale,
         archivio, ID)
AS
select v.*, rownum id
  from
(select
-- d_data
	cem.d_data_emissione d_data,
-- terminalista
	cem.terminalista||' - '||dte.cognome||'/'||dte.nome terminalista,
-- certificato
	cem.cod_certificato||' - '||dce.descrizione certificato,
-- tipo_pagamento
        cem.tipo_pagamento tipo_pagamento,
-- ..._segreteria
        max(
	   decode(cem.annullamento,'',
             decode(cem.segreteria,'','',1),'')) cod_segreteria,
        max(
	   decode(cem.annullamento,'',
             decode(cem.segreteria,'','',f_SDIR_des_diritto(cem.anno_emissione,cem.progr_emissione,1,cem.modalita_rilascio)),'')) des_segreteria,
        sum(
	   decode(cem.annullamento,'',
             decode(cem.segreteria,'','',cem.segreteria),'')) tot_segreteria,
	count(
	   decode(cem.annullamento,'',
             decode(cem.segreteria,'','',cem.progr_emissione),'')) tot_1,
-- ..._carta_identita
	max(
	   decode(cem.annullamento,'',
	     decode(cem.carta_identita,'','',3),'')) cod_carta_identita,
	max(
	   decode(cem.annullamento,'',
	     decode(cem.carta_identita,'','',f_SDIR_des_diritto(cem.anno_emissione,cem.progr_emissione,3,cem.modalita_rilascio)),'')) des_carta_identita,
	sum(
	   decode(cem.annullamento,'',
	     decode(cem.carta_identita,'','',cem.carta_identita),'')) tot_carta_identita,
	count(
	   decode(cem.annullamento,'',
	     decode(cem.carta_identita,'','',cem.progr_emissione),'')) tot_2,
-- ..._stato_civile
	max(
	   decode(cem.annullamento,'',
	     decode(cem.stato_civile,'','',2),'')) cod_stato_civile,
	max(
	   decode(cem.annullamento,'',
	     decode(cem.stato_civile,'','',f_SDIR_des_diritto(cem.anno_emissione,cem.progr_emissione,2,cem.modalita_rilascio)),'')) des_stato_civile,
	sum(
	   decode(cem.annullamento,'',
	     decode(cem.stato_civile,'','',cem.stato_civile),'')) tot_stato_civile,
	count(
	   decode(cem.annullamento,'',
	     decode(cem.stato_civile,'','',cem.progr_emissione),'')) tot_3,
-- ..._rimborso_st
	max(
	   decode(cem.annullamento,'',
	     decode(cem.rimborso_st,'','',4),'')) cod_rimborso_st,
	max(
	   decode(cem.annullamento,'',
	     decode(cem.rimborso_st,'','',f_SDIR_des_diritto(cem.anno_emissione,cem.progr_emissione,4,cem.modalita_rilascio)),'')) des_rimborso_st,
	sum(
	   decode(cem.annullamento,'',
	     decode(cem.rimborso_st,'','',cem.rimborso_st),'')) tot_rimborso_st,
	count(
	   decode(cem.annullamento,'',
	     decode(cem.rimborso_st,'','',cem.progr_emissione),'')) tot_4,
-- tot_bollo
	max(
	   decode(cem.annullamento,'',
	     decode(cem.bollo,'','',9),'')) cod_bollo,
	max(
	   decode(cem.annullamento,'',
	     decode(cem.bollo,'','',f_SDIR_des_diritto(cem.anno_emissione,cem.progr_emissione,9,cem.modalita_rilascio)),'')) des_bollo,
	sum(
	   decode(cem.annullamento,'',
	     decode(cem.bollo,'','',cem.bollo),'')) tot_bollo,
	count(
	   decode(cem.annullamento,'',
	     decode(cem.bollo,'','',cem.progr_emissione),'')) tot_5,
-- ..._diversi_1
	 to_number(null) cod_diversi_1,
	 to_char(null) des_diversi_1,
	 to_number(null) tot_diversi_1,
	 0 tot_6,
-- ..._diversi_2
	 to_number(null) cod_diversi_2,
	 to_char(null) des_diversi_2,
	 to_number(null) tot_diversi_2,
	 0 tot_7,
-- tot_esenti
       count(
	 decode(cem.annullamento,'',
	   decode(cem.segreteria,'',
	     decode(cem.carta_identita,'',
	       decode(cem.stato_civile,'',
                 decode(cem.rimborso_st,'',cem.progr_emissione,'')))),'')) tot_esenti,
-- tot_validi
       count(
	 decode(cem.annullamento,'',cem.progr_emissione,'')) tot_validi,
-- tot_annullati
       count(
 	 decode(cem.annullamento,'','',cem.progr_emissione)) tot_annullati,
-- tot_generale
       count(*) tot_generale,
-- archivio
       'CEM'
  from cerdte dte, cerdce dce, cercem cem
 where dte.cod_utente          (+) = cem.terminalista
   and dce.cod_certificato 	   = cem.cod_certificato
 group by cem.d_data_emissione
        , cem.terminalista||' - '||dte.cognome||'/'||dte.nome
        , cem.cod_certificato||' - '||dce.descrizione
        , cem.tipo_pagamento
UNION
select
-- d_data
	iec.d_data_emissione d_data,
-- terminalista
	iec.terminalista||' - '||dte.cognome||'/'||dte.nome terminalista,
-- certificato
	'INCASSO EXTRA CERTIFICAZIONE' certificato,
-- tipo_pagamento
        iec.tipo_pagamento tipo_pagamento,
-- ..._segreteria
        max(
	   decode(iec.annullamento,'',
             decode(iec.segreteria,'','',1),'')) cod_segreteria,
        max(
	   decode(iec.annullamento,'',
             decode(iec.segreteria,'','','Diritti Segreteria'),'')) des_segreteria,
        sum(
	   decode(iec.annullamento,'',
             decode(iec.segreteria,'','',iec.segreteria),'')) tot_segreteria,
	count(
	   decode(iec.annullamento,'',
             decode(iec.segreteria,'','',iec.progr_emissione),'')) tot_1,
-- ..._carta_identita
	max(
	   decode(iec.annullamento,'',
	     decode(iec.carta_identita,'','',3),'')) cod_carta_identita,
	max(
	   decode(iec.annullamento,'',
	     decode(iec.carta_identita,'','','Carta d''Identita`'),'')) des_carta_identita,
	sum(
	   decode(iec.annullamento,'',
	     decode(iec.carta_identita,'','',iec.carta_identita),'')) tot_carta_identita,
	count(
	   decode(iec.annullamento,'',
	     decode(iec.carta_identita,'','',iec.progr_emissione),'')) tot_2,
-- ..._stato_civile
	max(
	   decode(iec.annullamento,'',
	     decode(iec.stato_civile,'','',2),'')) cod_stato_civile,
	max(
	   decode(iec.annullamento,'',
	     decode(iec.stato_civile,'','','Diritti Stato Civ.'),'')) des_stato_civile,
	sum(
	   decode(iec.annullamento,'',
	     decode(iec.stato_civile,'','',iec.stato_civile),'')) tot_stato_civile,
	count(
	   decode(iec.annullamento,'',
	     decode(iec.stato_civile,'','',iec.progr_emissione),'')) tot_3,
-- ..._rimborso_st
	max(
	   decode(iec.annullamento,'',
	     decode(iec.rimborso_st,'','',4),'')) cod_rimborso_st,
	max(
	   decode(iec.annullamento,'',
	     decode(iec.rimborso_st,'','','Rimborso Stampati'),'')) des_rimborso_st,
	sum(
	   decode(iec.annullamento,'',
	     decode(iec.rimborso_st,'','',iec.rimborso_st),'')) tot_rimborso_st,
	count(
	   decode(iec.annullamento,'',
	     decode(iec.rimborso_st,'','',iec.progr_emissione),'')) tot_4,
-- ..._bollo
	max(
	   decode(iec.annullamento,'',
	     decode(iec.bollo,'','',9),'')) cod_bollo,
	max(
	   decode(iec.annullamento,'',
	     decode(iec.bollo,'','','Bollo'),'')) des_bollo,
	sum(
	   decode(iec.annullamento,'',
	     decode(iec.bollo,'','',iec.bollo),'')) tot_bollo,
	count(
	   decode(iec.annullamento,'',
	     decode(iec.bollo,'','',iec.progr_emissione),'')) tot_5,
-- ..._diversi_1
	 max(
	   decode(iec.annullamento,'',
	     decode(iec.diversi_1,'','',41),'')) cod_diversi_1,
	 max(
	   decode(iec.annullamento,'',
	     decode(iec.diversi_1,'','','Diversi 1 '||rtrim(inp_1.valore)),'')) des_diversi_1,
	 sum(
	   decode(iec.annullamento,'',
	     decode(iec.diversi_1,'','',iec.diversi_1),'')) tot_diversi_1,
	 count(
	   decode(iec.annullamento,'',
	     decode(iec.diversi_1,'','',iec.progr_emissione),'')) tot_6,
-- ..._diversi_2
	 max(
	   decode(iec.annullamento,'',
	     decode(iec.diversi_2,'','',42),'')) cod_diversi_2,
	 max(
	   decode(iec.annullamento,'',
	     decode(iec.diversi_2,'','','Diversi 2 '||rtrim(inp_2.valore)),'')) des_diversi_2,
	 sum(
	   decode(iec.annullamento,'',
	     decode(iec.diversi_2,'','',iec.diversi_2),'')) tot_diversi_2,
	 count(
	   decode(iec.annullamento,'',
	     decode(iec.diversi_2,'','',iec.progr_emissione),'')) tot_7,
-- tot_esenti
       count(
	 decode(iec.annullamento,'',
	   decode(iec.segreteria,'',
	     decode(iec.carta_identita,'',
               decode(iec.stato_civile,'',
                 decode(iec.rimborso_st,'',iec.progr_emissione,'')))),'')) tot_esenti,
-- tot_validi
       count(
	 decode(iec.annullamento,'',iec.progr_emissione,'')) tot_validi,
-- tot_annullati
       count(
 	 decode(iec.annullamento,'','',iec.progr_emissione)) tot_annullati,
-- tot_generale
       count(*) tot_generale,
-- archivio
       'IEC'
  from arcinp inp_1, arcinp inp_2,
       cerdte dte, ceriec iec
 where dte.cod_utente (+) 	= iec.terminalista
   and inp_1.parametro          = 'CEXT_DIV1'
   and inp_2.parametro          = 'CEXT_DIV2'
 group by iec.d_data_emissione
        , iec.terminalista||' - '||dte.cognome||'/'||dte.nome
        , iec.tipo_pagamento
) v
/
comment on table cersce_v is 'Certificazione - Statistica Certificati Emessi (view)'
/
