--liquibase formatted sql
--changeset amonopoli:202410231505_2 runOnChange:true stripComments:false
-- 1	ANA - ANAGRAFE
update cerdri
   set id_cerctc = 1
 where nvl(competenza,'AN') = 'AN'
   and cod_ri               not in (98,99)	-- uso interno (ads)
   and nvl(codice_anpr,99)  not in ('11','12','13')	-- uso elettorale (anpr)
   and id_cerctc            is null
/
-- 2	CIV - STATO CIVILE
update cerdri
   set id_cerctc = 2
 where nvl(competenza,'AN') = 'SC'
   and cod_ri               not in (98,99)
   and id_cerctc            is null
/
-- 3	ELE - ELETTORALE
update cerdri
   set id_cerctc = 3
 where nvl(competenza,'AN') = 'AN'
   and cod_ri               not in (98,99)	-- uso interno (ads)
   and nvl(codice_anpr,99)  in ('11','12','13')	-- uso elettorale (anpr)
   and id_cerctc            is null
/
