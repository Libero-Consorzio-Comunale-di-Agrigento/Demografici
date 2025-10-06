--liquibase formatted sql
--changeset amonopoli:202312201320_2 runOnChange:true stripComments:false
delete arccda;

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('510100', 'ANCONA', 42, 2, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('520100', 'BARI', 72, 6, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('530100', 'BOLOGNA', 37, 6, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('790100', 'BOLZANO', 21, 8, '(Sez. distaccata di Trento)');

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('540100', 'BRESCIA', 17, 29, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('550100', 'CAGLIARI', 92, 9, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('560100', 'CALTANISSETTA', 85, 4, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('570100', 'CAMPOBASSO', 70, 6, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('580100', 'CATANIA', 87, 15, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('590100', 'CATANZARO', 79, 23, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('600100', 'FIRENZE', 48, 17, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('610100', 'GENOVA', 10, 25, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('620100', 'L''AQUILA', 66, 49, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('630100', 'LECCE', 75, 35, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('640100', 'MESSINA', 83, 48, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('650100', 'MILANO', 15, 146, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('660100', 'NAPOLI', 63, 49, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('670100', 'PALERMO', 82, 53, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('680100', 'PERUGIA', 54, 39, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('690100', 'POTENZA', 76, 63, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('700100', 'REGGIO CALABRIA', null, null, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('710100', 'ROMA', 58, 91, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('720100', 'SALERNO', 65, 116, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('770100', 'SASSARI', 90, 64, '(Sez. distaccata di Cagliari)');

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('780100', 'TARANTO', 73, 27, '(Sez. distaccata di Lecce)');

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('730100', 'TORINO', 1, 272, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('740100', 'TRENTO', 22, 205, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('750100', 'TRIESTE', 32, 6, null);

insert into arccda (COD_TRIBUNALE, DESCRIZIONE, COD_PRO_TRIB, COD_COM_TRIB, NOTE)
values ('760100', 'VENEZIA', 27, 42, null);
