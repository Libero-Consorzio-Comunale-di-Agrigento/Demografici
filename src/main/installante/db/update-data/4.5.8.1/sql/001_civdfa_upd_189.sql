--liquibase formatted sql
--changeset amonopoli:202504181015 runOnChange:true stripComments:false
update civdfa
   set tipo_atto = 2
 where tipo_atto = 5
   and formula in ('189-QUA-NO','189-QUI-NO','189-SEX-NO','189-SET-NO','189-OTT-NO')
/
update civdfa
   set formula = decode(formula,'189-QUA-NO','189-QUATER',
                                '189-QUI-NO','189-QUINQU',
                                '189-SEX-NO','189-SEXIES',
                                '189-SET-NO','189-SEPTIE',
                                '189-OTT-NO','189-OCTIES')
 where tipo_atto = 2
   and formula in ('189-QUA-NO','189-QUI-NO','189-SEX-NO','189-SET-NO','189-OTT-NO')
   and not exists (select 1 from civdfa b
                    where b.formula in ('189-QUATER','189-QUINQU','189-SEXIES','189-SEPTIE','189-OCTIES'))
/
