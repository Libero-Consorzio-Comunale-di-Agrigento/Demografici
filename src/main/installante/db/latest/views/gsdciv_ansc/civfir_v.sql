--liquibase formatted sql
--changeset amonopoli:202402201640 runAlways:true stripComments:false
create or replace view civfir_v
as
select fir.*
     , (select descrizione from civfir_v_DIZ where cod_archivio = 'RUO' and codice = fir.cod_ruolo) des_ruolo
   --  , (select descrizione from civfir_v_DIZ where cod_archivio = 'TFI' and codice = fir.tipo_firma) des_tipo_firma
  from civfir fir
/
COMMENT ON TABLE CIVFIR_V IS 'Stato Civile - Dati dei Firmatari (view)'
/
