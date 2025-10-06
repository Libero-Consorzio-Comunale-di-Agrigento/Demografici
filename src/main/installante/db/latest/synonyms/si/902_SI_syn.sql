--liquibase formatted sql
--changeset amonopoli:202503240930_2 runOnChange:true stripComments:false
create or replace synonym menuditta for ${global.db.si.username}.menuditta
/
create or replace synonym arccom    for ${global.db.si.username}.com
/

