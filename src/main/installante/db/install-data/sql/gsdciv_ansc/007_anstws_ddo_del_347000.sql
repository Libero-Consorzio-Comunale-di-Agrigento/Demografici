--liquibase formatted sql
--changeset amonopoli:202602051535_1 runOnChange:true stripComments:false
delete anstws_ddo a
 where id_anst03 = 347000
   and exists (select 1 from civddo b
                where b.id          = a.id_civddo
                  and b.codice_ansc in (39,48)
                  and b.tipo_atto   = 4)
/
update anstws_ddo a
   set flag_obbligatorio = ''
 where id_anst03 in (347000)
   and flag_obbligatorio is not null
   and exists (select 1 from civddo b
                where b.id          = a.id_civddo
                  and b.codice_ansc = 25
                  and b.tipo_atto   = 4)
/
