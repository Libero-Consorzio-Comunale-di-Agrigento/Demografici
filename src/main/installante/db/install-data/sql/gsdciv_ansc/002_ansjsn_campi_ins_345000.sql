--liquibase formatted sql
--changeset amonopoli:202507301215_1 runAlways:true runOnChange:true stripComments:false
delete ansjsn_campi
 where id in (877671,877672,877673,877677,877678,877679,887045);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877671, 35112, 'flagDichiarante', 'AV1_flagDichiarante', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877672, 35112, 'flagComparente', 'AV1_flagComparente', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877673, 35112, 'flagFirmatario', 'AV1_flagFirmatario', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877677, 35113, 'flagDichiarante', 'AV2_flagDichiarante', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877678, 35113, 'flagComparente', 'AV2_flagComparente', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877679, 35113, 'flagFirmatario', 'AV2_flagFirmatario', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887045, 35106, 'dataStipulaAccordo', 'NEG_dataStipula_ACC', 100);


