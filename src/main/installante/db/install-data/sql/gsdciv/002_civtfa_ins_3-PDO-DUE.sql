--liquibase formatted sql
--changeset amonopoli:202405161535_2 runOnChange:true stripComments:false
insert into CIVTFA (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-PDO-DUE', 1, null, 
       'Esaminati i documenti <PRESA_VISIONE_DOCUMENTI> do'' atto dell''insussistenza di impedimenti alla pubblicazione, che questa, si fara'' in <COMUNE_AFFISSIONE_PUB_1> e in <COMUNE_AFFISSIONE_PUB_2>.'||chr(10)||
         'I documenti sono:'||chr(10)||
         'Per lo sposo: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSO> il <DATA_ESTRATTO_SPOSO>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSO> il <DATA_CUMULATIVO_SPOSO>.'||chr(10)||
         'Per la sposa: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSA> il <DATA_ESTRATTO_SPOSA>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSA> il <DATA_CUMULATIVO_SPOSA>.'||chr(10)||
         chr(10)||
         'Detti documenti, muniti del mio visto, inserisco come allegati al presente processo verbale.', 
       'Esaminati i documenti <PRESA_VISIONE_DOCUMENTI> do'' atto dell''insussistenza di impedimenti alla pubblicazione, che questa, si fara'' in <COMUNE_AFFISSIONE_PUB_1> e in <COMUNE_AFFISSIONE_PUB_2>.'||chr(10)||
         'I documenti sono:'||chr(10)||
         'Per lo sposo: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSO> il <DATA_ESTRATTO_SPOSO>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSO> il <DATA_CUMULATIVO_SPOSO>.'||chr(10)||
         'Per la sposa: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSA> il <DATA_ESTRATTO_SPOSA>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSA> il <DATA_CUMULATIVO_SPOSA>.'||chr(10)||
         chr(10)||
         'Detti documenti, muniti del mio visto, inserisco come allegati al presente processo verbale.'
  from dual
 where not exists (select 1 from civtfa b
                    where b.formula = '3-PDO-DUE')
/
