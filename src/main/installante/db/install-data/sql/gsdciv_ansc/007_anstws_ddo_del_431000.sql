--liquibase formatted sql
--changeset amonopoli:202602261500_1 runOnChange:true stripComments:false
delete anstws_ddo a
 where id_anst03 = 431000
   and exists (select 1 from civddo b
                where b.id          = a.id_civddo
                  and b.codice_ansc = 58
                  and b.tipo_atto   = -4)
/
delete anstws_ddo a
 where id_anst03 = 431000
   and flag_obbligatorio is not null
   and tipo_documento    = 'CS'
   and exists (select 1 from civddo b
                where b.id          = a.id_civddo
                  and b.codice_ansc = 28
                  and b.tipo_atto   = -4)
/
update anstws_ddo a
   set flag_obbligatorio = ''
 where id_anst03 = 431000
   and flag_obbligatorio is not null
   and exists (select 1 from civddo b
                where b.id          = a.id_civddo
                  and b.codice_ansc = 59
                  and b.tipo_atto   = -4)
/
