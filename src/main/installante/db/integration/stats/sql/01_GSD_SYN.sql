--liquibase formatted sql
--changeset amonopoli:202411190900_2 runOnChange:true
create or replace synonym ${targetUser}_INDIVIDUI_ANA                  for ${targetUser}.ANAVBI
/
create or replace synonym ${targetUser}_INDIVIDUI_ANA_P                for ${targetUser}.ANAVBI
/
create or replace synonym ${targetUser}_INDIVIDUI_ANA_STORICO          for ${targetUser}.ANAVBI_STORICO
/
create or replace synonym ${targetUser}_INDIVIDUI_ANA_STORICO_P        for ${targetUser}.ANAVBI_STORICO
/
create or replace synonym ${targetUser}_INDIVIDUI_ANA_TOTALE           for ${targetUser}.ANAVBI_TOTALE
/
create or replace synonym ${targetUser}_INDIVIDUI_ANA_TOTALE_P         for ${targetUser}.ANAVBI_TOTALE
/
create or replace synonym ${targetUser}_MOVIMENTI_ANA                  for ${targetUser}.ANAVMO
/
create or replace synonym ${targetUser}_MOVIMENTI_ANA_P                for ${targetUser}.ANAVMO
/
create or replace synonym ${targetUser}_STATISTICHE_ANA                for ${targetUser}.ANASTA_V
/
create or replace synonym ${targetUser}_STATISTICHE_ANA_P              for ${targetUser}.ANASTA_V
/
create or replace synonym ${targetUser}_ARMA_COD                       for ${targetUser}.ANAVXX_ARMA
/
create or replace synonym ${targetUser}_ARMA_COD_P                     for ${targetUser}.ANAVXX_ARMA
/
create or replace synonym ${targetUser}_ARMA_DES                       for ${targetUser}.ANAVXX_DES_ARMA
/
create or replace synonym ${targetUser}_ARMA_DES_P                     for ${targetUser}.ANAVXX_DES_ARMA
/
create or replace synonym ${targetUser}_ATTIVITA_PROF_COD              for ${targetUser}.ANAVXX_ATTIVITA_PROF
/
create or replace synonym ${targetUser}_ATTIVITA_PROF_COD_P            for ${targetUser}.ANAVXX_ATTIVITA_PROF
/
create or replace synonym ${targetUser}_CORPO_COD                      for ${targetUser}.ANAVXX_CORPO
/
create or replace synonym ${targetUser}_CORPO_COD_P                    for ${targetUser}.ANAVXX_CORPO
/
create or replace synonym ${targetUser}_CORPO_DES                      for ${targetUser}.ANAVXX_DES_CORPO
/
create or replace synonym ${targetUser}_CORPO_DES_P                    for ${targetUser}.ANAVXX_DES_CORPO
/
create or replace synonym ${targetUser}_DATA_STORICO                   for ${targetUser}.ANAVXX_DATA_STORICO
/
create or replace synonym ${targetUser}_DATA_STORICO_P                 for ${targetUser}.ANAVXX_DATA_STORICO
/
create or replace synonym ${targetUser}_DENOMINAZIONE_VIA_COD          for ${targetUser}.ANAVXX_CODICE_VIA
/
create or replace synonym ${targetUser}_DENOMINAZIONE_VIA_COD_P        for ${targetUser}.ANAVXX_CODICE_VIA
/
create or replace synonym ${targetUser}_DENOMINAZIONE_VIA_DES          for ${targetUser}.ANAVXX_DENOMINAZIONE_VIA
/
create or replace synonym ${targetUser}_DENOMINAZIONE_VIA_DES_P        for ${targetUser}.ANAVXX_DENOMINAZIONE_VIA
/
create or replace synonym ${targetUser}_COMUNE_COD                     for ${targetUser}.ANAVXX_COD_COMUNE
/
create or replace synonym ${targetUser}_COMUNE_COD_P                   for ${targetUser}.ANAVXX_COD_COMUNE
/
create or replace synonym ${targetUser}_COMUNE_DES                     for ${targetUser}.ANAVXX_COMUNE
/
create or replace synonym ${targetUser}_COMUNE_DES_P                   for ${targetUser}.ANAVXX_COMUNE
/
create or replace synonym ${targetUser}_ESITO_LEVA_COD                 for ${targetUser}.ANAVXX_ESITO_LEVA
/
create or replace synonym ${targetUser}_ESITO_LEVA_COD_P               for ${targetUser}.ANAVXX_ESITO_LEVA
/
create or replace synonym ${targetUser}_ESITO_LEVA_DES                 for ${targetUser}.ANAVXX_DES_ESITO_LEVA
/
create or replace synonym ${targetUser}_ESITO_LEVA_DES_P               for ${targetUser}.ANAVXX_DES_ESITO_LEVA
/
create or replace synonym ${targetUser}_FLAG_S                         for ${targetUser}.ANAVXX_FLAG_S
/
create or replace synonym ${targetUser}_FLAG_S_P                      for ${targetUser}.ANAVXX_FLAG_S
/
create or replace synonym ${targetUser}_FLAG_SI                        for ${targetUser}.ANAVXX_FLAG_SI
/
create or replace synonym ${targetUser}_FLAG_SI_P                      for ${targetUser}.ANAVXX_FLAG_SI
/
create or replace synonym ${targetUser}_GRADO_COD                      for ${targetUser}.ANAVXX_GRADO
/
create or replace synonym ${targetUser}_GRADO_COD_P                    for ${targetUser}.ANAVXX_GRADO
/
create or replace synonym ${targetUser}_GRADO_DES                      for ${targetUser}.ANAVXX_DES_GRADO
/
create or replace synonym ${targetUser}_GRADO_DES_P                    for ${targetUser}.ANAVXX_DES_GRADO
/
create or replace synonym ${targetUser}_GRUPPO_DI_STUDIO_COD           for ${targetUser}.ANAVXX_GRUPPO_DI_STUDIO
/
create or replace synonym ${targetUser}_GRUPPO_DI_STUDIO_COD_P         for ${targetUser}.ANAVXX_GRUPPO_DI_STUDIO
/
create or replace synonym ${targetUser}_GRUPPO_NAZIONALITA_DES         for ${targetUser}.ANAVXX_GRUPPO_NAZIONALITA
/
create or replace synonym ${targetUser}_GRUPPO_NAZIONALITA_DES_P       for ${targetUser}.ANAVXX_GRUPPO_NAZIONALITA
/
create or replace synonym ${targetUser}_MOTIVO_DOC_COD                 for ${targetUser}.ANAVXX_MOTIVO_DOC
/
create or replace synonym ${targetUser}_MOTIVO_DOC_COD_P               for ${targetUser}.ANAVXX_MOTIVO_DOC
/
create or replace synonym ${targetUser}_NAZIONALITA_COD                for ${targetUser}.ANAVXX_NAZIONALITA
/
create or replace synonym ${targetUser}_NAZIONALITA_COD_P              for ${targetUser}.ANAVXX_NAZIONALITA
/
create or replace synonym ${targetUser}_POSIZIONE_PROF_COD             for ${targetUser}.ANAVXX_POSIZIONE_PROF
/
create or replace synonym ${targetUser}_POSIZIONE_PROF_COD_P           for ${targetUser}.ANAVXX_POSIZIONE_PROF
/
create or replace synonym ${targetUser}_PROFESSIONE_COD                for ${targetUser}.ANAVXX_PROFESSIONE
/
create or replace synonym ${targetUser}_PROFESSIONE_COD_P              for ${targetUser}.ANAVXX_PROFESSIONE
/
create or replace synonym ${targetUser}_PROFESSIONE_DES                for ${targetUser}.ANAVXX_DES_PROFESSIONE
/
create or replace synonym ${targetUser}_PROFESSIONE_DES_P              for ${targetUser}.ANAVXX_DES_PROFESSIONE
/
create or replace synonym ${targetUser}_PROVINCIA_COD                  for ${targetUser}.ANAVXX_COD_PROVINCIA
/
create or replace synonym ${targetUser}_PROVINCIA_COD_P                for ${targetUser}.ANAVXX_COD_PROVINCIA
/
create or replace synonym ${targetUser}_RAPPORTO_PAR_COD               for ${targetUser}.ANAVXX_RAPPORTO_PAR
/
create or replace synonym ${targetUser}_RAPPORTO_PAR_COD_P             for ${targetUser}.ANAVXX_RAPPORTO_PAR
/
create or replace synonym ${targetUser}_RAPPORTO_PAR_DES               for ${targetUser}.ANAVXX_DES_RAPPORTO_PAR
/
create or replace synonym ${targetUser}_RAPPORTO_PAR_DES_P             for ${targetUser}.ANAVXX_DES_RAPPORTO_PAR
/
create or replace synonym ${targetUser}_REGIONE_COD                    for ${targetUser}.ANAVXX_COD_REGIONE
/
create or replace synonym ${targetUser}_REGIONE_COD_P                  for ${targetUser}.ANAVXX_COD_REGIONE
/
create or replace synonym ${targetUser}_REGIONE_DES                    for ${targetUser}.ANAVXX_REGIONE
/
create or replace synonym ${targetUser}_REGIONE_DES_P                  for ${targetUser}.ANAVXX_REGIONE
/
create or replace synonym ${targetUser}_SEQUENZA_PAR_COD               for ${targetUser}.ANAVXX_SEQUENZA_PAR
/
create or replace synonym ${targetUser}_SEQUENZA_PAR_COD_P             for ${targetUser}.ANAVXX_SEQUENZA_PAR
/
create or replace synonym ${targetUser}_SESSO_COD                      for ${targetUser}.ANAVXX_SESSO
/
create or replace synonym ${targetUser}_SESSO_COD_P                    for ${targetUser}.ANAVXX_SESSO
/
create or replace synonym ${targetUser}_SEZIONE_ELE                    for ${targetUser}.ANAVXX_SEZIONE_ELE
/
create or replace synonym ${targetUser}_SEZIONE_ELE_P                  for ${targetUser}.ANAVXX_SEZIONE_ELE
/
create or replace synonym ${targetUser}_STATO_ALBO_ELE_COD             for ${targetUser}.ANAVXX_STATO_ALBO_ELE
/
create or replace synonym ${targetUser}_STATO_ALBO_ELE_COD_P           for ${targetUser}.ANAVXX_STATO_ALBO_ELE
/
create or replace synonym ${targetUser}_STATO_CIVILE_COD               for ${targetUser}.ANAVXX_STATO_CIVILE
/
create or replace synonym ${targetUser}_STATO_CIVILE_COD_P             for ${targetUser}.ANAVXX_STATO_CIVILE
/
create or replace synonym ${targetUser}_STATO_ELE_COD                  for ${targetUser}.ANAVXX_STATO_ELE
/
create or replace synonym ${targetUser}_STATO_ELE_COD_P                for ${targetUser}.ANAVXX_STATO_ELE
/
create or replace synonym ${targetUser}_SUDDIVISIONE_01_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_01
/
create or replace synonym ${targetUser}_SUDDIVISIONE_01_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_01
/
create or replace synonym ${targetUser}_SUDDIVISIONE_02_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_02
/
create or replace synonym ${targetUser}_SUDDIVISIONE_02_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_02
/
create or replace synonym ${targetUser}_SUDDIVISIONE_03_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_03
/
create or replace synonym ${targetUser}_SUDDIVISIONE_03_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_03
/
create or replace synonym ${targetUser}_SUDDIVISIONE_04_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_04
/
create or replace synonym ${targetUser}_SUDDIVISIONE_04_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_04
/
create or replace synonym ${targetUser}_SUDDIVISIONE_05_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_05
/
create or replace synonym ${targetUser}_SUDDIVISIONE_05_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_05
/
create or replace synonym ${targetUser}_SUDDIVISIONE_06_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_06
/
create or replace synonym ${targetUser}_SUDDIVISIONE_06_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_06
/
create or replace synonym ${targetUser}_SUDDIVISIONE_07_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_07
/
create or replace synonym ${targetUser}_SUDDIVISIONE_07_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_07
/
create or replace synonym ${targetUser}_SUDDIVISIONE_08_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_08
/
create or replace synonym ${targetUser}_SUDDIVISIONE_08_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_08
/
create or replace synonym ${targetUser}_SUDDIVISIONE_09_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_09
/
create or replace synonym ${targetUser}_SUDDIVISIONE_09_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_09
/
create or replace synonym ${targetUser}_SUDDIVISIONE_10_DES            for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_10
/
create or replace synonym ${targetUser}_SUDDIVISIONE_10_DES_P          for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_10
/
create or replace synonym ${targetUser}_SUDDIVISIONE_CAP_DES           for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_CAP
/
create or replace synonym ${targetUser}_SUDDIVISIONE_CAP_DES_P         for ${targetUser}.ANAVXX_DES_SUDDIVISIONE_CAP
/
create or replace synonym ${targetUser}_TIPO_DI_COD                    for ${targetUser}.ANAVXX_TIPO_DI
/
create or replace synonym ${targetUser}_TIPO_DI_COD_P                  for ${targetUser}.ANAVXX_TIPO_DI
/
create or replace synonym ${targetUser}_TIPO_DI_DES                    for ${targetUser}.ANAVXX_DES_TIPO_DI
/
create or replace synonym ${targetUser}_TIPO_DI_DES_P                  for ${targetUser}.ANAVXX_DES_TIPO_DI
/
create or replace synonym ${targetUser}_TIPO_DS_COD                    for ${targetUser}.ANAVXX_TIPO_DS
/
create or replace synonym ${targetUser}_TIPO_DS_COD_P                  for ${targetUser}.ANAVXX_TIPO_DS
/
create or replace synonym ${targetUser}_TIPO_DS_DES                    for ${targetUser}.ANAVXX_DES_TIPO_DS
/
create or replace synonym ${targetUser}_TIPO_DS_DES_P                  for ${targetUser}.ANAVXX_DES_TIPO_DS
/
create or replace synonym ${targetUser}_TITOLO_STUDIO_COD              for ${targetUser}.ANAVXX_TITOLO_STUDIO
/
create or replace synonym ${targetUser}_TITOLO_STUDIO_COD_P            for ${targetUser}.ANAVXX_TITOLO_STUDIO
/
create or replace synonym ${targetUser}_TITOLO_STUDIO_DES              for ${targetUser}.ANAVXX_DES_TITOLO_STUDIO
/
create or replace synonym ${targetUser}_TITOLO_STUDIO_DES_P            for ${targetUser}.ANAVXX_DES_TITOLO_STUDIO
/
create or replace synonym ${targetUser}_UNITA_01_DES                   for ${targetUser}.ANAVXX_DES_UNITA_01
/
create or replace synonym ${targetUser}_UNITA_01_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_01
/
create or replace synonym ${targetUser}_UNITA_02_DES                   for ${targetUser}.ANAVXX_DES_UNITA_02
/
create or replace synonym ${targetUser}_UNITA_02_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_02
/
create or replace synonym ${targetUser}_UNITA_03_DES                   for ${targetUser}.ANAVXX_DES_UNITA_03
/
create or replace synonym ${targetUser}_UNITA_03_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_03
/
create or replace synonym ${targetUser}_UNITA_04_DES                   for ${targetUser}.ANAVXX_DES_UNITA_04
/
create or replace synonym ${targetUser}_UNITA_04_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_04
/
create or replace synonym ${targetUser}_UNITA_05_DES                   for ${targetUser}.ANAVXX_DES_UNITA_05
/
create or replace synonym ${targetUser}_UNITA_05_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_05
/
create or replace synonym ${targetUser}_UNITA_06_DES                   for ${targetUser}.ANAVXX_DES_UNITA_06
/
create or replace synonym ${targetUser}_UNITA_06_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_06
/
create or replace synonym ${targetUser}_UNITA_07_DES                   for ${targetUser}.ANAVXX_DES_UNITA_07
/
create or replace synonym ${targetUser}_UNITA_07_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_07
/
create or replace synonym ${targetUser}_UNITA_08_DES                   for ${targetUser}.ANAVXX_DES_UNITA_08
/
create or replace synonym ${targetUser}_UNITA_08_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_08
/
create or replace synonym ${targetUser}_UNITA_09_DES                   for ${targetUser}.ANAVXX_DES_UNITA_09
/
create or replace synonym ${targetUser}_UNITA_09_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_09
/
create or replace synonym ${targetUser}_UNITA_10_DES                   for ${targetUser}.ANAVXX_DES_UNITA_10
/
create or replace synonym ${targetUser}_UNITA_10_DES_P                 for ${targetUser}.ANAVXX_DES_UNITA_10
/
create or replace synonym ${targetUser}_UNITA_CAP_DES                  for ${targetUser}.ANAVXX_DES_UNITA_CAP
/
create or replace synonym ${targetUser}_UNITA_CAP_DES_P                for ${targetUser}.ANAVXX_DES_UNITA_CAP
/
create or replace synonym ${targetUser}_EVENTO_COD                     for ${targetUser}.ANAVXX_COD_EVE
/
create or replace synonym ${targetUser}_EVENTO_DES                     for ${targetUser}.ANAVXX_DES_COD_EVE
/
create or replace synonym ${targetUser}_MOVIMENTO_COD                  for ${targetUser}.ANAVXX_COD_MOV
/
create or replace synonym ${targetUser}_MOVIMENTO_DES                  for ${targetUser}.ANAVXX_DES_COD_MOV
/
