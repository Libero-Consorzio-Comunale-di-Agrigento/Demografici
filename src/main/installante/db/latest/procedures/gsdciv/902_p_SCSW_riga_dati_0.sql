--liquibase formatted sql
--changeset amonopoli:202301301255 runOnChange:true stripComments:false
create or replace procedure p_SCSW_riga_dati_0
(a_tipo_atto      IN            number
,a_ufficio        IN            number
,a_anno           IN            number
,a_atto           IN            number
,a_parte          IN            number
,a_serie          IN            varchar2
,a_formula        IN            varchar2
,a_data_reg       IN            number
,a_w_tipo_atto    IN            number
,a_terminalista   IN            varchar2
,a_comune_data    IN            varchar2
,a_comune         IN            varchar2
,a_data           IN            varchar2
,a_separatore	  IN	 	varchar2
,w_riga_dati      IN OUT        varchar2
,a_sequenza       IN            number
)

IS

w_sep					varchar2(255) := nvl(a_separatore,chr(9));

w_messaggio				varchar2(2000);
riga_dati1 				varchar2(4000);
riga_dati2 				varchar2(4000);
riga_dati3				varchar2(4000);
riga_dati5 				varchar2(4000);
residenza				varchar2(255);
cap_residenza				varchar2(10);
residenza_sposa				varchar2(255);
cap_residenza_sposa			varchar2(10);
w_comune_nascita			varchar2(4000);
w_cap_comune_nascita			varchar2(255);
w_des_tipo_atto				varchar2(255);
w_anno_atto				number;
vuoto					varchar2(3) := 'N';
w_comune_data				varchar2(4000);
w_comune 				varchar2(4000);
w_data					varchar2(4000);
testo_annotazione			varchar2(6000);
cap_comune_utente			varchar2(2000);
comune_utente				varchar2(2000);
solo_comune_utente			varchar2(2000);
tribunale_utente			varchar2(2000);
dep_invio_trib_riga1			varchar2(2000);
dep_invio_trib_riga2 			varchar2(2000);
dep_invio_procura_riga1                 varchar2(2000);
dep_invio_procura_riga2                 varchar2(2000);
dep_invio_comune_tras   		varchar2(1000);
al_tribunale_riga1                      varchar2(2000);
al_tribunale_riga2                      varchar2(2000);
al_procuratore_riga1                    varchar2(2000);
al_procuratore_riga2                    varchar2(2000);
al_prefetto_riga1                       varchar2(2000);
al_prefetto_riga2                       varchar2(2000);
al_comune_riga1                         varchar2(2000);
al_comune_riga2                         varchar2(2000);
comune_trascrizione_1_riga1             varchar2(2000);
comune_trascrizione_1_riga2             varchar2(2000);
comune_trascrizione_2_riga1             varchar2(2000);
comune_trascrizione_2_riga2             varchar2(2000);
blocco_trascrizione_1_riga1             varchar2(2000);
blocco_trascrizione_1_riga2             varchar2(2000);
blocco_trascrizione_2_riga1             varchar2(2000);
blocco_trascrizione_2_riga2             varchar2(2000);
invio_trib_competente_riga1         	varchar2(2000);
invio_trib_competente_riga2         	varchar2(2000);
invio_procura_competente_riga1       	varchar2(2000);
invio_procura_competente_riga2    	varchar2(2000);
invio_comune_trascrizione         	varchar2(1000);

w_flag_comune_estero_res                varchar2(1);
w_flag_comune_estero_res_f              varchar2(1);

comune_atto_matrimonio                  varchar2(255);
cap_comune_atto_matrimonio              varchar2(255);

w_estremi_atto_rif                      varchar2(255);

w_terminalista                          varchar2(100);
w_terminalista_atto			varchar2(100);
w_firma_omessa                          varchar2(255);
w_firma_omessa_term_atto                varchar2(255);

w_id_civann				number;

BEGIN
  w_terminalista := a_terminalista;
  w_comune_data  := a_comune_data;
  w_comune       := a_comune;
  w_data         := a_data;

  if a_tipo_atto in (1,6) then
     w_messaggio := f_ctr_word_civ(a_tipo_atto,a_ufficio,a_anno,a_atto,a_parte,a_serie,a_formula,'');

     begin
       select
-- riga_dati1
              decode(a_tipo_atto,6,
                decode(numero_atto_ansc_nascita,'', nvl(ufficio_nascita,'_____')),
                decode(numero_atto_ansc, '', UFFICIO))||w_sep||
              decode(a_tipo_atto,6,
                decode(numero_atto_ansc_nascita, '', nvl(anno_atto_nascita,'_____')),
                decode(numero_atto_ansc, '', TO_CHAR(ANNO)))||w_sep||
              decode(a_tipo_atto,6,
                decode(numero_atto_ansc_nascita, '', nvl(to_char(atto_nascita),'_____')),
                decode(numero_atto_ansc, '', TO_CHAR(ATTO), numero_atto_ansc))||w_sep||
              decode(a_tipo_atto,6,
                decode(numero_atto_ansc_nascita, '', nvl(parte_nascita,'_____')),
                decode(numero_atto_ansc, '', PARTE))||w_sep||
              decode(a_tipo_atto,6,
                decode(numero_atto_ansc_nascita, '', nvl(serie_nascita,'_____')),
                decode(numero_atto_ansc, '', SERIE))||w_sep||
              decode(a_tipo_atto,6,
                nvl(numero_atto_ansc_nascita,'______________________________'),
                NUMERO_ATTO_ANSC)||w_sep||
              decode(a_tipo_atto,6,'NASCITA','CITTADINANZA'),
-- riga_dati3
              COGNOME_NOME||w_sep||'nato/a il '||DATA_NASCITA||' a '||COMUNE_NASCITA||w_sep||
              'nato/a'||w_sep||DATA_NASCITA||w_sep||COMUNE_NASCITA||w_sep||CAP_COMUNE_NASCITA||w_sep||
              'residente a '||RESIDENZA||w_sep||RESIDENZA||w_sep||CAP_RESIDENZA||w_sep||
              NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||
              NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL,
-- riga_dati5
              AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
              FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||w_sep||UFFICIALE_PROV||w_sep||
              NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
              PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||
              DATA_PROTOCOLLO_PROV||w_sep||COMUNE_DATA||w_sep||
              DECODE(a_tipo_atto,6,nvl(COMUNE_ATTO_NASCITA, COMUNE_NASCITA),COMUNE)||w_sep||DATA,
-- residenza
              decode(a_tipo_atto,6,rpad('_',20,'_'),RESIDENZA),
-- cap_residenza
              decode(a_tipo_atto,6,'_____',lpad(CAP_RESIDENZA,5,'0')),
-- w_comune_nascita
              nvl(COMUNE_ATTO_NASCITA, COMUNE_NASCITA),
-- w_cap_comune_nascita
              decode(comune_atto_nascita,'',CAP_COMUNE_NASCITA,cap_comune_atto_nascita),
-- w_des_tipo_atto
              decode(a_tipo_atto,6,'nascita','cittadinanza'),
-- w_terminalista_atto
              terminalista_atto,
-- w_anno_atto
              to_number(null),
-- w_flag_comune_estero_res
              flag_comune_estero_res
         into riga_dati1, riga_dati3, riga_dati5,
              residenza, cap_residenza, w_comune_nascita, w_cap_comune_nascita,
              w_des_tipo_atto, w_terminalista_atto, w_anno_atto,
              w_flag_comune_estero_res
         from CERCCI
        where nvl(serie,' ')     = nvl(a_serie,' ')
          and nvl(parte,0)         = nvl(a_parte,0)
          and atto                         = a_atto
          and anno                         = a_anno
          and ufficio                 = a_ufficio
          and rownum                     = 1
          and w_messaggio          is null
       ;
     exception
       when no_data_found then
--alert_message_note('cit - no_data_found');
            riga_dati1 := a_UFFICIO||w_sep||a_ANNO||w_sep||a_ATTO||w_sep||a_PARTE||w_sep||a_SERIE||w_sep||w_sep||'CITTADINANZA';
            riga_dati3 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
            riga_dati5 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_comune_data||w_sep||w_comune||w_sep||w_data;
            residenza := ' ';
            cap_residenza := ' ';
            w_comune_nascita := ' ';
            w_cap_comune_nascita := ' ';
            w_terminalista_atto := '';
            vuoto:= 'S';
            w_flag_comune_estero_res := '';
     end;

  elsif a_tipo_atto in(2,7,8,-7) then
     w_messaggio :=  f_ctr_word_civ(a_tipo_atto,a_ufficio,a_anno,a_atto,a_parte,a_serie,a_formula,'');

     begin
       select
-- riga_dati1
              decode(numero_atto_ansc, '', UFFICIO)||w_sep||
              decode(numero_atto_ansc, '', ANNO)||w_sep||
              decode(numero_atto_ansc, '', to_char(ATTO), numero_atto_ansc)||w_sep||
              decode(numero_atto_ansc, '', PARTE)||w_sep||
              decode(numero_atto_ansc, '', SERIE)||w_sep||
              NUMERO_ATTO_ANSC||w_sep||
              'NASCITA',
-- riga_dati3
              COGNOME_NOME||w_sep||
              decode(SESSO,'M','nato il ','nata il ')||DATA_NASCITA||' a '||COMUNE_NASCITA||w_sep||
              decode(SESSO,'M','nato il ','nata il ')||w_sep||
              DATA_NASCITA||w_sep||COMUNE_NASCITA||w_sep||CAP_COMUNE_NASCITA||w_sep||
              'residente a '||RESIDENZA||w_sep||RESIDENZA||w_sep||CAP_RESIDENZA||w_sep||
              NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||
              NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL,
-- riga_dati5
              AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
              FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||UFFICIALE_PROV||w_sep||
              NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
              PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV||w_sep||
              COMUNE_DATA||w_sep||COMUNE||w_sep||DATA,
-- residenza
              nvl(RESIDENZA,rpad('_',20,'_')),
-- cap_residenza
              nvl(lpad(CAP_RESIDENZA,5,'0'),'_____'),
-- w_comune_nascita
              COMUNE_NASCITA,
-- w_cap_comune_nascita
              CAP_COMUNE_NASCITA,
-- w_des_tipo_atto
              'nascita',
-- w_terminalista_atto
              terminalista_atto,
-- w_anno_atto
              to_number(null),
-- w_flag_comune_estero_res
              flag_comune_estero_res
         into riga_dati1, riga_dati3, riga_dati5,
              residenza, cap_residenza, w_comune_nascita, w_cap_comune_nascita,
              w_des_tipo_atto, w_terminalista_atto, w_anno_atto,
              w_flag_comune_estero_res
         from CERCNA
        where nvl(serie,' ')         = nvl(a_serie,' ')
          and nvl(parte,0)             = nvl(a_parte,0)
          and atto                             = a_atto
          and anno                             = a_anno
          and ufficio                         = a_ufficio
          and a_tipo_atto        = 2
          and rownum                       = 1
          and w_messaggio                is null
       UNION
       select
-- riga_dati1
              decode(numero_atto_ansc_nas, '', UFFICIO_NAS)||w_sep||
              decode(numero_atto_ansc_nas, '', ANNO_NAS)||w_sep||
              decode(numero_atto_ansc_nas, '', to_char(ATTO_NAS), numero_atto_ansc_nas)||w_sep||
              decode(numero_atto_ansc_nas, '', PARTE_NAS)||w_sep||
              decode(numero_atto_ansc_nas, '', SERIE_NAS)||w_sep||
              NUMERO_ATTO_ANSC_NAS||w_sep||
              'NASCITA',
-- riga_dati3
              COGNOME_NOME||w_sep||
              decode(SESSO,'M','nato il ','nata il ')||DATA_NASCITA||' a '||COMUNE_NASCITA||w_sep||
              decode(SESSO,'M','nato il ','nata il ')||w_sep||
              DATA_NASCITA||w_sep||COMUNE_NASCITA||w_sep||CAP_COMUNE_NASCITA||w_sep||
              'residente a '||RESIDENZA||w_sep||RESIDENZA||w_sep||CAP_RESIDENZA||w_sep||
              NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||
              NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL,
-- riga_dati5
              AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
              FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||UFFICIALE_PROV||w_sep||
              NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
              PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV||w_sep||
              COMUNE_DATA||w_sep||NVL(COMUNE_REGISTRO,COMUNE_NASCITA)||w_sep||DATA,
-- residenza
              rpad('_',20,'_'),
-- cap_residenza
              '_____',
-- w_comune_nascita
              NVL(COMUNE_ATTO_NASCITA,COMUNE_NASCITA),
-- w_cap_comune_nascita
              decode(COMUNE_ATTO_NASCITA,'',CAP_COMUNE_NASCITA,CAP_COMUNE_ATTO_NASCITA),
-- w_des_tipo_atto
              'nascita',
-- w_terminalista_atto
              terminalista_atto,
-- w_anno_atto
              decode(translate(anno_nas,'0123456789','9999999999'),
                '9999',to_number(anno_nas), to_number(null)),
-- w_flag_comune_estero_res
              to_char(null)
          from CERCMO
         where nvl(serie,' ')             = nvl(a_serie,' ')
           and nvl(parte,0)                 = nvl(a_parte,0)
           and atto                                 = a_atto
           and anno                                 = a_anno
           and ufficio                             = a_ufficio
           and a_tipo_atto             = 8
           and rownum                             = 1
           and w_messaggio                  is null
        UNION
        select
-- riga_dati1
               null||w_sep||
               decode(substr(a_formula,1,1),
                 '1', decode(NUMERO_ATTO_ANSC_NASCITA_SPOSO, '', ANNO_ATTO_NASCITA_SPOSO),
                 '5', decode(NUMERO_ATTO_ANSC_NASCITA_SPOSA, '', ANNO_ATTO_NASCITA_SPOSA),
                      '____')||w_sep||
               decode(substr(a_formula,1,1),
                 '1', decode(NUMERO_ATTO_ANSC_NASCITA_SPOSO, '', ATTO_NASCITA_SPOSO, NUMERO_ATTO_ANSC_NASCITA_SPOSO),
                 '5', decode(NUMERO_ATTO_ANSC_NASCITA_SPOSA, '', ATTO_NASCITA_SPOSA, NUMERO_ATTO_ANSC_NASCITA_SPOSA),
                      '_____')||w_sep||
               decode(substr(a_formula,1,1),
                 '1', decode(NUMERO_ATTO_ANSC_NASCITA_SPOSO, '', PARTE_NASCITA_SPOSO),
                 '5', decode(NUMERO_ATTO_ANSC_NASCITA_SPOSA, '', PARTE_NASCITA_SPOSA),
                      '_____')||w_sep||
               decode(substr(a_formula,1,1),
                 '1', decode(NUMERO_ATTO_ANSC_NASCITA_SPOSO, '', SERIE_NASCITA_SPOSO),
                 '5', decode(NUMERO_ATTO_ANSC_NASCITA_SPOSA, '', SERIE_NASCITA_SPOSA),
                      '__')||w_sep||
               decode(substr(a_formula,1,1),
                 '1', NUMERO_ATTO_ANSC_NASCITA_SPOSO,
                 '5', NUMERO_ATTO_ANSC_NASCITA_SPOSA,
                      '______________________________')||w_sep||
               'NASCITA',
-- riga_dati3
               decode(substr(a_formula,1,1), '1',COGNOME_NOME_SPOSO, '5',COGNOME_NOME_SPOSA, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1','nato il ', '5','nata il ', 'nato/a il ')||
               decode(substr(a_formula,1,1), '1',DATA_NASCITA_SPOSO, '5',DATA_NASCITA_SPOSA, '__________')||
                 ' a '||decode(substr(a_formula,1,1), '1',COMUNE_NASCITA_SPOSO, '5',COMUNE_NASCITA_SPOSA, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1','nato il', '5','nata il ', 'nato/a il ')||w_sep||
               decode(substr(a_formula,1,1), '1',DATA_NASCITA_SPOSO, '5',DATA_NASCITA_SPOSA, '__________')||w_sep||
               decode(substr(a_formula,1,1), '1',COMUNE_NASCITA_SPOSO, '5',COMUNE_NASCITA_SPOSA, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1',CAP_COMUNE_NASCITA_SPOSO, '5',CAP_COMUNE_NASCITA_SPOSA, '_____')||w_sep||
               'residente a '||decode(substr(a_formula,1,1), '1',RESIDENZA_SPOSO, '5',RESIDENZA_SPOSA, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1',RESIDENZA_SPOSO, '5',RESIDENZA_SPOSA, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1',CAP_RESIDENZA_SPOSO, '5',CAP_RESIDENZA_SPOSA, '_____')||w_sep||
               decode(substr(a_formula,1,3),'532','E','538','E','132','E','138','E','')||w_sep||
               decode(substr(a_formula,1,3),
                 '532',COGNOME_NOME_SPOSO,
                 '538',COGNOME_NOME_SPOSO,
                 '132',COGNOME_NOME_SPOSA,
                 '138',COGNOME_NOME_SPOSA,'')||w_sep||
               decode(substr(a_formula,1,3),'532','nato il ','538','nato il ','132','138','nata il ','')||
                 decode(substr(a_formula,1,3),
                   '532',DATA_NASCITA_SPOSO,
                   '538',DATA_NASCITA_SPOSO,
                   '132',DATA_NASCITA_SPOSA,
                   '138',DATA_NASCITA_SPOSA,'')||
                 decode(substr(a_formula,1,3),'532',' a ','538',' a ','132',' a ','138',' a ','')||
                   decode(substr(a_formula,1,3),
                     '532',COMUNE_NASCITA_SPOSO,
                     '538',COMUNE_NASCITA_SPOSO,
                     '132',COMUNE_NASCITA_SPOSA,
                     '138',COMUNE_NASCITA_SPOSA,'')||w_sep||
               decode(substr(a_formula,1,3),'532','nato il ','538','nato il ','132','nata il ','138','nata il ','')||w_sep||
               decode(substr(a_formula,1,3),
                 '532',DATA_NASCITA_SPOSO,
                 '538',DATA_NASCITA_SPOSO,
                 '132',DATA_NASCITA_SPOSA,
                 '138',DATA_NASCITA_SPOSA,'')||w_sep||
               decode(substr(a_formula,1,3),
                 '532',COMUNE_NASCITA_SPOSO,
                 '538',COMUNE_NASCITA_SPOSO,
                 '132',COMUNE_NASCITA_SPOSA,
                 '138',COMUNE_NASCITA_SPOSA,'')||w_sep||
               decode(substr(a_formula,1,3),
                 '532',CAP_COMUNE_NASCITA_SPOSO,
                 '538',CAP_COMUNE_NASCITA_SPOSO,
                 '132',CAP_COMUNE_NASCITA_SPOSA,
                 '138',CAP_COMUNE_NASCITA_SPOSA,'')||w_sep||
               decode(substr(a_formula,1,3),'532','residente a ','538','residente a ','132','residente a ','138','residente a ','')||
                 decode(substr(a_formula,1,3),
                   '532',RESIDENZA_SPOSO,
                   '538',RESIDENZA_SPOSO,
                   '132',RESIDENZA_SPOSA,
                   '138',RESIDENZA_SPOSA,'')||w_sep||
               decode(substr(a_formula,1,3),
                 '532',RESIDENZA_SPOSO,
                 '538',RESIDENZA_SPOSO,
                 '132',RESIDENZA_SPOSA,
                 '138',RESIDENZA_SPOSA,'')||w_sep||
               decode(substr(a_formula,1,3),
                 '532',CAP_RESIDENZA_SPOSO,
                 '538',CAP_RESIDENZA_SPOSO,
                 '132',CAP_RESIDENZA_SPOSA,
                 '138',CAP_RESIDENZA_SPOSA,'')||w_sep||
               'Matrimonio celebrato in '||nvl(COMUNE_MATRIMONIO,'_______________________')||
                 ' il '||nvl(DATA_MATRIMONIO,'___________'),
-- riga_dati5
               AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
               FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||UFFICIALE_PROV||w_sep||
               NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
               PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV||w_sep||
               COMUNE_DATA||w_sep||
               decode(substr(a_formula,1,1),
                 '1', nvl(COMUNE_ATTO_NASCITA_SPOSO,COMUNE_NASCITA_SPOSO),
                 '5', nvl(COMUNE_ATTO_NASCITA_SPOSA,COMUNE_NASCITA_SPOSA),
                      rpad('_',30,'_'))||w_sep||
               DATA,
-- comune_residenza
               rpad('_',20,'_'),
-- cap_comune_residenza
               '_____',
-- w_comune_nascita
               decode(substr(a_formula,1,1),
                 '1', nvl(COMUNE_ATTO_NASCITA_SPOSO,COMUNE_NASCITA_SPOSO),
                 '5', nvl(COMUNE_ATTO_NASCITA_SPOSA,COMUNE_NASCITA_SPOSA),
                      rpad('_',30,'_')),
-- w_cap_comune_nascita
               decode(substr(a_formula,1,1),
                 '1', decode(comune_atto_nascita_sposo,'',CAP_COMUNE_NASCITA_SPOSO,CAP_COMUNE_ATTO_NASCITA_SPOSO),
                 '5', decode(comune_atto_nascita_sposa,'',CAP_COMUNE_NASCITA_SPOSA,CAP_COMUNE_ATTO_NASCITA_SPOSA),
                      '_____'),
-- w_des_tipo_atto
               'nascita',
-- w_terminalista_atto
               terminalista_atto,
-- w_anno_atto
               decode(substr(a_formula,1,1),
                 '1',decode(translate(ANNO_ATTO_NASCITA_SPOSO,'0123456789','9999999999'),'9999',to_number(ANNO_ATTO_NASCITA_SPOSO),to_number(null)),
                 '5',decode(translate(ANNO_ATTO_NASCITA_SPOSA,'0123456789','9999999999'),'9999',to_number(ANNO_ATTO_NASCITA_SPOSA),to_number(null)),
                     to_number(null)),
-- w_flag_comune_estero_res
               to_char(null)
          from CERCMA
         where nvl(serie,' ')         = nvl(a_serie,' ')
           and nvl(parte,0)             = nvl(a_parte,0)
           and atto                             = a_atto
           and anno                             = a_anno
           and ufficio                       = a_ufficio
           and a_tipo_atto        = 7
           and rownum                         = 1
           and w_messaggio                is null
        UNION
        select
-- riga_dati1
               null||w_sep||
               decode(substr(a_formula,1,1),
                 '1', decode(NUMERO_ATTO_ANSC_NASCITA_1, '', ANNO_ATTO_NASCITA_1),
                 '5', decode(NUMERO_ATTO_ANSC_NASCITA_2, '', ANNO_ATTO_NASCITA_2),
                      '____')||w_sep||
               decode(substr(a_formula,1,1),
                 '1', decode(NUMERO_ATTO_ANSC_NASCITA_1, '', ATTO_NASCITA_1, NUMERO_ATTO_ANSC_NASCITA_1),
                 '5', decode(NUMERO_ATTO_ANSC_NASCITA_2, '', ATTO_NASCITA_2, NUMERO_ATTO_ANSC_NASCITA_2),
                      '_____')||w_sep||
               decode(substr(a_formula,1,1),
                 '1', decode(NUMERO_ATTO_ANSC_NASCITA_1, '', PARTE_NASCITA_1),
                 '5', decode(NUMERO_ATTO_ANSC_NASCITA_2, '', PARTE_NASCITA_2),
                      '_____')||w_sep||
               decode(substr(a_formula,1,1),
                 '1', decode(NUMERO_ATTO_ANSC_NASCITA_1, '', SERIE_NASCITA_1),
                 '5', decode(NUMERO_ATTO_ANSC_NASCITA_2, '', SERIE_NASCITA_2),
                      '__')||w_sep||
               decode(substr(a_formula,1,1),
                 '1', NUMERO_ATTO_ANSC_NASCITA_1,
                 '5', NUMERO_ATTO_ANSC_NASCITA_2,
                      '______________________________')||w_sep||
               'NASCITA',
-- riga_dati3
               decode(substr(a_formula,1,1), '1',COGNOME_NOME_1, '5',COGNOME_NOME_2, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1',NAT_OA_IL_1||' ',    '5',NAT_OA_IL_2||' ',    'nato/a il ')||
                 decode(substr(a_formula,1,1), '1',DATA_NASCITA_1, '5',DATA_NASCITA_2, '__________')||
                 ' a '||decode(substr(a_formula,1,1), '1',COMUNE_NASCITA_1, '5',COMUNE_NASCITA_2, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1',NAT_OA_IL_1,    '5',NAT_OA_IL_2, 'nato/a il ')||w_sep||
               decode(substr(a_formula,1,1), '1',DATA_NASCITA_1, '5',DATA_NASCITA_2, '__________')||w_sep||
               decode(substr(a_formula,1,1), '1',COMUNE_NASCITA_1, '5',COMUNE_NASCITA_2, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1',CAP_COMUNE_NASCITA_1, '5',CAP_COMUNE_NASCITA_2, '_____')||w_sep||
               'residente a '||decode(substr(a_formula,1,1), '1',RESIDENZA_1, '5',RESIDENZA_2, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1',RESIDENZA_1, '5',RESIDENZA_2, rpad('_',30,'_'))||w_sep||
               decode(substr(a_formula,1,1), '1',CAP_RESIDENZA_1, '5',CAP_RESIDENZA_2, '_____')||w_sep||
               'E'||w_sep||
               decode(substr(a_formula,1,1), '1',COGNOME_NOME_2, '5',COGNOME_NOME_1,'')||w_sep||
               decode(substr(a_formula,1,1), '1',NAT_OA_IL_2,    '5',NAT_OA_IL_1,'')||
                 decode(substr(a_formula,1,1), '1',DATA_NASCITA_2, '5',DATA_NASCITA_1,'')||
                 ' a '||
                 decode(substr(a_formula,1,1), '1',COMUNE_NASCITA_2, '5',COMUNE_NASCITA_1,'')||w_sep||
               decode(substr(a_formula,1,1), '1',NAT_OA_IL_2, '5',NAT_OA_IL_1,'')||w_sep||
               decode(substr(a_formula,1,1), '1',DATA_NASCITA_2, '5',DATA_NASCITA_1,'')||w_sep||
               decode(substr(a_formula,1,1), '1',COMUNE_NASCITA_2, '5',COMUNE_NASCITA_1,'')||w_sep||
               decode(substr(a_formula,1,1), '1',CAP_COMUNE_NASCITA_2, '5',CAP_COMUNE_NASCITA_1,'')||w_sep||
               'residente a '||decode(substr(a_formula,1,1), '1',RESIDENZA_2, '5',RESIDENZA_1,'')||w_sep||
               decode(substr(a_formula,1,1), '1',RESIDENZA_2, '5',RESIDENZA_1,'')||w_sep||
               decode(substr(a_formula,1,1), '1',CAP_RESIDENZA_2, '5',CAP_RESIDENZA_1,'')||w_sep||
               'Unione Civile costituita in '||nvl(COMUNE_UNIONE,'_______________________')||
                 ' il '||nvl(DATA_UNIONE,'___________'),
-- riga_dati5
               AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
               FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||UFFICIALE_PROV||w_sep||
               NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
               PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV||w_sep||
               COMUNE_DATA||w_sep||
               decode(substr(a_formula,1,1),
                 '1', nvl(COMUNE_ATTO_NASCITA_1,COMUNE_NASCITA_1),
                 '5', nvl(COMUNE_ATTO_NASCITA_2,COMUNE_NASCITA_2),
                      rpad('_',30,'_'))||w_sep||
               DATA,
-- comune_residenza
               rpad('_',20,'_'),
-- cap_comune_residenza
               '_____',
-- w_comune_nascita
               decode(substr(a_formula,1,1),
                 '1', nvl(COMUNE_ATTO_NASCITA_1,COMUNE_NASCITA_1),
                 '5', nvl(COMUNE_ATTO_NASCITA_2,COMUNE_NASCITA_2),
                      rpad('_',30,'_')),
-- w_cap_comune_nascita
               decode(substr(a_formula,1,1),
                 '1', decode(comune_atto_nascita_1, '', CAP_COMUNE_NASCITA_1, cap_comune_atto_nascita_1),
                 '5', decode(comune_atto_nascita_2, '', CAP_COMUNE_NASCITA_2, cap_comune_atto_nascita_2),
                      '_____'),
-- w_des_tipo_atto
               'nascita',
-- w_terminalista_atto
               terminalista_atto,
-- w_anno_atto
               decode(substr(a_formula,1,1),
                 '1',decode(translate(ANNO_ATTO_NASCITA_1,'0123456789','9999999999'),'9999',to_number(ANNO_ATTO_NASCITA_1),to_number(null)),
                 '5',decode(translate(ANNO_ATTO_NASCITA_2,'0123456789','9999999999'),'9999',to_number(ANNO_ATTO_NASCITA_2),to_number(null)),
                     to_number(null)),
-- w_flag_comune_estero_res
               to_char(null)
          from CERCUC
         where nvl(serie,' ')         = nvl(a_serie,' ')
           and nvl(parte,0)             = nvl(a_parte,0)
           and atto                             = a_atto
           and anno                             = a_anno
           and ufficio                       = a_ufficio
           and a_tipo_atto        = -7
           and rownum                         = 1
           and w_messaggio                is null
        ;
      exception
        when no_data_found then
--alert_message_note('nas - no_data_found');
             riga_dati1 := a_UFFICIO||w_sep||a_ANNO||w_sep||a_ATTO||w_sep||a_PARTE||w_sep||a_SERIE||w_sep||w_sep||'NASCITA';
             riga_dati3 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
             riga_dati5 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_comune_data||w_sep||w_comune||w_sep||w_data;
             residenza  := ' ';
             cap_residenza  := ' ';
             w_comune_nascita := ' ';
             w_cap_comune_nascita := ' ';
             w_terminalista_atto := '';
             vuoto:= 'S';
             w_flag_comune_estero_res := '';
      end;

  elsif a_tipo_atto in (4,9,-4,-9) then
      w_messaggio :=  f_ctr_word_civ(a_tipo_atto,a_ufficio,a_anno,a_atto,a_parte,a_serie,a_formula,'');

      begin
        select
-- riga_dati1
               decode(a_tipo_atto,9,
                 decode(NUMERO_ATTO_ANSC_MATRIMONIO, '', nvl(TO_CHAR(UFFICIO_MATRIMONIO),'_____')),
                 decode(NUMERO_ATTO_ANSC, '', TO_CHAR(UFFICIO)))||w_sep||
               decode(a_tipo_atto,9,
                 decode(NUMERO_ATTO_ANSC_MATRIMONIO, '', nvl(TO_CHAR(ANNO_ATTO_MATRIMONIO),'_____')),
                 decode(NUMERO_ATTO_ANSC, '', TO_CHAR(ANNO)))||w_sep||
               decode(a_tipo_atto,9,
                 decode(NUMERO_ATTO_ANSC_MATRIMONIO, '', nvl(TO_CHAR(ATTO_MATRIMONIO),'_____')),
                 decode(NUMERO_ATTO_ANSC, '', TO_CHAR(ATTO), NUMERO_ATTO_ANSC))||w_sep||
               decode(a_tipo_atto,9,
                 decode(NUMERO_ATTO_ANSC_MATRIMONIO, '', nvl(PARTE_MATRIMONIO,'_____')),
                 decode(NUMERO_ATTO_ANSC, '', TO_CHAR(PARTE)))||w_sep||
               decode(a_tipo_atto,9,
                 decode(NUMERO_ATTO_ANSC_MATRIMONIO, '', nvl(SERIE_MATRIMONIO,'_____')),
                 decode(NUMERO_ATTO_ANSC, '', SERIE))||w_sep||
               decode(a_tipo_atto,9,
                 nvl(NUMERO_ATTO_ANSC_MATRIMONIO,'______________________________'),
                 NUMERO_ATTO_ANSC)||w_sep||
               'MATRIMONIO',
-- riga_dati3
               COGNOME_NOME_SPOSO||w_sep||
               NATO_IL||' '||DATA_NASCITA_SPOSO||' a '||COMUNE_NASCITA_SPOSO||w_sep||
               'nato'||w_sep||DATA_NASCITA_SPOSO||w_sep||COMUNE_NASCITA_SPOSO||w_sep||CAP_COMUNE_NASCITA_SPOSO||w_sep||
               'residente a '||RESIDENZA_SPOSO||w_sep||RESIDENZA_SPOSO||w_sep||CAP_RESIDENZA_SPOSO||w_sep||
               'E'||w_sep||
               COGNOME_NOME_SPOSA||w_sep||
               NATA_IL||' '||DATA_NASCITA_SPOSA||' a '||COMUNE_NASCITA_SPOSA||w_sep||
               'nata'||w_sep||DATA_NASCITA_SPOSA||w_sep||COMUNE_NASCITA_SPOSA||w_sep||CAP_COMUNE_NASCITA_SPOSA||w_sep||
               'residente a '||RESIDENZA_SPOSA||w_sep||RESIDENZA_SPOSA||w_sep||CAP_RESIDENZA_SPOSA||w_sep||
               'Matrimonio celebrato in '||nvl(nvl(COMUNE_ATTO_MATRIMONIO,COMUNE_MATRIMONIO),'_______________________')||' il '||nvl(DATA_MATRIMONIO,'___________'),
-- riga_dati5
               AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
               FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||UFFICIALE_PROV||w_sep||
               NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
               PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV||w_sep||
               COMUNE_DATA||w_sep||nvl(COMUNE_ATTO_MATRIMONIO,COMUNE)||w_sep||DATA,
-- residenza
               decode(a_tipo_atto,9,rpad('_',20,'_'),nvl(RESIDENZA_SPOSO,rpad('_',20,'_'))),
-- residenza_sposa
               decode(a_tipo_atto,9,rpad('_',20,'_'),nvl(RESIDENZA_SPOSA,rpad('_',20,'_'))),
-- cap_residenza
               decode(a_tipo_atto,9,'_____',lpad(CAP_RESIDENZA_SPOSO,5,'0')),
-- cap_residenza_sposa
               decode(a_tipo_atto,9,'_____',lpad(CAP_RESIDENZA_SPOSA,5,'0')),
-- w_des_tipo_atto
               'matrimonio',
-- w_terminalista_atto
               terminalista_atto,
-- w_anno_atto
               to_number(null),
-- w_flag_comune_estero_res
               flag_comune_estero_res_m,
-- w_flag_comune_estero_res_f
               flag_comune_estero_res_f,
-- comune_atto_matrimonio
               decode(a_tipo_atto,9,comune_atto_matrimonio),
-- cap_comune_atto_matrimonio
               decode(a_tipo_atto,9,cap_comune_atto_matrimonio)
          into riga_dati1, riga_dati3, riga_dati5,
               residenza, residenza_sposa, cap_residenza, cap_residenza_sposa,
               w_des_tipo_atto,w_terminalista_atto,
               w_anno_atto, w_flag_comune_estero_res, w_flag_comune_estero_res_f,
               comune_atto_matrimonio, cap_comune_atto_matrimonio
          from CERCMA
         where nvl(serie,' ') = nvl(a_serie,' ')
           and nvl(parte,0)     = nvl(a_parte,0)
           and atto                      = a_atto
           and anno                     = a_anno
           and ufficio                 = a_ufficio
           and a_tipo_atto    in (4,9)
           and rownum                 = 1
           and w_messaggio        is null
        UNION
        select
-- riga_dati1
               decode(a_tipo_atto,-9,
                 decode(NUMERO_ATTO_ANSC_UNIONE, '', nvl(TO_CHAR(UFFICIO_UNIONE),'_____')),
                 decode(NUMERO_ATTO_ANSC, '', TO_CHAR(UFFICIO)))||w_sep||
               decode(a_tipo_atto,-9,
                 decode(NUMERO_ATTO_ANSC_UNIONE, '', nvl(TO_CHAR(ANNO_ATTO_UNIONE),'_____')),
                 decode(NUMERO_ATTO_ANSC, '', TO_CHAR(ANNO)))||w_sep||
               decode(a_tipo_atto,-9,
                 decode(NUMERO_ATTO_ANSC_UNIONE, '', nvl(TO_CHAR(ATTO_UNIONE),'_____'), NUMERO_ATTO_ANSC_UNIONE),
                 decode(NUMERO_ATTO_ANSC, '', TO_CHAR(ATTO), NUMERO_ATTO_ANSC))||w_sep||
               decode(a_tipo_atto,-9,
                 decode(NUMERO_ATTO_ANSC_UNIONE, '', nvl(PARTE_UNIONE,'_____')),
                 decode(NUMERO_ATTO_ANSC, '', TO_CHAR(PARTE)))||w_sep||
               decode(a_tipo_atto,-9,
                 decode(NUMERO_ATTO_ANSC_UNIONE, '', nvl(SERIE_UNIONE,'_____')),
                 decode(NUMERO_ATTO_ANSC, '', SERIE))||w_sep||
               decode(a_tipo_atto,-9,
                 nvl(NUMERO_ATTO_ANSC_UNIONE,'______________________________'),
                 NUMERO_ATTO_ANSC)||w_sep||
               'UNIONE CIVILE',
-- riga_dati3
               COGNOME_NOME_1||w_sep||
               NAT_OA_IL_1||' '||DATA_NASCITA_1||' a '||COMUNE_NASCITA_1||w_sep||
               NAT_OA_IL_1||w_sep||DATA_NASCITA_1||w_sep||COMUNE_NASCITA_1||w_sep||CAP_COMUNE_NASCITA_1||w_sep||
               'residente a '||RESIDENZA_1||w_sep||RESIDENZA_1||w_sep||CAP_RESIDENZA_1||w_sep||
               'E'||w_sep||
               COGNOME_NOME_2||w_sep||
               NAT_OA_IL_2||' '||DATA_NASCITA_2||' a '||COMUNE_NASCITA_2||w_sep||
               NAT_OA_IL_2||w_sep||DATA_NASCITA_2||w_sep||COMUNE_NASCITA_2||w_sep||CAP_COMUNE_NASCITA_2||w_sep||
               'residente a '||RESIDENZA_2||w_sep||RESIDENZA_2||w_sep||CAP_RESIDENZA_2||w_sep||
               'Unione Civile costituita in '||nvl(nvl(COMUNE_ATTO_UNIONE,COMUNE_UNIONE),'_______________________')||' il '||nvl(DATA_UNIONE,'___________'),
-- riga_dati5
               AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
               FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||UFFICIALE_PROV||w_sep||
               NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
               PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV||w_sep||
               COMUNE_DATA||w_sep||nvl(COMUNE_ATTO_UNIONE,COMUNE)||w_sep||DATA,
-- residenza
               decode(a_tipo_atto,-9,rpad('_',20,'_'),nvl(RESIDENZA_1,rpad('_',20,'_'))),
-- residenza_sposa
               decode(a_tipo_atto,-9,rpad('_',20,'_'),nvl(RESIDENZA_2,rpad('_',20,'_'))),
-- cap_residenza
               decode(a_tipo_atto,-9,'_____',lpad(CAP_RESIDENZA_1,5,'0')),
-- cap_residenza_sposa
               decode(a_tipo_atto,-9,'_____',lpad(CAP_RESIDENZA_2,5,'0')),
-- w_des_tipo_atto
               'unione civile',
-- w_terminalista_atto
               terminalista_atto,
-- w_anno_atto
               to_number(null),
-- w_flag_comune_estero_res
               flag_comune_estero_res_m,
-- w_flag_comune_estero_res_f
               flag_comune_estero_res_f,
-- comune_atto_matrimonio
               decode(a_tipo_atto,-9,comune_atto_unione),
-- cap_comune_atto_matrimonio
               decode(a_tipo_atto,-9,cap_comune_atto_unione)
          from CERCUC
         where nvl(serie,' ') = nvl(a_serie,' ')
           and nvl(parte,0)     = nvl(a_parte,0)
           and atto                      = a_atto
           and anno                     = a_anno
           and ufficio                 = a_ufficio
           and a_tipo_atto    in (-4,-9)
           and rownum                 = 1
           and w_messaggio        is null
        ;
      exception
        when no_data_found then
--alert_message_note('mat - no_data_found');
             riga_dati1 := a_UFFICIO||w_sep||a_ANNO||w_sep||a_ATTO||w_sep||a_PARTE||w_sep||a_SERIE||w_sep||w_sep||'UNIONE CIVILE';
             riga_dati3 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
             riga_dati5 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_comune_data||w_sep||w_comune||w_sep||w_data;
             residenza  := ' ';
             residenza_sposa := ' ';
             cap_residenza  := ' ';
             cap_residenza_sposa := ' ';
             w_terminalista_atto := '';
             vuoto:= 'S';
             w_flag_comune_estero_res := '';
             w_flag_comune_estero_res_f := '';
      end;

  elsif a_tipo_atto = 5 then
     w_messaggio := f_ctr_word_civ(a_tipo_atto,a_ufficio,a_anno,a_atto,a_parte,a_serie,a_formula,'');

     begin
       select
-- riga_dati1
              decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
              decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
              decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
              decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
              decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
              NUMERO_ATTO_ANSC||w_sep||
              'MORTE',
-- riga_dati3
              COGNOME_NOME||w_sep||
              NAT_OA_IL||' '||DATA_NASCITA||' a '||COMUNE_NASCITA||w_sep||
              NAT_OA||w_sep||DATA_NASCITA||w_sep||COMUNE_NASCITA||w_sep||CAP_COMUNE_NASCITA||w_sep||
              'residente a '||RESIDENZA||w_sep||RESIDENZA||w_sep||CAP_RESIDENZA||w_sep||
              NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL||w_sep||
              NULL||w_sep||NULL||w_sep||NULL||w_sep||NULL,
-- riga_dati5
              AUTORITA_PROV||w_sep||AUTORITA_PROV_DA||w_sep||AUTORITA_PROV_IN||w_sep||COMUNE_PROV||w_sep||AUTORITA_PROV_COMUNE||w_sep||
              FRAZIONE_PROV||w_sep||AUTORITA_PROV_UFFICIO||w_sep||UFFICIALE_PROV||w_sep||
              NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
              PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV||w_sep||
              COMUNE_DATA||w_sep||COMUNE||w_sep||DATA,
-- comune_residenza
              nvl(RESIDENZA,rpad('_',20,'_')),
-- cap_comune_residenza
              nvl(lpad(CAP_RESIDENZA,5,'0'),'_____'),
-- w_des_tipo_atto
              'morte',
-- w_terminalista_atto
              terminalista_atto,
-- w_anno_atto
              to_number(null),
-- w_flag_comune_estero_res
              flag_comune_estero_res
         into riga_dati1, riga_dati3, riga_dati5, residenza, cap_residenza,
              w_des_tipo_atto, w_terminalista_atto, w_anno_atto, w_flag_comune_estero_res
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
--alert_message_note('mor - no_data_found');
            riga_dati1 := a_UFFICIO||w_sep||a_ANNO||w_sep||a_ATTO||w_sep||a_PARTE||w_sep||a_SERIE||w_sep||w_sep||'MORTE';
            riga_dati3 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
            riga_dati5 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_comune_data||w_sep||w_comune||w_sep||w_data;
            residenza := ' ';
            cap_residenza := ' ';
            w_terminalista_atto := '';
            vuoto:= 'S';
            w_flag_comune_estero_res := '';
     end;
  end if;

          w_messaggio := f_ctr_word_civ(0,a_ufficio,a_anno,a_atto,a_parte,a_serie,a_formula,'');

--alert_message_note('a_formula '||a_formula||' - a_w_tipo_atto '||a_w_tipo_atto);
       begin
         select formula||w_sep||descrizione_1||' '||descrizione_2||' '||descrizione_3
           into riga_dati2
           from civdfa
          where tipo_atto   = a_w_tipo_atto
              and formula     = decode(substr(a_formula,1,1),
                                  '5','1'||substr(a_formula,2),
                                  'X','1'||substr(a_formula,2),
                                       a_formula)
            and w_messaggio is null
           ;
       exception
           when no_data_found then
           riga_dati2:= a_formula||w_sep;
    end;

    begin
      select c.id_civann
        into w_id_civann
        from civcom c
       where tipo_atto       = a_tipo_atto
         and ufficio         = a_ufficio
         and anno            = a_anno
         and atto            = a_atto
         and nvl(parte,0)    = nvl(a_parte,0)
         and nvl(serie,' ')  = nvl(a_serie,' ')
         and formula         = a_formula
         and nvl(data_reg,0) = nvl(a_data_reg,0)
         and nvl(sequenza,0) = nvl(a_sequenza,0)
         and rownum = 1
      ;
    exception
      when others then
           w_id_civann := '';
    end;

    if w_id_civann is not null then
       testo_annotazione := f_CIV_testo_annotazione_x_id (w_id_civann,a_formula);
    else
       testo_annotazione := f_testo_annotazione (a_tipo_atto,a_ufficio,a_anno,a_atto,a_parte,a_serie,a_formula,'E',a_data_reg,a_sequenza,'S');
    end if;

          w_messaggio := f_ctr_word_civ(99,a_ufficio,a_anno,a_atto,a_parte,a_serie,a_formula,testo_annotazione);

      if w_messaggio is not null then
           testo_annotazione := '';
      end if;

      begin
        SELECT e.descrizione,lpad(c.cap,5,'0'),c.descrizione||' ('||c.sigla_provincia||')',
               c.descrizione
          into TRIBUNALE_UTENTE,cap_comune_utente,comune_utente,solo_comune_utente
          from arccom c, arccom e
         where (c.cod_provincia,c.cod_comune) = (select pro_cliente,com_cliente
                                                                  from menuditta)
           and e.cod_comune    (+)    = substr(lpad(c.tribunale,6,0),4,3)
           and e.cod_provincia (+)    = substr(lpad(c.tribunale,6,0),1,3);
      end;

      dep_invio_trib_RIGA1     := 'La S.V. è pregata di inviare copia dell''annotazione formulata:';
--      dep_invio_trib_RIGA2     := '- al Tribunale competente, per l''esecuzione nei registri depositati '||
      dep_invio_trib_RIGA2     := '- all''archivio, per l''esecuzione nei registri depositati presso la Prefettura competente,'||
                                               'ai sensi dell''art.3, comma 1 e 2 del D.M. 27/02/2001.';

      dep_invio_procura_RIGA1  := 'La S.V. è pregata di inviare copia dell''annotazione formulata:';
--      dep_invio_procura_RIGA2  := '- al Procuratore della Repubblica competente, per l''esecuzione nei registri depositati '||
      dep_invio_procura_RIGA2  := '- al Procuratore della Repubblica/al Prefetto competente, per l''esecuzione nei registri depositati '||
                                               'presso il Tribunale ai sensi dell''art.3, comma 1 e 2 del D.M. 27/02/2001.';

            dep_invio_comune_tras    := '- al Comune che eventualmente ha trascritto l''atto di '||w_des_tipo_atto||
                                                        ' (e al relativo Procuratore della Repubblica/Prefetto competente per territorio, per l''annotazione '||
                                                'sulla copia del registro depositato) ai sensi dell''art. 102, comma 5, del D.P.R. N. 396/2000.';

-- tipo_atto not in (6,7,8):
-- annotazione registrata su atto di nascita non presente in archivio
-- in seguito a Cittadinanza (6), Matrimonio (7), Divorzio (7) o Morte (8)
-- e
-- comune di nascita non corrispondente a quello di utenza:
-- la comunicazione viene intestata solo al comune di nascita
      if a_tipo_atto in (6,7,8,-7) and w_comune_nascita not like solo_comune_utente||' (%' then

               al_tribunale_riga1                        := null;
               al_tribunale_riga2                        := null;
               al_procuratore_riga1                    := null;
               al_procuratore_riga2                    := null;
               al_prefetto_riga1                       := null;
               al_prefetto_riga2                       := null;
            al_comune_RIGA1                             := 'All''UFFICIALE DELLO STATO CIVILE del COMUNE di';
            al_comune_RIGA2                             := w_cap_comune_nascita||' '||w_comune_nascita;
            comune_trascrizione_1_RIGA1    := NULL;
            comune_trascrizione_1_RIGA2    := NULL;
            blocco_trascrizione_1_RIGA1    := NULL;
             blocco_trascrizione_1_RIGA2    := NULL;
            comune_trascrizione_2_RIGA1    := NULL;
          comune_trascrizione_2_RIGA2    := NULL;
          blocco_trascrizione_2_RIGA1    := NULL;
          blocco_trascrizione_2_RIGA2    := NULL;
             invio_trib_competente_riga1    := dep_invio_trib_riga1;
             invio_trib_competente_riga2    := dep_invio_trib_riga2;
             invio_procura_competente_riga1 := dep_invio_procura_riga1;
             invio_procura_competente_riga2 := dep_invio_procura_riga2;
             invio_comune_trascrizione           := dep_invio_comune_tras;

      else
-- tipo_atto not in (6,7,8):
-- annotazione registrata su atto di qualsiasi tipo presente in archivio,
-- il comune di riferimento è sicuramente quello di utenza:
-- la comunicazione viene inestata alla Procura / Prefettura di riferimento
-- oppure
-- il comune di nascita corrisponde a quello di utenza:
-- la comunicazione viene intestata a Tribunale / Procuratore / Prefetto e Comune Utente
               if nvl(w_anno_atto,a_anno) <= 2000 then
                    al_tribunale_riga1                   := 'Al TRIBUNALE';
                  al_tribunale_riga2                   := 'di '||tribunale_utente;
                    al_procuratore_riga1                 := 'Al PROCURATORE DELLA REPUBBLICA';
                  al_procuratore_riga2                 := 'di '||tribunale_utente;
                  al_prefetto_riga1                    := null;
                  al_prefetto_riga2                    := null;
               else
                    al_tribunale_riga1                     := null;
                  al_tribunale_riga2                     := null;
                    al_procuratore_riga1                 := null;
                  al_procuratore_riga2                 := null;
                  al_prefetto_riga1                    := 'Al PREFETTO';
                  al_prefetto_riga2                    := 'di '||tribunale_utente;
               end if;


            al_comune_RIGA1                := 'All''UFFICIALE DELLO STATO CIVILE del COMUNE di';

            if a_tipo_atto in (9,-9)  AND comune_atto_matrimonio is not null THEN
			    al_comune_RIGA2                := cap_comune_atto_matrimonio||' '||comune_atto_matrimonio;
			else
			    al_comune_RIGA2                := cap_comune_utente||' '||comune_utente;
            end if;

			invio_comune_trascrizione           := null;

                if residenza not like solo_comune_utente||' (%' and
                     w_flag_comune_estero_res is null
                     --and rtrim(residenza,'_')            is not null
                then
                     comune_trascrizione_1_RIGA1      := 'All''UFFICIALE DELLO STATO CIVILE del COMUNE di';
                     comune_trascrizione_1_RIGA2      := cap_residenza||' '||residenza;
                     blocco_trascrizione_1_RIGA1      := '(trascritto nei registri del Comune di '||residenza;
                      blocco_trascrizione_1_RIGA2      := 'dell''anno _____ Parte _____ Serie _____ N. ______)';
                      invio_trib_competente_RIGA1    := dep_invio_trib_riga1;
                   invio_trib_competente_RIGA2    := dep_invio_trib_riga2;
                      invio_procura_competente_RIGA1 := dep_invio_procura_riga1;
                   invio_procura_competente_RIGA2 := dep_invio_procura_riga2;
                else
                     comune_trascrizione_1_RIGA1    := NULL;
                     comune_trascrizione_1_RIGA2    := NULL;
                     blocco_trascrizione_1_RIGA1    := NULL;
                      blocco_trascrizione_1_RIGA2    := NULL;
                      invio_trib_competente_riga1    := null;
                      invio_trib_competente_riga2    := null;
                      invio_procura_competente_riga1 := null;
                      invio_procura_competente_riga2 := null;
                end if;

                if a_tipo_atto in (4,9,-4,-9)                                                     and
                     w_flag_comune_estero_res_f is null                             and
                      residenza_sposa != residenza                                         and
                      residenza_sposa not like solo_comune_utente||' (%'
                      --and rtrim(residenza_sposa,'_')    is not null
                then
                   comune_trascrizione_2_RIGA1    := 'All''UFFICIALE DELLO STATO CIVILE del COMUNE di';
                   comune_trascrizione_2_RIGA2    := cap_residenza_sposa||' '||residenza_sposa;
                   blocco_trascrizione_2_RIGA1    := '(trascritto nei registri del Comune di '||residenza_sposa;
                   blocco_trascrizione_2_RIGA2    := 'dell''anno _____ Parte _____ Serie _____ N. ______)';
                      invio_trib_competente_RIGA1    := dep_invio_trib_riga1;
                   invio_trib_competente_RIGA2    := dep_invio_trib_riga2;
                      invio_procura_competente_RIGA1 := dep_invio_procura_riga1;
                   invio_procura_competente_RIGA2 := dep_invio_procura_riga2;
                else
                     comune_trascrizione_2_RIGA1    := NULL;
                   comune_trascrizione_2_RIGA2    := NULL;
                   blocco_trascrizione_2_RIGA1    := NULL;
                   blocco_trascrizione_2_RIGA2    := NULL;
                end if;
      end if;

   begin
    select nome||' '||cognome
      into w_terminalista_atto
      from cerdte
     where cod_utente = w_terminalista_atto
       and rownum = 1
    ;
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

--  alert_message_note('tipo_atto '||a_tipo_atto||
--                                      'ufficio '||a_ufficio||
--                                      'anno '||a_anno||
--                                      'atto '||a_atto||
--                                      'parte '||a_parte||
--                                      'serie '||a_serie||
--                                      'formula '||a_formula||
--                                      'data_reg '||a_data_reg);

  begin
      select estremi_atto_rif_1||w_sep||estremi_atto_rif_2
        into w_estremi_atto_rif
        from civann_rif
       where tipo_atto        = a_tipo_atto
         and ufficio            = a_ufficio
         and anno                    = a_anno
         and atto                        = a_atto
         and nvl(parte,0)      = nvl(a_parte,0)
         and nvl(serie,' ')    = nvl(a_serie,' ')
         and formula              = a_formula
         and data_reg                = a_data_reg
         and rownum                 = 1
      ;
  exception
      when others then
           w_estremi_atto_rif := w_sep;
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

--alert_message_note('PRIMA DI rec_dati=...completa');
      w_riga_dati := riga_dati1||w_sep||
                     riga_dati2||w_sep||
                     testo_annotazione||w_sep||
                     w_estremi_atto_rif||w_sep||
                     riga_dati3||w_sep||
                     al_tribunale_riga1||w_sep||al_tribunale_riga2||w_sep||
                     al_procuratore_riga1||w_sep||al_procuratore_riga2||w_sep||
                     al_prefetto_riga1||w_sep||al_prefetto_riga2||w_sep||
                     tribunale_utente||w_sep||
                     al_comune_riga1||w_sep||al_comune_riga2||w_sep||
                     comune_trascrizione_1_riga1||w_sep||comune_trascrizione_1_riga2||w_sep||
                     comune_trascrizione_2_riga1||w_sep||comune_trascrizione_2_riga2||w_sep||
                     blocco_trascrizione_1_riga1||w_sep||blocco_trascrizione_1_riga2||w_sep||
                     blocco_trascrizione_2_riga1||w_sep||blocco_trascrizione_2_riga2||w_sep||
                     riga_dati5||w_sep||
                     invio_trib_competente_riga1||w_sep||invio_trib_competente_riga2||w_sep||
                     invio_procura_competente_riga1||w_sep||invio_procura_competente_riga2||w_sep||
                     invio_comune_trascrizione||w_sep||
                     w_terminalista||w_sep||w_firma_omessa||w_sep||
                     w_terminalista_atto||w_sep||w_firma_omessa_term_atto||w_sep||null;

END;
/
