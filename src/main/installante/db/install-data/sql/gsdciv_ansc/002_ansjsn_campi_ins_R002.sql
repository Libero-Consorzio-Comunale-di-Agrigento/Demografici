--liquibase formatted sql
--changeset amonopoli:202603021246_2 runAlways:true runOnChange:true stripComments:false
delete ansjsn_campi
 where id_sezione in (select id from ansjsn_sezioni
                       where servizio like 'R002%');

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1452, 124, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1453, 124, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1454, 124, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1455, 124, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1456, 124, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1457, 124, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1446, 124, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1458, 124, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1459, 124, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1460, 124, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1461, 124, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1447, 124, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1448, 124, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1449, 124, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1450, 124, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1451, 124, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1463, 124, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1464, 124, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1422, 125, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1479, 135, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1488, 136, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1489, 136, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1490, 136, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1491, 136, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1492, 136, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1493, 136, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1482, 136, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1494, 136, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1495, 136, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1496, 136, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1497, 136, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1483, 136, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1484, 136, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1485, 136, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1486, 136, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1487, 136, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1500, 136, 'indirizzoResidenza', 'RIC_indirizzoResidenza', 180);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1498, 136, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1499, 136, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1501, 139, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1546, 140, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1547, 140, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1548, 140, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1549, 140, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1550, 140, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1551, 140, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1540, 140, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1552, 140, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1553, 140, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1554, 140, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1555, 140, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1541, 140, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1542, 140, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1543, 140, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1544, 140, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1545, 140, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1556, 140, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1557, 140, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1570, 149, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1571, 149, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1572, 149, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1573, 149, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1574, 149, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1575, 149, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1564, 149, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1576, 149, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1577, 149, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1578, 149, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1579, 149, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1565, 149, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1566, 149, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1567, 149, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1568, 149, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1569, 149, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1580, 149, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1581, 149, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1582, 151, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1595, 155, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1596, 155, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1597, 155, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1598, 155, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1599, 155, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1600, 155, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1589, 155, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1601, 155, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1602, 155, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1603, 155, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1604, 155, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1590, 155, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1591, 155, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1592, 155, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1593, 155, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1594, 155, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1607, 155, 'indirizzoResidenza', 'RIC_indirizzoResidenza', 180);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1605, 155, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1606, 155, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1608, 157, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1621, 161, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1622, 161, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1623, 161, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1624, 161, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1625, 161, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1626, 161, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1615, 161, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1627, 161, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1628, 161, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1629, 161, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1630, 161, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1616, 161, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1617, 161, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1618, 161, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1619, 161, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1620, 161, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1631, 161, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1632, 161, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (1633, 163, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2332, 339, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2333, 339, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2334, 339, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2335, 339, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2336, 339, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2337, 339, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2338, 339, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2339, 339, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2340, 339, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2341, 339, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2342, 339, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2343, 339, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2344, 339, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2345, 339, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2346, 339, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2347, 339, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2348, 339, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2349, 339, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2350, 341, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2357, 345, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2358, 345, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2359, 345, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2360, 345, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2361, 345, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2362, 345, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2363, 345, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2364, 345, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2365, 345, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2366, 345, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2367, 345, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2368, 345, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2369, 345, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2370, 345, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2371, 345, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2372, 345, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2373, 345, 'indirizzoResidenza', 'RIC_indirizzoResidenza', 180);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2374, 345, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2375, 345, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2376, 347, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2383, 351, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2384, 351, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2385, 351, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2386, 351, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2387, 351, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2388, 351, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2389, 351, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2390, 351, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2391, 351, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2392, 351, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2393, 351, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2394, 351, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2395, 351, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2396, 351, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2397, 351, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2398, 351, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2399, 351, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2400, 351, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2401, 353, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2408, 357, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2409, 357, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2410, 357, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2411, 357, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2412, 357, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2413, 357, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2414, 357, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2415, 357, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2416, 357, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2417, 357, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2418, 357, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2419, 357, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2420, 357, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2421, 357, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2422, 357, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2423, 357, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2424, 357, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2425, 357, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2426, 359, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2433, 363, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2434, 363, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2435, 363, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2436, 363, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2437, 363, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2438, 363, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2439, 363, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2440, 363, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2441, 363, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2442, 363, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2443, 363, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2444, 363, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2445, 363, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2446, 363, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2447, 363, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2448, 363, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2449, 363, 'indirizzoResidenza', 'RIC_indirizzoResidenza', 180);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2450, 363, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2451, 363, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2452, 365, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2459, 369, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2460, 369, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2461, 369, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2462, 369, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2463, 369, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2464, 369, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2465, 369, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2466, 369, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2467, 369, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2468, 369, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2469, 369, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2470, 369, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2471, 369, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2472, 369, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2473, 369, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2474, 369, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2475, 369, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2476, 369, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2477, 371, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2708, 418, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2709, 418, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2710, 418, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2711, 418, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2712, 418, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2713, 418, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2714, 418, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2715, 418, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2716, 418, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2717, 418, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2718, 418, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2719, 418, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2720, 418, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2721, 418, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2722, 418, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2723, 418, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2724, 418, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2725, 418, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2726, 420, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2902, 446, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2903, 446, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2904, 446, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2905, 446, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2906, 446, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2907, 446, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2908, 446, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2909, 446, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2910, 446, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2911, 446, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2912, 446, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2913, 446, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2914, 446, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2915, 446, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2916, 446, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2917, 446, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2918, 446, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2919, 446, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2920, 448, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2927, 452, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2928, 452, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2929, 452, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2930, 452, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2931, 452, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2932, 452, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2933, 452, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2934, 452, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2935, 452, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2936, 452, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2937, 452, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2938, 452, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2939, 452, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2940, 452, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2941, 452, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2942, 452, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2943, 452, 'indirizzoResidenza', 'RIC_indirizzoResidenza', 180);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2944, 452, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2945, 452, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (2946, 454, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3819, 603, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3820, 603, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3821, 603, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3822, 603, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3823, 603, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3824, 603, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3825, 603, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3826, 603, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3827, 603, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3828, 603, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3829, 603, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3830, 603, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3831, 603, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3832, 603, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3833, 603, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3834, 603, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3835, 603, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3836, 603, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3837, 605, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3844, 611, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3845, 611, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3846, 611, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3847, 611, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3848, 611, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3849, 611, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3850, 611, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3851, 611, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3852, 611, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3853, 611, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3854, 611, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3855, 611, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3856, 611, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3857, 611, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3858, 611, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3859, 611, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3860, 611, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3861, 611, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3862, 614, 'id', 'BEN_idSoggettoAnsc_1', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3869, 619, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3870, 619, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3871, 619, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3872, 619, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3873, 619, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3874, 619, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3875, 619, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3876, 619, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3877, 619, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3878, 619, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3879, 619, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3880, 619, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3881, 619, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3882, 619, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3883, 619, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3884, 619, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3885, 619, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3886, 619, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3887, 622, 'id', 'BEN_idSoggettoAnsc_m', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3894, 627, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3895, 627, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3896, 627, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3897, 627, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3898, 627, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3899, 627, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3900, 627, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3901, 627, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3902, 627, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3903, 627, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3904, 627, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3905, 627, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3906, 627, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3907, 627, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3908, 627, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3909, 627, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3910, 627, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3911, 627, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (3912, 630, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880670, 36557, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880671, 36557, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880672, 36557, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880673, 36557, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880674, 36557, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880675, 36558, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880676, 36558, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880677, 36558, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880678, 36558, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880679, 36558, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880680, 36559, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880681, 36559, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880682, 36559, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880683, 36559, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880684, 36559, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880685, 36560, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880686, 36560, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880687, 36560, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880688, 36560, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880689, 36560, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880690, 36561, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880691, 36561, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880692, 36561, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880693, 36561, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880694, 36561, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880695, 36562, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880696, 36562, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880697, 36562, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880698, 36562, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880699, 36562, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880700, 36563, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880701, 36563, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880702, 36563, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880703, 36563, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880704, 36563, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880705, 36564, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880706, 36564, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880707, 36564, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880708, 36564, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880709, 36564, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880710, 36565, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880711, 36565, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880712, 36565, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880713, 36565, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880714, 36565, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880715, 36566, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880716, 36566, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880717, 36566, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880718, 36566, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880719, 36566, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880720, 36567, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880721, 36567, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880722, 36567, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880723, 36567, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880724, 36567, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880725, 36568, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880726, 36568, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880727, 36568, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880728, 36568, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880729, 36568, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880730, 36569, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880731, 36569, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880732, 36569, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880733, 36569, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880734, 36569, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880735, 36570, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880736, 36570, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880737, 36570, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880738, 36570, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (880739, 36570, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887262, 37138, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887263, 37138, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887264, 37138, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887265, 37138, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887266, 37138, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887267, 37138, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887268, 37138, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887269, 37138, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887270, 37138, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887256, 37141, 'id', 'BEN_idSoggettoAnsc_1', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887257, 37144, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887258, 37144, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887259, 37144, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887260, 37144, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887261, 37144, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887277, 37149, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887278, 37149, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887279, 37149, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887280, 37149, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887281, 37149, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887282, 37149, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887283, 37149, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887284, 37149, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887285, 37149, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887271, 37152, 'id', 'BEN_idSoggettoAnsc_1', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887272, 37155, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887273, 37155, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887274, 37155, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887275, 37155, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887276, 37155, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887292, 37160, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887293, 37160, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887294, 37160, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887295, 37160, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887296, 37160, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887297, 37160, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887298, 37160, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887299, 37160, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887300, 37160, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887286, 37163, 'id', 'BEN_idSoggettoAnsc_1', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887287, 37166, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887288, 37166, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887289, 37166, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887290, 37166, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887291, 37166, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887307, 37171, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887308, 37171, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887309, 37171, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887310, 37171, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887311, 37171, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887312, 37171, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887313, 37171, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887314, 37171, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887315, 37171, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887316, 37171, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887317, 37171, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887318, 37171, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887319, 37171, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887320, 37171, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887321, 37171, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887322, 37171, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887323, 37171, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887324, 37171, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887301, 37174, 'id', 'BEN_idSoggettoAnsc_1', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887302, 37177, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887303, 37177, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887304, 37177, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887305, 37177, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887306, 37177, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887331, 37182, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887332, 37182, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887333, 37182, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887334, 37182, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887335, 37182, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887336, 37182, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887337, 37182, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887338, 37182, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887339, 37182, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887340, 37182, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887341, 37182, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887342, 37182, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887343, 37182, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887344, 37182, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887345, 37182, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887346, 37182, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887347, 37182, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887348, 37182, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887325, 37185, 'id', 'BEN_idSoggettoAnsc_1', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887326, 37188, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887327, 37188, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887328, 37188, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887329, 37188, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887330, 37188, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887355, 37193, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887356, 37193, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887357, 37193, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887358, 37193, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887359, 37193, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887360, 37193, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887361, 37193, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887362, 37193, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887363, 37193, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887364, 37193, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887365, 37193, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887366, 37193, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887367, 37193, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887368, 37193, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887369, 37193, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887370, 37193, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887371, 37193, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887372, 37193, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887349, 37196, 'id', 'BEN_idSoggettoAnsc_1', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887350, 37199, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887351, 37199, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887352, 37199, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887353, 37199, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887354, 37199, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887379, 37204, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887380, 37204, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887381, 37204, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887382, 37204, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887383, 37204, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887384, 37204, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887385, 37204, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887386, 37204, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887387, 37204, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887373, 37207, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887374, 37210, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887375, 37210, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887376, 37210, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887377, 37210, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887378, 37210, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887394, 37215, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887395, 37215, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887396, 37215, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887397, 37215, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887398, 37215, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887399, 37215, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887400, 37215, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887401, 37215, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887402, 37215, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887388, 37218, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887389, 37221, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887390, 37221, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887391, 37221, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887392, 37221, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887393, 37221, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887409, 37226, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887410, 37226, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887411, 37226, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887412, 37226, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887413, 37226, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887414, 37226, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887415, 37226, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887416, 37226, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887417, 37226, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887403, 37229, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887404, 37232, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887405, 37232, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887406, 37232, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887407, 37232, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887408, 37232, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887424, 37237, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887425, 37237, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887426, 37237, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887427, 37237, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887428, 37237, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887429, 37237, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887430, 37237, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887431, 37237, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887432, 37237, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887433, 37237, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887434, 37237, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887435, 37237, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887436, 37237, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887437, 37237, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887438, 37237, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887439, 37237, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887440, 37237, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887441, 37237, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887418, 37240, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887419, 37243, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887420, 37243, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887421, 37243, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887422, 37243, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887423, 37243, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887448, 37248, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887449, 37248, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887450, 37248, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887451, 37248, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887452, 37248, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887453, 37248, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887454, 37248, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887455, 37248, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887456, 37248, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887457, 37248, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887458, 37248, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887459, 37248, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887460, 37248, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887461, 37248, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887462, 37248, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887463, 37248, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887464, 37248, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887465, 37248, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887442, 37251, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887443, 37254, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887444, 37254, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887445, 37254, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887446, 37254, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887447, 37254, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887472, 37259, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887473, 37259, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887474, 37259, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887475, 37259, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887476, 37259, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887477, 37259, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887478, 37259, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887479, 37259, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887480, 37259, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887481, 37259, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887482, 37259, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887483, 37259, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887484, 37259, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887485, 37259, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887486, 37259, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887487, 37259, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887488, 37259, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887489, 37259, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887466, 37262, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887467, 37265, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887468, 37265, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887469, 37265, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887470, 37265, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887471, 37265, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887496, 37270, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887497, 37270, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887498, 37270, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887499, 37270, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887500, 37270, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887501, 37270, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887502, 37270, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887503, 37270, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887504, 37270, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887490, 37273, 'id', 'BEN_idSoggettoAnsc_m', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887491, 37276, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887492, 37276, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887493, 37276, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887494, 37276, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887495, 37276, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887511, 37281, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887512, 37281, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887513, 37281, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887514, 37281, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887515, 37281, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887516, 37281, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887517, 37281, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887518, 37281, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887519, 37281, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887505, 37284, 'id', 'BEN_idSoggettoAnsc_m', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887506, 37287, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887507, 37287, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887508, 37287, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887509, 37287, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887510, 37287, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887526, 37292, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887527, 37292, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887528, 37292, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887529, 37292, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887530, 37292, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887531, 37292, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887532, 37292, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887533, 37292, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887534, 37292, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887520, 37295, 'id', 'BEN_idSoggettoAnsc_m', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887521, 37298, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887522, 37298, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887523, 37298, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887524, 37298, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887525, 37298, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887541, 37303, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887542, 37303, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887543, 37303, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887544, 37303, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887545, 37303, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887546, 37303, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887547, 37303, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887548, 37303, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887549, 37303, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887550, 37303, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887551, 37303, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887552, 37303, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887553, 37303, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887554, 37303, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887555, 37303, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887556, 37303, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887557, 37303, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887558, 37303, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887535, 37306, 'id', 'BEN_idSoggettoAnsc_m', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887536, 37309, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887537, 37309, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887538, 37309, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887539, 37309, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887540, 37309, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887565, 37314, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887566, 37314, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887567, 37314, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887568, 37314, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887569, 37314, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887570, 37314, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887571, 37314, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887572, 37314, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887573, 37314, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887574, 37314, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887575, 37314, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887576, 37314, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887577, 37314, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887578, 37314, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887579, 37314, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887580, 37314, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887581, 37314, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887582, 37314, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887559, 37317, 'id', 'BEN_idSoggettoAnsc_m', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887560, 37320, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887561, 37320, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887562, 37320, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887563, 37320, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887564, 37320, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887589, 37325, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887590, 37325, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887591, 37325, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887592, 37325, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887593, 37325, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887594, 37325, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887595, 37325, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887596, 37325, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887597, 37325, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887598, 37325, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887599, 37325, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887600, 37325, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887601, 37325, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887602, 37325, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887603, 37325, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887604, 37325, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887605, 37325, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887606, 37325, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887583, 37328, 'id', 'BEN_idSoggettoAnsc_m', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887584, 37331, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887585, 37331, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887586, 37331, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887587, 37331, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887588, 37331, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887613, 37336, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887614, 37336, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887615, 37336, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887616, 37336, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887617, 37336, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887618, 37336, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887619, 37336, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887620, 37336, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887621, 37336, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887607, 37339, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887608, 37342, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887609, 37342, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887610, 37342, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887611, 37342, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887612, 37342, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887628, 37347, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887629, 37347, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887630, 37347, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887631, 37347, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887632, 37347, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887633, 37347, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887634, 37347, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887635, 37347, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887636, 37347, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887622, 37350, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887623, 37353, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887624, 37353, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887625, 37353, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887626, 37353, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887627, 37353, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887643, 37358, 'nomeEnte', 'ENT_nomeEnte', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887644, 37358, 'idComuneEnte', 'ENT_idComuneEnte', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887645, 37358, 'nomeComuneEnte', 'ENT_nomeComuneEnte', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887646, 37358, 'idProvinciaEnte', 'ENT_idProvinciaEnte', 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887647, 37358, 'siglaProvinciaEnte', 'ENT_siglaProvinciaEnte', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887648, 37358, 'nazioneEnte', 'ENT_nazioneEnte', 55);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887649, 37358, 'nomeNazioneEnte', 'ENT_nomeNazioneEnte', 57);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887650, 37358, 'idAnagraficaConsolato', 'ENT_idAnagraficaConsolato', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887651, 37358, 'nomeAnagraficaConsolato', 'ENT_nomeAnagraficaConsolato', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887637, 37361, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887638, 37364, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887639, 37364, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887640, 37364, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887641, 37364, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887642, 37364, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887658, 37369, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887659, 37369, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887660, 37369, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887661, 37369, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887662, 37369, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887663, 37369, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887664, 37369, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887665, 37369, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887666, 37369, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887667, 37369, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887668, 37369, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887669, 37369, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887670, 37369, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887671, 37369, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887672, 37369, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887673, 37369, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887674, 37369, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887675, 37369, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887652, 37372, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887653, 37375, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887654, 37375, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887655, 37375, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887656, 37375, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887657, 37375, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887682, 37380, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887683, 37380, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887684, 37380, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887685, 37380, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887686, 37380, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887687, 37380, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887688, 37380, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887689, 37380, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887690, 37380, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887691, 37380, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887692, 37380, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887693, 37380, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887694, 37380, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887695, 37380, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887696, 37380, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887697, 37380, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887698, 37380, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887699, 37380, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887676, 37383, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887677, 37386, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887678, 37386, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887679, 37386, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887680, 37386, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887681, 37386, 'inputFirma3', null, 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887706, 37391, 'cognome', 'RIC_cognome', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887707, 37391, 'nome', 'RIC_nome', 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887708, 37391, 'sesso', 'RIC_sesso', 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887709, 37391, 'dataNascita', 'RIC_dataNascita', 50);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887710, 37391, 'idComuneNascita', 'RIC_idComuneNascita', 60);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887711, 37391, 'nomeComuneNascita', 'RIC_nomeComuneNascita', 70);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887712, 37391, 'idProvinciaNascita', 'RIC_idProvinciaNascita', 80);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887713, 37391, 'siglaProvinciaNascita', 'RIC_siglaProvinciaNascita', 90);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887714, 37391, 'idStatoNascita', 'RIC_idStatoNascita', 100);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887715, 37391, 'nomeStatoNascita', 'RIC_nomeStatoNascita', 110);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887716, 37391, 'idComuneResidenza', 'RIC_idComuneResidenza', 120);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887717, 37391, 'nomeComuneResidenza', 'RIC_nomeComuneResidenza', 130);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887718, 37391, 'idProvinciaResidenza', 'RIC_idProvinciaResidenza', 140);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887719, 37391, 'siglaProvinciaResidenza', 'RIC_siglaProvinciaResidenza', 150);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887720, 37391, 'idStatoResidenza', 'RIC_idStatoResidenza', 160);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887721, 37391, 'nomeStatoResidenza', 'RIC_nomeStatoResidenza', 170);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887722, 37391, 'idNazionalita', 'RIC_idNazionalita', 190);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887723, 37391, 'nazionalita', 'RIC_nazionalita', 200);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887700, 37394, 'id', 'BEN_idSoggettoAnsc', 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887701, 37397, 'idTipoFirma', null, 10);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887702, 37397, 'idModalitaInput', null, 20);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887703, 37397, 'inputFirma1', null, 30);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887704, 37397, 'inputFirma2', null, 40);

insert into ansjsn_campi (ID, ID_SEZIONE, CAMPO, CAMPO_DB, SEQUENZA)
values (887705, 37397, 'inputFirma3', null, 50);
