--liquibase formatted sql
--changeset amonopoli:202312211350 runOnChange:true stripComments:false
create or replace view ISTD7A_int
	(archivio, punto, des_punto)
AS
-- nati vivi - dichiarati all'ufficiale di stato civile (1.1)
select 'NAS','1.1','Nati Vivi - Dichiarati all''Ufficiale'
  from dual
UNION
-- nati vivi - di cui nati nel territorio del comune (1.1.1)
select 'NAS','1.1.1','Nati Vivi - Dichiarati all''Ufficiale - Nati nel Comune'
  from dual
UNION
-- nati vivi - di cui nati in altro comune (1.1.2)
select 'NAS','1.1.2','Nati Vivi - Dichiarati all''Ufficiale - Nati in altro Comune'
  from dual
UNION
-- nati vivi - dichiarati in un centro di nascita (1.2)
select 'NAS','1.2','Dichiarati alla Direzione Sanitaria'
  from dual
UNION
-- nati vivi - da stranieri
select 'NAS','1.3.1','Nati Vivi - da Genitori Stranieri'
  from dual
UNION
-- nati morti - legittimi
select 'NAS','2.1','Nati Morti - Legittimi'
  from dual
UNION
-- nati morti - naturali
select 'NAS','2.2','Nati Morti - Naturali'
  from dual
UNION
-- nati morti - da stranieri
select 'NAS','2.3.1','Nati Morti - da Genitori Stranieri '
  from dual
UNION
-- nati vivi legittimi
select 'NAS','3.1','Nati Vivi - Legittimi'
  from dual
UNION
-- nati vivi naturali 
select 'NAS','3.2','Nati Vivi - Naturali'
  from dual
UNION
-- nati vivi e morti - da parti plurimi
select 'NAS','3.3','Nati Vivi - da Parti Plurimi'
  from dual
UNION
-- morti nel 1 anno
select 'MOR','4.1','Morti - nel 1 anno di vita'
  from dual
UNION
-- morti oltre il 1 anno
select 'MOR','4.2','Morti - oltre 1 anno di vita'
  from dual
UNION
-- morti stranieri
select 'MOR','4.3.1','Morti - Stranieri'
  from dual
UNION
-- matrimoni religiosi
select 'MAT','5.1','Matrimoni - Rito Religioso'
  from dual
UNION
-- matrimoni civili
select 'MAT','5.2','Matrimoni - Rito Civile'
  from dual
UNION
-- matrimoni stranieri
select 'MAT','5.3.1','Matrimoni - Stranieri'
  from dual
UNION
-- 6.1 - accordi ex art.6 - separazioni
-- 6.2 - accordi ex art.6 - divorzi
-- 6.3 - accordi ex art.6 - scioglimenti
-- 7.1 - accordi ex art.12 - separazioni
-- 7.2 - accordi ex art.12 - divorzi
-- 7.3 - accordi ex art.12 - scioglimenti
select 'DIV', '6.1', 'Accordi extragiudiziali ex art. 6 - Separazioni'
  from dual
UNION
select 'DIV', '6.2', 'Accordi extragiudiziali ex art. 6 - Divorzi'
  from dual
UNION
select 'SCI', '6.3', 'Accordi extragiudiziali ex art. 6 - Scioglimenti'
  from dual
UNION
select 'DIV', '7.1', 'Accordi extragiudiziali ex art. 12 - Separazioni'
  from dual
UNION
select 'DIV', '7.2', 'Accordi extragiudiziali ex art. 12 - Divorzi'
  from dual
UNION
select 'SCI', '7.3', 'Accordi extragiudiziali ex art. 12 - Scioglimenti'
  from dual
UNION
-- 8.1 Unioni Civili
select 'UCI','8.1','Unioni Civili'
  from dual
UNION
-- 8.2 Unioni Civili - Scioglimenti (per rilevazione annuale < 2024)
select 'SCI_AN','8.2','Unioni Civili - Scioglimenti (per rilevazione annuale < 2024)'
  from dual
UNION
-- 9.1 Cessazioni di Unione Civile
select 'DIV', '9.1', 'Provvedimenti Tribunale / Corte d''Appello - Separazioni'
  from dual
UNION
select 'DIV', '9.2', 'Provvedimenti Tribunale / Corte d''Appello - Divorzi'
  from dual
UNION
select 'SCI', '9.3', 'Provvedimenti Tribunale / Corte d''Appello - Scioglimenti'
  from dual
/
comment on table ISTD7A_INT is 'ISTAT - Dati per Compilazione Modello D7A - Intestazioni (view)'
/
