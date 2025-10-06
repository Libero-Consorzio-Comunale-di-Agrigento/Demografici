--liquibase formatted sql
--changeset snocca:202401151112 runOnChange:true
update civdrf
   set flag_default = ''
 where formula  = '0-TTR-T2'
   and tipo_Atto = -4
/
