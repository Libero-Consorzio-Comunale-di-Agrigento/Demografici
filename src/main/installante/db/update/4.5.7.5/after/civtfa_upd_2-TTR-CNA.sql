--liquibase formatted sql
--changeset amonopoli:202405211130 runOnChange:true
update civtfa
   set testo_4000 = replace(testo_4000,
                              'Ufficiale dello Stato Civile del Comune di <COMUNE_RESIDENZA> ho ricevuto da',
                              'Ufficiale dello Stato Civile del Comune di <COMUNE> ho ricevuto da'),
       testo_A3   = replace(testo_A3,
                              'Ufficiale dello Stato Civile del Comune di <COMUNE_RESIDENZA> ho ricevuto da',
                              'Ufficiale dello Stato Civile del Comune di <COMUNE> ho ricevuto da')
 where formula = '2-TTR-CNA'
   and riga    = 1
/