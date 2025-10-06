--liquibase formatted sql
--changeset amonopoli:202410290905 runOnChange:true stripComments:false
update cerdce
   set flag_dismesso = 'S'
 where cod_certificato in ('CDI','CDA','CDN')
    or cod_certificato in ('CI1','CI2','CI3','CI4','CI5','CI6','CI7','CI8','CI9')
    or cod_certificato in ('CA1','CA2','CA3','CA4','CA5','CA6','CA7','CA8','CA9')
    or cod_certificato in ('CN1','CN2','CN3','CN4','CN5','CN6','CN7','CN8','CN9')
    or cod_certificato in ('CE1','CE2','CE3','CE4','CE5','CE6','CE7','CE8','CE9')
/
