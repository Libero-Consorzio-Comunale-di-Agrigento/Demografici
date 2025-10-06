--liquibase formatted sql
--changeset amonopoli:202411191600_2 runOnChange:true stripComments:false
create or replace view anavxx_motivo_doc
	(codice, descrizione, ordinamento)
AS
-- MOTIVO_... DOCUMENTO
select cod_md, descrizione, cod_md 
  from anadmd
 order by 1
/
comment on table anavxx_motivo_doc is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/
create or replace view anavxx_codice_via
	(codice, descrizione, ordinamento)
AS
-- CODICE_VIA
select cod_via, cod_via||' - '||denom_uff, cod_via
  from arcvie
 order by 1
/
comment on table anavxx_codice_via is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/
create or replace function f_anavxx_sequenza_par
(a_sequenza_par IN number)

return varchar2

IS

w_descrizione_drp_prec  varchar2(255);

w_descrizione           varchar2(4000);

cursor sel_drp (w_sequenza IN number) is
select descrizione
  from anadrp
 where sequenza = w_sequenza
 order by decode(cod_rp,'CF',1,'MR',1,'MG',1,'ZI',1,'NP',1,2), cod_rp, sesso
;

begin
  if a_sequenza_par is not null then
     w_descrizione_drp_prec := '';
     for rec in sel_drp (a_sequenza_par) loop
         if w_descrizione_drp_prec is null then
            w_descrizione := rec.descrizione;
         elsif w_descrizione_drp_prec != rec.descrizione then
            w_descrizione := w_descrizione||' / '||rec.descrizione;
         end if;
         w_descrizione_drp_prec := rec.descrizione;
     end loop;
  end if;

  return w_descrizione;

end;
/
create or replace view anavxx_sequenza_par
	(codice, descrizione, ordinamento)
AS
-- SEQUENZA_PAR
select distinct sequenza, sequenza||' - '||f_anavxx_sequenza_par(sequenza) descrizione, sequenza
  from anadrp
 order by 1
/
comment on table anavxx_sequenza_par is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/
create or replace view anavxx_sezione_ele
	(codice, descrizione, ordinamento)
AS
-- SEZIONE_ELE
select sezione, 'SEZIONE: '||sezione, sezione
  from eledse
 order by 1
/
comment on table anavxx_sezione_ele is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/
-- PROFESSIONE
create or replace view anavxx_professione
(codice, descrizione, ordinamento)
as
select drp_m.cod_pr codice, drp_m.cod_pr||' - '||drp_m.descrizione||decode(drp_m.descrizione,drp_f.descrizione,'',' / '||drp_f.descrizione) descrizione, 1
  from anadpr drp_m
     , anadpr drp_f
 where drp_m.sesso = 'M'
   and drp_f.sesso = 'F'
   and drp_m.cod_pr = drp_f.cod_pr
UNION
select drp_m.cod_pr codice, drp_m.cod_pr||' - '||drp_m.descrizione, 1
  from anadpr drp_m
 where drp_m.sesso = 'M'
   and not exists (select 'x' from anadpr drp_f
                    where drp_f.sesso = 'F'
                      and drp_f.cod_pr = drp_m.cod_pr)
UNION
select drp_f.cod_pr codice, drp_f.cod_pr||' - '||drp_f.descrizione descrizione, 1
  from anadpr drp_f
 where drp_f.sesso = 'F'
   and not exists (select 'x' from anadpr drp_m
                    where drp_m.sesso = 'M'
                      and drp_m.cod_pr = drp_f.cod_pr)
order by 1
/
comment on table anavxx_professione is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_attivita_prof
	(codice, descrizione, ordinamento)
AS
-- ATTIVITA_PROF
select cod_at codice, cod_at||' - '||descrizione descrizione, cod_at
  from anadat 
 order by 1
/
comment on table anavxx_attivita_prof is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_posizione_prof
	(codice, descrizione, ordinamento)
AS
-- POSIZIONE_PROF
select cod_pp codice, cod_pp||' - '||descrizione descrizione, cod_pp
  from anadpp 
 order by 1
/
comment on table anavxx_posizione_prof is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_esito_leva
	(codice, descrizione, ordinamento)
AS
-- ESITO_LEVA
select cod_es codice, cod_es||' - '||descrizione descrizione, 1 
  from levdes 
 order by 1
/
comment on table anavxx_esito_leva is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_arma
	(codice, descrizione, ordinamento)
AS
-- ARMA
select cod_ar codice, cod_ar||' - '||descrizione descrizione, 1 
  from levdar 
 order by 1
/
comment on table anavxx_arma is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_corpo
	(codice, descrizione, ordinamento)
AS
-- CORPO
select cod_co codice, cod_co||' - '||descrizione descrizione, 1 
  from levdco 
 order by 1
/
comment on table anavxx_corpo is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_grado
	(codice, descrizione, ordinamento)
AS
-- GRADO
select cod_gr codice, cod_gr||' - '||descrizione descrizione, 1 
  from levdgr 
 order by 1
/
comment on table anavxx_grado is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_motivo_doc
	(codice, descrizione, ordinamento)
AS
-- MOTIVO_DOCUMENTO
select cod_md codice, cod_md||' - '||descrizione descrizione, cod_md
  from anadmd
 order by 1
/
comment on table anavxx_motivo_doc is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/
create or replace view anavxx_cod_mov
	(codice, descrizione, ordinamento)
AS
-- CODICE_MOVIMENTO
select  1, '1 - ISCRIZIONE IN APR (compreso RIMPATRIO AIRE)', 1              from dual UNION
select  2, '2 - CANCELLAZIONE DA APR (escluso ESPATRIO AIRE)', 2           from dual UNION
select  3, '3 - ISCRIZIONE IN AIRE (compreso ESPATRIO AIRE)', 3             from dual UNION
select  4, '4 - CANCELLAZIONE DA AIRE (escluso RIMPATRIO AIRE)', 4          from dual UNION
select 10, '10 - CAMBIO DI ABITAZIONE IN APR', 10  from dual UNION
select 11, '11 - CAMBIO DI ABITAZIONE IN APR', 11  from dual UNION
select 12, '12 - CAMBIO DI ABITAZIONE IN AIRE', 12 from dual UNION
select 13, '13 - CAMBIO DI ABITAZIONE IN AIRE', 13 from dual UNION
select 97, '97 - RETTIFICA APR', 97                from dual UNION
select 98, '98 - RETTIFICA AIRE', 98               from dual
 order by 1
/
comment on table anavxx_cod_mov is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/
create or replace view anavxx_cod_eve
	(codice, descrizione, ordinamento)
AS
-- CODICE_EVENTO
select distinct dev.cod_ev, dev.cod_ev||' - '||dev.descrizione, dev.cod_ev
  from anadev dev, anadce dce
 where dev.cod_ev = dce.cod_eve
   and dce.cod_mov in (1,2,3,4)
UNION
 select 53, '53 - IRREPERIBILITA'' AL CENSIMENTO', 53
   from dual
UNION
select 99, '99 - RETTIFICA (GENERALITA / CITTADINANZA / STATO CIVILE)', 99
  from anadev dev, anadce dce
order by 1
/
comment on table anavxx_cod_eve is 'Statistiche Anagrafe - Filtri "numerici" per elaborazione elenchi (view)'
/
