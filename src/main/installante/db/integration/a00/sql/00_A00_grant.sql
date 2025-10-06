--liquibase formatted sql
--changeset amonopoli:202503251300_1 runOnChange:true
grant select on  N_STAMPA        to ${targetUser} with grant option;
grant select on  N_PRENOTAZIONE  to ${targetUser} with grant option;
grant select on  A_SELEZIONE     to ${targetUser} with grant option;
grant select on  A_SEQUENZE_MENU to ${targetUser} with grant option;
--
grant all on  A_ACCESSI                 to ${targetUser} with grant option;
grant all on  A_AIUTI_ERRORE            to ${targetUser} with grant option;
grant all on  A_AMBIENTI                to ${targetUser} with grant option;
grant all on  A_APPLICAZIONI            to ${targetUser} with grant option;
grant all on  A_APPOGGIO_STAMPE         to ${targetUser} with grant option;
grant all on  A_CAMPI_VISTE_ELENCHI     to ${targetUser} with grant option;
grant all on  A_CATALOGO_STAMPE         to ${targetUser} with grant option;
grant all on  A_CLASSI_STAMPA           to ${targetUser} with grant option;
grant all on  A_CODE_ELENCHI            to ${targetUser} with grant option;
grant all on  A_COLONNE_ELENCO          to ${targetUser} with grant option;
grant all on  A_COMPETENZE              to ${targetUser} with grant option;
grant all on  A_CONDIZIONI_ELENCHI      to ${targetUser} with grant option;
grant all on  A_DIRITTI_ACCESSO         to ${targetUser} with grant option;
grant all on  A_DOMINI_SELEZIONI        to ${targetUser} with grant option;
grant all on  A_DUAL                    to ${targetUser} with grant option;
grant all on  A_ELENCHI                 to ${targetUser} with grant option;
grant all on  A_EMULAZIONI              to ${targetUser} with grant option;
grant all on  A_ENTI                    to ${targetUser} with grant option;
grant all on  A_ERRORI                  to ${targetUser} with grant option;
grant all on  A_ERRORI_APPLICAZIONI     to ${targetUser} with grant option;
grant all on  A_FUNZIONI_CHIAMATE       to ${targetUser} with grant option;
grant all on  A_GRUPPI_LAVORO           to ${targetUser} with grant option;
grant all on  A_GRUPPI_LINGUISTICI      to ${targetUser} with grant option;
grant all on  A_GUIDE_O                 to ${targetUser} with grant option;
grant all on  A_GUIDE_V                 to ${targetUser} with grant option;
grant all on  A_HELP                    to ${targetUser} with grant option;
grant all on  A_INDICI_AIUTO            to ${targetUser} with grant option;
grant all on  A_ISTANZE_AMBIENTE        to ${targetUser} with grant option;
grant all on  A_MARGINI_STAMPA          to ${targetUser} with grant option;
grant all on  A_MENU                    to ${targetUser} with grant option;
grant all on  A_MODI_STAMPA             to ${targetUser} with grant option;
grant all on  A_OGGETTI                 to ${targetUser} with grant option;
grant all on  A_PARAMETRI               to ${targetUser} with grant option;
grant all on  A_PARAMETRI_ELENCHI       to ${targetUser} with grant option;
grant all on  A_PARAMETRI_INSTALLAZIONE to ${targetUser} with grant option;
grant all on  A_PARAMETRI_SCHED         to ${targetUser} with grant option;
grant all on  A_PASSI_PROC              to ${targetUser} with grant option;
grant all on  A_PERSONALIZZAZIONI       to ${targetUser} with grant option;
grant all on  A_PRENOTAZIONI            to ${targetUser} with grant option;
grant all on  A_RUOLI                   to ${targetUser} with grant option;
grant all on  A_SEGNALAZIONI_ERRORE     to ${targetUser} with grant option;
grant all on  A_SELEZIONI               to ${targetUser} with grant option;
grant all on  A_SEQUENZE_EMULAZIONE     to ${targetUser} with grant option;
grant all on  A_SETTAGGI_STAMP          to ${targetUser} with grant option;
grant all on  A_STAMPANTI               to ${targetUser} with grant option;
grant all on  A_STAMPE                  to ${targetUser} with grant option;
grant all on  A_STAMPEWEB               to ${targetUser} with grant option;
grant all on  A_TESTATE_ELENCHI         to ${targetUser} with grant option;
grant all on  A_TESTI_HELP              to ${targetUser} with grant option;
grant all on  A_UTENTI                  to ${targetUser} with grant option;
grant all on  A_VISTE_ELENCHI           to ${targetUser} with grant option;
grant all on  A_VOCI_MENU               to ${targetUser} with grant option;
grant all on  A_V_PARAMETRI             to ${targetUser} with grant option;
grant all on  A_V_SELEZIONI             to ${targetUser} with grant option;
grant all on  A_V_UTENTI                to ${targetUser} with grant option;
grant all on  A00_REF_CODES             to ${targetUser} with grant option;
grant all on  A_COMUNI                  to ${targetUser} with grant option;
grant all on  A_CONSOLATI               to ${targetUser} with grant option;
grant all on  A_PROVINCIE               to ${targetUser} with grant option;
grant all on  A_RAGGRUPPAMENTI_STATI    to ${targetUser} with grant option;
grant all on  A_REGIONI                 to ${targetUser} with grant option;
grant all on  A_STATI_TERRITORI         to ${targetUser} with grant option;
--
grant select,insert,update,delete on MENUMENUTE to ${targetUser} with grant option;
--
grant all on REGISTRO to ${targetUser} with grant option;
--
grant execute on REGISTRO_UTILITY to ${targetUser} with grant option;
grant execute on si4_tree         to ${targetUser} with grant option;
grant execute on ASTESTUT         to ${targetUser} with grant option;

