--liquibase formatted sql
--changeset amonopoli:202602051410_3 runOnChange:true stripComments:false
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_U', 210, 0, 2212, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= 5
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_U'
                      and b.id_anst03 = 2212)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_V', 210, 0, 2212, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= 5
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_V'
                      and b.id_anst03 = 2212)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_U', 210, 0, 2213, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= 5
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_U'
                      and b.id_anst03 = 2213)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_V', 210, 0, 2213, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= 5
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_V'
                      and b.id_anst03 = 2213)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_U', 210, 0, 431000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_U'
                      and b.id_anst03 = 431000)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_V', 210, 0, 431000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_V'
                      and b.id_anst03 = 431000)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_U', 210, 0, 432000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_U'
                      and b.id_anst03 = 432000)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_V', 210, 0, 432000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_V'
                      and b.id_anst03 = 432000)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_U', 210, 0, 433000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_U'
                      and b.id_anst03 = 433000)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_V', 210, 0, 433000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_V'
                      and b.id_anst03 = 433000)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_U', 210, 0, 434000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_U'
                      and b.id_anst03 = 434000)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_V', 210, 0, 434000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_V'
                      and b.id_anst03 = 434000)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_U', 210, 0, 436000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_U'
                      and b.id_anst03 = 436000)
/
insert into anstws_ddo (ID, ID_CIVDDO, ID_ANSTWS, SEQUENZA, VERSION, ID_ANST03, FLAG_OBBLIGATORIO, TIPO_DOCUMENTO)
select to_number(null), ddo.id, 'R001_V', 210, 0, 436000, 'S', null
  from civddo ddo
 where ddo.codice_ansc = 115
   and ddo.tipo_atto   	= -4
   and not exists (select 1 from anstws_ddo b
                    where b.id_civddo = ddo.id
                      and b.id_anstws = 'R001_V'
                      and b.id_anst03 = 436000)
/
