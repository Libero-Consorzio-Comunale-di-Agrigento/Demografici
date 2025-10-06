--liquibase formatted sql
--changeset amonopoli:202303060955_3_2 runOnChange:true stripComments:false
update civdca dca
   set id_civddo = (select id from civddo ddo
                     where ddo.tipo_atto = dca.tipo_atto
                       and ddo.cod_do    = 'CO')
 where id_civddo is null
   and exists (select 1 from civddo ddo
                where ddo.tipo_atto = dca.tipo_atto
                  and ddo.cod_do    = 'CO')
/
