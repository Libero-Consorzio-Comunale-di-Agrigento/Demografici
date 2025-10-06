--liquibase formatted sql
--changeset amonopoli:202301121325 runOnChange:true
create or replace procedure p_SCSW_riga_dati 
(a_terminalista   IN      varchar2
,a_comune_data    IN      varchar2
,a_comune         IN      varchar2
,a_data           IN      varchar2
,a_tipo_atto_nb   IN      number
,a_tipo_atto      IN      number
,a_w_tipo_atto    IN      number
,a_formula        IN      varchar2
,a_codice_co      IN      number
,a_ufficio        IN      number
,a_anno           IN      number
,a_atto           IN      number
,a_parte          IN      number
,a_serie          IN      varchar2
,a_data_reg       IN      number
,a_sequenza       IN      number
,a_separatore     IN      varchar2
,a_errore         IN OUT  varchar2
,a_return         IN OUT  number
,a_riga_dati      IN OUT  varchar2
)

IS

w_sep					varchar2(255) := nvl(a_separatore,chr(9));

fail					exception;
w_sfs 					number := 0;
  
riga_intesta				varchar2(4000);
riga_dati                          	varchar2(4000);
riga_dati1                        	varchar2(4000);
riga_dati2                        	varchar2(4000);
riga_dati3                        	varchar2(4000);
riga_dati4                        	varchar2(4000);
riga_dati5                        	varchar2(4000);
cap_residenza         			varchar2(10);
cap_residenza_sposa   			varchar2(10);
w_comune_nascita            		varchar2(4000);

w_comune_data                    	varchar2(4000);
w_comune                            	varchar2(4000);
w_data                                	varchar2(4000);

comune_utente         			varchar2(2000);
testo_annotazione     			varchar2(6000);
residenza             			varchar2(255);
residenza_sposa       			varchar2(255);
tribunale_utente      			varchar2(2000);
w_des_tipo_atto                		varchar2(255);

comune_trascrizione_1_riga1		varchar2(2000);
comune_trascrizione_1_riga2             varchar2(2000);

comune_trascrizione_2_riga1		varchar2(2000);
comune_trascrizione_2_riga2		varchar2(2000);

blocco_trascrizione_1_riga1		varchar2(2000);
blocco_trascrizione_1_riga2		varchar2(2000);

blocco_trascrizione_2_riga1		varchar2(2000);
blocco_trascrizione_2_riga2		varchar2(2000);

invio_trib_competente_riga1		varchar2(2000);
invio_trib_competente_riga2		varchar2(2000);
invio_procura_competente_riga1		varchar2(2000);
invio_procura_competente_riga2		varchar2(2000);
invio_comune_trascrizione 		varchar2(1000);

al_tribunale_riga1			varchar2(2000);
al_tribunale_riga2			varchar2(2000);
al_procuratore_riga1			varchar2(2000);
al_procuratore_riga2			varchar2(2000);
al_prefetto_riga1			varchar2(2000);
al_prefetto_riga2			varchar2(2000);

valori                     		varchar2(4000);
valori_finali        			varchar2(4000);


doc_dati                		varchar2(2000);
doc_modello            			varchar2(2000);
doc_word                		varchar2(2000);
doc_nome                		varchar2(2000);
file_rtf                		varchar2(2000);

w_anno                    		number(4);
w_parte                    		number(1);
w_serie                    		varchar2(5);
w_formula                		varchar2(10);
w_atto                     		number(4);
w_numero_copie     			number(1);
conta_copie     			number(2) := 0;
vuoto           			varchar2(3) := 'N';

w_terminalista    			varchar2(100);
w_terminalista_atto    			varchar2(100);
w_firma_omessa				varchar2(255);
w_firma_omessa_term_atto		varchar2(255);

w_messaggio            			varchar2(2000);

--
-- 02/10/2007 - A.Monopoli
--
dep_invio_trib_riga1                    varchar2(2000);
dep_invio_trib_riga2                    varchar2(2000);
dep_invio_comune_tras                 	varchar2(1000);
w_anno_atto                             number;

--cursor sel_dati is
--     select com.anno, com.parte, com.serie, com.formula, com.atto, com.numero_copie, 
--            com.ufficio, com.tipo_atto, com.data_reg,
--            decode(com.tipo_atto,6,2,7,2,8,2,9,4,-7,2,-9,4,tipo_atto) w_tipo_atto,
--            sequenza
--       from civcom com
--    where com.codice_co = nvl(a_codice_co,0)
--      and com.ufficio   = nvl(a_ufficio,0)
--      and (com.tipo_atto = a_tipo_atto_nb or a_tipo_atto_nb is null)
--    order by 8, 7, 1, 2, 3, 5
--   ;

BEGIN
  w_terminalista := a_terminalista;
  w_comune_data  := a_comune_data;
  w_comune       := a_comune;
  w_data         := a_data; 
    
--for rec_dati in sel_dati loop     
  if nvl(a_tipo_atto_nb,0)  = 0 then
     p_SCSW_riga_dati_0(a_tipo_atto,a_ufficio,a_anno,a_atto,a_parte,a_serie,a_formula,a_data_reg,a_w_tipo_atto,w_terminalista,w_comune_data,w_comune,w_data,w_sep,riga_dati,a_sequenza);

  elsif nvl(a_tipo_atto_nb,0) = 1 then
     w_messaggio := f_ctr_word_civ (1,a_ufficio,a_anno,a_atto,a_parte,a_serie,'','');

    begin
          select decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
                  decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
                  decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
                  decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
                  decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
                  NUMERO_ATTO_ANSC||w_sep||
                  ACQUISTO_PERDITA||w_sep||ISCR_CANC||w_sep||L_ACQUISTO_LA_PERDITA||w_sep||
                  COGNOME_NOME||w_sep||COGNOME||w_sep||NOME||w_sep||
                  DATA_NASCITA||w_sep||COMUNE_NASCITA||w_sep||CAP_COMUNE_NASCITA||w_sep||
                  RESIDENZA||w_sep||lpad(CAP_RESIDENZA,5,'0')||w_sep||
                  INDIRIZZO_ANA||w_sep||DATA_CITTADINANZA||w_sep||
                  DATA_RICHIESTA||w_sep||DATA_GIURAMENTO||w_sep||DATA_DECORRENZA||w_sep||
                  GIURAMENTO_UFFICIO||w_sep||GIURAMENTO_ANNO||w_sep||GIURAMENTO_ATTO||w_sep||GIURAMENTO_NUMERO_ATTO_ANSC||w_sep||
                  DECRETO_NUMERO||w_sep||DECRETO_DATA||w_sep||DECRETO_DATA_NOTIFICA||w_sep||DECRETO_FIRMATO||w_sep||
                  COMUNE_DATA||w_sep||COMUNE||w_sep||DATA||w_sep||
                  AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
                  FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||
                  NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||UFFICIALE_PROV||w_sep||
                  PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||
                  DATA_PROTOCOLLO_PROV||w_sep||
                  ENTE_STRANIERO||w_sep||COMUNE_ENTE_STRANIERO||w_sep||STATO_ENTE_STRANIERO||w_sep||
                  DATA_ATTO_ENTE_STRANIERO||w_sep||
                  TIPO_ATTO_ENTE_STRANIERO||w_sep||ESTREMI_ATTO_ENTE_STRANIERO||w_sep||
                  W_TERMINALISTA,TERMINALISTA_ATTO
                into riga_dati,w_terminalista_atto
                from CERCCI
           where nvl(serie,' ')     = nvl(a_serie,' ')
         and nvl(parte,0)         = nvl(a_parte,0)
         and atto                         = a_atto
         and anno                         = a_anno
         and ufficio                     = a_ufficio
         and rownum                     =    1 
                 and w_messaggio            is null
            ;
    exception
      when no_data_found then
         riga_dati:= w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
				  w_sep||w_sep||w_sep;
         w_terminalista_atto := '';
      when others then
         riga_dati:= w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
				  w_sep||w_sep||w_sep;
         w_terminalista_atto := '';
          a_errore := '0-Errore in ricerca dati 1 ('||SQLERRM||')';            
    end;

  elsif  nvl(a_tipo_atto_nb,0) = 2 then
      w_messaggio := f_ctr_word_civ(2,a_ufficio,a_anno,a_atto,a_parte,a_serie,'','');

    begin
        select decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
                   decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
                   decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
                   decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
                   decode(NUMERO_ATTO_ANSC, '', PARTE_EDIT)||w_sep||
                   decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
                   decode(NUMERO_ATTO_ANSC, '', SERIE_EDIT)||w_sep||
                   NUMERO_ATTO_ANSC||w_sep||
                   UFFICIO_ORIG||w_sep||ANNO_ORIG||w_sep||
                   ATTO_ORIG||w_sep||PARTE_ORIG||w_sep||PARTE_ORIG_EDIT||w_sep||SERIE_ORIG||w_sep||
                   SERIE_ORIG_EDIT||w_sep||
                   NUMERO_ATTO_ANSC_ORIG||w_sep||
                   COMUNE_ATTO||w_sep||COGNOME_NOME||w_sep||COGNOME||w_sep||
                   NOME||w_sep||CODICE_FISCALE||w_sep||SECONDO_NOME||w_sep||TERZO_NOME||w_sep||
                   SESSO||w_sep||NAT_OA||w_sep||DATA_NASCITA||w_sep||
                   GIORNO_NASCITA||w_sep||GIORNO_NASCITA_LETTERE||w_sep||MESE_NASCITA||w_sep||
                   ANNO_NASCITA||w_sep||ANNO_NASCITA_LETTERE||w_sep||COMUNE_NASCITA||w_sep||CAP_COMUNE_NASCITA||w_sep||
                   ORE||w_sep||ORE_LETTERE||w_sep||MINUTI||w_sep||MINUTI_LETTERE||w_sep||
                   E_MINUTI||w_sep||E_MINUTI_LETTERE||w_sep||DEL_LUOGO_NASCITA||w_sep||
                   DEL_LUOGO_NASCITA_TRUNC||w_sep||LUOGO_NASCITA||w_sep||LUOGO_NASCITA_TRUNC||w_sep||
                   PATERNITA||w_sep||PATERNITA_SOLO_NOME||w_sep||INDIRIZZO_ANA_PAT||w_sep||DATA_NAS_PAT||w_sep||
                   MATERNITA||w_sep||MATERNITA_SOLO_NOME||w_sep||INDIRIZZO_ANA_MAT||w_sep||DATA_NAS_MAT||w_sep||
                   RESIDENZA||w_sep||lpad(CAP_RESIDENZA,5,'0')||w_sep||COMUNE_DATA||w_sep||COMUNE||w_sep||DATA||w_sep||
                   AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
                   FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||
                   NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
                   UFFICIALE_PROV||w_sep||
                   PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV||w_sep||
                   ENTE_STRANIERO||w_sep||COMUNE_ENTE_STRANIERO||w_sep||STATO_ENTE_STRANIERO||w_sep||
                   DATA_ATTO_ENTE_STRANIERO||w_sep||
                   TIPO_ATTO_ENTE_STRANIERO||w_sep||ESTREMI_ATTO_ENTE_STRANIERO||w_sep||
                   ATTO_NOTARILE||w_sep||COMUNE_ATTO_NOTARILE||w_sep||DATA_ATTO_NOTARILE||w_sep||
                   ESTREMI_DOC_ATTO_NOTARILE||w_sep||
                   CENTRO_NASCITA||w_sep||COMUNE_CENTRO_NASCITA||w_sep||
                   NUMERO_DICH_CENTRO_NASCITA||w_sep||ANNO_DICH_CENTRO_NASCITA||w_sep||
                   DATA_RICHIESTA_CENTRO_NASCITA||w_sep||
                   ADDETTO_CENTRO_NASCITA||w_sep||QUALIFICA_CENTRO_NASCITA||w_sep||
                   DATA_DICH_CENTRO_NASCITA||w_sep||ORE_DICH_CENTRO_NASCITA||w_sep||MINUTI_DICH_CENTRO_NASCITA||w_sep||
                   W_TERMINALISTA,TERMINALISTA_ATTO
                into riga_dati,w_terminalista_atto
        from CERCNA
       where nvl(serie,' ')     = nvl(a_serie,' ')
                 and nvl(parte,0)         = nvl(a_parte,0)
                 and atto                         = a_atto
                 and anno                         = a_anno
                 and ufficio                     = a_ufficio
                 and rownum                     =    1 
                 and w_messaggio            is null
                 ;
    exception
        when no_data_found then
          riga_dati :=  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
          w_terminalista_atto := '';         
        when others then
          riga_dati :=  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
          w_terminalista_atto := '';                   
          a_errore := '0-Errore in ricerca dati 2 ('||SQLERRM||')';
      end;

    elsif nvl(a_tipo_atto_nb,0) = 3 then
      w_messaggio := f_ctr_word_civ(3,a_ufficio,a_anno,a_atto,a_parte,a_serie,'','');

      begin
            select UFFICIO||w_sep||ANNO||w_sep||ATTO||w_sep||PARTE||w_sep||PARTE_EDIT||w_sep||SERIE||w_sep||
                 SERIE_EDIT||w_sep||COGNOME_NOME_SPOSO||w_sep||NATO||w_sep||
                 DATA_NASCITA_SPOSO||w_sep||COMUNE_NASCITA_SPOSO||w_sep||CAP_COMUNE_NASCITA_SPOSO||w_sep||
                 RESIDENZA_SPOSO||w_sep||CAP_RESIDENZA_SPOSO||w_sep||
                 INDIRIZZO_ANA_SPOSO||w_sep||
                 COGNOME_NOME_SPOSA||w_sep||NATA||w_sep||DATA_NASCITA_SPOSA||w_sep||
                 COMUNE_NASCITA_SPOSA||w_sep||CAP_COMUNE_NASCITA_SPOSA||w_sep||
                 RESIDENZA_SPOSA||w_sep||CAP_RESIDENZA_SPOSA||w_sep||
                 INDIRIZZO_ANA_SPOSA||w_sep||
                 DATA_PUBBLICAZIONI||w_sep||COMUNE_DATA||w_sep||COMUNE||w_sep||DATA||w_sep||
                 ANNO_TESTATA||w_sep||GIORNO||w_sep||MESE||w_sep||ORE||w_sep||MINUTI||w_sep||UFFICIALE||w_sep||
                 COMUNE_MATRIMONIO||w_sep||STATO_CIVILE_SPOSO||w_sep||PROFESSIONE_SPOSO||w_sep||
                 CITTADINANZA_SPOSO||w_sep||STATO_CIVILE_SPOSA||w_sep||PROFESSIONE_SPOSA||w_sep||
                 CITTADINANZA_SPOSA||w_sep||ATTO_NASCITA_SPOSO||w_sep||PARTE_NASCITA_SPOSO||w_sep||
                 SERIE_NASCITA_SPOSO||w_sep||ANNO_ATTO_NASCITA_SPOSO||w_sep||ATTO_NASCITA_SPOSO_EDIT||w_sep||
                 COMUNE_ATTO_NASCITA_SPOSO||w_sep||
                 ATTO_NASCITA_SPOSA||w_sep||PARTE_NASCITA_SPOSA||w_sep||
                 SERIE_NASCITA_SPOSA||w_sep||ANNO_ATTO_NASCITA_SPOSA||w_sep||ATTO_NASCITA_SPOSA_EDIT||w_sep||
                 COMUNE_ATTO_NASCITA_SPOSA||w_sep||
                 COMUNE_AFFISSIONE||w_sep||DA_DATA_AFFISSIONE||w_sep||A_DATA_AFFISSIONE||w_sep||
                 GIORNI_AFFISSIONE||w_sep||
                 COMUNE_AFFISSIONE_2||w_sep||DA_DATA_AFFISSIONE_2||w_sep||A_DATA_AFFISSIONE_2||w_sep||
                 DATA_RILASCIO||w_sep||STAT_OA||w_sep||RILASCIAT_OA||w_sep||
                 CERTIFICATO||w_sep||ARTICOLO||w_sep||LEGGE||w_sep||
                 replace(RIGA_DOCUMENTI_1,';',' ')||w_sep||replace(RIGA_DOCUMENTI_2,';',' ')||w_sep||
             replace(RIGA_DOCUMENTI_3,';',' ')||w_sep||replace(RIGA_DOCUMENTI_4,';',' ')||w_sep||
             replace(RIGA_DOCUMENTI_5,';',' ')||w_sep||replace(RIGA_DOCUMENTI_6,';',' ')||w_sep||
                 replace(RIGA_DOCUMENTI_7,';',' ')||w_sep||replace(RIGA_DOCUMENTI_8,';',' ')||w_sep||
             replace(RIGA_DOCUMENTI_9,';',' ')||w_sep||replace(RIGA_DOCUMENTI_10,';',' ')||w_sep||
             replace(RIGA_DOCUMENTI_11,';',' ')||w_sep||replace(RIGA_DOCUMENTI_12,';',' ')||w_sep||
                 replace(RIGA_DOCUMENTI_13,';',' ')||w_sep||replace(RIGA_DOCUMENTI_14,';',' ')||w_sep||
             replace(RIGA_DOCUMENTI_15,';',' ')||w_sep||
                 replace(AUTORITA_PROV,';',' ')||w_sep||replace(AUTORITA_PROV_DA,';',' ')||w_sep||replace(AUTORITA_PROV_IN,';',' ')||w_sep||
				 replace(COMUNE_PROV,';',' ')||w_sep||replace(AUTORITA_PROV_COMUNE,';',' ')||w_sep||
             replace(FRAZIONE_PROV,';',' ')||w_sep||replace(AUTORITA_PROV_UFFICIO,';',' ')||w_sep||replace(NOTA_RIF,';',' ')||w_sep||
             replace(ANNO_NOTA_RIF,';',' ')||w_sep||replace(DATA_NOTA_RIF,';',' ')||w_sep||
             replace(UFFICIALE_PROV,';',' ')||w_sep||replace(PROTOCOLLO_PROV,';',' ')||w_sep||
             replace(ANNO_PROTOCOLLO_PROV,';',' ')||w_sep||replace(DATA_PROTOCOLLO_PROV,';',' ')||w_sep||
                         W_TERMINALISTA,TERMINALISTA_ATTO
                into riga_dati,w_terminalista_atto
                from CERCPU
             where nvl(serie,' ')     = nvl(a_serie,' ')
                 and nvl(parte,0)         = nvl(a_parte,0)
                 and atto                         = a_atto
                 and anno                         = a_anno
                 and ufficio                     = a_ufficio
                 and rownum                     = 1 
                 and w_messaggio            is null
                    ;
      exception
          when no_data_found then
            riga_dati:=   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep;
            w_terminalista_atto := '';
        when others then
            riga_dati:=   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep;
            w_terminalista_atto := '';
            a_errore := '0-Errore in ricerca dati 3 ('||SQLERRM||')';
        end;

    elsif nvl(a_tipo_atto_nb,0) = 4 then
      w_messaggio := f_ctr_word_civ(4,a_ufficio,a_anno,a_atto,a_parte,a_serie,'','');
       
        begin
              select decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', PARTE_EDIT)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', SERIE_EDIT)||w_sep||
                     NUMERO_ATTO_ANSC||w_sep||
                     UFFICIO_ORIG||w_sep||
                     ANNO_ORIG||w_sep||ATTO_ORIG||w_sep||PARTE_ORIG||w_sep||
                     PARTE_ORIG_EDIT||w_sep||SERIE_ORIG||w_sep||SERIE_ORIG_EDIT||w_sep||
                     NUMERO_ATTO_ANSC_ORIG||w_sep||
                     COGNOME_NOME_SPOSO||w_sep||CODICE_FISCALE_SPOSO||w_sep||NATO_IL||w_sep||
                     DATA_NASCITA_SPOSO||w_sep||COMUNE_NASCITA_SPOSO||w_sep||CAP_COMUNE_NASCITA_SPOSO||w_sep||
                     TRIBUNALE_NASCITA_SPOSO||w_sep||
                     ATTO_NASCITA_SPOSO||w_sep||PARTE_NASCITA_SPOSO||w_sep||SERIE_NASCITA_SPOSO||w_sep||
                     ANNO_ATTO_NASCITA_SPOSO||w_sep||
                     NUMERO_ATTO_ANSC_NASCITA_SPOSO||w_sep||
                     ATTO_NASCITA_SPOSO_EDIT||w_sep||
                     COMUNE_ATTO_NASCITA_SPOSO||w_sep||
                     RESIDENZA_SPOSO||w_sep||lpad(CAP_RESIDENZA_SPOSO,5,'0')||w_sep||INDIRIZZO_ANA_SPOSO||w_sep||
                     COGNOME_NOME_SPOSA||w_sep||CODICE_FISCALE_SPOSA||w_sep||NATA_IL||w_sep||
                     DATA_NASCITA_SPOSA||w_sep||COMUNE_NASCITA_SPOSA||w_sep||CAP_COMUNE_NASCITA_SPOSA||w_sep||
                     TRIBUNALE_NASCITA_SPOSA||w_sep||
                     ATTO_NASCITA_SPOSA||w_sep||PARTE_NASCITA_SPOSA||w_sep||SERIE_NASCITA_SPOSA||w_sep||
                     ANNO_ATTO_NASCITA_SPOSA||w_sep||
                     NUMERO_ATTO_ANSC_NASCITA_SPOSA||w_sep||
                     ATTO_NASCITA_SPOSA_EDIT||w_sep||
                     COMUNE_ATTO_NASCITA_SPOSA||w_sep||
                     RESIDENZA_SPOSA||w_sep||lpad(CAP_RESIDENZA_SPOSA,5,'0')||w_sep||INDIRIZZO_ANA_SPOSA||w_sep||
                     DATA_MATRIMONIO||w_sep||
                     GIORNO_MATRIMONIO||w_sep||GIORNO_MATRIMONIO_LETTERE||w_sep||MESE_MATRIMONIO||w_sep||
                     ANNO_MATRIMONIO||w_sep||ANNO_MATRIMONIO_LETTERE||w_sep||
                     COMUNE_MATRIMONIO||w_sep||CAP_COMUNE_MATRIMONIO||w_sep||RITO||w_sep||
                     DATA_RICONCILIAZIONE||w_sep||DATA_CONFERMA_DIVORZIO||w_sep||DATA_ACCORDO_DIVORZIO||w_sep|| 
                     COMUNE_DATA||w_sep||COMUNE||w_sep||DATA||w_sep||
                     AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
                     FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||
                     NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
                     UFFICIALE_PROV||w_sep||PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||
                     DATA_PROTOCOLLO_PROV||w_sep||
                     ENTE_STRANIERO||w_sep||COMUNE_ENTE_STRANIERO||w_sep||STATO_ENTE_STRANIERO||w_sep||
                     DATA_ATTO_ENTE_STRANIERO||w_sep||
                     TIPO_ATTO_ENTE_STRANIERO||w_sep||ESTREMI_ATTO_ENTE_STRANIERO||w_sep||
                     W_TERMINALISTA,TERMINALISTA_ATTO
                    into riga_dati,w_terminalista_atto
                    from CERCMA
                 where nvl(serie,' ')     = nvl(a_serie,' ')
                     and nvl(parte,0)         = nvl(a_parte,0)
                     and atto                         = a_atto
                     and anno                         = a_anno
                     and ufficio                     = a_ufficio
                     and rownum                     = 1 
                     and w_messaggio            is null
                        ;
          exception
              when no_data_found then
                riga_dati :=  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
				       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                w_terminalista_atto := '';
            when others then
              riga_dati :=  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
				       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                w_terminalista_atto := '';
              a_errore := '0-Errore in ricerca dati 4 ('||SQLERRM||')';
          end;

    elsif nvl(a_tipo_atto_nb,0) = 5 then
      w_messaggio := f_ctr_word_civ(5,a_ufficio,a_anno,a_atto,a_parte,a_serie,'','');
       
      begin
            select decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
             decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
             decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
             decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
             decode(NUMERO_ATTO_ANSC, '', PARTE_EDIT)||w_sep||
             decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
             decode(NUMERO_ATTO_ANSC, '', SERIE_EDIT)||w_sep||
             NUMERO_ATTO_ANSC||w_sep||
             UFFICIO_ORIG||w_sep||ANNO_ORIG||w_sep||
             ATTO_ORIG||w_sep||PARTE_ORIG||w_sep||PARTE_ORIG_EDIT||w_sep||
             SERIE_ORIG||w_sep||SERIE_ORIG_EDIT||w_sep||
             NUMERO_ATTO_ANSC_ORIG||w_sep||
             COGNOME_NOME||w_sep||
             CODICE_FISCALE||w_sep||
             SESSO||w_sep||NAT_OA||w_sep||NAT_OA_IL||w_sep||DATA_NASCITA||w_sep||
             COMUNE_NASCITA||w_sep||CAP_COMUNE_NASCITA||w_sep||
             TRIBUNALE_NASCITA||w_sep||RESIDENZA||w_sep||lpad(CAP_RESIDENZA,5,'0')||w_sep||
             INDIRIZZO_ANA||w_sep||DECEDUT_OA||w_sep||MORT_OA||w_sep||DATA_MORTE||w_sep||
             GIORNO_MORTE||w_sep||GIORNO_MORTE_LETTERE||w_sep||MESE_MORTE||w_sep||
             ANNO_MORTE||w_sep||ANNO_MORTE_LETTERE||w_sep||
             COMUNE_MORTE||w_sep||CAP_COMUNE_MORTE||w_sep||
             ORE||w_sep||ORE_LETTERE||w_sep||MINUTI||w_sep|| MINUTI_LETTERE||w_sep||
             E_MINUTI||w_sep||E_MINUTI_LETTERE||w_sep||MOTIVO_MORTE||w_sep||STATO_CIVILE||w_sep||
             COGNOME_NOME_CONIUGE||w_sep||COMUNE_DATA||w_sep||COMUNE||w_sep||DATA||w_sep||
             TRIBUNALE||w_sep||COMUNE_REGISTRO||w_sep||ANNO_NAS||w_sep||PARTE_NAS||w_sep||
             SERIE_NAS||w_sep||ATTO_NAS||w_sep||UFFICIO_NAS||w_sep||
             NUMERO_ATTO_ANSC_NAS||w_sep||
             ATTO_NAS_EDIT||w_sep||
             PADRE||w_sep||MADRE||w_sep||
             PROFESSIONE||w_sep||LUOGO_MORTE||w_sep||
             AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
             FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||
             NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||UFFICIALE_PROV||w_sep||
             PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||
             DATA_PROTOCOLLO_PROV||w_sep||
             ENTE_STRANIERO||w_sep||COMUNE_ENTE_STRANIERO||w_sep||STATO_ENTE_STRANIERO||w_sep||
             DATA_ATTO_ENTE_STRANIERO||w_sep||
             TIPO_ATTO_ENTE_STRANIERO||w_sep||ESTREMI_ATTO_ENTE_STRANIERO||w_sep||
-- dati trasporto / seppellimento / cremazione
             DATA_RICHIESTA_TRASPORTO||w_sep||RICHIEDENTE_TRASPORTO||w_sep||
               DATA_TRASPORTO||w_sep||ORE_TRASPORTO||w_sep||MINUTI_TRASPORTO||w_sep||
               INCARICATO_TRASPORTO||w_sep||COMUNE_DEST_TRASPORTO||w_sep||
               INDIRIZZO_DEST_TRASPORTO||w_sep||CIMITERO_DEST_TRASPORTO||w_sep||
               DATA_CREMAZIONE||w_sep||ORE_CREMAZIONE||w_sep||MINUTI_CREMAZIONE||w_sep||
               COMUNE_CREMAZIONE||w_sep||DESTINAZIONE_CENERI||w_sep||NOTE_CREMAZIONE||w_sep||
               DITTA_ONORANZE_FUNEBRI||w_sep||DATA_ONORANZE_FUNEBRI||w_sep||
               ORE_ONORANZE_FUNEBRI||w_sep||MINUTI_ONORANZE_FUNEBRI||w_sep||
               COMUNE_ONORANZE_FUNEBRI||w_sep||NOTE_TRASPORTO||w_sep||
               PROTOCOLLO_TRASPORTO||w_sep||ANNO_PROTOCOLLO_TRASPORTO||w_sep||DATA_PROTOCOLLO_TRASPORTO||w_sep||
               PROTOCOLLO_PERMESSO||w_sep||ANNO_PROTOCOLLO_PERMESSO||w_sep||DATA_PROTOCOLLO_PERMESSO||w_sep||
               PROT_PERMESSO_ALTRO_COMUNE||w_sep||ANNO_PERMESSO_ALTRO_COMUNE||w_sep||DATA_PERMESSO_ALTRO_COMUNE||w_sep||
               PROTOCOLLO_CREMAZIONE||w_sep||ANNO_PROTOCOLLO_CREMAZIONE||w_sep||DATA_PROTOCOLLO_CREMAZIONE||w_sep||
--
             W_TERMINALISTA,TERMINALISTA_ATTO
                into riga_dati,w_terminalista_atto
        from CERCMO
       where nvl(serie,' ')     = nvl(a_serie,' ')
                 and nvl(parte,0)         = nvl(a_parte,0)
                 and atto                         = a_atto
                 and anno                         = a_anno
                 and ufficio                     = a_ufficio
                 and rownum                     = 1 
                 and w_messaggio            is null
                    ;
      exception
          when no_data_found then
            riga_dati :=  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
            w_terminalista_atto := '';
        when others then
          riga_dati :=  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
          w_terminalista_atto := '';
          a_errore := '0-Errore in ricerca dati 5 ('||SQLERRM||')';    
    end;

    elsif nvl(a_tipo_atto_nb,0) = -4 then
      w_messaggio := f_ctr_word_civ(-4,a_ufficio,a_anno,a_atto,a_parte,a_serie,'','');
       
        begin
              select decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', PARTE_EDIT)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', SERIE_EDIT)||w_sep||
                     NUMERO_ATTO_ANSC||w_sep||
                     UFFICIO_ORIG||w_sep||
                     ANNO_ORIG||w_sep||ATTO_ORIG||w_sep||PARTE_ORIG||w_sep||
                     PARTE_ORIG_EDIT||w_sep||SERIE_ORIG||w_sep||SERIE_ORIG_EDIT||w_sep||
                     NUMERO_ATTO_ANSC_ORIG||w_sep||
                     COGNOME_NOME_1||w_sep||CODICE_FISCALE_1||w_sep||NAT_OA_IL_1||w_sep||
                     DATA_NASCITA_1||w_sep||COMUNE_NASCITA_1||w_sep||CAP_COMUNE_NASCITA_1||w_sep||
                     TRIBUNALE_NASCITA_1||w_sep||
                     ATTO_NASCITA_1||w_sep||PARTE_NASCITA_1||w_sep||SERIE_NASCITA_1||w_sep||
                     ANNO_ATTO_NASCITA_1||w_sep||
                     NUMERO_ATTO_ANSC_NASCITA_1||w_sep||
                     ATTO_NASCITA_1_EDIT||w_sep||
                     COMUNE_ATTO_NASCITA_1||w_sep||
                     RESIDENZA_1||w_sep||lpad(CAP_RESIDENZA_1,5,'0')||w_sep||INDIRIZZO_ANA_1||w_sep||
                     COGNOME_NOME_2||w_sep||CODICE_FISCALE_2||w_sep||NAT_OA_IL_2||w_sep||
                     DATA_NASCITA_2||w_sep||COMUNE_NASCITA_2||w_sep||CAP_COMUNE_NASCITA_2||w_sep||
                     TRIBUNALE_NASCITA_2||w_sep||
                     ATTO_NASCITA_2||w_sep||PARTE_NASCITA_2||w_sep||SERIE_NASCITA_2||w_sep||
                     ANNO_ATTO_NASCITA_2||w_sep||
                     NUMERO_ATTO_ANSC_NASCITA_2||w_sep||
                     ATTO_NASCITA_2_EDIT||w_sep||
                     COMUNE_ATTO_NASCITA_2||w_sep||
                     RESIDENZA_2||w_sep||lpad(CAP_RESIDENZA_2,5,'0')||w_sep||INDIRIZZO_ANA_2||w_sep||
                     DATA_UNIONE||w_sep||
                     GIORNO_UNIONE_LETTERE||w_sep||MESE_UNIONE||w_sep||
                     ANNO_UNIONE_LETTERE||w_sep||
                     COMUNE_UNIONE||w_sep||CAP_COMUNE_UNIONE||w_sep||
                     DATA_CONFERMA_SCIOGLIMENTO||w_sep||DATA_ACCORDO_SCIOGLIMENTO||w_sep||
                     COMUNE_DATA||w_sep||COMUNE||w_sep||DATA||w_sep||
                     AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
                     FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||
                     NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
                     UFFICIALE_PROV||w_sep||PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||
                     DATA_PROTOCOLLO_PROV||w_sep||
                     ENTE_STRANIERO||w_sep||COMUNE_ENTE_STRANIERO||w_sep||STATO_ENTE_STRANIERO||w_sep||
                     DATA_ATTO_ENTE_STRANIERO||w_sep||
                     TIPO_ATTO_ENTE_STRANIERO||w_sep||ESTREMI_ATTO_ENTE_STRANIERO||w_sep||
                     W_TERMINALISTA,TERMINALISTA_ATTO
                    into riga_dati,w_terminalista_atto
                    from CERCUC
                 where nvl(serie,' ')     = nvl(a_serie,' ')
                     and nvl(parte,0)         = nvl(a_parte,0)
                     and atto                         = a_atto
                     and anno                         = a_anno
                     and ufficio                     = a_ufficio
                     and rownum                     = 1 
                     and w_messaggio            is null
                        ;
          exception
              when no_data_found then
                riga_dati :=  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep;
                w_terminalista_atto := '';
            when others then
              riga_dati :=  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                       w_sep||w_sep||w_sep;
                w_terminalista_atto := '';
              a_errore := '0-Errore in ricerca dati UCI ('||SQLERRM||')';
          end;
    end if;

  if nvl(a_tipo_atto_nb,0)  != 0 then
     begin
       select nome||' '||cognome
         into w_terminalista_atto
         from cerdte
        where cod_utente = w_terminalista_atto
          and rownum = 1;
     exception
         when no_data_found then
            begin
                select nominativo
                INTO w_terminalista_atto
                from a_utenti
               where utente = w_terminalista_atto
                 and rownum = 1
              ;
            EXCEPTION 
              when others then
                       null;
            end;  
     end;

     if w_terminalista is not null then
        w_firma_omessa := f_get_firma_omessa('SCSW','CIV_FIRMA');
     else 
        w_firma_omessa := '';
     end if;

     if w_terminalista_atto is not null then
        w_firma_omessa_term_atto := f_get_firma_omessa('SCSW','CIV_FIRMA');
     else 
        w_firma_omessa_term_atto := '';
     end if;
    
     riga_dati := riga_dati||w_sep||w_firma_omessa||w_sep||w_terminalista_atto||w_sep||w_firma_omessa_term_atto||w_sep||null;
  end if;

--  while conta_copie < nvl(rec_dati.numero_copie,1) loop               
 --   valori := riga_dati;                                          
 --   conta_copie := conta_copie + 1;
--  end loop;
--  conta_copie:= 0;

  riga_dati := 'DEP'||w_sep||
               riga_dati||w_sep||
               f_SER_riga_dati(w_sep,'CIV')||w_sep||
               f_SER_riga_dati(w_sep,'COM')||w_sep||
               f_SER_riga_dati(w_sep,'URP');                                          

  a_riga_Dati := riga_dati;
  a_return := 1;  
--end loop;
END;
/
