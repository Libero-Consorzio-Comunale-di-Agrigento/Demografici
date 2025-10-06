--liquibase formatted sql
--changeset amonopoli:202503211150_2 runOnChange:true stripComments:false
create or replace procedure ANAANA_IST_FI
(a_fascia		IN	number,
 a_stato		IN	number,
 a_matricola		IN	number,
 a_cod_fam		IN	number,
 a_ufficio_nas		IN	number,
 a_anno_atto_nas	IN 	number,
 a_atto_nas		IN	number,
 a_parte_nas		IN 	number,
 a_serie_nas		IN	varchar2,
 a_ufficio_nas_tr	IN	number,
 a_anno_atto_nas_tr	IN 	number,
 a_atto_nas_tr		IN	number,
 a_parte_nas_tr		IN 	number,
 a_serie_nas_tr		IN	varchar2)
IS
  w_cod_fam		number;
  w_matricola		number;
  w_componenti		number;
  w_componenti_minori	number;
begin
--
-- l'inserimento in ANAANA di un iscritto per nascita
-- produce l'aggiornamento dei dati anagrafici richiesti in ISTMP4
--

  if a_fascia = 1 and a_stato = 1 then

     begin
       select count(*)
         into w_componenti
         from anaana ana
        where ana.fascia	= 1
          and ana.cod_fam	= a_cod_fam
       ;
       w_componenti := w_componenti + 1;
     exception
       when others then null;
     end;

     begin
       select count(*) 
         into w_componenti_minori
         from anaana ana
        where ana.fascia	= 1
          and ana.cod_fam	= a_cod_fam
          and add_months(to_date(ana.data_nas,'j'),216) - sysdate > 0
       ;
       w_componenti_minori := w_componenti_minori + 1;
     exception
       when others then null;
     end;

     if a_atto_nas_tr is null then
	begin
	  update istmp4
	     set matricola		= a_matricola,
	         num_componenti		= w_componenti,
	         num_componenti_minori	= w_componenti_minori
	   where ufficio	= a_ufficio_nas
	     and anno		= a_anno_atto_nas
	     and atto		= a_atto_nas
	     and parte		= a_parte_nas
	     and serie		= a_serie_nas
	  ;
	end;
     else	-- a_atto_nas_tr is null
	begin
	  update istmp4
	     set matricola		= a_matricola,
	         num_componenti		= w_componenti,
	         num_componenti_minori	= w_componenti_minori
	   where ufficio	= a_ufficio_nas_tr
	     and anno		= a_anno_atto_nas_tr
	     and atto		= a_atto_nas_tr
	     and parte		= a_parte_nas_tr
	     and serie		= a_serie_nas_tr
	  ;
	end;
     end if;
     
     begin
	  update istmp4
	     set flag_completo	= 'S'
	   where matricola		= a_matricola
             and DATA_NAS_PAT		is not null           
	     and STATO_CIVILE_PAT	is not null
	     and NAZIONALITA_PAT	is not null
	     and DATA_NAS_MAT		is not null
	     and STATO_CIVILE_MAT 	is not null
	     and NAZIONALITA_MAT	is not null
	     and COD_FISCALE_MAT        is not null
	     and MATRICOLA		is not null
	     and NUM_COMPONENTI		is not null
	     and NUM_COMPONENTI_MINORI  is not null
	  ;
     end;

  end if;
end;
/
