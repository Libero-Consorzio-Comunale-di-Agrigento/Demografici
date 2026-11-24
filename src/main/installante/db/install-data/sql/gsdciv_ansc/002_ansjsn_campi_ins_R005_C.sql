--liquibase formatted sql
--changeset amonopoli:202603031306_2 runAlways:true runOnChange:true stripComments:false
delete ansjsn_campi
 where id_sezione in (select id from ansjsn_sezioni
                       where servizio = 'R005_C');

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877680, 36314, 'cognome', 'cognomePar', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877681, 36314, 'nome', 'nomePar', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877682, 36314, 'sesso', 'sessoPar', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (877683, 36314, 'datanascita', 'dataNascitaPar', 40);
