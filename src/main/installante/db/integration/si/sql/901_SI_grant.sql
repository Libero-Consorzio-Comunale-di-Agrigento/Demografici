--liquibase formatted sql
--changeset amonopoli:202503240930_1 runOnChange:true stripComments:false
grant all on menuditta to ${targetUser} with grant option
/
grant all on com       to ${targetUser} with grant option
/
