--liquibase formatted sql
--changeset snocca:202210181800 runOnChange:true
create or replace synonym AS4_ANAGRAFE_SOGGETTI for ${global.db.as4.username}.ANAGRAFE_SOGGETTI
/
create or replace synonym AS4_ANAGRAFE_SOGGETTI_PKG for ${global.db.as4.username}.ANAGRAFE_SOGGETTI_PKG
/
create or replace synonym AS4_ANAGRAFE_SOGGETTI_TPK for ${global.db.as4.username}.ANAGRAFE_SOGGETTI_TPK
/
create or replace synonym AS4_ANAGRAFICI_TPK for ${global.db.as4.username}.ANAGRAFICI_TPK
/
create or replace synonym AS4_ANAGRAFICI_PKG for ${global.db.as4.username}.ANAGRAFICI_PKG
/
create or replace synonym AS4_CONTATTI_TPK for ${global.db.as4.username}.CONTATTI_TPK
/
create or replace synonym AS4_CONTATTI_PKG for ${global.db.as4.username}.CONTATTI_PKG
/
create or replace synonym AS4_RECAPITI_TPK for ${global.db.as4.username}.RECAPITI_TPK
/
create or replace synonym AS4_RECAPITI_PKG for ${global.db.as4.username}.RECAPITI_PKG
/
create or replace synonym AS4_TIPI_SOGGETTO_TPK for ${global.db.as4.username}.TIPI_SOGGETTO_TPK
/
create or replace synonym AS4_TIPI_RECAPITO_TPK for ${global.db.as4.username}.TIPI_RECAPITO_TPK
/
create or replace synonym AS4_TIPI_CONTATTO_TPK for ${global.db.as4.username}.TIPI_CONTATTO_TPK
/
