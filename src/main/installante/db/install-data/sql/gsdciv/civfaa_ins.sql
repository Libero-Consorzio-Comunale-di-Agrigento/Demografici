--liquibase formatted sql
--changeset amonopoli:202303231755_4 runOnChange:true stripComments:false
delete civfaa
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 1, 'CIA_TXT', 'La presente copia è conforme all''atto originale di <DES_TIPO_ATTO>, N. <ATTO>, dell''anno <ANNO>, esistente presso questo ufficio.'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') != '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = 1
                      and tipo_formula = 'CIA_TXT')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 4, 'CIA_TXT', 'La presente copia è conforme all''atto originale di <DES_TIPO_ATTO>, N. <ATTO> <PARTE_SERIE>, dell''anno <ANNO>, esistente presso questo ufficio.'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') != '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = 4
                      and tipo_formula = 'CIA_TXT')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', -4, 'CIA_TXT', 'La presente copia è conforme all''atto originale di <DES_TIPO_ATTO>, N. <ATTO> <PARTE_SERIE>, dell''anno <ANNO>, esistente presso questo ufficio.'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') != '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = -4
                      and tipo_formula = 'CIA_TXT')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 5, 'CIA_TXT', 'La presente copia è conforme all''atto originale di <DES_TIPO_ATTO>, N. <ATTO> <PARTE_SERIE>, dell''anno <ANNO>, esistente presso questo ufficio.'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') != '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = 5
                      and tipo_formula = 'CIA_TXT')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 2, 'CIA_TXT', 'La presente copia è conforme all''atto originale di <DES_TIPO_ATTO>, N. <ATTO> <PARTE_SERIE>, dell''anno <ANNO>, esistente presso questo ufficio.'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') != '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = 2
                      and tipo_formula = 'CIA_TXT')
/
insert into civFAA (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 1, 'CIA_TXT', 'Ai sensi dell''art. 18, comma 2, del D.P.R. N. 445/2000 il sottoscritto ufficiale dello Stato Civile, attesta la conformità all''originale della presente copia sottoscritta sul documento originale da <FIRME_CHIUSURA>'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') = '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = 1
                      and tipo_formula = 'CIA_TXT')
/
insert into civFAA (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 4, 'CIA_TXT', 'Ai sensi dell''art. 18, comma 2, del D.P.R. N. 445/2000 il sottoscritto ufficiale dello Stato Civile, attesta la conformità all''originale della presente copia sottoscritta sul documento originale da <FIRME_CHIUSURA>'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') = '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = 4
                      and tipo_formula = 'CIA_TXT')
/
insert into civFAA (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', -4, 'CIA_TXT', 'Ai sensi dell''art. 18, comma 2, del D.P.R. N. 445/2000 il sottoscritto ufficiale dello Stato Civile, attesta la conformità all''originale della presente copia sottoscritta sul documento originale da <FIRME_CHIUSURA>'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') = '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = -4
                      and tipo_formula = 'CIA_TXT')
/
insert into civFAA (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 5, 'CIA_TXT', 'Ai sensi dell''art. 18, comma 2, del D.P.R. N. 445/2000 il sottoscritto ufficiale dello Stato Civile, attesta la conformità all''originale della presente copia sottoscritta sul documento originale da <FIRME_CHIUSURA>'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') = '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = 5
                      and tipo_formula = 'CIA_TXT')
/
insert into civFAA (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 2, 'CIA_TXT', 'Ai sensi dell''art. 18, comma 2, del D.P.R. N. 445/2000 il sottoscritto ufficiale dello Stato Civile, attesta la conformità all''originale della presente copia sottoscritta sul documento originale da <FIRME_CHIUSURA>'||chr(10)||
                         '<COMUNE_FIRMA>, li <DATA>', 0
  from menuditta
 where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') = '083097'
   and not exists (select 1 from civfaa
                    where tipo_atto    = 2
                      and tipo_formula = 'CIA_TXT')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 1, 'CIA_FIR', 'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||
                         '<TERMINALISTA>', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = 1
                      and tipo_formula = 'CIA_FIR')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 4, 'CIA_FIR', 'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||
                         '<TERMINALISTA>', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = 4
                      and tipo_formula = 'CIA_FIR')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', -4, 'CIA_FIR', 'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||
                         '<TERMINALISTA>', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = -4
                      and tipo_formula = 'CIA_FIR')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 5, 'CIA_FIR', 'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||
                         '<TERMINALISTA>', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = 5
                      and tipo_formula = 'CIA_FIR')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 2, 'CIA_FIR', 'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||
                         '<TERMINALISTA>', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = 2
                      and tipo_formula = 'CIA_FIR')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 1, 'CIA_INT', 'Comune di <COMUNE>'||chr(10)||
                         'Ufficio dello Stato Civile', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = 1
                      and tipo_formula = 'CIA_INT')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 4, 'CIA_INT', 'Comune di <COMUNE>'||chr(10)||
                         'Ufficio dello Stato Civile', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = 4
                      and tipo_formula = 'CIA_INT')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', -4, 'CIA_INT', 'Comune di <COMUNE>'||chr(10)||
                         'Ufficio dello Stato Civile', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = -4
                      and tipo_formula = 'CIA_INT')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 5, 'CIA_INT', 'Comune di <COMUNE>'||chr(10)||
                         'Ufficio dello Stato Civile', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = 5
                      and tipo_formula = 'CIA_INT')
/
insert into civfaa (ID, TIPO_ATTO, TIPO_FORMULA, TESTO, VERSION)
select '', 2, 'CIA_INT', 'Comune di <COMUNE>'||chr(10)||
                         'Ufficio dello Stato Civile', 0
  from dual
 where not exists (select 1 from civfaa
                    where tipo_atto    = 2
                      and tipo_formula = 'CIA_INT')
/
update civfaa
   set sequenza = decode(tipo_formula,'CIA_INT',1,'CIA_TXT',2,'CIA_FIR',3)
 where tipo_formula like 'CIA%'
/
update civfaa
   set flag_cia = 'S'
 where tipo_formula like 'CIA%'
/
