--liquibase formatted sql
--changeset amonopoli:202306081145 runOnChange:true stripComments:false
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 101,
       1,
       '',
       '',
       'D',
       'GIU',
       'GIURAMENTO',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 101
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 102,
       1,
       '',
       '',
       'A',
       'DAQ',
       'DECRETO ACQUISTO',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 102
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 103,
       1,
       '',
       '',
       'A',
       'ASM',
       'ATTESTAZIONE SINDACO MINORE',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 103
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 104,
       1,
       '',
       '',
       'A',
       'AS1',
       'ATTESTAZIONE SINDACO 18ENNE',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 104
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 105,
       1,
       '',
       '',
       'A',
       'ASA',
       'ATTESTAZIONE SINDACO ATTRIBUZIONE',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 105
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 106,
       1,
       '',
       '',
       'P',
       'DPE',
       'DECRETO PERDITA',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 106
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 107,
       1,
       '',
       '',
       'D',
       'R18',
       'RICHIESTA 18ENNE',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 107
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 108,
       1,
       '',
       '',
       '',
       'ATL',
       'ATTO A TESTO LIBERO',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 108
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 109,
       1,
       '',
       '',
       'A',
       'TAM',
       'TRASCRIZIONE ATTI MULTIPLI',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 109
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 201,
       2,
       '1',
       'A',
       'O',
       'O1A',
       'PARTE 1 SERIE A',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 201
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 202,
       2,
       '1',
       'B',
       'O',
       'O1B',
       'PARTE 1 SERIE B',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 202
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 203,
       2,
       '2',
       'A',
       'T',
       'T2A',
       'PARTE 2 SERIE A',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 203
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 204,
       2,
       '2',
       'B',
       '',
       'ATL',
       'ATTO A TESTO LIBERO',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 204
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 207,
       2,
       '2',
       'B',
       'O',
       'CNA',
       'CENTRO NASCITA',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 207
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 208,
       2,
       '2',
       'B',
       'O',
       'TEA',
       'TRASCRIZIONE ESTERO (AUTORITA'') / IN VIAGGIO',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 208
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 209,
       2,
       '2',
       'B',
       'O',
       'TEP',
       'TRASCRIZIONE ESTERO (PRIVATO)',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 209
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 210,
       2,
       '2',
       'B',
       'O',
       'ODN',
       'TRASCRIZIONE DECRETO TRIBUNALE OMESSA DIC. DI NASCITA',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 210
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 211,
       2,
       '2',
       'B',
       'D',
       'RPN',
       'RICONOSCIMENTO (PRE-NATALE)',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 211
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 212,
       2,
       '2',
       'B',
       'D',
       'RIC',
       'RICONOSCIMENTO (POST-NASCITA)',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 212
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 213,
       2,
       '2',
       'B',
       'D',
       'CGE',
       'CAMBIO GENERALITA''',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 213
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 214,
       2,
       '2',
       'B',
       'D',
       'ADO',
       'ADOZIONE NAZIONALE / INTERNAZIONALE',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 214
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 215,
       2,
       '1',
       '',
       'O',
       'O1',
       'PARTE 1 (SENZA SERIE)',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 215
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 216,
       2,
       '2',
       '',
       'O',
       'O2',
       'PARTE 2 (SENZA SERIE)',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 216
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 301,
       3,
       '1',
       '',
       'O',
       'O1',
       'ALL''UFFICIALE DI STATO CIVILE',
       'S',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 301
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 302,
       3,
       '2',
       'A',
       'T',
       'T2A',
       'DA ALTRO COMUNE',
       'S',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 302
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 304,
       3,
       '2',
       'B',
       '',
       'ATL',
       'DALL''ESTERO',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 304
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 401,
       4,
       '1',
       '',
       'O',
       'O1',
       'PARTE 1',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 401
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 402,
       4,
       '2',
       'A',
       'O',
       'O2A',
       'PARTE 2 SERIE A',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 402
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 403,
       4,
       '2',
       'B',
       'T',
       'T2B',
       'PARTE 2 SERIE B',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 403
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 404,
       4,
       '2',
       'C',
       '',
       'ATL',
       'ATTO A TESTO LIBERO',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 404
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 405,
       4,
       '2',
       'C',
       'O',
       'TEP',
       'TRASCRIZIONE ESTERO (PRIVATO)',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 405
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 406,
       4,
       '2',
       'C',
       'O',
       'TEA',
       'TRASCRIZIONE ESTERO (AUTORITA'') / IN VIAGGIO',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 406
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 407,
       4,
       '2',
       'C',
       'O',
       'CPD',
       'CIVILE PER DELEGA',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 407
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 408,
       4,
       '2',
       'C',
       'T',
       'TMC',
       'TRASCRIZIONE MATRIMONIO CIVILE',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 408
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 409,
       4,
       '2',
       'C',
       'T',
       'TMD',
       'TRASCRIZIONE MATRIMONIO CIVILE SU DELEGA',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 409
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 410,
       4,
       '2',
       'C',
       'O',
       'FCC',
       'FUORI DALLA CASA COMUNALE',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 410
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 411,
       4,
       '2',
       'C',
       'O',
       'PDV',
       'PERICOLO DI VITA',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 411
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 451,
       4,
       '2',
       'C',
       '',
       'UAC',
       'UFFICIALE DI STATO CIVILE - ACCORDO',
       'S',
       '',
       'S',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 451
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 452,
       4,
       '2',
       'C',
       '',
       'UCO',
       'UFFICIALE DI STATO CIVILE - CONFERMA',
       'S',
       '',
       'S',
       'S',
       'S',
       '12SD',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 452
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 453,
       4,
       '2',
       'C',
       '',
       'UAL',
       'UFFICIALE DI STATO CIVILE - ALTRO',
       '',
       '',
       'S',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 453
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 454,
       4,
       '2',
       'C',
       '',
       'AVV',
       'NEGOZIAZIONE ASSISTITA',
       'S',
       '',
       'S',
       'S',
       'S',
       '6SD',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 454
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 455,
       4,
       '2',
       'C',
       '',
       'AAL',
       'NEGOZIAZIONE ASSISTITA - ALTRO',
       '',
       '',
       'S',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 455
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 456,
       4,
       '2',
       'C',
       '',
       'TRI',
       'TRIBUNALE ITALIANO',
       '',
       '',
       'S',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 456
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 457,
       4,
       '2',
       'C',
       '',
       'EST',
       'TRIBUNALE ESTERO',
       '',
       '',
       'S',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 457
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 458,
       4,
       '2',
       'C',
       '',
       'RCN',
       'RICONCILIAZIONE',
       '',
       '',
       'S',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 458
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 501,
       5,
       '1',
       '',
       'O',
       'O1',
       'PARTE 1',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 501
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 502,
       5,
       '2',
       'A',
       'T',
       'T2A',
       'PARTE 2 SERIE A',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 502
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 503,
       5,
       '2',
       'B',
       'O',
       'O2B',
       'PARTE 2 SERIE B',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 503
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 504,
       5,
       '2',
       'B BIS',
       'T',
       'T2B',
       'PARTE 2 SERIE B BIS',
       'S',
       'S',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 504
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 505,
       5,
       '2',
       'C',
       '',
       'ATL',
       'ATTO A TESTO LIBERO',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 505
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 506,
       5,
       '2',
       'C',
       'O',
       'TEP',
       'TRASCRIZIONE ESTERO (PRIVATO)',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 506
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 507,
       5,
       '2',
       'C',
       'O',
       'TEA',
       'TRASCRIZIONE ESTERO (AUTORITA'') / IN VIAGGIO',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 507
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 508,
       5,
       '2',
       'C',
       'O',
       'CIG',
       'CADUTO IN GUERRA',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 508
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 509,
       5,
       '2',
       'C',
       'T',
       'BIS',
       'DECEDUTO IN OSPEDALE DI ALTRO COMUNE',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 509
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 510,
       5,
       '2',
       'C',
       'O',
       'MPR',
       'MORTE PRESUNTA',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 510
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 601,
       -4,
       '',
       '',
       'V',
       'PV1',
       'ALL''UFFICIALE DI STATO CIVILE',
       'S',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 601
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 602,
       -4,
       '',
       '',
       'V',
       'PV2',
       'DA AUTORITA'' GIUDIZIARIA',
       'S',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 602
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 603,
       -4,
       '',
       '',
       'V',
       'PV3',
       'FUORI DALLA CASA COMUNALE',
       'S',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 603
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 701,
       -4,
       '1',
       '',
       'O',
       'O1',
       'UNIONE CIVILE',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 701
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 702,
       -4,
       '1',
       '',
       'O',
       'UCN',
       'UNIONE CIVILE - CONIUGI',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 702
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 703,
       -4,
       '2',
       '',
       'O',
       'FCC',
       'UNIONE CIVILE - FUORI DALLA CASA COMUNALE',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 703
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 704,
       -4,
       '2',
       '',
       'O',
       'PDV',
       'UNIONE CIVILE - PERICOLO DI VITA',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 704
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 705,
       -4,
       '2',
       '',
       'O',
       'UPD',
       'UNIONE CIVILE - PER DELEGA',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 705
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 706,
       -4,
       '2',
       '',
       'T',
       'T2',
       'TRASCRIZIONE UNIONE CIVILE',
       'S',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 706
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 707,
       -4,
       '2',
       '',
       'T',
       'TPD',
       'TRASCRIZIONE UNIONE CIVILE - PER DELEGA',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 707
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 708,
       -4,
       '2',
       '',
       'O',
       'TEP',
       'TRASCRIZIONE ESTERO (PRIVATO)',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 708
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 709,
       -4,
       '2',
       '',
       'O',
       'TEA',
       'TRASCRIZIONE ESTERO (AUTORITA)',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 709
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 710,
       -4,
       '2',
       '',
       '',
       'ATL',
       'ATTO A TESTO LIBERO',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 710
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 711,
       -4,
       '2',
       '',
       'D',
       'SCC',
       'SCELTA COGNOME COMUNE',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 711
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 712,
       -4,
       '2',
       '',
       'D',
       'MCO',
       'MANCATA COMPARIZIONE',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 712
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 713,
       -4,
       '2',
       '',
       '',
       'DVS',
       'DICHIARAZIONE VOLONTA'' SCIOGLIMENTO UNIONE',
       '',
       '',
       'S',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 713
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 714,
       -4,
       '2',
       '',
       '',
       'UAC',
       'UFFICIALE DI STATO CIVILE - ACCORDO',
       'S',
       '',
       'S',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 714
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 715,
       -4,
       '2',
       '',
       '',
       'UCO',
       'UFFICIALE DI STATO CIVILE - CONFERMA',
       'S',
       '',
       'S',
       'S',
       'S',
       '12SU',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 715
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 716,
       -4,
       '2',
       '',
       '',
       'AVV',
       'NEGOZIAZIONE ASSISTITA',
       'S',
       '',
       'S',
       'S',
       'S',
       '6SU',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 716
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 717,
       -4,
       '2',
       '',
       '',
       'TRI',
       'TRIBUNALE ITALIANO',
       '',
       '',
       'S',
       'S',
       'S',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 717
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 718,
       -4,
       '2',
       '',
       '',
       'EST',
       'TRIBUNALE ESTERO',
       '',
       '',
       'S',
       'S',
       'S',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 718
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 719,
       -4,
       '2',
       '',
       '',
       'ANN',
       'NULLITA'' UNIONE CIVILE',
       '',
       '',
       'S',
       'S',
       'S',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 719
                  )
/
insert into civcta
       (ID, TIPO_ATTO, PARTE, SERIE, NATURA, SIGLA, DESCRIZIONE,
        FLAG_FORMULE, FLAG_PREGRESSO, FLAG_DIVORZIO, FLAG_ANAGRAFE,
        FLAG_ISTAT, COD_MODELLO_ISTAT, TIPO_ACCORDO_ISTAT,
        FLAG_VERBALE
       )
select 720,
       -4,
       '2',
       '',
       '',
       'UAL',
       'UFFICIALE DI STATO CIVILE - ALTRO',
       '',
       '',
       'S',
       '',
       '',
       '',
       '',
       ''
  from dual
 where not exists (select 1 from civcta b
                    where b.id = 720
                  )
/
update civcta
   set tipo_atto          = 1,
       parte              = '',
       serie              = '',
       natura             = 'D',
       sigla              = 'GIU',
       descrizione        = 'GIURAMENTO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 101
/
update civcta
   set tipo_atto          = 1,
       parte              = '',
       serie              = '',
       natura             = 'A',
       sigla              = 'DAQ',
       descrizione        = 'DECRETO ACQUISTO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 102
/
update civcta
   set tipo_atto          = 1,
       parte              = '',
       serie              = '',
       natura             = 'A',
       sigla              = 'ASM',
       descrizione        = 'ATTESTAZIONE SINDACO MINORE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 103
/
update civcta
   set tipo_atto          = 1,
       parte              = '',
       serie              = '',
       natura             = 'A',
       sigla              = 'AS1',
       descrizione        = 'ATTESTAZIONE SINDACO 18ENNE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 104
/
update civcta
   set tipo_atto          = 1,
       parte              = '',
       serie              = '',
       natura             = 'A',
       sigla              = 'ASA',
       descrizione        = 'ATTESTAZIONE SINDACO ATTRIBUZIONE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 105
/
update civcta
   set tipo_atto          = 1,
       parte              = '',
       serie              = '',
       natura             = 'P',
       sigla              = 'DPE',
       descrizione        = 'DECRETO PERDITA',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 106
/
update civcta
   set tipo_atto          = 1,
       parte              = '',
       serie              = '',
       natura             = 'D',
       sigla              = 'R18',
       descrizione        = 'RICHIESTA 18ENNE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 107
/
update civcta
   set tipo_atto          = 1,
       parte              = '',
       serie              = '',
       natura             = '',
       sigla              = 'ATL',
       descrizione        = 'ATTO A TESTO LIBERO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 108
/
update civcta
   set tipo_atto          = 2,
       parte              = '1',
       serie              = 'A',
       natura             = 'O',
       sigla              = 'O1A',
       descrizione        = 'PARTE 1 SERIE A',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 201
/
update civcta
   set tipo_atto          = 2,
       parte              = '1',
       serie              = 'B',
       natura             = 'O',
       sigla              = 'O1B',
       descrizione        = 'PARTE 1 SERIE B',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 202
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'A',
       natura             = 'T',
       sigla              = 'T2A',
       descrizione        = 'PARTE 2 SERIE A',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 203
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'B',
       natura             = '',
       sigla              = 'ATL',
       descrizione        = 'ATTO A TESTO LIBERO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 204
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'B',
       natura             = 'O',
       sigla              = 'CNA',
       descrizione        = 'CENTRO NASCITA',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 207
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'B',
       natura             = 'O',
       sigla              = 'TEA',
       descrizione        = 'TRASCRIZIONE ESTERO (AUTORITA'') / IN VIAGGIO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 208
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'B',
       natura             = 'O',
       sigla              = 'TEP',
       descrizione        = 'TRASCRIZIONE ESTERO (PRIVATO)',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 209
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'B',
       natura             = 'O',
       sigla              = 'ODN',
       descrizione        = 'TRASCRIZIONE DECRETO TRIBUNALE OMESSA DIC. DI NASCITA',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 210
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'B',
       natura             = 'D',
       sigla              = 'RPN',
       descrizione        = 'RICONOSCIMENTO (PRE-NATALE)',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 211
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'B',
       natura             = 'D',
       sigla              = 'RIC',
       descrizione        = 'RICONOSCIMENTO (POST-NASCITA)',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 212
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'B',
       natura             = 'D',
       sigla              = 'CGE',
       descrizione        = 'CAMBIO GENERALITA''',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 213
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = 'B',
       natura             = 'D',
       sigla              = 'ADO',
       descrizione        = 'ADOZIONE NAZIONALE / INTERNAZIONALE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 214
/
update civcta
   set tipo_atto          = 2,
       parte              = '1',
       serie              = '',
       natura             = 'O',
       sigla              = 'O1',
       descrizione        = 'PARTE 1 (SENZA SERIE)',
       flag_formule       = '',
       flag_pregresso     = 'S',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 215
/
update civcta
   set tipo_atto          = 2,
       parte              = '2',
       serie              = '',
       natura             = 'O',
       sigla              = 'O2',
       descrizione        = 'PARTE 2 (SENZA SERIE)',
       flag_formule       = '',
       flag_pregresso     = 'S',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 216
/
update civcta
   set tipo_atto          = 3,
       parte              = '1',
       serie              = '',
       natura             = 'O',
       sigla              = 'O1',
       descrizione        = 'ALL''UFFICIALE DI STATO CIVILE',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 301
/
update civcta
   set tipo_atto          = 3,
       parte              = '2',
       serie              = 'A',
       natura             = 'T',
       sigla              = 'T2A',
       descrizione        = 'DA ALTRO COMUNE',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 302
/
update civcta
   set tipo_atto          = 3,
       parte              = '2',
       serie              = 'B',
       natura             = '',
       sigla              = 'ATL',
       descrizione        = 'DALL''ESTERO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 304
/
update civcta
   set tipo_atto          = 4,
       parte              = '1',
       serie              = '',
       natura             = 'O',
       sigla              = 'O1',
       descrizione        = 'PARTE 1',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 401
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'A',
       natura             = 'O',
       sigla              = 'O2A',
       descrizione        = 'PARTE 2 SERIE A',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 402
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'B',
       natura             = 'T',
       sigla              = 'T2B',
       descrizione        = 'PARTE 2 SERIE B',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 403
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'ATL',
       descrizione        = 'ATTO A TESTO LIBERO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 404
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = 'O',
       sigla              = 'TEP',
       descrizione        = 'TRASCRIZIONE ESTERO (PRIVATO)',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 405
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = 'O',
       sigla              = 'TEA',
       descrizione        = 'TRASCRIZIONE ESTERO (AUTORITA'') / IN VIAGGIO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 406
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = 'O',
       sigla              = 'CPD',
       descrizione        = 'CIVILE PER DELEGA',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 407
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = 'T',
       sigla              = 'TMC',
       descrizione        = 'TRASCRIZIONE MATRIMONIO CIVILE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 408
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = 'T',
       sigla              = 'TMD',
       descrizione        = 'TRASCRIZIONE MATRIMONIO CIVILE SU DELEGA',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 409
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = 'O',
       sigla              = 'FCC',
       descrizione        = 'FUORI DALLA CASA COMUNALE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 410
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = 'O',
       sigla              = 'PDV',
       descrizione        = 'PERICOLO DI VITA',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 411
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'UAC',
       descrizione        = 'UFFICIALE DI STATO CIVILE - ACCORDO',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 451
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'UCO',
       descrizione        = 'UFFICIALE DI STATO CIVILE - CONFERMA',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = 'S',
       flag_istat         = 'S',
       cod_modello_istat  = '12SD',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 452
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'UAL',
       descrizione        = 'UFFICIALE DI STATO CIVILE - ALTRO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 453
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'AVV',
       descrizione        = 'NEGOZIAZIONE ASSISTITA',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = 'S',
       flag_istat         = 'S',
       cod_modello_istat  = '6SD',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 454
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'AAL',
       descrizione        = 'NEGOZIAZIONE ASSISTITA - ALTRO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 455
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'TRI',
       descrizione        = 'TRIBUNALE ITALIANO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 456
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'EST',
       descrizione        = 'TRIBUNALE ESTERO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 457
/
update civcta
   set tipo_atto          = 4,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'RCN',
       descrizione        = 'RICONCILIAZIONE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 458
/
update civcta
   set tipo_atto          = 5,
       parte              = '1',
       serie              = '',
       natura             = 'O',
       sigla              = 'O1',
       descrizione        = 'PARTE 1',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 501
/
update civcta
   set tipo_atto          = 5,
       parte              = '2',
       serie              = 'A',
       natura             = 'T',
       sigla              = 'T2A',
       descrizione        = 'PARTE 2 SERIE A',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 502
/
update civcta
   set tipo_atto          = 5,
       parte              = '2',
       serie              = 'B',
       natura             = 'O',
       sigla              = 'O2B',
       descrizione        = 'PARTE 2 SERIE B',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 503
/
update civcta
   set tipo_atto          = 5,
       parte              = '2',
       serie              = 'B BIS',
       natura             = 'T',
       sigla              = 'T2B',
       descrizione        = 'PARTE 2 SERIE B BIS',
       flag_formule       = 'S',
       flag_pregresso     = 'S',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 504
/
update civcta
   set tipo_atto          = 5,
       parte              = '2',
       serie              = 'C',
       natura             = '',
       sigla              = 'ATL',
       descrizione        = 'ATTO A TESTO LIBERO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 505
/
update civcta
   set tipo_atto          = 5,
       parte              = '2',
       serie              = 'C',
       natura             = 'O',
       sigla              = 'TEP',
       descrizione        = 'TRASCRIZIONE ESTERO (PRIVATO)',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 506
/
update civcta
   set tipo_atto          = 5,
       parte              = '2',
       serie              = 'C',
       natura             = 'O',
       sigla              = 'TEA',
       descrizione        = 'TRASCRIZIONE ESTERO (AUTORITA'') / IN VIAGGIO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 507
/
update civcta
   set tipo_atto          = 5,
       parte              = '2',
       serie              = 'C',
       natura             = 'O',
       sigla              = 'CIG',
       descrizione        = 'CADUTO IN GUERRA',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 508
/
update civcta
   set tipo_atto          = 5,
       parte              = '2',
       serie              = 'C',
       natura             = 'T',
       sigla              = 'BIS',
       descrizione        = 'DECEDUTO IN OSPEDALE DI ALTRO COMUNE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 509
/
update civcta
   set tipo_atto          = 5,
       parte              = '2',
       serie              = 'C',
       natura             = 'O',
       sigla              = 'MPR',
       descrizione        = 'MORTE PRESUNTA',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 510
/
update civcta
   set tipo_atto          = -4,
       parte              = '',
       serie              = '',
       natura             = 'V',
       sigla              = 'PV1',
       descrizione        = 'ALL''UFFICIALE DI STATO CIVILE',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = 'S'
 where id = 601
/
update civcta
   set tipo_atto          = -4,
       parte              = '',
       serie              = '',
       natura             = 'V',
       sigla              = 'PV2',
       descrizione        = 'DA AUTORITA'' GIUDIZIARIA',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = 'S'
 where id = 602
/
update civcta
   set tipo_atto          = -4,
       parte              = '',
       serie              = '',
       natura             = 'V',
       sigla              = 'PV3',
       descrizione        = 'FUORI DALLA CASA COMUNALE',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = 'S'
 where id = 603
/
update civcta
   set tipo_atto          = -4,
       parte              = '1',
       serie              = '',
       natura             = 'O',
       sigla              = 'O1',
       descrizione        = 'UNIONE CIVILE',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 701
/
update civcta
   set tipo_atto          = -4,
       parte              = '1',
       serie              = '',
       natura             = 'O',
       sigla              = 'UCN',
       descrizione        = 'UNIONE CIVILE - CONIUGI',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 702
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = 'O',
       sigla              = 'FCC',
       descrizione        = 'UNIONE CIVILE - FUORI DALLA CASA COMUNALE',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 703
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = 'O',
       sigla              = 'PDV',
       descrizione        = 'UNIONE CIVILE - PERICOLO DI VITA',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 704
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = 'O',
       sigla              = 'UPD',
       descrizione        = 'UNIONE CIVILE - PER DELEGA',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 705
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = 'T',
       sigla              = 'T2',
       descrizione        = 'TRASCRIZIONE UNIONE CIVILE',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 706
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = 'T',
       sigla              = 'TPD',
       descrizione        = 'TRASCRIZIONE UNIONE CIVILE - PER DELEGA',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 707
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = 'O',
       sigla              = 'TEP',
       descrizione        = 'TRASCRIZIONE ESTERO (PRIVATO)',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 708
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = 'O',
       sigla              = 'TEA',
       descrizione        = 'TRASCRIZIONE ESTERO (AUTORITA)',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 709
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = '',
       sigla              = 'ATL',
       descrizione        = 'ATTO A TESTO LIBERO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = 'S',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 710
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = 'D',
       sigla              = 'SCC',
       descrizione        = 'SCELTA COGNOME COMUNE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 711
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = 'D',
       sigla              = 'MCO',
       descrizione        = 'MANCATA COMPARIZIONE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = '',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 712
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = '',
       sigla              = 'DVS',
       descrizione        = 'DICHIARAZIONE VOLONTA'' SCIOGLIMENTO UNIONE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 713
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = '',
       sigla              = 'UAC',
       descrizione        = 'UFFICIALE DI STATO CIVILE - ACCORDO',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 714
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = '',
       sigla              = 'UCO',
       descrizione        = 'UFFICIALE DI STATO CIVILE - CONFERMA',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = 'S',
       flag_istat         = 'S',
       cod_modello_istat  = '12SU',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 715
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = '',
       sigla              = 'AVV',
       descrizione        = 'NEGOZIAZIONE ASSISTITA',
       flag_formule       = 'S',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = 'S',
       flag_istat         = 'S',
       cod_modello_istat  = '6SU',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 716
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = '',
       sigla              = 'TRI',
       descrizione        = 'TRIBUNALE ITALIANO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = 'S',
       flag_istat         = 'S',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 717
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = '',
       sigla              = 'EST',
       descrizione        = 'TRIBUNALE ESTERO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = 'S',
       flag_istat         = 'S',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 718
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = '',
       sigla              = 'ANN',
       descrizione        = 'NULLITA'' UNIONE CIVILE',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = 'S',
       flag_istat         = 'S',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 719
/
update civcta
   set tipo_atto          = -4,
       parte              = '2',
       serie              = '',
       natura             = '',
       sigla              = 'UAL',
       descrizione        = 'UFFICIALE DI STATO CIVILE - ALTRO',
       flag_formule       = '',
       flag_pregresso     = '',
       flag_divorzio      = 'S',
       flag_anagrafe      = '',
       flag_istat         = '',
       cod_modello_istat  = '',
       tipo_accordo_istat = '',
       flag_verbale       = ''
 where id = 720
/
