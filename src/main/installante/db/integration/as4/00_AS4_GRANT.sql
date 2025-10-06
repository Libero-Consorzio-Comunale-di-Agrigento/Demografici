--liquibase formatted sql
--changeset snocca:202210151701 runOnChange:true

grant select on ANAGRAFE_SOGGETTI to ${targetUser}
/
grant execute on ANAGRAFE_SOGGETTI_PKG to ${targetUser}
/
grant execute on ANAGRAFE_SOGGETTI_TPK to ${targetUser}
/
grant execute on ANAGRAFICI_PKG to ${targetUser}
/
grant execute on ANAGRAFICI_TPK to ${targetUser}
/
grant select on AS4_V_ANAGRAFICI to ${targetUser}
/
grant select on AS4_V_ANAGRAFICI_STRUTTURA to ${targetUser}
/
grant select on AS4_V_CONTATTI to ${targetUser}
/
grant select on AS4_V_RECAPITI to ${targetUser}
/
grant select on AS4_V_RECAPITI_CORRENTI to ${targetUser}
/
grant select on AS4_V_SOGGETTI to ${targetUser}
/
grant select on AS4_V_SOGGETTI_CORRENTI to ${targetUser}
/
grant select on AS4_V_SOGGETTI_STORICO to ${targetUser}
/
grant select on AS4_V_TIPI_CONTATTO to ${targetUser}
/
grant select on AS4_V_TIPI_RECAPITO to ${targetUser}
/
grant select on AS4_V_TIPI_SOGGETTO to ${targetUser}
/
grant execute on CONTATTI_PKG to ${targetUser}
/
grant execute on CONTATTI_TPK to ${targetUser}
/
grant execute on RECAPITI_PKG to ${targetUser}
/
grant execute on RECAPITI_TPK to ${targetUser}
/
grant execute on TIPI_CONTATTO_TPK to ${targetUser}
/
grant execute on TIPI_RECAPITO_TPK to ${targetUser}
/
grant execute on TIPI_SOGGETTO_TPK to ${targetUser}
/
