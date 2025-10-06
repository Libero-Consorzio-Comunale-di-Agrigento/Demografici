--liquibase formatted sql
--changeset amonopoli:202305230915_3 runOnChange:true stripComments:false
insert into CIVDRF (TIPO_ATTO, RICHIAMO, PROGR_DETTAGLIO, FORMULA, FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO, ID, FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO)
select 2, 99, 0, '2-FIR-CNA1', null, null, null, null, null, null
  from dual
 where not exists (select 1 from civdrf b
                    where b.tipo_atto = 2
                      and b.richiamo  = 99
                      and b.formula   = '2-FIR-CNA1')
/
insert into CIVDRF (TIPO_ATTO, RICHIAMO, PROGR_DETTAGLIO, FORMULA, FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO, ID, FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO)
select 2, 99, 0, '2-FIR-CNA2', null, null, null, null, null, null
  from dual
 where not exists (select 1 from civdrf b
                    where b.tipo_atto = 2
                      and b.richiamo  = 99
                      and b.formula   = '2-FIR-CNA2')
/
insert into CIVDRF (TIPO_ATTO, RICHIAMO, PROGR_DETTAGLIO, FORMULA, FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO, ID, FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO)
select 2, 99, 0, '2-FIR-CNA3', null, null, null, null, null, null
  from dual
 where not exists (select 1 from civdrf b
                    where b.tipo_atto = 2
                      and b.richiamo  = 99
                      and b.formula   = '2-FIR-CNA3')
/
insert into CIVDRF (TIPO_ATTO, RICHIAMO, PROGR_DETTAGLIO, FORMULA, FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO, ID, FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO)
select 2, 99, 0, '2-FIR-CNA4', null, null, null, null, null, null
  from dual
 where not exists (select 1 from civdrf b
                    where b.tipo_atto = 2
                      and b.richiamo  = 99
                      and b.formula   = '2-FIR-CNA4')
/
