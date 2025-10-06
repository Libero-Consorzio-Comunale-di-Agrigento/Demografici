--liquibase formatted sql
--changeset snocca:202210191300 runOnChange:true
create or replace synonym AD4_COMUNI for ${global.db.ad4.username}.COMUNI
/

create or replace synonym AD4_MODULI for ${global.db.ad4.username}.MODULI
/

create or replace synonym AD4_PROGETTI for ${global.db.ad4.username}.PROGETTI
/

create or replace synonym AD4_PROVINCE for ${global.db.ad4.username}.PROVINCE
/

create or replace synonym AD4_REGIONI for ${global.db.ad4.username}.REGIONI
/

create or replace synonym AD4_RUOLI for ${global.db.ad4.username}.RUOLI
/

create or replace synonym AD4_STATI_TERRITORI for ${global.db.ad4.username}.STATI_TERRITORI
/

create or replace synonym AD4_UTENTI for ${global.db.ad4.username}.UTENTI
/

create or replace synonym AD4_DIRITTI_ACCESSO for ${global.db.ad4.username}.DIRITTI_ACCESSO
/

create or replace synonym AD4_UTENTI_SOGGETTI for ${global.db.ad4.username}.UTENTI_SOGGETTI
/

create or replace synonym AD4_LINGUE for ${global.db.ad4.username}.LINGUE
/

create or replace synonym AD4_ISTANZE for ${global.db.ad4.username}.ISTANZE
/

CREATE OR REPLACE SYNONYM AD4_REGISTRO          FOR ${global.db.ad4.username}.REGISTRO
/
CREATE OR REPLACE SYNONYM AD4_REGISTRO_UTILITY  FOR ${global.db.ad4.username}.AD4_REGISTRO_UTILITY
/
CREATE OR REPLACE SYNONYM AD4_KEY_ERROR_LOG_PKG FOR ${global.db.ad4.username}.KEY_ERROR_LOG_PKG
/
