--liquibase formatted sql
--changeset amonopoli:202411191225_1 runOnChange:true
CREATE OR REPLACE SYNONYM STATS_CAMPI_GRAFICI            FOR ${global.db.stats.username}.STATS_CAMPI_GRAFICI
/
CREATE OR REPLACE SYNONYM STATS_CAMPI_SELECT             FOR ${global.db.stats.username}.STATS_CAMPI_SELECT
/
CREATE OR REPLACE SYNONYM STATS_CAMPI_STATICI_VISTE      FOR ${global.db.stats.username}.STATS_CAMPI_STATICI_VISTE
/
CREATE OR REPLACE SYNONYM STATS_CAMPI_VISTE              FOR ${global.db.stats.username}.STATS_CAMPI_VISTE
/
CREATE OR REPLACE SYNONYM STATS_CATEGORIE                FOR ${global.db.stats.username}.STATS_CATEGORIE
/
CREATE OR REPLACE SYNONYM STATS_CATEGORIE_SELECT         FOR ${global.db.stats.username}.STATS_CATEGORIE_SELECT
/
CREATE OR REPLACE SYNONYM STATS_ESTRAZIONI               FOR ${global.db.stats.username}.STATS_ESTRAZIONI
/
CREATE OR REPLACE SYNONYM STATS_GRAFICI                  FOR ${global.db.stats.username}.STATS_GRAFICI
/
CREATE OR REPLACE SYNONYM STATS_GROUP_BY_SELECT          FOR ${global.db.stats.username}.STATS_GROUP_BY_SELECT
/
CREATE OR REPLACE SYNONYM STATS_ORDER_BY_SELECT          FOR ${global.db.stats.username}.STATS_ORDER_BY_SELECT
/
CREATE OR REPLACE SYNONYM STATS_REGISTRO                 FOR ${global.db.stats.username}.STATS_REGISTRO
/
CREATE OR REPLACE SYNONYM STATS_SELECT                   FOR ${global.db.stats.username}.STATS_SELECT
/
CREATE OR REPLACE SYNONYM STATS_VISTE                    FOR ${global.db.stats.username}.STATS_VISTE
/
CREATE OR REPLACE SYNONYM STATS_WHERE_SELECT             FOR ${global.db.stats.username}.STATS_WHERE_SELECT
/
CREATE OR REPLACE SYNONYM STATS_HIBERNATE_SEQUENCE       FOR ${global.db.stats.username}.HIBERNATE_SEQUENCE
/
CREATE OR REPLACE SYNONYM STATS_V_ENTI                   FOR ${global.db.stats.username}.V_ENTI
/
