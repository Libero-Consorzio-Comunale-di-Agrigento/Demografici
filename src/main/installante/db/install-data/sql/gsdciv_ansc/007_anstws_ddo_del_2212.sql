--liquibase formatted sql
--changeset amonopoli:202603131015_1 runOnChange:true stripComments:false
delete anstws_ddo a
 where id_anst03 = 2212
   and exists (select 1 from civddo b
                where b.id          = a.id_civddo
                  and b.codice_ansc = 34
                  and b.tipo_atto   = 5)
/
