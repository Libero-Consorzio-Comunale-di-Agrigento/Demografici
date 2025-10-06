--liquibase formatted sql
--changeset amonopoli:202411190900_1 runOnChange:true
grant select on ANASTA_V                       to ${global.db.stats.username}
/
grant select on ANAVBI                         to ${global.db.stats.username}
/
grant select on ANAVBI_STORICO                 to ${global.db.stats.username}
/
grant select on ANAVBI_TOTALE                  to ${global.db.stats.username}
/
grant select on ANAVMO                         to ${global.db.stats.username}
/
grant select on ANAVXX_ARMA                    to ${global.db.stats.username}
/
grant select on ANAVXX_ATTIVITA_PROF           to ${global.db.stats.username}
/
grant select on ANAVXX_CODICE_VIA              to ${global.db.stats.username}
/
grant select on ANAVXX_COD_COMUNE              to ${global.db.stats.username}
/
grant select on ANAVXX_COD_PROVINCIA           to ${global.db.stats.username}
/
grant select on ANAVXX_COD_REGIONE             to ${global.db.stats.username}
/
grant select on ANAVXX_COMUNE                  to ${global.db.stats.username}
/
grant select on ANAVXX_CORPO                   to ${global.db.stats.username}
/
grant select on ANAVXX_DATA_STORICO            to ${global.db.stats.username}
/
grant select on ANAVXX_DENOMINAZIONE_VIA       to ${global.db.stats.username}
/
grant select on ANAVXX_DES_ARMA                to ${global.db.stats.username}
/
grant select on ANAVXX_DES_CORPO               to ${global.db.stats.username}
/
grant select on ANAVXX_DES_ESITO_LEVA          to ${global.db.stats.username}
/
grant select on ANAVXX_DES_GRADO               to ${global.db.stats.username}
/
grant select on ANAVXX_DES_PROFESSIONE         to ${global.db.stats.username}
/
grant select on ANAVXX_DES_RAPPORTO_PAR        to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_01     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_02     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_03     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_04     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_05     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_06     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_07     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_08     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_09     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_10     to ${global.db.stats.username}
/
grant select on ANAVXX_DES_SUDDIVISIONE_CAP    to ${global.db.stats.username}
/
grant select on ANAVXX_DES_TIPO_DI             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_TIPO_DS             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_TITOLO_STUDIO       to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_01             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_02             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_03             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_04             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_05             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_06             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_07             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_08             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_09             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_10            to ${global.db.stats.username}
/
grant select on ANAVXX_DES_UNITA_CAP           to ${global.db.stats.username}
/
grant select on ANAVXX_ESITO_LEVA              to ${global.db.stats.username}
/
grant select on ANAVXX_FLAG_S                  to ${global.db.stats.username}
/
grant select on ANAVXX_FLAG_SI                 to ${global.db.stats.username}
/
grant select on ANAVXX_GRADO                   to ${global.db.stats.username}
/
grant select on ANAVXX_GRUPPO_DI_STUDIO        to ${global.db.stats.username}
/
grant select on ANAVXX_GRUPPO_NAZIONALITA      to ${global.db.stats.username}
/
grant select on ANAVXX_MOTIVO_DOC              to ${global.db.stats.username}
/
grant select on ANAVXX_NAZIONALITA             to ${global.db.stats.username}
/
grant select on ANAVXX_POSIZIONE_PROF          to ${global.db.stats.username}
/
grant select on ANAVXX_PROFESSIONE             to ${global.db.stats.username}
/
grant select on ANAVXX_RAPPORTO_PAR            to ${global.db.stats.username}
/
grant select on ANAVXX_REGIONE                 to ${global.db.stats.username}
/
grant select on ANAVXX_SEQUENZA_PAR            to ${global.db.stats.username}
/
grant select on ANAVXX_SESSO                   to ${global.db.stats.username}
/
grant select on ANAVXX_SEZIONE_ELE             to ${global.db.stats.username}
/
grant select on ANAVXX_STATO_ALBO_ELE          to ${global.db.stats.username}
/
grant select on ANAVXX_STATO_CIVILE            to ${global.db.stats.username}
/
grant select on ANAVXX_STATO_ELE               to ${global.db.stats.username}
/
grant select on ANAVXX_TIPO_DI                 to ${global.db.stats.username}
/
grant select on ANAVXX_TIPO_DS                 to ${global.db.stats.username}
/
grant select on ANAVXX_TITOLO_STUDIO           to ${global.db.stats.username}
/
grant select on ANAVXX_COD_EVE                 to ${global.db.stats.username}
/
grant select on ANAVXX_COD_MOV                 to ${global.db.stats.username}
/
grant select on ANAVXX_DES_COD_EVE             to ${global.db.stats.username}
/
grant select on ANAVXX_DES_COD_MOV             to ${global.db.stats.username}
/
