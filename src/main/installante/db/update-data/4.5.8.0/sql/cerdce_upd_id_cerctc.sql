--liquibase formatted sql
--changeset amonopoli:202410231505_1 runOnChange:true stripComments:false
-- 1	ANA - ANAGRAFE
update cerdce
   set id_cerctc = 1
 where competenza      = 'AN'
   and tipo_archivio   = 0
   and tipo_formato    is null
   and cod_certificato not in ('CIL','CGP','KIL','KGP','ERM','DCI','DCA') 
   and descrizione     not like '%ELETTOR%'
   and descrizione     not like '%LEVA%'
   and descrizione     not like 'DICH%'
   and id_cerctc       is null
/
-- 2	CIV - STATO CIVILE
update cerdce dce
   set id_cerctc = 2
 where competenza    = 'SC'
   and tipo_formato  is null
   and id_cerctc     is null
/
-- 3	ELE - ELETTORALE
update cerdce dce
   set id_cerctc = 3
 where competenza    = 'AN'
   and tipo_archivio = 0
   and tipo_formato  is null
   and id_cerctc     is null
   and (cod_certificato in ('CIL','CGP','KIL','KGP') or descrizione like '%ELETTOR%')
/
-- 4	LEV - LEVA
update cerdce dce
   set id_cerctc = 4
 where competenza    = 'AN'
   and tipo_archivio = 0
   and tipo_formato  is null
   and id_cerctc     is null
   and (cod_certificato in ('ERM') or descrizione like '%LEVA%')
/
-- 5	DIC - DICHIARAZIONI SOSTITUTIVE 
update cerdce dce
   set id_cerctc = 5
 where competenza    = 'AN'
   and id_cerctc     is null
   and (descrizione  like 'DICH%' or cod_certificato in ('DCI','DCA'))
/
-- 6 - VARIE-ANA - DOCUMENTI VARI ANAGRAFE
update cerdce dce
   set id_cerctc = 6
 where competenza    = 'AN'
   and id_cerctc     is null
/
-- 7 - VARIE-CIV - DOCUMENTI VARI STATO CIVILE
update cerdce dce
   set id_cerctc = 7
 where competenza    = 'SC'
   and id_cerctc     is null
/
