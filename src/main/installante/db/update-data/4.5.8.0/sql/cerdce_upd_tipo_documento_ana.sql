--liquibase formatted sql
--changeset amonopoli:202412051505 runOnChange:true stripComments:false
update cerdce
   set TIPO_DOCUMENTO_ANA        = decode(cod_certificato,'UE1','U1','UE2','U2')
     , FLAG_NUMERA_DOCUMENTO_ANA = decode(f_valore_inp('CERT_UE1',1,1,'X','S'),'S','S')
 where cod_certificato in ('UE1','UE2')
/
update cerdce
   set TIPO_DOCUMENTO_ANA        = 'CE'
     , FLAG_NUMERA_DOCUMENTO_ANA = to_char(null)
 where cod_certificato in ('CIE')
   and descrizione like '%CIE%' or descrizione like '%C.I.E.%' or descrizione like '%CARTA%ID%ELET%'
/
