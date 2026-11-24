--liquibase formatted sql
--changeset amonopoli:202603021245_3 runOnChange:true stripComments:false
update anstws
   set flag_otp_firma = 'S'
 where flag_otp_firma is null
   and id in ('R002','R002_2','R002_3')
/
