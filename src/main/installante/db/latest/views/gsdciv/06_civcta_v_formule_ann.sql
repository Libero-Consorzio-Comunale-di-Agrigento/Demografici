--liquibase formatted sql
--changeset snocca:202301051708 runOnChange:true stripComments:false
create or replace view civcta_v_formule_ann
(tipo_atto, sigla_categoria, tipo_atto_ann, formula, flag_default, flag_divorzio, tipo_divorzio)
as
-- atti di cittadinanza
-- annotazioni su atto di nascita
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, decode(dfa.formula,'140-NO','S') flag_default, null, null
  from civcta cta
     , civdfa dfa
 where dfa.formula                like '140%'
   and dfa.formula                not like '%-AN'
   and dfa.flag_nuovo_ordinamento is not null
   and dfa.tipo_annotazione       in ('M','C')
   and dfa.tipo_atto              = 2
   and cta.tipo_atto              = 1
   and nvl(cta.natura,'A')        in ('A','P')
UNION
-- atti di matrimonio
-- annotazioni su atto di nascita
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, decode(dfa.formula,'132','S') flag_default, cta.flag_divorzio, null
  from civcta cta
     , civdfa dfa
 where dfa.formula          like '132%'
   and dfa.formula          not like '%-AN'
   and dfa.tipo_annotazione in ('M','C')
   and dfa.tipo_atto        = 2
   and cta.tipo_atto        = 4
   and (nvl(cta.natura,'O')  in ('O') or cta.sigla = 'TMD')
   and cta.flag_divorzio    is null
UNION
-- atti di divorzio (escluso Tribunale Estero)
-- annotazioni su atto di nascita / atto di matrimonio
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, to_char(null) flag_default, cta.flag_divorzio, nat.natura_pr
  from civmat_natura nat
     , civcta cta
     , civdfa dfa
 where dfa.tipo_annotazione in ('M','C')
   and dfa.formula          not like '%-AN'
   and dfa.tipo_atto        = nat.tipo_atto
   and dfa.formula          = nat.formula
   and nat.sigla            = cta.sigla
   and cta.tipo_atto        = 4
   and cta.flag_divorzio    = 'S'
   and cta.sigla            != 'EST'
UNION
-- atti di divorzio (SOLO Tribunale Estero)
-- annotazioni su atto di nascita
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, decode(dfa.formula,'135-NO','S') flag_default, cta.flag_divorzio, nat.natura_pr
  from (select 'C' natura_pr from dual UNION select 'S' natura_pr from dual) nat
     , civcta cta
     , civdfa dfa
 where (dfa.formula = '135-NO' or dfa.formula like '999%')
   and dfa.formula          not like '%-AN'
   and dfa.tipo_annotazione in ('M','C')
   and dfa.tipo_atto        = 2
   and cta.tipo_atto        = 4
   and cta.flag_divorzio    = 'S'
   and cta.sigla            = 'EST'
UNION
-- atti di divorzio (SOLO Tribunale Estero) - scioglimento / cessazione
-- annotazioni su atto di matrimonio
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, decode(dfa.formula,'170-NO','S') flag_default, cta.flag_divorzio, nat.natura_pr
  from (select 'C' natura_pr from dual UNION select 'S' natura_pr from dual) nat
     , civcta cta
     , civdfa dfa
 where (dfa.formula in ('170','170-NO') or dfa.formula like '999%')
   and dfa.formula          not like '%-AN'
   and dfa.tipo_annotazione in ('M','C')
   and dfa.tipo_atto        = 4
   and cta.tipo_atto        = 4
   and cta.flag_divorzio    = 'S'
   and cta.sigla            = 'EST'
UNION
-- atti di divorzio (SOLO Tribunale Estero) - separazione / altro
-- annotazioni su atto di matrimonio
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, decode(dfa.formula,'170-NO','S') flag_default, cta.flag_divorzio, nat.natura_pr
  from (select 'X' natura_pr from dual UNION select 'A' natura_pr from dual) nat
     , civcta cta
     , civdfa dfa
 where dfa.formula          like '999%'
   and dfa.formula          not like '%-AN'
   and dfa.tipo_annotazione in ('M','C')
   and dfa.tipo_atto        = 4
   and cta.tipo_atto        = 4
   and cta.flag_divorzio    = 'S'
   and cta.sigla            = 'EST'
UNION
-- atti di divorzio (SOLO tipo divorzio 'Altro')
-- annotazioni su atto di matrimonio
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, decode(dfa.formula,'170-NO','S') flag_default, cta.flag_divorzio, nat.natura_pr
  from (select 'A' natura_pr from dual) nat
     , civcta cta
     , civdfa dfa
 where dfa.formula          like '999%'
   and dfa.formula          not like '%-AN'
   and dfa.tipo_annotazione in ('M','C')
   and dfa.tipo_atto        = 4
   and cta.tipo_atto        = 4
   and cta.flag_divorzio    = 'S'
   and cta.sigla            = 'UAL'
UNION
-- atti di unione civile
-- annotazioni su atto di nascita / atto di unione civile
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, to_char(null) flag_default, cta.flag_divorzio, null
  from civcta cta
     , civdfa dfa
     , civuci_natura nat
 where dfa.tipo_annotazione in ('M','C')
   and dfa.formula          not like '%-AN'
   and dfa.tipo_atto        = nat.tipo_atto
   and nvl(cta.natura,'O')  in ('O') 
   and cta.tipo_atto        = -4
   and nat.sigla            = cta.sigla
   and dfa.formula          = nat.formula
UNION
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, to_char(null) flag_default, cta.flag_divorzio, null
  from civcta cta
     , civdfa dfa
     , civuci_natura nat
 where dfa.tipo_annotazione in ('M','C')
   and dfa.formula          not like '%-AN'
   and dfa.tipo_atto        = nat.tipo_atto
   and cta.tipo_atto        = -4
   and nat.sigla            = decode(cta.natura,'O','O1','T','T2')
   and dfa.formula          = nat.formula
   and not exists (select 'x' from civuci_natura b
                    where b.sigla = cta.sigla)
UNION
-- atti di morte
-- annotazioni su atto di nascita
select cta.tipo_atto, cta.sigla, dfa.tipo_atto, dfa.formula, decode(dfa.formula,'164','S') flag_default, null, null
  from civcta cta
     , civdfa dfa
 where dfa.formula          in ('164','164-NO')
   and dfa.formula          not like '%-AN'
   and dfa.tipo_annotazione in ('M','C')
   and dfa.tipo_atto        = 2
   and cta.tipo_atto        = 5
   and nvl(cta.natura,'O')  in ('O')
/
