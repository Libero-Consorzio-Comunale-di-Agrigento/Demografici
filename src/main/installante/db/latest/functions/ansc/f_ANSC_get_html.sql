--liquibase formatted sql
--changeset amonopoli:202511131125 runOnChange:true stripComments:false
CREATE OR REPLACE FUNCTION f_ANSC_get_html
(a_servizio	IN	varchar2
,a_testo_clob	IN	clob
)

RETURN CLOB

IS

w_servizio	varchar2(255) := upper(a_servizio);
w_return_clob	CLOB;

BEGIN

  if a_servizio is not null and a_testo_clob is not null then

     w_return_clob := a_testo_clob;

     if w_return_clob like '%<b>%' or w_return_clob like '%<br/>%' then
        goto fine;
     end if;


     if w_servizio = 'R008_E' then
-- 1. Formatta stato APPROVATO in grassetto
        w_return_clob := REPLACE(w_return_clob, 'stato: APPROVATO', 'stato: <b>APPROVATO</b>');

-- 2. Formatta stato DA APPROVARE in rosso
        w_return_clob := REPLACE(w_return_clob, 'stato: DA APPROVARE', 'stato: <span style="color:red;">DA APPROVARE</span>');

-- 3. Formatta comuneCompetente in grassetto
-- Cattura tutto tra "comuneCompetente: " e " - " (il separatore successivo)
        w_return_clob := REGEXP_REPLACE(w_return_clob, 'comuneCompetente: (.*?)( - )', 'comuneCompetente: <b>\1</b>\2', 1, 0, 'n');

-- 4. Formatta soggetto in grassetto e aggiunge a capo
-- Cattura tutto tra "soggetto: " e chr(10) (a capo)
        w_return_clob := REGEXP_REPLACE(w_return_clob, 'soggetto: (.*?)('||chr(10)||')', 'soggetto: <b>\1</b><br/>\2', 1, 0, 'n');


     elsif w_servizio = 'R008_A' then
-- 1. Formatta comuneDestinatario in grassetto
-- Cattura tutto tra "comuneDestinatario: " e " - " (il separatore successivo)
        w_return_clob := REGEXP_REPLACE(w_return_clob, 'comuneDestinatario: (.*?)( - )', 'comuneDestinatario: <b>\1</b>\2', 1, 0, 'n');

-- 2. Formatta tipo aggiungendo a capo
-- Cattura tutto tra "tipo: " e chr(10) (a capo)
        w_return_clob := REGEXP_REPLACE(w_return_clob, 'tipo: (.*?)('||chr(10)||')', 'tipo: \1<br/>\2', 1, 0, 'n');


     elsif w_servizio in ('R005_1','R005_2') then
-- 1. Formatta idSoggettoAnsc in grassetto
-- Cattura tutto tra "idSoggettoAnsc: " e " (" (parentesi)
        w_return_clob := REGEXP_REPLACE(w_return_clob, 'idSoggettoAnsc: (.*?)( \()', 'idSoggettoAnsc: <b>\1</b>\2', 1, 0, 'n');

     end if; --if w_servizio = 'R008_E' then

-- 4. Sostituisci a capo con doppio <br/>
--     w_return_clob := REPLACE(w_return_clob, CHR(10), '<br/><br/>');
     w_return_clob := REPLACE(w_return_clob, CHR(10), '<br/>');
     w_return_clob := REPLACE(w_return_clob, CHR(13), '');

  end if; --if a_servizio is not null and a_testo_clob is not null then

<< fine >>
null;

  RETURN w_return_clob;

END;
/
