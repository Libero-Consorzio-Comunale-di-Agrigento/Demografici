--liquibase formatted sql
--changeset amonopoli:202504021205_1 runOnChange:true stripComments:false
create or replace function F_MOV_descrizione_evento
	(a_anno_progr		number,
	 a_numero_progr		number)
return varchar2
IS
w_cod_eve		number;
w_cod_mov		number;
w_cod_variazione varchar2(1);

w_des_cod_var  varchar2(255);
w_des_evento   varchar2(2000);
begin
  begin
    select cod_eve,cod_mov,cod_variazione
      into w_cod_eve, w_cod_mov, w_cod_variazione
      from anamov
     where anno_progr = a_anno_progr
	   and numero_progr = a_numero_progr
    ;
  exception
    when others then
         w_cod_eve:=null;
		 w_cod_mov:=null;
		 w_cod_variazione:= null;
  end;

  if w_cod_eve = 1 and w_cod_mov = 3 then
    w_des_evento :=  'ISCRIZIONE AIRE PER NASCITA';
    if w_cod_variazione = 'C' then
       w_des_cod_var := 'C'||' AL CENSIMENTO';
    end if;
  else

<< cod_variazione >>
 Begin
  select decode(w_cod_eve,
           92, descrizione||decode(w_cod_mov,
                              10, ' (VARIAZIONE RAPPORTO PARENTELA)',
                              11, ' (VARIAZIONE INDIRIZZO)',
                              12, ' (VARIAZIONE RAPPORTO PARENTELA)',
                              13, ' (VARIAZIONE INDIRIZZO)'),
           93, decode(w_cod_variazione,'U','UNIONE CIVILE','MATRIMONIO'),
               descrizione||decode(w_cod_eve,
                              '53', decode(w_cod_variazione,'C',' AL CENSIMENTO',''),
                              '50', decode(w_cod_variazione,'E',' ALL''ESTERO','')))
    into w_des_evento
    from anadev
   where cod_ev = w_cod_eve
  ;
 Exception when NO_DATA_FOUND then
    w_des_evento := null;
 End;

<< generalita >>
 Begin
  select 'RETTIFICA GENERALITA'''
    into w_des_evento
    from anamov
   where cod_eve = 99
     and cognome_Nome_prec is not null
     and sesso_prec is not null
     and (cognome_Nome_prec != cognome_Nome or
          sesso_prec != sesso)
     and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
  return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

<< cittadinanza >>
 Begin
  select 'RETTIFICA CITTADINANZA (da '||
          nazionalita_prec||' a '||nazionalita||')'
    into w_des_evento
    from anamov
   where cod_eve = 99
     and nazionalita_prec is not null
     and nazionalita      is not null
     and (nazionalita_prec != nazionalita)
     and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
  return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

 Begin
  select 'RETTIFICA DATA DECORRENZA CITTADINANZA'
    into w_des_evento
    from anamov
   where cod_eve = 99
     and nvl(data_inizio_naz,0) ! = nvl(data_inizio_naz_prec,0)
     and anno_progr = a_anno_progr
     and numero_progr = a_numero_progr;
  return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

<< stato_civile >>
 Begin
  select 'RETTIFICA STATO CIVILE (da '||
          stato_civile_prec||' a '||stato_civile||')'
    into w_des_evento
    from anamov
   where cod_eve = 99
     and stato_civile_prec is not null
     and stato_civile      is not null
     and (stato_civile_prec != stato_civile)
     and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
 return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

<< prof_tit_studio >>
 Begin
  select 'RETTIFICA PROFESSIONE/TITOLO STUDIO'||
         decode(cod_variazione,'A',' (x BONIFICA ANPR)')
    into w_des_evento
    from anamov
   where cod_eve = 99
     and (nvl(cod_prof_prec,0) != nvl(cod_prof,0) or
      nvl(titolo_studio_prec,' ') != nvl(titolo_studio,' '))
     and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
  return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

<< pat_mat >>
 Begin
  select 'RETTIFICA PATERNITA/MATERNITA'||
         decode(cod_variazione,'A',' (x BONIFICA ANPR)')
    into w_des_evento
    from anamov
   where cod_eve = 99
     and (nvl(paternita_prec,' ') != nvl(paternita,' ') or
      nvl(maternita_prec,' ') != nvl(maternita,' '))
     and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
  return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

<< dati_nascita >>
 Begin
  select 'RETTIFICA DATI NASCITA'||
         decode(cod_variazione,'A',' (x BONIFICA ANPR)')
    into w_des_evento
    from anamov
   where cod_eve = 99
     and (nvl(data_nas_prec,0) != nvl(data_nas,0) or
                  nvl(cod_pro_nas_prec,0) != nvl(cod_pro_nas,0) or
                  nvl(cod_com_nas_prec,0) != nvl(cod_com_nas,0) or
                   nvl(cod_pro_atto_nas_prec,0) != nvl(cod_pro_atto_nas,0) or
                  nvl(cod_com_atto_nas_prec,0) != nvl(cod_com_atto_nas,0) or
                   nvl(atto_nas_prec,0) != nvl(atto_nas,0) or
                  nvl(parte_nas_prec,0) != nvl(parte_nas,0) or
                   nvl(serie_nas_prec,' ') != nvl(serie_nas,' ') or
                  nvl(ufficio_nas_prec,0) != nvl(ufficio_nas,0) or
                  nvl(anno_atto_nas_prec,0) != nvl(anno_atto_nas,0) or
                   nvl(atto_nas_tr_prec,0) != nvl(atto_nas_tr,0) or
                  nvl(parte_nas_tr_prec,0) != nvl(parte_nas_tr,0) or
                   nvl(serie_nas_tr_prec,' ') != nvl(serie_nas_tr,' ') or
                nvl(anno_atto_nas_tr_prec,0) != nvl(anno_atto_nas_tr,0) or
                  nvl(ufficio_nas_tr_prec,0) != nvl(ufficio_nas_tr,0)
          )
     and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
  return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

<< dati_matrimonio >>
 Begin
  select 'RETTIFICA DATI MATRIMONIO'||
         decode(cod_variazione,'A',' (x BONIFICA ANPR)')
    into w_des_evento
    from anamov
   where cod_eve = 99
     and (nvl(cognome_nome_cn_prec,' ') != nvl(cognome_nome_cn,' ') or
          nvl(matricola_cn_prec,0) != nvl(matricola_cn,0) or
          nvl(data_mat_prec,0) != nvl(data_mat,0) or
          nvl(cod_pro_mat_prec,0) != nvl(cod_pro_mat,0) or
          nvl(cod_com_mat_prec,0) != nvl(cod_com_mat,0) or
          nvl(cod_pro_atto_mat_prec,0) != nvl(cod_pro_atto_mat,0) or
          nvl(cod_com_atto_mat_prec,0) != nvl(cod_com_atto_mat,0) or
          nvl(atto_mat_prec,0) != nvl(atto_mat,0) or
          nvl(parte_mat_prec,0) != nvl(parte_mat,0) or
          nvl(serie_mat_prec,' ') != nvl(serie_mat,' ') or
          nvl(ufficio_mat_prec,0) != nvl(ufficio_mat,0) or
          nvl(atto_mat_tr_prec,0) != nvl(atto_mat_tr,0) or
          nvl(anno_atto_mat_prec,0) != nvl(anno_atto_mat,0) or
          nvl(parte_mat_tr_prec,0) != nvl(parte_mat_tr,0) or
          nvl(serie_mat_tr_prec,' ') != nvl(serie_mat_tr,' ') or
          nvl(anno_atto_mat_tr_prec,0) != nvl(anno_atto_mat_tr,0) or
          nvl(ufficio_mat_tr_prec,0) != nvl(ufficio_mat_tr,0)
      )
	 and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
  return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

 << dati_vedovanza >>
 Begin
  select 'RETTIFICA DATI VEDOVANZA'||
         decode(cod_variazione,'A',' (x BONIFICA ANPR)')
    into w_des_evento
    from anamov
   where cod_eve = 99
     and (nvl(data_ved_prec,0) != nvl(data_ved,0) or
          nvl(cod_pro_ved_prec,0) != nvl(cod_pro_ved,0) or
          nvl(cod_com_ved_prec,0) != nvl(cod_com_ved,0) or
          nvl(cod_pro_atto_ved_prec,0) != nvl(cod_pro_atto_ved,0) or
          nvl(cod_com_atto_ved_prec,0) != nvl(cod_com_atto_ved,0) or
          nvl(atto_ved_prec,0) != nvl(atto_ved,0) or
          nvl(parte_ved_prec,0) != nvl(parte_ved,0) or
          nvl(serie_ved_prec,' ') != nvl(serie_ved,' ') or
          nvl(anno_atto_ved_prec,0) != nvl(anno_atto_ved,0) or
          nvl(ufficio_ved_prec,0) != nvl(ufficio_ved,0)
      )
	 and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
  return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

<< dati_divorzio >>
 Begin
  select 'RETTIFICA DATI DIVORZIO'||
         decode(cod_variazione,'A',' (x BONIFICA ANPR)')
    into w_des_evento
    from anamov
   where cod_eve = 99
     and (nvl(data_div_prec,0) != nvl(data_div,0) or
          nvl(cod_pro_div_prec,0) != nvl(cod_pro_div,0) or
          nvl(cod_com_div_prec,0) != nvl(cod_com_div,0) or
          nvl(cod_pro_atto_div_prec,0) != nvl(cod_pro_atto_div,0) or
          nvl(cod_com_atto_div_prec,0) != nvl(cod_com_atto_div,0) or
          nvl(atto_div_prec,0) != nvl(atto_div,0) or
          nvl(parte_div_prec,0) != nvl(parte_div,0) or
          nvl(serie_div_prec,' ') != nvl(serie_div,' ') or
          nvl(ufficio_div_prec,0) != nvl(ufficio_div,0) or
          nvl(anno_atto_div_prec,0) != nvl(anno_atto_div,0) or
          nvl(data_div_giu_prec,0) != nvl(data_div_giu,0) or
          nvl(data_div_ann_prec,0) != nvl(data_div_ann,0)
      )
	 and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
 return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

<< codice_fiscale >>
 Begin
  select 'RETTIFICA CODICE FISCALE'||
         decode(cod_variazione,'A',' (x BONIFICA ANPR)')
    into w_des_evento
    from anamov
   where cod_eve = 99
     and  (nvl(cod_fiscale_prec,' ') != nvl(cod_fiscale,' ') or
           nvl(cf_calcolato_prec,' ') != nvl(cf_calcolato,' ')
      )
	 and anno_progr = a_anno_progr
	 and numero_progr = a_numero_progr;
  return(w_des_evento);
 Exception when NO_DATA_FOUND then
    NULL;
 End;

<< matricola_aire >>
 begin
   select 'RETTIFICA MATRICOLA AIRE'||
         decode(cod_variazione,'A',' (x BONIFICA ANPR)')
     into w_des_evento
     from anamov
    where w_cod_eve = 99
      and w_cod_mov = 98
      and nvl(matricola_aire_prec,' ') != nvl(matricola_aire,' ')
      and anno_progr = a_anno_progr
      and numero_progr = a_numero_progr;
 return(w_des_evento);
 exception
      when no_data_found then
         null;
 end;

<< dati_censimento>>
 begin
   select 'RETTIFICA DATI CENSIMENTO'||
         decode(cod_variazione,'A',' (x BONIFICA ANPR)')
     into w_des_evento
     from anamov
    where w_cod_eve = 99
      and w_cod_mov = 97
      and nvl(anno_cens_prec,0) != nvl(anno_cens,0)
	  and anno_progr = a_anno_progr
	  and numero_progr = a_numero_progr;
 return(w_des_evento);
 exception
      when no_data_found then
         null;
 end;

 end if;
 return(w_des_evento);
end;
/
