--liquibase formatted sql
--changeset amonopoli:202510291545_3 runOnChange:true stripComments:false
insert into civdrf (tipo_atto, richiamo, progr_dettaglio, formula, flag_default, flag_ricorrente, flag_testo_fisso, id, flag_aggiunta_a_capo, flag_aggiunta_richiamo)
select 4, 5, 1, '504-5-9',to_char(null), 'S', to_char(null), to_number(null), 'S', to_char(null)
  from dual
 where not exists (select 1 from civdrf b where b.tipo_atto = 4 and richiamo = 5 and progr_dettaglio = 1 and formula = '504-5-9')
/
