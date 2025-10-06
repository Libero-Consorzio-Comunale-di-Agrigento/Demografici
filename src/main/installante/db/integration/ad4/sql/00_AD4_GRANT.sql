--liquibase formatted sql
--changeset snocca:202210181629 runOnChange:true

GRANT SELECT ON AD4.COMUNI    TO ${targetUser}
/

GRANT SELECT ON AD4.MODULI    TO ${targetUser}
/

GRANT SELECT ON AD4.PROGETTI  TO ${targetUser}
/

GRANT SELECT ON AD4.PROVINCE  TO ${targetUser}
/

GRANT SELECT ON AD4.REGIONI   TO ${targetUser}
/

GRANT SELECT ON AD4.RUOLI     TO ${targetUser}
/

GRANT SELECT ON AD4.STATI_TERRITORI   TO ${targetUser}
/

GRANT SELECT ON AD4.UTENTI    TO ${targetUser}
/

GRANT SELECT ON AD4.DIRITTI_ACCESSO   TO ${targetUser}
/
GRANT INSERT ON AD4.DIRITTI_ACCESSO   TO ${targetUser}
/
GRANT UPDATE ON AD4.DIRITTI_ACCESSO   TO ${targetUser}
/
GRANT DELETE ON AD4.DIRITTI_ACCESSO   TO ${targetUser}
/

GRANT SELECT ON AD4.UTENTI_SOGGETTI   TO ${targetUser}
/

GRANT SELECT ON AD4.LINGUE   TO ${targetUser}
/

GRANT EXECUTE ON AD4_SOGGETTO   TO ${targetUser}
/

GRANT EXECUTE ON AD4_UTENTE   TO ${targetUser}
/

GRANT SELECT  ON REGISTRO               TO ${targetUser}
/
GRANT INSERT  ON REGISTRO               TO ${targetUser}
/
GRANT UPDATE  ON REGISTRO               TO ${targetUser}
/
GRANT DELETE  ON REGISTRO               TO ${targetUser}
/
GRANT EXECUTE ON AD4_REGISTRO_UTILITY   TO ${targetUser}
/
GRANT EXECUTE ON KEY_ERROR_LOG_PKG      TO ${targetUser}
/
