--liquibase formatted sql
--changeset amonopoli:202305191215 runOnChange:true stripComments:false
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_BLOB, FLAG_VISIBILE)
select 'CERTIFICATO', null, 'JWT: CERTIFICATO (P12)', 0, 'S', 'S'
  from dual
 where not exists (select 1 from ansinp b
                    where b.parametro = 'CERTIFICATO')
/
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_BLOB, FLAG_VISIBILE)
select 'ID_COMUNE',  f_ANSC_id_comune_al(m.pro_cliente,m.com_cliente,''), 'JWT: ID COMUNE ENTE', 0, '', 'S'
  from menuditta m
 where not exists (select 1 from ansinp b
                    where b.parametro = 'ID_COMUNE')
/
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_BLOB, FLAG_VISIBILE)
select 'PASSWORD', null, 'JWT: PASSWORD (P12)', 0, '', 'S'
  from dual
 where not exists (select 1 from ansinp b
                    where b.parametro = 'PASSWORD')
/
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_BLOB, FLAG_VISIBILE)
select 'POSTAZIONE', lpad(m.pro_cliente,3,'0')||lpad(m.com_cliente,3,'0')||'-PC-0001', 'JWT: POSTAZIONE (P12)', 0, '', 'S'
  from menuditta m
 where not exists (select 1 from ansinp b
                    where b.parametro = 'POSTAZIONE')
/
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_BLOB, FLAG_VISIBILE)
select 'RESP_XML', 'true', 'WS: RESPONSE XML', 0, '', 'S'
  from dual
 where not exists (select 1 from ansinp b
                    where b.parametro = 'RESP_XML')
/
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_BLOB, FLAG_VISIBILE)
select 'SEDE', lpad(m.pro_cliente,3,'0')||lpad(m.com_cliente,3,'0'), 'JWT: CODICE SEDE', 0, '', 'S'
  from menuditta m
 where not exists (select 1 from ansinp b
                    where b.parametro = 'SEDE')
/
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_BLOB, FLAG_VISIBILE)
select 'WS_CLIENT', 'http://<tomcat>:<port>/de4gsdzk/richiestaANSC', 'WS: CLIENT BRIDGE', 0, '', 'S'
  from dual
 where not exists (select 1 from ansinp b
                    where b.parametro = 'WS_CLIENT')
/
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_BLOB, FLAG_VISIBILE)
select 'URL_OTP', '', 'URL RICHIESTA OTP', 0, '', 'S'
  from dual
 where not exists (select 1 from ansinp b
                    where b.parametro = 'URL_OTP')
/
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_BLOB, FLAG_VISIBILE)
select 'AMBIENTE', 'PRE', 'WS: AMBIENTE', 0, '', 'S'
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') in ('037054','023089')
   and not exists (select 1 from ansinp b
                    where b.parametro = 'AMBIENTE')
/
update ansinp
   set version = 0
 where version is null
/
update ansinp
   set flag_blob = 'S'
 where parametro = 'CERTIFICATO'
   and flag_blob is null
/
update ansinp
   set flag_visibile = 'S'
 where parametro in ('AMBIENTE','CERTIFICATO','ID_COMUNE','PASSWORD','POSTAZIONE','RESP_XML','SEDE','URL_OTP','WS_CLIENT')
   and flag_visibile is null
/
