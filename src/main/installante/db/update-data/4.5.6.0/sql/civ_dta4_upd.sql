--liquibase formatted sql
--changeset amonopoli:202303060956_1 runOnChange:true stripComments:false
update civdta dta
   set id_civddo_cia = (select id from civddo
                     where cod_do = 'CI'
                       and tipo_atto = dta.tipo_atto)
 where id_civddo_cia is null
/
