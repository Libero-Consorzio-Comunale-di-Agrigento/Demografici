--liquibase formatted sql
--changeset amonopoli:202305251105 runOnChange:true stripComments:false
update civdcd 
   set codice_ansc = 0
 where cod_cd = '00'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 1
 where cod_cd = 'E1'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 2
 where cod_cd = 'E2'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 3
 where cod_cd = 'E3'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 4
 where cod_cd = 'E4'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 5
 where cod_cd = 'L1'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 6
 where cod_cd = 'S1'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 7
 where cod_cd = 'S4'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 8
 where cod_cd = 'M1'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 9
 where cod_cd = 'M2'
   and codice_ansc is null
/
update civdcd 
   set codice_ansc = 10
 where cod_cd = 'M3'
   and codice_ansc is null
/
