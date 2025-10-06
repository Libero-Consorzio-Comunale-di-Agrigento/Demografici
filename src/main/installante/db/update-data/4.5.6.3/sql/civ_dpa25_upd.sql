--liquibase formatted sql
--changeset snocca:202306291800 runOnChange:true stripComments:false
update civdpa dpa
   set avvocato_sposo_cognome = avvocato_sposo
 where avvocato_sposo_cognome is null and avvocato_sposo is not null
/
update civdpa dpa
   set avvocato_sposa_cognome = avvocato_sposa
 where avvocato_sposa_cognome is null and avvocato_sposa is not null
/