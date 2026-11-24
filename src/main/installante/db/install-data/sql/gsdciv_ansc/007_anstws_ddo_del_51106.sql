--liquibase formatted sql
--changeset amonopoli:202607010900 runOnChange:true stripComments:false
delete anstws_ddo a
 where id_anst03 = 51106
   and exists (select 1 from civddo b
                where b.id          = a.id_civddo
                  and b.codice_ansc = 80
                  and b.tipo_atto   = 1)
/
