--liquibase formatted sql
--changeset amonopoli:202411191550_3 runOnChange:true stripComments:false
create or replace function f_STATS_descrizione_campo
(a_nome_campo	IN	varchar2)

return varchar2

IS

w_nome_campo	varchar2(255) := upper(a_nome_campo);
w_descrizione	varchar2(255);

begin
  w_descrizione := initcap(replace(w_nome_campo, '_',' '));

-- _par --> parentela
  if w_descrizione like '% Par %' then
     w_descrizione := replace(w_descrizione, ' Par ',' Parentela ');

  elsif w_descrizione like '% Par' then
     w_descrizione := replace(w_descrizione, ' Par',' Parentela');

-- _res  —> residenza
  elsif w_descrizione like '% Res %' then
     w_descrizione := replace(w_descrizione, ' Res ',' Residenza ');

  elsif w_descrizione like '% Res' then
     w_descrizione := replace(w_descrizione, ' Res',' Residenza');

-- indirizzo_int     —> indirizzo (con Interno)
  elsif w_descrizione like '% Int %' then
     w_descrizione := replace(w_descrizione, ' Int ',' ')||' (con Interno)';

  elsif w_descrizione like '% Int' then
     w_descrizione := replace(w_descrizione, ' Int',' (con Interno)');

-- _prof --> Professione
  elsif w_descrizione like '% Prof %' then
     w_descrizione := replace(w_descrizione, ' Prof ',' Professione ');

  elsif w_descrizione like '% Prof' then
     w_descrizione := replace(w_descrizione, ' Prof',' Professione');

-- _ele  —> Elettorale
  elsif w_descrizione like '% Ele %' then
     w_descrizione := replace(w_descrizione, ' Ele ',' Elettorale ');

  elsif w_descrizione like '% Ele' then
     w_descrizione := replace(w_descrizione, ' Ele',' Elettorale');

-- _DI   —> Doc. Identità
  elsif w_descrizione like '% Di' then
     w_descrizione := replace(w_descrizione, ' Di',' Documento di Identita');

-- _DS   —> Doc. Soggiorno
  elsif w_descrizione like '% Ds' then
     w_descrizione := replace(w_descrizione, ' Ds',' Documento di Soggiorno');
 
-- _CI   —> Carta Identità
  elsif w_descrizione like '% Ci' then
     w_descrizione := replace(w_descrizione, ' Ci',' Carta di Identita');

-- _CIE   —> Carta Identità Elettronica
  elsif w_descrizione like '% Cie' then
     w_descrizione := replace(w_descrizione, ' Cie',' CIE');

-- _PS   —> Permesso di Soggiorno
  elsif w_descrizione like '% Ps' then
     w_descrizione := replace(w_descrizione, ' Ps',' Permesso di Soggiorno');

-- _CS   —> Carta di Soggiorno
  elsif w_descrizione like '% Cs' then
     w_descrizione := replace(w_descrizione, ' Cs',' Carta di Soggiorno');

-- _RP   —> Ricevuta Richiesta Permesso Soggiorno
  elsif w_descrizione like '% Rp' then
     w_descrizione := replace(w_descrizione, ' Rp',' Ricevuta Richiesta PS');

-- _LL   —> Libretto di Lavoro
  elsif w_descrizione like '% Ll' then
     w_descrizione := replace(w_descrizione, ' Ll',' Libretto di Lavoro');

-- _U1   —> Attestazione di Regolaritaà Soggiorno
  elsif w_descrizione like '% U1' then
     w_descrizione := replace(w_descrizione, ' U1',' Attestazione di Regolarita Sogg. UE');

-- _U2   —> Attestazione di Soggiorno Permanente
  elsif w_descrizione like '% U2' then
     w_descrizione := replace(w_descrizione, ' U2',' Attestazione di Sogg. Permanente UE');

-- _iscr —> Iscrizione
  elsif w_descrizione like '% Immi %' then
     w_descrizione := replace(w_descrizione, ' Immi ',' Immigrazione ');

  elsif w_descrizione like '% Immi' then
     w_descrizione := replace(w_descrizione, ' Immi',' Immigrazione');

  elsif w_descrizione like '% Iscr %' then
     w_descrizione := replace(w_descrizione, ' Iscr ',' Iscrizione ');

  elsif w_descrizione like '% Iscr' then
     w_descrizione := replace(w_descrizione, ' Iscr',' Iscrizione');

-- _canc --> Cancellazione
  elsif w_descrizione like '% Emig %' then
     w_descrizione := replace(w_descrizione, ' Emig ',' Emigrazione ');

  elsif w_descrizione like '% Emig' then
     w_descrizione := replace(w_descrizione, ' Emig',' Emigrazione');

  elsif w_descrizione like '% Canc %' then
     w_descrizione := replace(w_descrizione, ' Canc ',' Cancellazione ');

  elsif w_descrizione like '% Canc' then
     w_descrizione := replace(w_descrizione, ' Canc',' Cancellazione');

-- anno_progr / numero_progr     —> Anno Progressivo (Movimento)
  elsif w_descrizione like '% Progr' then
     w_descrizione := replace(w_descrizione, ' Progr',' Progressivo (Movimento)');

  end if;

-- flag_xxx    —> es. Cf Calcolato (SI/NO)
  if w_descrizione like 'Flag %' then
     w_descrizione := w_descrizione||' (SI/NO)';

-- nazionalita_cee --> Nazionalita UE (si/NO)
  elsif w_descrizione like 'Nazionalita Cee' then
     w_descrizione := 'Nazionalita UE'||' (SI/NO)';

-- pensionato --> Pensionato (SI/NO)
  elsif w_descrizione like 'Pensionato' then
     w_descrizione := w_descrizione||' (SI/NO)';

-- val_espatrio --> Validita per Espatrio (SI/NO)
  elsif w_descrizione like 'Val Espatrio%' then
     w_descrizione := replace(w_descrizione, 'Val Espatrio','Validita Espatrio');
     w_descrizione := w_descrizione||' (SI/NO)';

-- numero_familiari, etc --> Numero Ultra 64enni (nel nucleo)
  elsif w_descrizione like 'Numero Familiari%' or w_descrizione like 'Numero Figli%' or w_descrizione like 'Numero Ultra%' then
     if substr(w_descrizione,length(w_descrizione),1) in ('0','1','2','3','4','5','6','7','8','9') then
        w_descrizione := w_descrizione||'enni';
     end if;
     w_descrizione := w_descrizione||' (nel nucleo)';

-- convivenza --> Denominazione Convivenza
  elsif w_descrizione like 'Convivenza' then
     w_descrizione := 'Denominazione Convivenza';

-- Data Indirizzo    —> Data Decorrenza Indirizzo
  elsif w_descrizione like 'Data Inidirizzo' then
     w_descrizione := 'Data Decorrenza Indirizzo';

-- Data Rif    —> Data di Riferimento
  elsif w_descrizione like 'Data Rif%' then
     w_descrizione := replace(w_descrizione, 'Data Rif','Data di Riferimento');

-- suddivizione_x    --> Codice Suddivisione per Unita 5
  elsif w_descrizione like '% Suddivisione %' then
     w_descrizione := replace(w_descrizione, ' Suddivisione ',' Suddivisione per Unita Territoriale ');

-- scrutatore_albo_x --> (Unico / Regionale / etc...)
  elsif w_descrizione like '%Scrutatore Albo S' then
     w_descrizione := replace(w_descrizione, 'Albo S','(Albo Sorteggiati)');

  elsif w_descrizione like '%Scrutatore Albo V' then
     w_descrizione := replace(w_descrizione, 'Albo V','(Albo Unico)');

  elsif w_descrizione like '%Scrutatore Albo R' then
     w_descrizione := replace(w_descrizione, 'Albo R','(Albo Regionale)');

-- giudice_albo_x --> (Assise / Appello)
  elsif w_descrizione like '%Giudice Albo A' then
     w_descrizione := replace(w_descrizione, 'Albo A','Popolare (Albo Assise)');

  elsif w_descrizione like '%Giudice Albo P' then
     w_descrizione := replace(w_descrizione, 'Albo P','Popolare (Albo Appello)');

  end if;

-- data_..._edit     —> (gg/mm/aaaa)
  if w_descrizione like 'Data % Edit' then
     w_descrizione := replace(w_descrizione, ' Edit',' (gg/mm/aaaa)');

-- atto_..._edit --> Atto Nascita (con Parte e Serie)
  elsif w_descrizione like 'Atto % Edit' then
     w_descrizione := replace(w_descrizione, ' Edit',' (con Parte e Serie)');

-- pratica_edit      —> verifica(?)
  elsif w_descrizione like 'Pratica % Edit' then
     w_descrizione := replace(w_descrizione, ' Edit',' (con Anno)');

-- des_  —> descrizione
  elsif w_descrizione like 'Des %' then
     w_descrizione := replace(w_descrizione, 'Des ','Descrizione ');

-- cod_  —> codice
  elsif w_descrizione like 'Cod %' then
     w_descrizione := replace(w_descrizione, 'Cod ','Codice ');
  
  end if;

-- _prec  —> precedente
  if w_descrizione like '% Prec %' then
     w_descrizione := replace(w_descrizione, ' Prec ',' Precedente ');

  elsif w_descrizione like '% Prec' then
     w_descrizione := replace(w_descrizione, ' Prec',' Precedente');

  end if;

-- totale  —> totale somma
  if w_descrizione = 'Totale' then
     w_descrizione := 'Somma Totale';

  end if;

  return w_descrizione;

end;
/
