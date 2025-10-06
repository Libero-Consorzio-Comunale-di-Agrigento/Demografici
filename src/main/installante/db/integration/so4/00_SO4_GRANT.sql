--liquibase formatted sql
--changeset snocca:202210190800 runOnChange:true

GRANT SELECT ON AMMINISTRAZIONI                 TO ${targetUser}
/

grant select on anagrafe_unita_organizzative    to ${targetUser}
/

GRANT SELECT ON AOO                             TO ${targetUser}
/

grant select on aoo_view                        TO ${targetUser}
/

grant select on applicativi                     to ${targetUser}
/

GRANT EXECUTE ON CODICI_IPA_TPK                 TO ${targetUser}
/

grant select on COMPETENZE_DELEGA               to ${targetUser}
/

grant execute on competenze_delega_tpk          to ${targetUser}
/

grant select on deleghe                         to ${targetUser}
/

GRANT EXECUTE ON INDIRIZZO_TELEMATICO           TO ${targetUser}
/

grant select on indirizzi_telematici            TO ${targetUser}
/

GRANT SELECT ON OTTICHE                         TO ${targetUser}
/

GRANT SELECT ON RUOLI_COMPONENTE                TO ${targetUser}
/

GRANT EXECUTE ON SO4_UTIL                       TO ${targetUser}
/

GRANT SELECT ON SUDDIVISIONI_STRUTTURA          TO ${targetUser}
/

GRANT SELECT ON VISTA_ATCO_GRAILS               TO ${targetUser}
/

GRANT SELECT ON VISTA_ATCO_GRAILS_PUBB          TO ${targetUser}
/

GRANT SELECT ON VISTA_COMP_GRAILS               TO ${targetUser}
/

GRANT SELECT ON VISTA_COMP_GRAILS_PUBB          TO ${targetUser}
/

GRANT SELECT ON VISTA_PUBB_RUCO                 TO ${targetUser}
/

GRANT SELECT ON VISTA_UNITA_ORGANIZZATIVE       TO ${targetUser}
/

GRANT SELECT ON VISTA_UNITA_ORGANIZZATIVE_PUBB  TO ${targetUser}
/