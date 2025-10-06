--liquibase formatted sql
--changeset amonopoli:202504181015_2 runOnChange:true stripComments:false
update civtfa
   set formula = decode(formula,'189-QUA-NO','189-QUATER',
                                '189-QUI-NO','189-QUINQU',
                                '189-SEX-NO','189-SEXIES',
                                '189-SET-NO','189-SEPTIE',
                                '189-OTT-NO','189-OCTIES')
 where formula in ('189-QUA-NO','189-QUI-NO','189-SEX-NO','189-SET-NO','189-OTT-NO')
   and exists (select 1 from civdfa dfa
                where formula in ('189-QUATER','189-QUINQU','189-SEXIES','189-SEPTIE','189-OCTIES'))
   and not exists (select 1 from civdfa dfa
                    where formula in ('189-QUA-NO','189-QUI-NO','189-SEX-NO','189-SET-NO','189-OTT-NO'))
/
