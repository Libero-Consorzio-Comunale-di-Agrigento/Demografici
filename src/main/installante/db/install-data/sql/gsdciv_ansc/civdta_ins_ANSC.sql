--liquibase formatted sql
--changeset amonopoli:202410011655 runOnChange:true stripComments:false
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '',
       '',
       'Processo Verbale',
       'V',
       '',
       '101',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '601',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 101
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '',
       '',
       'Processo Verbale - Autorita'' Giudiziaria',
       'V',
       '',
       '102',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '602',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 102
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '',
       '',
       'Processo Verbale - Fuori Casa Comunale',
       'V',
       '',
       '103',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '603',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 103
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '1',
       '',
       'Unione Civile nel Comune',
       'O',
       '',
       '111',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '701',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 111
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Unione Civile Fuori Casa Comunale',
       'O',
       '',
       '112',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '703',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 112
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Unione Civile Pericolo di Vita',
       'O',
       '',
       '113',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '704',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 113
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '1',
       '',
       'Unione Civile Coniugi',
       'O',
       '',
       '114',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '702',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 114
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Unione Civile per Delega di altro Comune',
       'O',
       '',
       '115',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '705',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 115
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Trascrizione Unione Civile in altro Comune',
       'T',
       '',
       '116',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '706',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 116
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Trascrizione Unione Civile per Delega in altro Comune',
       'T',
       '',
       '117',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '707',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 117
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Trascrizione dall''Estero (da Privato)',
       'O',
       '',
       '118',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '708',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 118
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Trascrizione dall''Estero (da Autorita'')',
       'O',
       '',
       '119',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '709',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 119
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Scelta del Cognome Comune',
       'D',
       '',
       '120',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '711',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 120
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Scioglimento - Dichiarazione della Volontà',
       'D',
       '',
       '151',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '713',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 151
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Scioglimento - Accordo c/o Ufficiale',
       'D',
       '',
       '152',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '714',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 152
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Scioglimento - Conferma c/o Ufficiale',
       'D',
       '',
       '153',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '715',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 153
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Scioglimento - Negoziazione Assistita',
       'D',
       '',
       '154',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '716',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 154
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Scioglimento - Nullità ',
       'D',
       '',
       '155',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '719',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 155
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Scioglimento - Mancata Conferma',
       'D',
       '',
       '156',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '720',
       '',
       'S',
       'A',
       '',
       '',
       '',
       'M',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 156
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Scioglimento - Tribunale Italiano',
       'D',
       '',
       '157',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '717',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 157
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Scioglimento - Tribunale Estero',
       'D',
       '',
       '158',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '718',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 158
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Atto Pregresso Parte 2 - Originale',
       'O',
       '',
       '201',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '710',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 201
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Atto Pregresso Parte 2 - Trascritto',
       'T',
       '',
       '202',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '706',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 202
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select -4,
       '2',
       '',
       'Atto Pregresso Parte 2 - Diverso',
       'D',
       '',
       '203',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '710',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = -4
                      and b.sequenza  = 203
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 1,
       '',
       '',
       'Verbale di Giuramento',
       'D',
       '',
       '101',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '101',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 1
                      and b.sequenza  = 101
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 1,
       '',
       '',
       'Acquisto Cittadinanza',
       'A',
       '',
       '102',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '102',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 1
                      and b.sequenza  = 102
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 1,
       '',
       '',
       'Perdita Cittadinanza',
       'P',
       '',
       '103',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '106',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 1
                      and b.sequenza  = 103
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 1,
       '',
       '',
       'Generico Cittadinanza (casi residuali)',
       '',
       '',
       '104',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '108',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 1
                      and b.sequenza  = 104
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA,
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO,
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE,
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO,
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO,
        FLAG_ANSC)
select 1,
       '',
       '',
       'Trascrizione Atti Multipli',
       'A',
       '',
       '109',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '109',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 1
                      and b.sequenza  = 109
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 1,
       '',
       '',
       'Atto Pregresso - Acquisto',
       'A',
       '',
       '201',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '102',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 1
                      and b.sequenza  = 201
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 1,
       '',
       '',
       'Atto Pregresso - Perdita',
       'P',
       '',
       '202',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '106',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 1
                      and b.sequenza  = 202
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 1,
       '',
       '',
       'Atto Pregresso - Giuramento',
       'D',
       '',
       '203',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '101',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 1
                      and b.sequenza  = 203
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 1,
       '',
       '',
       'Atto Pregresso - Diverso',
       'D',
       '',
       '204',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '108',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 1
                      and b.sequenza  = 204
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '1',
       'A',
       'Denuncia di Nascita in Comune',
       'O',
       '',
       '101',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '201',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 101
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Denuncia di Nascita c/o Direzione Sanitaria',
       'O',
       '',
       '102',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '207',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 102
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '1',
       'B',
       'Denuncia di Nascita Tardiva',
       'O',
       '',
       '103',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '202',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 103
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'A',
       'Trascrizione Denuncia di Nascita in altro Comune ',
       'T',
       '',
       '104',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '203',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 104
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Trascrizione dall''Estero (da Privato)',
       'O',
       '',
       '105',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '209',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 105
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Trascrizione dall''Estero (da Autorita'') / In Viaggio',
       'O',
       '',
       '106',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '208',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 106
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Adozione',
       'D',
       '',
       '107',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '214',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 107
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Riconoscimento Nascituro',
       'D',
       '',
       '121',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '211',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 121
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Riconoscimento Post-Nascita',
       'D',
       '',
       '122',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '212',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 122
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Cambio Generalità',
       'D',
       '',
       '123',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '213',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 123
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Atto Pregresso 2B - Originale',
       'O',
       '',
       '201',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '204',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 201
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Atto Pregresso 2B - Trascritto',
       'T',
       '',
       '202',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '204',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 202
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Atto Pregresso 2B - Diverso',
       'D',
       '',
       '203',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '204',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 203
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '1',
       '',
       'Atto Pregresso Parte 1 - Originale (ante 1969) ',
       'O',
       '',
       '204',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '215',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 204
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 2,
       '2',
       '',
       'Atto Pregresso Parte 2 - Originale (anno 1800) ',
       'O',
       '',
       '205',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '216',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 205
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 3,
       '1',
       '',
       'Richiesta all''Ufficiale di Stato Civile',
       'O',
       '',
       '101',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '301',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 3
                      and b.sequenza  = 101
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 3,
       '2',
       'A',
       'Richiesta da Altro Comune',
       'T',
       '',
       '102',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '302',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 3
                      and b.sequenza  = 102
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 3,
       '2',
       'B',
       'Richiesta dall''Estero',
       'O',
       '',
       '103',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '304',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 3
                      and b.sequenza  = 103
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '1',
       '',
       'Rito Civile nel Comune',
       'O',
       '',
       '101',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '401',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 101
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'A',
       'Rito Religioso nel Comune',
       'O',
       '',
       '102',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '402',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 102
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Matrimonio Civile per Delega',
       'O',
       '',
       '103',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '407',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 103
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Matrimonio Fuori Casa Comunale',
       'O',
       '',
       '104',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '410',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 104
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Matrimonio Pericolo di vita',
       'O',
       '',
       '105',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '411',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 105
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'B',
       'Trascrizione Rito Religioso in altro Comune',
       'T',
       '',
       '106',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '403',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 106
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Trascrizione Matrimonio Civile in altro Comune',
       'T',
       '',
       '107',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '408',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 107
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Trascrizione Matrimonio Civile per Delega in altro Comune',
       'T',
       '',
       '108',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '409',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 108
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Trascrizione dall''Estero (da Privato)',
       'O',
       '',
       '109',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '405',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 109
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Trascrizione dall''Estero (da Autorita'') / In Viaggio',
       'O',
       '',
       '110',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '406',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 110
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Separazione - Accordo c/o Ufficiale',
       'D',
       '',
       '111',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '451',
       '',
       'S',
       'X',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 111
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Cessazione - Accordo c/o Ufficiale',
       'D',
       '',
       '112',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '451',
       '',
       'S',
       'C',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 112
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Scioglimento - Accordo c/o Ufficiale',
       'D',
       '',
       '113',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '451',
       '',
       'S',
       'S',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 113
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Separazione - Conferma c/o Ufficiale',
       'D',
       '',
       '121',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '452',
       '',
       'S',
       'X',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 121
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Cessazione - Conferma c/o Ufficiale',
       'D',
       '',
       '122',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '452',
       '',
       'S',
       'C',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 122
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Scioglimento - Conferma c/o Ufficiale',
       'D',
       '',
       '123',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '452',
       '',
       'S',
       'S',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 123
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Modifica delle Condizioni di Separazione c/o Ufficiale',
       'D',
       '',
       '124',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '453',
       '',
       'S',
       'A',
       '',
       '',
       '',
       'C',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 124
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Modifica delle Condizioni di Scioglimento / Cessazione  c/o Ufficiale',
       'D',
       '',
       '125',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '453',
       '',
       'S',
       'A',
       '',
       '',
       '',
       'D',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 125
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Mancata Conferma dell''Accordo c/o Ufficiale',
       'D',
       '',
       '126',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '453',
       '',
       'S',
       'A',
       '',
       '',
       '',
       'M',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 126
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Separazione - Negoziazione Assistita',
       'D',
       '',
       '131',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '454',
       '',
       'S',
       'X',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 131
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Cessazione - Negoziazione Assistita',
       'D',
       '',
       '132',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '454',
       '',
       'S',
       'C',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 132
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Scioglimento - Negoziazione Assistita',
       'D',
       '',
       '133',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '454',
       '',
       'S',
       'S',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 133
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Modifica delle Condizioni di Separazione - Negoziazione Assistita',
       'D',
       '',
       '134',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '455',
       '',
       'S',
       'A',
       '',
       '',
       '',
       'C',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 134
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Modifica delle Condizioni di Scioglimento / Cessazione - Negoziazione Assistita',
       'D',
       '',
       '135',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '455',
       '',
       'S',
       'A',
       '',
       '',
       '',
       'D',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 135
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Cessazione - Tribunale Italiano',
       'D',
       '',
       '151',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '456',
       '',
       'S',
       'C',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 151
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Scioglimento - Tribunale Italiano',
       'D',
       '',
       '152',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '456',
       '',
       'S',
       'S',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 152
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Divorzio - Tribunale Estero',
       'D',
       '',
       '161',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '457',
       '',
       'S',
       'A',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 161
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Riconciliazione',
       'D',
       '',
       '171',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '458',
       '',
       'S',
       'A',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 171
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Atto Pregresso 2C - Originale',
       'O',
       '',
       '201',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '404',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 201
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Atto Pregresso 2C - Trascritto',
       'T',
       '',
       '202',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '404',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 202
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 4,
       '2',
       'C',
       'Atto Pregresso 2C - Diverso',
       'D',
       '',
       '203',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '404',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 4
                      and b.sequenza  = 203
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '1',
       '',
       'Deceduto in Casa',
       'O',
       '',
       '101',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '501',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 101
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '2',
       'B',
       'Deceduto in Ospedale',
       'O',
       '',
       '102',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '503',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 102
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '2',
       'A',
       'Trascrizione Deceduto in Casa in altro Comune',
       'T',
       '',
       '103',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '502',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 103
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '2',
       'C',
       'Trascrizione Deceduto in Ospedale in altro Comune',
       'T',
       '',
       '104',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '509',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 104
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '2',
       'C',
       'Trascrizione dall''Estero (da Privato)',
       'O',
       '',
       '105',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '506',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 105
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '2',
       'C',
       'Trascrizione dall''Estero (da Autorita'') / In Viaggio',
       'O',
       '',
       '106',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '507',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 106
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '2',
       'C',
       'Atto Pregresso 2C - Originale',
       'O',
       '',
       '201',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '505',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 201
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '2',
       'C',
       'Atto Pregresso 2C - Trascritto',
       'T',
       '',
       '202',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '505',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 202
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '2',
       'C',
       'Atto Pregresso 2C - Diverso',
       'D',
       '',
       '203',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '505',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 203
                   )
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, 
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, 
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, 
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, 
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO, 
        FLAG_ANSC)
select 5,
       '2',
       'B BIS',
       'Atto Pregresso Parte 2 Serie B BIS - Trascritto',
       'T',
       '',
       '204',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '504',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 5
                      and b.sequenza  = 204
                   )
/
update civdta
   set descrizione         = 'Processo Verbale',
       note                = '',
       id_civcta           = '601',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 101
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Processo Verbale - Autorita'' Giudiziaria',
       note                = '',
       id_civcta           = '602',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 102
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Processo Verbale - Fuori Casa Comunale',
       note                = '',
       id_civcta           = '603',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 103
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Unione Civile nel Comune',
       note                = '',
       id_civcta           = '701',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 111
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Unione Civile Fuori Casa Comunale',
       note                = '',
       id_civcta           = '703',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 112
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Unione Civile Pericolo di Vita',
       note                = '',
       id_civcta           = '704',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 113
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Unione Civile Coniugi',
       note                = '',
       id_civcta           = '702',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 114
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Unione Civile per Delega di altro Comune',
       note                = '',
       id_civcta           = '705',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 115
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione Unione Civile in altro Comune',
       note                = '',
       id_civcta           = '706',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 116
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione Unione Civile per Delega in altro Comune',
       note                = '',
       id_civcta           = '707',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 117
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione dall''Estero (da Privato)',
       note                = '',
       id_civcta           = '708',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 118
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione dall''Estero (da Autorita'')',
       note                = '',
       id_civcta           = '709',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 119
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scelta del Cognome Comune',
       note                = '',
       id_civcta           = '711',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 120
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Dichiarazione della Volontà',
       note                = '',
       id_civcta           = '713',
       flag_divorzio       = 'S',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 151
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Accordo c/o Ufficiale',
       note                = '',
       id_civcta           = '714',
       flag_divorzio       = 'S',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 152
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Conferma c/o Ufficiale',
       note                = '',
       id_civcta           = '715',
       flag_divorzio       = 'S',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 153
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Negoziazione Assistita',
       note                = '',
       id_civcta           = '716',
       flag_divorzio       = 'S',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 154
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Nullità ',
       note                = '',
       id_civcta           = '719',
       flag_divorzio       = 'S',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 155
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Mancata Conferma',
       note                = '',
       id_civcta           = '720',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'A',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = 'M'
 where tipo_atto = -4
   and sequenza  = 156
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Tribunale Italiano',
       note                = '',
       id_civcta           = '717',
       flag_divorzio       = 'S',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 157
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Tribunale Estero',
       note                = '',
       id_civcta           = '718',
       flag_divorzio       = 'S',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 158
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso Parte 2 - Originale',
       note                = '',
       id_civcta           = '710',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 201
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso Parte 2 - Trascritto',
       note                = '',
       id_civcta           = '706',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 202
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso Parte 2 - Diverso',
       note                = '',
       id_civcta           = '710',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = -4),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = -4
   and sequenza  = 203
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Verbale di Giuramento',
       note                = '',
       id_civcta           = '101',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 1),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 1
   and sequenza  = 101
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Acquisto Cittadinanza',
       note                = '',
       id_civcta           = '102',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 1),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 1
   and sequenza  = 102
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Perdita Cittadinanza',
       note                = '',
       id_civcta           = '106',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 1),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 1
   and sequenza  = 103
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Generico Cittadinanza (casi residuali)',
       note                = '',
       id_civcta           = '108',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 1),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 1
   and sequenza  = 104
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso - Acquisto',
       note                = '',
       id_civcta           = '102',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 1),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 1
   and sequenza  = 201
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso - Perdita',
       note                = '',
       id_civcta           = '106',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 1),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 1
   and sequenza  = 202
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso - Giuramento',
       note                = '',
       id_civcta           = '101',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 1),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 1
   and sequenza  = 203
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso - Diverso',
       note                = '',
       id_civcta           = '108',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 1),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 1
   and sequenza  = 204
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Denuncia di Nascita in Comune',
       note                = '',
       id_civcta           = '201',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 101
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Denuncia di Nascita c/o Direzione Sanitaria',
       note                = '',
       id_civcta           = '207',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 102
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Denuncia di Nascita Tardiva',
       note                = '',
       id_civcta           = '202',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 103
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione Denuncia di Nascita in altro Comune ',
       note                = '',
       id_civcta           = '203',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 104
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione dall''Estero (da Privato)',
       note                = '',
       id_civcta           = '209',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 105
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione dall''Estero (da Autorita'') / In Viaggio',
       note                = '',
       id_civcta           = '208',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 106
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Adozione',
       note                = '',
       id_civcta           = '214',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 107
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Riconoscimento Nascituro',
       note                = '',
       id_civcta           = '211',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 121
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Riconoscimento Post-Nascita',
       note                = '',
       id_civcta           = '212',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 122
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Cambio Generalità',
       note                = '',
       id_civcta           = '213',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 123
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso 2B - Originale',
       note                = '',
       id_civcta           = '204',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 201
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso 2B - Trascritto',
       note                = '',
       id_civcta           = '204',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 202
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso 2B - Diverso',
       note                = '',
       id_civcta           = '204',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 203
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso Parte 1 - Originale (ante 1969) ',
       note                = '',
       id_civcta           = '215',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 204
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso Parte 2 - Originale (anno 1800) ',
       note                = '',
       id_civcta           = '216',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 205
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Richiesta all''Ufficiale di Stato Civile',
       note                = '',
       id_civcta           = '301',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 3),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 3
   and sequenza  = 101
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Richiesta da Altro Comune',
       note                = '',
       id_civcta           = '302',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 3),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 3
   and sequenza  = 102
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Richiesta dall''Estero',
       note                = '',
       id_civcta           = '304',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 3),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 3
   and sequenza  = 103
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Rito Civile nel Comune',
       note                = '',
       id_civcta           = '401',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 101
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Rito Religioso nel Comune',
       note                = '',
       id_civcta           = '402',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 102
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Matrimonio Civile per Delega',
       note                = '',
       id_civcta           = '407',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 103
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Matrimonio Fuori Casa Comunale',
       note                = '',
       id_civcta           = '410',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 104
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Matrimonio Pericolo di vita',
       note                = '',
       id_civcta           = '411',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 105
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione Rito Religioso in altro Comune',
       note                = '',
       id_civcta           = '403',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 106
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione Matrimonio Civile in altro Comune',
       note                = '',
       id_civcta           = '408',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 107
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione Matrimonio Civile per Delega in altro Comune',
       note                = '',
       id_civcta           = '409',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 108
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione dall''Estero (da Privato)',
       note                = '',
       id_civcta           = '405',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 109
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione dall''Estero (da Autorita'') / In Viaggio',
       note                = '',
       id_civcta           = '406',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 110
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Separazione - Accordo c/o Ufficiale',
       note                = '',
       id_civcta           = '451',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'X',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 111
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Cessazione - Accordo c/o Ufficiale',
       note                = '',
       id_civcta           = '451',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'C',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 112
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Accordo c/o Ufficiale',
       note                = '',
       id_civcta           = '451',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'S',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 113
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Separazione - Conferma c/o Ufficiale',
       note                = '',
       id_civcta           = '452',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'X',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 121
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Cessazione - Conferma c/o Ufficiale',
       note                = '',
       id_civcta           = '452',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'C',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 122
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Conferma c/o Ufficiale',
       note                = '',
       id_civcta           = '452',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'S',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 123
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Modifica delle Condizioni di Separazione c/o Ufficiale',
       note                = '',
       id_civcta           = '453',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'A',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = 'C'
 where tipo_atto = 4
   and sequenza  = 124
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Modifica delle Condizioni di Scioglimento / Cessazione  c/o Ufficiale',
       note                = '',
       id_civcta           = '453',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'A',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = 'D'
 where tipo_atto = 4
   and sequenza  = 125
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Mancata Conferma dell''Accordo c/o Ufficiale',
       note                = '',
       id_civcta           = '453',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'A',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = 'M'
 where tipo_atto = 4
   and sequenza  = 126
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Separazione - Negoziazione Assistita',
       note                = '',
       id_civcta           = '454',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'X',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 131
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Cessazione - Negoziazione Assistita',
       note                = '',
       id_civcta           = '454',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'C',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 132
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Negoziazione Assistita',
       note                = '',
       id_civcta           = '454',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'S',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 133
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Modifica delle Condizioni di Separazione - Negoziazione Assistita',
       note                = '',
       id_civcta           = '455',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'A',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = 'C'
 where tipo_atto = 4
   and sequenza  = 134
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Modifica delle Condizioni di Scioglimento / Cessazione - Negoziazione Assistita',
       note                = '',
       id_civcta           = '455',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'A',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = 'D'
 where tipo_atto = 4
   and sequenza  = 135
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Cessazione - Tribunale Italiano',
       note                = '',
       id_civcta           = '456',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'C',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 151
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Scioglimento - Tribunale Italiano',
       note                = '',
       id_civcta           = '456',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'S',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 152
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Divorzio - Tribunale Estero',
       note                = '',
       id_civcta           = '457',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'A',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 161
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Riconciliazione',
       note                = '',
       id_civcta           = '458',
       flag_divorzio       = 'S',
       tipo_divorzio       = 'A',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 171
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso 2C - Originale',
       note                = '',
       id_civcta           = '404',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 201
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso 2C - Trascritto',
       note                = '',
       id_civcta           = '404',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 202
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso 2C - Diverso',
       note                = '',
       id_civcta           = '404',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 4),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 4
   and sequenza  = 203
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Deceduto in Casa',
       note                = '',
       id_civcta           = '501',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 101
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Deceduto in Ospedale',
       note                = '',
       id_civcta           = '503',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 102
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione Deceduto in Casa in altro Comune',
       note                = '',
       id_civcta           = '502',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 103
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione Deceduto in Ospedale in altro Comune',
       note                = '',
       id_civcta           = '509',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 104
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione dall''Estero (da Privato)',
       note                = '',
       id_civcta           = '506',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 105
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Trascrizione dall''Estero (da Autorita'') / In Viaggio',
       note                = '',
       id_civcta           = '507',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 106
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso 2C - Originale',
       note                = '',
       id_civcta           = '505',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 201
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso 2C - Trascritto',
       note                = '',
       id_civcta           = '505',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 202
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso 2C - Diverso',
       note                = '',
       id_civcta           = '505',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 203
   and flag_ansc = 'S'
/
update civdta
   set descrizione         = 'Atto Pregresso Parte 2 Serie B BIS - Trascritto',
       note                = '',
       id_civcta           = '504',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 5),
       flag_pregresso      = 'S',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 5
   and sequenza  = 204
   and flag_ansc = 'S'
/
insert into civdta
       (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA,
        NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO,
        ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE,
        ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO,
        ID_CIVDDO_CIA, FLAG_PREGRESSO, FLAG_DISMESSO, TIPO_DIVORZIO_ALTRO,
        FLAG_ANSC)
select 2,
       '2',
       'B',
       'Trascrizione da Tribunale - Omessa Denuncia',
       'O',
       '',
       '151',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '210',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from civdta b
                    where b.tipo_atto = 2
                      and b.sequenza  = 151
                   )
/
update civdta
   set descrizione         = 'Trascrizione da Tribunale - Omessa Denuncia',
       note                = '',
       id_civcta           = '210',
       flag_divorzio       = '',
       tipo_divorzio       = '',
       id_civddo_cia       = (select id from civddo ddo where cod_do = 'CI' and tipo_atto = 2),
       flag_pregresso      = '',
       flag_dismesso       = '',
       tipo_divorzio_altro = ''
 where tipo_atto = 2
   and sequenza  = 151
   and flag_ansc = 'S'
/
