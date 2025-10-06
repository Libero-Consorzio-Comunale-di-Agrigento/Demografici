--liquibase formatted sql
--changeset snocca:202303091556 runOnChange:true

grant select on DOCUMENTI to ${targetUser}
/
grant select on OGGETTI_FILE to ${targetUser}
/
grant update on OGGETTI_FILE to ${targetUser}
/
grant execute on F_ELIMINA_DOCUMENTO to ${targetUser}
/
