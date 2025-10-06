--liquibase formatted sql
--changeset amonopoli:202301301550 runOnChange:true stripComments:false
create or replace function f_CIV_testo_annotazione_auto
(a_tipo_atto			IN	number
,a_formula			IN	varchar2
,a_tipo_atto_rif		IN	number
,a_id_atto_rif			IN	varchar2
,a_soggetto_rif			IN	number
--
,a_natura_atto			IN	varchar2
,a_anno_atto			IN	number
,a_numero_atto			IN	number
,a_parte_atto			IN	number
,a_serie_atto			IN	varchar2
,a_data_evento			IN	varchar2
,a_des_com_evento		IN	varchar2
,a_cod_pro_evento		IN	number
,a_cognome_nome_1		IN	varchar2
,a_sesso_1			IN	varchar2
,a_cognome_nome_2		IN	varchar2
,a_tipo_div			IN	varchar2
,a_data_accordo_div		IN	varchar2
,a_parte_accordo_div		IN	number
,a_serie_accordo_div		IN	varchar2
,a_atto_accordo_div		IN	number
,a_avvocato_1_div		IN	varchar2
,a_avvocato_2_div		IN	varchar2
,a_num_sentenza_div		IN	varchar2
,a_flag_imprecisato_mor		IN	varchar2
,a_trib_sentenza_ucn		IN	varchar2
,a_num_sentenza_ucn		IN	varchar2
,a_data_sentenza_ucn		IN	varchar2
,a_anno_accordo_div		IN	number		default null
,a_testo_riassunto		IN	clob		default null
)

return varchar2

IS

w_soggetto_rif		number        := nvl(a_soggetto_rif,1);

w_des_cliente           varchar2(255) := f_get_comune_cliente('DES_COM');
w_cod_cliente           varchar2(255) := f_get_comune_cliente('COD_COMUNE');

w_cod_pro_mat           number;

w_testo_tfa		varchar2(4000);
w_ctr_175_quinqu	varchar2(255);
w_ctr_nfa_auto		varchar2(255);

w_ANNO_ACCORDO_DIV			varchar2(255);
w_ANNO_ATTO				varchar2(255);
w_ACQUISTATO_PERDUTO			varchar2(255);
w_ATTO_ACCORDO_DIV			varchar2(255);
w_AVVOCATO_1_DIV			varchar2(255);
w_AVVOCATO_2_DIV			varchar2(255);
w_COGNOME_NOME_1			varchar2(255);
w_COGNOME_NOME_2			varchar2(255);
w_COMUNE_EVENTO				varchar2(255);
w_COMUNE_UTENTE				varchar2(255);
w_DATA_ACCORDO_DIV			varchar2(255);
w_DATA_EVENTO				varchar2(255);
w_DATA_E_NUM_SENTENZA_DIV		varchar2(255);
w_DATA_OGGI				varchar2(255);
w_DATA_SENTENZA_UCN			varchar2(255);
w_ISCRITTO_TRASCRITTO			varchar2(255);
w_LO_SCIOGLIMENTO_LA_CESSAZION		varchar2(255);
w_MORTO_MORTA				varchar2(255);
w_NON					varchar2(255);
w_NUMERO_ATTO				varchar2(255);
w_NUMERO_SENTENZA_DIV			varchar2(255);
w_NUMERO_SENTENZA_UCN			varchar2(255);
w_PARTE_ACCORDO_DIV			varchar2(255);
w_PARTE_ATTO				varchar2(255);
w_SERIE_ACCORDO_DIV			varchar2(255);
w_SERIE_ATTO				varchar2(255);
w_SERIE_E_ANNO_ACCORDO_DIV		varchar2(255);
w_SERIE_E_ANNO_ATTO			varchar2(255);
w_SCIOGLIMENTO_CESSAZIONE		varchar2(255);
w_STATO_DICHIARATO_A			varchar2(255);
w_STATO_PRONUNZIATO_A			varchar2(255);
w_STATO_SCIOLTO_SONO_CESSATI		varchar2(255);
w_TRIBUNALE_SENTENZA_UCN		varchar2(255);

w_flag_ansc				varchar2(255) := f_flag_ansc();

w_numero_unico_rif			varchar2(255);
w_id_atto_ansc_rif			varchar2(255);
w_cognome_nome_1_rif			varchar2(255);
w_cognome_nome_2_rif			varchar2(255);
w_numero_unico_acc			varchar2(255);
w_id_atto_ansc_acc			varchar2(255);
w_numero_analogico_acc			varchar2(255);

w_aggiungi_nota				number;

w_testo_riassunto			varchar2(4000);

cursor sel_nfa is
select variabile,
       decode(testo_auto,'','',
         testo_auto||decode(testo_var_auto,'','',' ')) testo_fisso_auto,
       decode(upper(testo_var_auto),
         '<ACQUISTATO-PERDUTO>', w_acquistato_perduto,
         '<ANNO_ACCORDO_DIVORZIO>', w_anno_accordo_div,
         '<ANNO_ATTO>', w_anno_atto,
         '<ATTO_ACCORDO_DIVORZIO>', w_atto_accordo_div,
         '<AVVOCATO_1_DIVORZIO>', w_avvocato_1_div,
         '<AVVOCATO_2_DIVORZIO>', w_avvocato_2_div,
         '<COGNOME_NOME_1>', w_cognome_nome_1,
         '<COGNOME_NOME_2>', w_cognome_nome_2,
         '<COMUNE_EVENTO>', w_comune_evento,
         '<COMUNE_UTENTE>', w_comune_utente,
         '<DATA_ACCORDO_DIVORZIO>', w_data_accordo_div,
         '<DATA_EVENTO>', w_data_evento,
         '<DATA_E_NUM_SENTENZA_DIVORZIO>', w_data_e_num_sentenza_div,
         '<DATA_OGGI>', w_data_oggi,
         '<DATA_SENTENZA_UCI_CONIUGE>', w_data_sentenza_ucn,
         '<ISCRITTO-TRASCRITTO>', w_iscritto_trascritto,
         '<LO_SCIOGLIMENTO-LA_CESSAZIONE>', w_lo_scioglimento_la_cessazion,
         '<MORTO-MORTA>', w_morto_morta,
         '<NON>', w_non,
         '<NUMERO_ATTO>', w_numero_atto,
         '<NUMERO_SENTENZA_DIVORZIO>', w_numero_sentenza_div,
	 '<NUMERO_SENTENZA_UCI_CONIUGE>', w_numero_sentenza_ucn,
         '<PARTE_ACCORDO_DIVORZIO>', w_parte_accordo_div,
         '<PARTE_ATTO>', w_parte_atto,
         '<SCIOGLIMENTO-CESSAZIONE>', w_scioglimento_cessazione,
         '<SERIE_ACCORDO_DIVORZIO>', w_serie_accordo_div,
         '<SERIE_ATTO>', w_serie_atto,
         '<SERIE_E_ANNO_ACCORDO_DIVORZIO>', w_serie_e_anno_accordo_div,
         '<SERIE_E_ANNO_ATTO>', w_serie_e_anno_atto,
         '<STATO_DICHIARATO-STATA_DICHIARATA>', w_stato_dichiarato_a,
         '<STATO_PRONUNZIATO-STATA_PRONUNZIATA>', w_stato_pronunziato_a,
         '<STATO_SCIOLTO-SONO_CESSATI>', w_stato_sciolto_sono_cessati,
         '<TRIBUNALE_SENTENZA_UCI_CONIUGE>', w_tribunale_sentenza_ucn) testo_var_auto
  from civnfa
 where formula = a_formula
   and testo_auto||testo_var_auto is not null
 order by variabile
;

w_formula		varchar2(255);

w_c1			varchar2(255);
w_c2			varchar2(255);
w_c3			varchar2(255);
w_c4			varchar2(255);
w_c5			varchar2(255);
w_c6			varchar2(255);
w_c7			varchar2(255);
w_c8			varchar2(255);
w_c9			varchar2(255);
w_c10			varchar2(255);
w_c11			varchar2(255);
w_c12			varchar2(255);
w_c13			varchar2(255);
w_c14			varchar2(255);
w_c15			varchar2(255);
w_c16			varchar2(255);
w_c17			varchar2(255);
w_c18			varchar2(255);
w_c19			varchar2(255);
w_c20			varchar2(255);
w_c21			varchar2(255);
w_c22			varchar2(255);
w_c23			varchar2(255);
w_c24			varchar2(255);
w_c25			varchar2(255);
w_c26			varchar2(255);
w_c27			varchar2(255);
w_c28			varchar2(255);
w_c29			varchar2(255);
w_c30			varchar2(255);

w_testo			varchar2(4000);

w_errore		varchar2(4000);
errore			exception;

begin

  if nvl(w_flag_ansc,'N') = 'S' then
     begin
       select decode(a_formula,
                '132', '132-AN',
                '132-NO', '132-AN',
                '135-NO', '135-AN',
                '138-BIS', '138-BIS-AN',
                '138-NO', '138-AN',
                '138-TER', '138-TER-AN',
                '139-BIS', '139-BIS-AN',
                '139-NONIES', '139-NON-AN',
                '139-OCTIES', '139-OCT-AN',
                '139-QUINQU', '139-QUI-AN',
                '139-SEXIES', '139-SEX-AN',
                '139-TER', '139-TER-AN',
                '140-BIS-NO', '140-BIS-AN',
                '140-NO', '140-AN',
                '140-QUA-NO', '140-QUA-AN',
                '140-QUI-NO', '140-QUI-AN',
                '140-SEX-NO', '140-SEX-AN',
                '164', '164-AN',
                '164-NO', '164-AN',
                '170', '170-AN',
                '170-NO', '170-NO-AN',
                '173-BIS', '173-BIS-AN',
                '175-NO', '175-AN',
                '175-QUATER', '175-QUA-AN',
                '175-QUATER', '175-QUA-AN',
                '175-SEPTIE', '175-SEP-AN',
                '175-SEXIES', '175-SEX-AN',
                '175-TER-NO', '175-TER-AN',
                '175-TER-NO', '175-TER-AN',
                '187-OCTIES', '187-OCT-AN',
                '187-QUATER', '187-QUA-AN',
                '187-QUINQU', '187-QUI-AN',
                '187-SEPTIE', '187-SEP-AN',
                '187-SEXIES', '187-SEX-AN',
                 a_formula)
         into w_formula
         from dual
       ;
     exception
       when others then
            w_formula := a_formula;
     end;

  else
     w_formula := a_formula;
  end if;

  begin
    select tfa.testo_4000,
           case
             when a_formula = '175-QUINQU' and tfa.testo_4000 like '%#9 #10 #11 e #12 #13 #14%' then
                  'S'
           end,
           (select 'S'
              from civnfa nfa
             where nfa.formula                        = tfa.formula
               and nfa.testo_auto||nfa.testo_var_auto is not null
               and rownum                             = 1)
      into w_testo_tfa, w_ctr_175_quinqu, w_ctr_nfa_auto
      from civtfa tfa,
           civdfa dfa
     where tfa.formula   = dfa.formula
       and dfa.formula   = w_formula
       and dfa.tipo_atto = a_tipo_atto
       and rownum = 1
    ;
--dbms_output.put_line('dopo sel_civtfa');
  exception
    when others then
--dbms_output.put_line('dopo sel_civtfa - errore');
         w_testo_tfa      := '';
  end;

  if w_testo_tfa is null then
     goto fine;
  end if;

  if nvl(w_ctr_nfa_auto,'N') = 'S' then
     w_ANNO_ATTO			:= a_anno_atto;
     if nvl(a_parte_atto,0) = 1 then
        w_PARTE_ATTO			:= 'I';
     elsif nvl(a_parte_atto,0) = 2 then
        w_PARTE_ATTO			:= 'II';
     else
        w_PARTE_ATTO			:= a_parte_atto;
     end if;
     w_NUMERO_ATTO			:= a_numero_atto;
     w_SERIE_ATTO			:= a_serie_atto;
     w_SERIE_E_ANNO_ATTO		:= a_serie_atto||' anno '||a_anno_atto;

     w_COMUNE_UTENTE			:= w_des_cliente;
     w_DATA_OGGI			:= to_char(sysdate,'dd/mm/yyyy');
     w_COMUNE_EVENTO			:= a_des_com_evento;
     w_DATA_EVENTO			:= a_data_evento;

     if a_soggetto_rif = 1 then
        w_COGNOME_NOME_1		:= a_cognome_nome_1;
        w_COGNOME_NOME_2		:= a_cognome_nome_2;
        w_AVVOCATO_1_DIV		:= a_avvocato_1_div;
        w_AVVOCATO_2_DIV		:= a_avvocato_2_div;
     elsif a_soggetto_rif = 2 then
        w_COGNOME_NOME_1		:= a_cognome_nome_2;
        w_COGNOME_NOME_2		:= a_cognome_nome_1;
        w_AVVOCATO_1_DIV		:= a_avvocato_2_div;
        w_AVVOCATO_2_DIV		:= a_avvocato_1_div;
     end if;

     if nvl(a_sesso_1,'X') = 'M' then
        w_MORTO_MORTA			:= 'morto';
     elsif nvl(a_sesso_1,'X') = 'F' then
        w_MORTO_MORTA			:= 'morta';
     end if;

     if a_natura_atto = 'O' then
        if a_formula like '175%' then
           if to_char(a_parte_atto)||a_serie_atto = '2A' then
              w_ISCRITTO_TRASCRITTO	:= 'trascritto';
           elsif a_cod_pro_evento > 199 then
              w_ISCRITTO_TRASCRITTO	:= 'trascritto';
              w_COMUNE_EVENTO           := w_des_cliente;
           end if;
        else
           w_ISCRITTO_TRASCRITTO	:= 'iscritto';
        end if;
     elsif a_natura_atto = 'T' then
        w_ISCRITTO_TRASCRITTO		:= 'trascritto';
     elsif a_natura_atto = 'A' then
        w_ACQUISTATO_PERDUTO		:= 'acquistato';
        w_NON				:= '';
     elsif a_natura_atto = 'P' then
        w_ACQUISTATO_PERDUTO		:= 'perduto';
        w_NON				:= 'non';
     end if;

     if a_tipo_div is not null then
        w_NUMERO_SENTENZA_DIV			:= a_num_sentenza_div;
        w_DATA_E_NUM_SENTENZA_div		:= a_data_evento||' N.'||nvl(a_num_sentenza_div,'__________');
        w_ANNO_ACCORDO_DIV			:= nvl(a_anno_accordo_div,to_number(substr(a_data_accordo_div,7,4)));
        w_ATTO_ACCORDO_DIV			:= a_atto_accordo_div;
        if nvl(a_PARTE_ACCORDO_DIV,0) = 2 then
           w_PARTE_ACCORDO_DIV			:= 'II';
        else
           w_PARTE_ACCORDO_DIV			:= a_parte_accordo_div;
        end if;
        w_SERIE_ACCORDO_DIV			:= a_serie_accordo_div;
        w_SERIE_E_ANNO_ACCORDO_DIV		:= a_serie_accordo_div||' anno '||w_anno_accordo_div;
        w_DATA_ACCORDO_DIV			:= a_data_accordo_div;
        if a_tipo_div = 'S' then
           w_SCIOGLIMENTO_CESSAZIONE		:= 'scioglimento';
           w_LO_SCIOGLIMENTO_LA_CESSAZION	:= 'lo scioglimento';
           w_STATO_DICHIARATO_A			:= 'stato dichiarato';
           w_STATO_PRONUNZIATO_A		:= 'stato pronunziato';
           w_STATO_SCIOLTO_SONO_CESSATI		:= 'e'' stato sciolto il';
        elsif a_tipo_div = 'C' then
           w_SCIOGLIMENTO_CESSAZIONE		:= 'cessazione degli effetti civili';
           w_LO_SCIOGLIMENTO_LA_CESSAZION	:= 'la cessazione degli effetti civili';
           w_STATO_DICHIARATO_A			:= 'stata dichiarata';
           w_STATO_PRONUNZIATO_A		:= 'stata pronunziata';
           w_STATO_SCIOLTO_SONO_CESSATI		:= 'sono cessati gli effetti civili del';
        end if;
     end if;

     w_TRIBUNALE_SENTENZA_UCN			:= a_trib_sentenza_ucn;
     w_NUMERO_SENTENZA_UCN			:= a_num_sentenza_ucn;
     w_DATA_SENTENZA_UCN			:= a_data_sentenza_ucn;

     for rec_nfa in sel_nfa loop
         if rec_nfa.variabile = 1     then w_c1  := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 2  then w_c2  := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 3  then w_c3  := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 4  then w_c4  := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 5  then w_c5  := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 6  then w_c6  := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 7  then w_c7  := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 8  then w_c8  := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 9  then w_c9  := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 10 then w_c10 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 11 then w_c11 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 12 then w_c12 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 13 then w_c13 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 14 then w_c14 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 15 then w_c15 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 16 then w_c16 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 17 then w_c17 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 18 then w_c18 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 19 then w_c19 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 20 then w_c20 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 21 then w_c21 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 22 then w_c22 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 23 then w_c23 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 24 then w_c24 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 25 then w_c25 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 26 then w_c26 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 27 then w_c27 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 28 then w_c28 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 29 then w_c29 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         elsif rec_nfa.variabile = 30 then w_c30 := rec_nfa.testo_fisso_auto||rec_nfa.testo_var_auto;
         end if;
     end loop;

     goto replace_testo;
  end if;

-- 132: (matrimonio) Anno #7 Parte #8  #9 N. #10 .
-- 135: (trascr. sentenza) Anno #7 parte #8 serie #9 N. #10
-- 138: <idem>
-- 138-bis: (accordo) n. #5 parte #6 serie #7
-- 134-ter: (accordo) n. #3 parte #4 serie #5 (conferma) n. #6 parte #7 serie #8 anno #11
-- 139-bis: (unione civile) anno #7 , parte #8 , n. #9
-- 139-non: (accordo) n. #3 parte #4 (conferma) n. #5 parte #6
-- 139-oct: (trascr. negoziazione) anno #7 , parte #8 , n #9
-- 139-qui: (unione civile) anno #10 ,parte #11 , serie #12 , n. #13
-- 139-sex: (unione civile) anno #6 , parte #7 , serie #8 , n. #9
-- 139-ter: (unione civile) anno #11 , parte #12 , n.  #13
-- 140-sex: (cittadinanza) N. #3
-- 164: (morte) Anno #6 Parte #7 #8 N. #9
-- 170: (trascr. sentenza) Anno #4 Parte II Serie C N. #5 
-- 170-no: (trasr. sentenza) Anno #5 Parte #6 Serie #7 N. #8
-- 173-bis: (unione civile) anno #7 , parte #8 , n. #9
-- 175-qua: (accordo) n. #4 parte #5 serie #6
-- 175-qui: (accordo) n. #3 parte #4 serie #5 (conferma) n. #6 parte #7 serie #8 anno #13

  w_numero_atto        := a_numero_atto;
  w_parte_atto         := a_parte_atto;
  w_serie_atto         := a_serie_atto;
  w_anno_atto          := a_anno_atto;
  w_atto_accordo_div   := a_atto_accordo_div;
  w_parte_accordo_div  := a_parte_accordo_div;
  w_serie_accordo_div  := a_serie_accordo_div;
  w_anno_accordo_div   := a_anno_accordo_div;
  w_data_accordo_div   := a_data_accordo_div;

  if nvl(w_flag_ansc,'N') = 'S' then
     w_aggiungi_nota := 0;
     begin
       select numero_unico, id_atto_ansc, to_char(null), to_char(null)
         into w_numero_unico_rif, w_id_atto_ansc_rif, w_cognome_nome_1_rif, w_cognome_nome_2_rif
         from civcit
        where id_atto         = a_id_atto_rif
          and a_tipo_atto_rif = 1
       UNION
       select numero_unico, id_atto_ansc, cognome_nome_m, cognome_nome_f
         from civmat
        where id_atto         = a_id_atto_rif
          and a_tipo_atto_rif = 4
       UNION
       select numero_unico, id_atto_ansc, cognome_nome_m, cognome_nome_f
         from civuci
        where id_atto         = a_id_atto_rif
          and a_tipo_atto_rif = -4
       UNION
       select numero_unico, id_atto_ansc, to_char(null), to_char(null)
         from civmor
        where id_atto         = a_id_atto_rif
          and a_tipo_atto_rif = 5
       ;
       if w_id_atto_ansc_rif is not null then
          w_numero_atto        := 'N. '||w_id_atto_ansc_rif;
       elsif w_numero_unico_rif is not null then
          w_numero_atto        := 'N. '||w_numero_unico_rif||' Anno '||w_anno_atto||' (*)';
          w_aggiungi_nota      := 1;
       else 
          w_numero_atto        := '';
       end if;
       w_parte_atto         := '';
       w_serie_atto         := '';
       w_anno_atto          := '';
     exception
       when others then
            w_numero_unico_rif   := '';
            w_id_atto_ansc_rif   := '';
            w_cognome_nome_1_rif := '';
            w_cognome_nome_2_rif := '';
     end;

     begin
       select numero_unico, id_atto_ansc,
              atto||decode(parte,'','',1,' Parte I',2,' Parte II')||decode(serie,'','',' Serie '||serie)||' Anno '||anno
         into w_numero_unico_acc, w_id_atto_ansc_acc, w_numero_analogico_acc
         from civmat
        where anno            = a_anno_accordo_div
          and atto            = a_atto_accordo_div
          and parte           = a_parte_accordo_div
          and nvl(serie,' ')  = nvl(a_serie_accordo_div,' ')
          and cognome_nome_m  = w_cognome_nome_1_rif
          and cognome_nome_f  = w_cognome_nome_2_rif
          and a_tipo_atto_rif = 4
       UNION
       select numero_unico, id_atto_ansc,
              atto||decode(parte,'','',1,' Parte I',2,' Parte II')||decode(serie,'','',' Serie '||serie)||' Anno '||anno
         from civuci
        where anno            = a_anno_accordo_div
          and atto            = a_atto_accordo_div
          and parte           = a_parte_accordo_div
          and nvl(serie,' ')  = nvl(a_serie_accordo_div,' ')
          and cognome_nome_m  = w_cognome_nome_1_rif
          and cognome_nome_f  = w_cognome_nome_2_rif
          and a_tipo_atto_rif = -4
       ;
       if w_id_atto_ansc_acc is not null then
          w_atto_accordo_div   := 'N. '||w_id_atto_ansc_acc;
       elsif w_numero_unico_acc is not null then
          w_atto_accordo_div   := 'N. '||w_numero_unico_acc||' Anno '||w_anno_accordo_div||' (*)';
          w_aggiungi_nota      := 1;
       else
          w_atto_accordo_div   := 'N. '||w_numero_analogico_acc;
       end if;
       w_parte_accordo_div  := '';
       w_serie_accordo_div  := '';
       w_anno_accordo_div   := '';
  	 exception
	   when others then
	        w_numero_unico_acc   := '';
			w_id_atto_ansc_acc   := '';
	 end;
  end if;

--
-- matrimonio su atto di nascita
-- 132    - testo: #1 ha contratto matrimonio con #2 il #3 nel Comune di #4 . L atto fu #5 nei registri di matrimonio del Comune di #6 Anno #7 Parte #8  #9 N. #10 .
-- 132-NO - testo: #1 ha contratto matrimonio con #2 il #3 nel Comune di #4 . L'atto fu #5 nei registri di matrimonio del Comune di #6 Anno #7 Parte #8  #9 N. #10.
--
  if a_tipo_atto = 2 and a_formula in ('132','132-NO') then
--dbms_output.put_line('matrimonio su atto di nascita');
     begin
       select -- C1
              decode(w_soggetto_rif, 1, a_cognome_nome_1, 2, a_cognome_nome_2),
              -- C2
              decode(w_soggetto_rif, 1, a_cognome_nome_2, 2, a_cognome_nome_1),
              -- C3
              a_data_evento,
              -- C4
              a_des_com_evento,
              -- C5
              decode(a_natura_atto,
                'O', decode(to_char(w_parte_atto)||w_serie_atto, '2A', 'trascritto', 'iscritto'),
                'T', 'trascritto',null),
              -- C6
              a_des_com_evento,
              -- C7
              w_anno_atto,
              -- C8
              decode(w_parte_atto,1,'I',2,'II',w_parte_atto),
              -- C9
              decode(w_serie_atto,'','','Serie '||w_serie_atto),
              -- C10
              w_numero_atto,
              a_cod_pro_evento
         into w_c1, w_c2, w_c3, w_c4, w_c5, w_c6, w_c7, w_c8, w_c9, w_c10, w_cod_pro_mat
         from dual
       ;
       if w_cod_pro_mat >= 199 then
          w_c5 := 'trascritto';
          w_c6 := w_des_cliente;
       end if;
--dbms_output.put_line('dopo sel_civmat_v');
     exception
       when others then
--dbms_output.put_line('dopo sel_civmat_v - errore');
            w_errore := 'errore in recupero campo (formula: '||a_formula||')';
            raise errore;
     end;
  end if;

--
-- divorzio su atto di nascita
-- 07/02/2023 (AM) 138-TER: aggiunto #11 (a_anno_atto)
-- 08/03/2023 (AM) 135-NO x divorzio estero
-- 135-NO  - testo: Il matrimonio di #1 con #2 e' stato sciolto con sentenza del #3 in data #4 #5 riconosciuta efficace in Italia e trascritta nei registri di matrimonio del  Comune di #6 Anno #7 parte #8 serie #9 N. #10
-- 138-NO  - testo: Con sentenza del #1 ,in data #2 , annotata nell'atto di matrimonio in data #9 , e' #3 #4 #5 del matrimonio contratto da #6 con #7 di cui all'annotazione in data #8 .
-- 138-BIS - testo: Con convenzione di negoziazione assistita dagli avvocati #1 #2 conclusa in data #3 , trascritta nei registri di matrimonio dell'ufficio dello stato civile del Comune di #4 , al n. #5 parte #6 serie #7 , e' stato concluso l'accordo di #8 del matrimonio di #9 con #10 di cui all'annotazione in data #11 .
-- 138-TER - testo: Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 #11 , #9 matrimonio annotato in data #10 .
--
  if a_tipo_atto = 2 and a_formula in ('135-NO','138-NO','138-BIS','138-TER') then
--dbms_output.put_line('divorzio su atto di nascita');
     begin
       select -- C1
              decode(a_formula,
                '135-NO',  decode(w_soggetto_rif, 1, a_cognome_nome_1, 2, a_cognome_nome_2),
                '138-NO',  'Tribunale di '||a_des_com_evento,
                '138-BIS', a_avvocato_1_div,
                '138-TER', w_des_cliente,''),
              -- C2
              decode(a_formula,
                '135-NO',  decode(w_soggetto_rif, 1, a_cognome_nome_2, 2, a_cognome_nome_1),
                '138-NO',  decode(w_cod_cliente,
                             '025006', a_data_evento,	-- BELLUNO
                                       a_data_evento||' N. '||nvl(a_num_sentenza_div,'__________')),
                '138-BIS', a_avvocato_2_div,
                '138-TER', nvl(a_data_accordo_div,a_data_evento),''),
              -- C3
              decode(a_formula,
                '135-NO',  'Tribunale di '||a_des_com_evento,
                '138-NO',  decode(w_cod_cliente,
                             '025006', nvl(a_num_sentenza_div,'__________'),	-- BELLUNO
                                       decode(a_tipo_div,'S','stato pronunziato','C','stata pronunziata')),
                '138-BIS', w_data_accordo_div,
                '138-TER', w_atto_accordo_div,''),
              -- C4
              decode(a_formula,
                '135-NO',  a_data_evento,
                '138-NO',  decode(w_cod_cliente,
                             '025006', '__________', 	-- BELLUNO
                                       decode(a_tipo_div,'S','lo scioglimento','C','la cessazione')),
                '138-BIS', w_des_cliente,
                '138-TER', w_parte_accordo_div,''),
              -- C5
              decode(a_formula,
                '135-NO',  'N. '||nvl(a_num_sentenza_div,'__________'),
                '138-NO',  decode(w_cod_cliente,
                             '025006', decode(a_tipo_div,'S','stato pronunziato','C','stata pronunziata'),	-- BELLUNO
                                       decode(a_tipo_div,'S','','C','degli effetti civili')),
                '138-BIS', w_numero_atto,
                '138-TER', w_serie_accordo_div,''),
              -- C6
              decode(a_formula,
                '135-NO',  w_des_cliente,
                '138-NO',  decode(w_cod_cliente,
                             '025006', decode(a_tipo_div,'S','lo scioglimento','C','la cessazione degli effetti civili'),	-- BELLUNO
                                       a_cognome_nome_1),
                '138-BIS', w_parte_atto,
                '138-TER', w_numero_atto,''),
              -- C7
              decode(a_formula,
                '135-NO',  w_anno_atto,
                '138-NO',  decode(w_cod_cliente,
                             '025006', a_cognome_nome_1,	-- BELLUNO
                                       a_cognome_nome_2),
                '138-BIS', w_serie_atto,
                '138-TER', w_parte_atto,''),
              -- C8
              decode(a_formula,
                '135-NO',  to_char(w_parte_atto),
                '138-NO',  decode(w_cod_cliente,
                             '025006', a_cognome_nome_2,	-- BELLUNO
                                       '____________'),
                '138-BIS', decode(a_tipo_div,'S','scioglimento','C','cessazione degli effetti civili'),
                '138-TER', w_serie_atto,''),
              -- C9
              decode(a_formula,
                '135-NO',  w_serie_atto,
                '138-NO',  '____________',
                '138-BIS', a_cognome_nome_1,
                '138-TER', decode(a_tipo_div,'S','e'' stato sciolto il', 'C','sono cessati gli effetti civili del',''),''),
              -- C10
              decode(a_formula,
                '135-NO',  w_numero_atto,
                '138-NO',  '____________',
                '138-BIS', a_cognome_nome_2,
                '138-TER', '__________',''),
              -- C11
              decode(a_formula,
                '138-NO',  '____________',
                '138-BIS', '__________',
                '138-TER', w_anno_atto,''),
              -- C29
              a_anno_atto,
              -- C30
              a_numero_atto
         into w_c1, w_c2, w_c3, w_c4, w_c5, w_c6, w_c7, w_c8, w_c9, w_c10, w_c11, w_c29, w_c30
         from dual
       ;
--dbms_output.put_line('dopo sel_civmat_v');
     exception
       when others then
--dbms_output.put_line('dopo sel_civmat_v - errore');
            w_errore := 'errore in recupero campo (formula: '||a_formula||')';
            raise errore;
     end;
  end if;

--
-- divorzio su atto di matrimonio
-- 07/02/2023 (AM) 175-SEPTIE: aggiunto #10 (a_anno_atto)
-- 08/03/2023 (AM) 170-NO x divorzio estero
-- 12/03/2025 (AM) 170 x divorzio estero
-- 170        - testo: Con sentenza della corte di appello di #1 in data #2 trascritta nei registri di matrimonio del Comune di #3 Anno #4 Parte II Serie C N. #5 e' stata  dichiarata efficace nello Stato la sentenza del #6 in data #7 con la quale  fu #8 #9 del matrimonio cui si riferisce l'atto controscritto.  
-- 170-NO     - testo: Con sentenza del #1 in data #2 N. #3 trascritta nei registri di matrimonio del Comune di #4 Anno #5 Parte #6 Serie #7 N. #8 e' #9 #10 #11 del matrimonio  cui si riferisce l'atto controscritto.
-- 175-NO     - testo: Con sentenza del #1 in data #2 e' #3 #4 #5 del matrimonio cui si riferisce l'atto controscritto
-- 175-QUATER - testo: Con convenzione di negoziazione assistita dagli avvocati  #1 e #2 ,conclusa in data #3 , trascritta nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , e' stato concluso l'accordo di separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all'atto di matrimonio controscritto.
-- 175-QUINQU - testo: Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 , i coniugi #9 #10 #11 e #12 #13 #14 di cui al matrimonio controscritto si sono separati.
-- 175-SEPTIE - testo: Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 #10 , #9 matrimonio controscritto.
-- 175-SEXIES - testo: Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , trascritta nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 anno #8, e' stato concluso l'accordo di #7 del matrimonio controscritto
--
  if a_tipo_atto = 4 and a_formula in ('170','170-NO','175-NO','175-QUATER','175-QUINQU','175-SEPTIE','175-SEXIES') then
--dbms_output.put_line('divorzio su atto di matrimonio');
     begin
       select -- C1
              decode(a_formula,
                '170',       a_des_com_evento,
                '170-NO',    'Tribunale di '||a_des_com_evento,
                '175-NO',    'Tribunale di '||a_des_com_evento,
                '175-QUATER', a_avvocato_1_div,
                '175-SEXIES', a_avvocato_1_div,
                '175-QUINQU', w_des_cliente,
                '175-SEPTIE', w_des_cliente,
                ''),
              -- C2
              decode(a_formula,
                '170',        a_data_evento,
                '170-NO',     a_data_evento,
                '175-NO',     a_data_evento||' N. '||nvl(a_num_sentenza_div,'__________'),
                '175-QUATER', a_avvocato_2_div,
                '175-SEXIES', a_avvocato_2_div,
                '175-QUINQU', w_data_accordo_div,
                '175-SEPTIE', w_data_accordo_div,
                ''),
              -- C3
              decode(a_formula,
                '170',        w_des_cliente,
                '170-NO',     nvl(a_num_sentenza_div,'__________'),
                '175-NO',     decode(a_tipo_div,'S','stato dichiarato','C','stata dichiarata'),
                '175-QUATER', w_data_accordo_div,
                '175-SEXIES', w_data_accordo_div,
                '175-QUINQU', w_atto_accordo_div,
                '175-SEPTIE', w_atto_accordo_div,
                ''),
              -- C4
              decode(a_formula,
                '170',        w_anno_atto,
                '170-NO',     w_des_cliente,
                '175-NO',     decode(a_tipo_div,'S','lo scioglimento','C','la cessazione'),
                '175-QUATER', w_numero_atto,
                '175-SEXIES', w_numero_atto,
                '175-QUINQU', w_parte_accordo_div,
                '175-SEPTIE', w_parte_accordo_div,
                ''),
              -- C5
              decode(a_formula,
                '170',        w_numero_atto,
                '170-NO',     w_anno_atto,
                '175-NO',     decode(a_tipo_div,'S','','C','degli effetti civili'),
                '175-QUATER', w_parte_atto,
                '175-SEXIES', w_parte_atto,
                '175-QUINQU', w_serie_accordo_div,
                '175-SEPTIE', w_serie_accordo_div,
                ''),
              -- C6
              decode(a_formula,
                '170',        'Tribunale di __________',
                '170-NO',     w_parte_atto,
                '175-NO',     '',
                '175-QUATER', w_serie_atto,
                '175-SEXIES', w_serie_atto,
                '175-QUINQU', w_numero_atto,
                '175-SEPTIE', w_numero_atto,
                ''),
              -- C7
              decode(a_formula,
                '170',        '__/__/____',
                '170-NO',     w_serie_atto,
                '175-NO',     '',
                '175-QUATER', '',
                '175-SEXIES', decode(a_tipo_div,'C','cessazione degli effetti civili','S','scioglimento',''),
                '175-QUINQU', w_parte_atto,
                '175-SEPTIE', w_parte_atto,
                ''),
              -- C8
              decode(a_formula,
                '170',        decode(a_tipo_div,'S','stato pronunciato','C','stata pronunciata','stata pronunciata'),
                '170-NO',     w_numero_atto,
                '175-NO',     '',
                '175-QUATER', '',
                '175-SEXIES', w_anno_atto,
                '175-QUINQU', w_serie_atto,
                '175-SEPTIE', w_serie_atto,
                ''),
              -- C9
              decode(a_formula,
                '170',        decode(a_tipo_div,'S','lo scioglimento','C','la cessazione','la nullita'''),
                '170-NO',     decode(a_tipo_div,'S','stato pronunciato','C','stata pronunciata','stata pronunciata'),
                '175-NO',     '',
                '175-QUATER', a_cognome_nome_1,
                '175-SEXIES', '',
                '175-QUINQU', a_cognome_nome_1,
                '175-SEPTIE', decode(a_tipo_div,'C','sono cessati gli effetti civili del','S','e'' stato sciolto il',''),
                ''),
              -- C10
              decode(a_formula,
                '170-NO',     decode(a_tipo_div,'S','lo scioglimento','C','la cessazione','la nullita'''),
                '175-NO',     '',
                '175-QUATER', a_cognome_nome_2,
                '175-SEXIES', '',
                '175-QUINQU', decode(w_ctr_175_quinqu,'S','',a_cognome_nome_2),
                '175-SEPTIE', w_anno_atto,
                ''),
              -- C11
              decode(a_formula,
                '170-NO',     decode(a_tipo_div,'S','','C','degli effetti civili'),
                ''),
              -- C12
              decode(a_formula,
                '175-QUINQU', decode(w_ctr_175_quinqu,'S',a_cognome_nome_2)),
              -- C13
              null,
              -- C14
              null,
              -- C29
              a_anno_atto,
              -- C30
              a_numero_atto
         into w_c1, w_c2, w_c3, w_c4, w_c5, w_c6, w_c7, w_c8, w_c9, w_c10, w_c11, w_c12, w_c13, w_c14, w_c29, w_c30
         from dual
       ;
--dbms_output.put_line('dopo sel_civmat_v');
     exception
        when others then
--dbms_output.put_line('dopo sel_civmat_v - errore');
             w_errore := 'errore in recupero campo (formula: '||a_formula||')';
             raise errore;
     end;
  end if;

--
-- morte su atto di nascita
-- 164    - testo: #1 e'  #2 in #3 il #4 (atto di morte del Comune di #5 Anno #6 Parte #7 #8 N. #9 ).
-- 164-NO - testo: #1 e'  #2 in #3 il #4 (atto di morte del Comune di #5 Anno #6 Parte #7 #8 N. #9 ).
--
  if a_tipo_atto = 2 and a_formula in ('164','164-NO') then
--dbms_output.put_line('morte su atto di nascita');
     begin
       select -- C1
              a_cognome_nome_1,
              -- C2
              decode(a_sesso_1,'F','morta','morto'),
              -- C3
              a_des_com_evento,
              -- C4
             decode(nvl(a_flag_imprecisato_mor,'NNN'),
                'SSS','data imprecisata',
                'SSN','giorno imprecisato del''anno '||substr(a_data_evento, -4),
                'SNN','giorno imprecisato del mese '||substr(a_data_evento, -7),
                a_data_evento),
              -- C5
              w_des_cliente,
              -- C6
              w_anno_atto,
              -- C7
              decode(w_parte_atto,1,'I',2,'II',w_parte_atto),
              -- C8
              decode(w_serie_atto,'','','Serie '||w_serie_atto),
              -- C9
              w_numero_atto
         into w_c1, w_c2, w_c3, w_c4, w_c5, w_c6, w_c7, w_c8, w_c9
         from dual
       ;
--dbms_output.put_line('dopo sel_civmor_v');
     exception
        when others then
--dbms_output.put_line('dopo sel_civmor_v - errore');
             w_errore := 'errore in recupero campo (formula: '||a_formula||')';
             raise errore;
     end;
  end if;

--
-- unione civile su atto di nascita
-- 139-BIS    - testo: #1 ha costituito unione civile con #2 il #3 nel Comune di #4 . L'atto fu #5 nei registri di unioni civili del Comune di #6 , anno #7 , parte #8 , n. #9
-- 139-TER    - testo: #1 ha costituito unione civile con #2 il #3 a seguito di sentenza di rettificazione di attribuzione di sesso di #4 #5 , pronunciata dal #6 #7 , n #8 , in data #9 . L'atto fu iscritto nei registri di unioni  civili del Comune di #10 , anno #11 , parte #12 , n.  #13 , in esecuzione dell'ordine di cui alla summenzionata sentenza.
-- 139-QUINQU - testo: L'unione civile di #1 #2 con #3 #4 e' stata dichiarata nulla con sentenza del #5 #6 in data #7 , n. #8 annotata nei registri di unioni civili del Comune di #9 , anno #10 ,parte #11 , serie #12 , n. #13 .
-- 139-SEXIES - testo: Con sentenza del #1 #2 in data #3 , n. #4 , annotata nei registri di unioni civili del Comune di #5 , anno #6 , parte #7 , serie #8 , n. #9 , e' stato pronunciato lo scioglimento dell'unione civile di #10 #11 con #12 #13
-- 139-SEPTIE - testo: L'unione civile di #1 #2 con #3 #4 e' stata sciolta con sentenza del #5 #6 , in data #7 , n. #8 , riconosciuta efficace in Italia e trascritta nei registri di unioni civili del Comune di #9 , anno #10 , parte #11 , n. #12
-- 139-OCTIES - testo: Con convenzione di negoziazione assistita dagli avvocati #1 #2 #3 #4 , in data #5 , trascritta nei registri di unioni civili dell'ufficio dello stato civile del Comune di #6 , anno #7 , parte #8 , n #9 , e' stato concluso l'accordo di scioglimento dell'unione civile di #10 #11 con #12 #13 .
-- 139-NONIES - testo: Con accordo ricevuto dall'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei registri di unioni civili del predetto ufficio dello stato civile, al n. #3 parte #4 , e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #5 parte #6 , e' stata sciolta l'unione civile di #7 #8 con #9 #10 .
--
  if a_tipo_atto = 2 and a_formula in ('139-BIS','139-TER','139-QUINQU','139-SEXIES','139-SEPTIE','139-OCTIES','139-NONIES') then
--dbms_output.put_line('unone civile su atto di nascita');
     begin
       select -- C1
              decode(a_formula,
                '139-BIS'   , decode(a_soggetto_rif,1,a_cognome_nome_1,2,a_cognome_nome_2),
                '139-TER'   , decode(a_soggetto_rif,1,a_cognome_nome_1,2,a_cognome_nome_2),
                '139-QUINQU', decode(a_soggetto_rif,1,a_cognome_nome_1,2,a_cognome_nome_2),
                '139-SEXIES', 'Tribunale di',
                '139-SEPTIE', decode(a_soggetto_rif,1,a_cognome_nome_1,2,a_cognome_nome_2),
                '139-OCTIES', decode(a_soggetto_rif,1,a_avvocato_1_div,2,a_avvocato_2_div),
                '139-NONIES', w_des_cliente),
              -- C2
              decode(a_formula,
                '139-BIS'   , decode(a_soggetto_rif,1,a_cognome_nome_2,2,a_cognome_nome_1),
                '139-TER'   , decode(a_soggetto_rif,1,a_cognome_nome_2,2,a_cognome_nome_1),
                '139-QUINQU', to_char(null),
                '139-SEXIES', a_des_com_evento,
                '139-SEPTIE', to_char(null),
                '139-OCTIES', to_char(null),
                '139-NONIES', a_data_accordo_div),
              -- C3
              decode(a_formula,
                '139-BIS'   , a_data_evento,
                '139-TER'   , a_data_evento,
                '139-QUINQU', decode(a_soggetto_rif,1,a_cognome_nome_2,2,a_cognome_nome_1),
                '139-SEXIES', a_data_evento,
                '139-SEPTIE', decode(a_soggetto_rif,1,a_cognome_nome_2,2,a_cognome_nome_1),
                '139-OCTIES', a_avvocato_2_div,
                '139-NONIES', w_atto_accordo_div),
              -- C4
              decode(a_formula,
                '139-BIS'   , a_des_com_evento,
                '139-TER'   , to_char(null),
                '139-QUINQU', to_char(null),
                '139-SEXIES', to_char(null),
                '139-SEPTIE', to_char(null),
                '139-OCTIES', to_char(null),
                '139-NONIES', w_parte_accordo_div),
              -- C5
              decode(a_formula,
                '139-BIS'   , decode(a_natura_atto,'O','iscritto','trascritto'),
                '139-TER'   , to_char(null),
                '139-QUINQU', to_char(null),
                '139-SEXIES', w_des_cliente,
                '139-SEPTIE', 'Tribunale di',
                '139-OCTIES', a_data_evento,
                '139-NONIES', w_numero_atto),
              -- C6
              decode(a_formula,
                '139-BIS'   , w_des_cliente,
                '139-TER'   , to_char(null),
                '139-QUINQU', to_char(null),
                '139-SEXIES', w_anno_atto,
                '139-SEPTIE', a_des_com_evento,
                '139-OCTIES', w_des_cliente,
                '139-NONIES', w_parte_atto),
              -- C7
              decode(a_formula,
                '139-BIS'   , w_anno_atto,
                '139-TER'   , to_char(null),
                '139-QUINQU', to_char(null),
                '139-SEXIES', w_parte_atto,
                '139-SEPTIE', a_data_evento,
                '139-OCTIES', w_anno_atto,
                '139-NONIES', decode(a_soggetto_rif,1,a_cognome_nome_1,2,a_cognome_nome_2)),
              -- C8
              decode(a_formula,
                '139-BIS'   , w_parte_atto,
                '139-TER'   , to_char(null),
                '139-QUINQU', to_char(null),
                '139-SEXIES', w_serie_atto,
                '139-SEPTIE', to_char(null),
                '139-OCTIES', w_parte_atto,
                '139-NONIES', to_char(null)),
              -- C9
              decode(a_formula,
                '139-BIS'   , w_numero_atto,
                '139-TER'   , to_char(null),
                '139-QUINQU', w_des_cliente,
                '139-SEXIES', w_numero_atto,
                '139-SEPTIE', w_des_cliente,
                '139-OCTIES', w_numero_atto,
                '139-NONIES', decode(a_soggetto_rif,1,a_cognome_nome_2,2,a_cognome_nome_1)),
              -- C10
              decode(a_formula,
                '139-BIS'   , to_char(null),
                '139-TER'   , w_des_cliente,
                '139-QUINQU', w_anno_atto,
                '139-SEXIES', decode(a_soggetto_rif,1,a_cognome_nome_1,2,a_cognome_nome_2),
                '139-SEPTIE', w_anno_atto,
                '139-OCTIES', decode(a_soggetto_rif,1,a_cognome_nome_1,2,a_cognome_nome_2),
                '139-NONIES', to_char(null)),
              -- C11
              decode(a_formula,
                '139-BIS'   , to_char(null),
                '139-TER'   , w_anno_atto,
                '139-QUINQU', w_parte_atto,
                '139-SEXIES', to_char(null),
                '139-OCTIES', to_char(null),
                '139-NONIES', to_char(null)),
              -- C12
              decode(a_formula,
                '139-BIS'   , to_char(null),
                '139-TER'   , w_parte_atto,
                '139-QUINQU', w_serie_atto,
                '139-SEXIES', decode(a_soggetto_rif,1,a_cognome_nome_2,2,a_cognome_nome_1),
                '139-SEPTIE', w_parte_atto,
                '139-OCTIES', decode(a_soggetto_rif,1,a_cognome_nome_2,2,a_cognome_nome_1),
                '139-NONIES', to_char(null)),
              -- C13
              decode(a_formula,
                '139-BIS'   , to_char(null),
                '139-TER'   , w_numero_atto,
                '139-QUINQU', w_numero_atto,
                '139-SEXIES', to_char(null),
                '139-SEPTIE', w_numero_atto,
                '139-OCTIES', to_char(null),
                '139-NONIES', to_char(null))
         into w_c1, w_c2, w_c3, w_c4, w_c5, w_c6, w_c7, w_c8, w_c9, w_c10, w_c11, w_c12, w_c13
         from dual
       ;
--dbms_output.put_line('dopo sel_civuci_v');
     exception
        when others then
--dbms_output.put_line('dopo sel_civuci_v - errore');
             w_errore := 'errore in recupero campo (formula: '||a_formula||')';
             raise errore;
     end;
  end if;

--
-- unione civile su atto di matrimonio
-- 173-BIS    - testo: Le parti del matrimonio di cui all'atto controscritto hanno costituito unione civile tra persone dello stesso sesso a seguito di sentenza di rettificazione di attribuzione di sesso di #1 #2 , pronunciata dal #3 #4 , n. #5 , in data #6 . L'atto fu iscritto nei registri di unioni civili di questo Comune, anno #7 , parte #8 , n. #9 ,in esecuzione dell'ordine di cui alla summenzionata sentenza
--
  if a_tipo_atto = 4 and a_formula in ('173-BIS') then
--dbms_output.put_line('unone civile su atto di matrimonio');
     begin
       select -- C1
              decode(a_formula,'173-BIS',to_char(null)),
              -- C2
              decode(a_formula,'173-BIS',to_char(null)),
              -- C3
              decode(a_formula,'173-BIS',to_char(null)),
              -- C4
              decode(a_formula,'173-BIS',DECODE(a_trib_sentenza_ucn, null, '', 'Tribunale di ' ||a_trib_sentenza_ucn)),
              -- C5
              decode(a_formula,'173-BIS',a_num_sentenza_ucn),
              -- C6
              decode(a_formula,'173-BIS',a_data_sentenza_ucn),
              -- C7
              decode(a_formula,'173-BIS',w_anno_atto),
              -- C8
              decode(a_formula,'173-BIS',w_parte_atto),
              -- C9
              decode(a_formula,'173-BIS',w_numero_atto),
              -- 10
              to_char(null)
          into w_c1, w_c2, w_c3, w_c4, w_c5, w_c6, w_c7, w_c8, w_c9, w_c10
         from dual
       ;
--dbms_output.put_line('dopo sel_civuci_v');
     exception
        when others then
--dbms_output.put_line('dopo sel_civuci_v - errore');
             w_errore := 'errore in recupero campo (formula: '||a_formula||')';
             raise errore;
     end;
  end if;

--
-- divorzio su atto di unione civile
-- 187-QUATER - testo: Con dichiarazione resa avanti all'ufficio dello stato civile del Comune di #1 , in data #2 , e' stata manifestata la volonta' di scioglimento dell'unione civile tra persone dello stesso sesso.
-- 187-QUINQU - testo: Con sentenza del #1 #2 n. #3 , in data #4 , e' stato pronunciato lo scioglimento dell'unione civile tra persone dello stesso sesso di cui all'atto controscritto.
-- 187-SEXIES - testo: Con sentenza del #1 #2 n. #3 , in data #4 , e' stata dichiarata efficace nello Stato la pronuncia straniera di #5 #6 , n. #7 , in data #8 di #9  dell'unione civile tra persone dello stesso sesso di cui all'atto controscritto.
-- 187-SEPTIE - testo: Con convenzione di negoziazione assistita dagli avvocati #1 #2 #3 #4 , in data #5 , trascritta nei registri di unione civile dell'ufficio dello stato civile del Comune di #6 , anno #7 , parte #8 , n. #9 , e' stato concluso l'accordo di scioglimento dell'unione civile tra persone dello stesso sesso di cui all'atto controscritto.
-- 187-OCTIES - testo: Con accordo ricevuto dall'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei registri di unione civile del predetto ufficio dello stato civile, al n #3 parte #4 , e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #5 parte #6 , e' stata sciolta l'unione civile tra persone dello stesso sesso di cui all'atto controscritto.
-- 19-UCI     - testo: Con accordo concluso innanzi all'Ufficiale di Stato Civile del Comune di #1 , in data #2 , di cui all'atto iscritto nel registro delle unioni civili del predetto ufficio dello stato civile, al N. #3 Parte #4  Serie #5 , e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al N. #6 Parte #7 Serie #8 , e' stata sciolta l'unione civile annotata in data #9
-- 20-UCI     - testo: Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , trascritta nel registro delle unioni civili del Comune di #4 , al N. #5 Parte #6 Serie #7 , e' stato concluso l'accordo di scioglimento dell'unione civile di #8 con #9 di cui all'annotazione in data #10
--
  if a_tipo_atto = -4 and a_formula in ('187-QUATER','187-QUINQU','187-SEXIES','187-SEPTIE','187-OCTIES','19-UCI','20-UCI') then
--dbms_output.put_line('divorzio su atto di unione civile');
     begin
       select -- C1
              decode(a_formula,
                '187-QUATER', w_des_cliente,
                '187-QUINQU', 'Tribunale di',
                '187-SEXIES', 'Tribunale di',
                '187-SEPTIE', a_avvocato_1_div,
                '187-OCTIES', w_des_cliente,
                '19-UCI',     w_des_cliente,
                '20-UCI',     a_avvocato_1_div,''),
              -- C2
              decode(a_formula,
                '187-QUATER', a_data_evento,
                '187-QUINQU', a_des_com_evento,
                '187-SEXIES', a_des_com_evento,
                '187-SEPTIE', to_char(null),
                '187-OCTIES', w_data_accordo_div),
              -- C3
              decode(a_formula,
                '187-QUATER', to_char(null),
                '187-QUINQU', to_char(null),
                '187-SEXIES', to_char(null),
                '187-SEPTIE', a_avvocato_2_div,
                '187-OCTIES', w_atto_accordo_div),
              -- C4
              decode(a_formula,
                '187-QUATER', to_char(null),
                '187-QUINQU', a_data_evento,
                '187-SEXIES', a_data_evento,
                '187-SEPTIE', to_char(null),
                '187-OCTIES', w_parte_accordo_div),
              -- C5
              decode(a_formula,
                '187-QUATER', to_char(null),
                '187-QUINQU', to_char(null),
                '187-SEXIES', to_char(null),
                '187-SEPTIE', a_data_evento,
                '187-OCTIES', w_numero_atto),
              -- C6
              decode(a_formula,
                '187-QUATER', to_char(null),
                '187-QUINQU', to_char(null),
                '187-SEXIES', to_char(null),
                '187-SEPTIE', w_des_cliente,
                '187-OCTIES', w_parte_atto),
              -- C7
              decode(a_formula,
                '187-QUATER', to_char(null),
                '187-QUINQU', to_char(null),
                '187-SEXIES', to_char(null),
                '187-SEPTIE', w_anno_atto,
                '187-OCTIES', to_char(null)),
              -- C8
              decode(a_formula,
                '187-QUATER', to_char(null),
                '187-QUINQU', to_char(null),
                '187-SEXIES', to_char(null),
                '187-SEPTIE', w_parte_atto,
                '187-OCTIES', to_char(null)),
              -- C9
              decode(a_formula,
                '187-QUATER', to_char(null),
                '187-QUINQU', to_char(null),
                '187-SEXIES', to_char(null),
                '187-SEPTIE', w_numero_atto,
                '187-OCTIES', to_char(null)),
              -- C10
              to_char(null)
         into w_c1, w_c2, w_c3, w_c4, w_c5, w_c6, w_c7, w_c8, w_c9, w_c10
         from dual
       ;
--dbms_output.put_line('dopo sel_civuci_v');
     exception
        when others then
--dbms_output.put_line('dopo sel_civuci_v - errore');
             w_errore := 'errore in recupero campo (formula: '||a_formula||')';
             raise errore;
     end;
  end if;

--
-- cittadinanza su atto di nascita (superate - vecchio ordinamento)
-- 140        - testo: #1 ha #2 la cittadinanza italiana, come risulta da #3 #4 #5 #6 #7 #8 #9 #10 L'atto fu iscritto/trascritto nei registri di cittadinanza del Comune di #11  in data #12 N. #13.
-- 140-BIS    - testo: #1 in data #2 ha reso dinanzi a #3 dichiarazione con la quale #4 #5 #6 #7 #8 #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20
-- 140-TER    - testo: #1 in data #2 ha reso dinanzi a #3 dichiarazione con la quale ha comunicato che #4 #5 #6 #7 #8 #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20
--
-- cittadinanza su atto di nascita (nuovo ordinamento)
-- 140-NO     - testo: A seguito di atto o provvedimento #1 , #2 , #3 ,                                                             #4                   ha #5                                                           la cittadinanza italiana.
-- da formulario     : A seguito di atto o provvedimento (specificare la natura, data e provenienza dell'atto o del provvedimento), ... (nome e cognome) ha acquistato (ovvero: perduto; o: rinunciato; o: riacquistato) la cittadinanza italiana.
-- 140-BIS-NO - testo: #1                   in data #2  ha reso dinanzi a #3  dichiarazione con la quale #4 #5 #6 #7 #8 #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20
-- da formulario     : ... (nome e cognome) in data ... ha reso dinanzi a ... dichiarazione con la quale (riassumere brevemente il contenuto della dichiarazione; indicare, inoltre, il registro in cui la dichiarazione e' stata iscritta con la data ed il numero di iscrizione) ...
-- 140-QUA-NO - testo: A seguito di richiesta in data #1 , e' stato verificato il possesso ininterrotto della cittadinanza italiana nei riguardi di #2 .
-- da formulario     : A seguito di richiesta in data ..., e' stato verificato il possesso ininterrotto della cittadinanza italiana nei riguardi di ... (indicare nome e cognome).
-- 140-QUI-NO - testo: Con atto del #1                                                         in data #2  N. #3  e' stato accertato che #4                  #5 #6        cittadino italiano.
-- da formulario     : Con atto del ... (indicare l'Autorita' che ha effettuato l'accertamento) in data ... n. ... e' stato accertato che ... (nome e cognome) e' (o: non e') cittadino(a) italiano(a).
-- 140-SEX-NO - testo: Con atto del #1                                                         in data #2  N. #3  ha attestato che #4                           #5 #6       cittadino italiano.
-- da formulario     : Con atto del ... (indicare l'Autorita' che ha effettuato l'accertamento) in data ... n. ... ha attestato che ... che ... (nome e cognome) e' (o: non e') cittadino(a) italiano(a).
--
  if a_tipo_atto = 2 and a_formula like '140%-NO' then
     w_testo_riassunto := substr(a_testo_riassunto,1,4000);
     begin
--dbms_output.put_line('cittadinanza su atto di nascita');
       select -- C1
              decode(a_formula,
                '140-NO'    , rpad('_',30,'_'),	-- dati provvedimento
                '140-BIS-NO', nvl(a_cognome_nome_1,rpad('_',30,'_')),
                '140-QUA-NO', nvl(a_data_evento,rpad('_',10,'_')),	-- data_richiesta
                '140-QUI-NO', 'Sindaco del Comune di '||w_des_cliente,
                '140-SEX-NO', 'Sindaco del Comune di '||w_des_cliente),
              -- C2
              decode(a_formula,
                '140-NO'    , rpad('_',30,'_'),	-- dati provvedimento
                '140-BIS-NO', nvl(a_data_evento,rpad('_',10,'_')),
                '140-QUA-NO', nvl(a_cognome_nome_1,rpad('_',30,'_')),
                '140-QUI-NO', nvl(a_data_evento,rpad('_',10,'_')),
                '140-SEX-NO', nvl(a_data_evento,rpad('_',10,'_'))),
              -- C3
              decode(a_formula,
                '140-NO'    , rpad('_',30,'_'),	-- dati provvedimento
                '140-BIS-NO', 'Sindaco del Comune di '||w_des_cliente,
                '140-QUA-NO', to_char(null),
                '140-QUI-NO', nvl(w_numero_atto,'_____'),
                '140-SEX-NO', nvl(w_numero_atto,'_____')),
              -- C4
              decode(a_formula,
                '140-NO'    , nvl(a_cognome_nome_1,rpad('_',30,'_')),
                '140-BIS-NO', w_testo_riassunto,
                '140-QUA-NO', to_char(null),
                '140-QUI-NO', nvl(a_cognome_nome_1,rpad('_',30,'_')),
                '140-SEX-NO', nvl(a_cognome_nome_1,rpad('_',30,'_'))),
              -- C5
              decode(a_formula,
                '140-NO'    , decode(a_natura_atto,'A','acquistato','P','perduto',rpad('_',20,'_')),
                '140-BIS-NO', to_char(null),
                '140-QUA-NO', to_char(null),
                '140-QUI-NO', decode(a_natura_atto,'A','','P','non',''),
                '140-SEX-NO', decode(a_natura_atto,'A','','P','non','')),
              -- C6
              decode(a_formula,
                '140-NO'    , to_char(null),
                '140-BIS-NO', to_char(null),
                '140-QUA-NO', to_char(null),
                '140-QUI-NO', 'e''',
                '140-SEX-NO', 'e''')
         into w_c1, w_c2, w_c3, w_c4, w_c5, w_c6
         from dual
       ;
--dbms_output.put_line('dopo sel_civcit_v');
     exception
        when others then
--dbms_output.put_line('dopo sel_civcit_v - errore');
             w_errore := 'errore in recupero campo (formula: '||a_formula||')';
             raise errore;
     end;
  end if;

<< replace_testo >>

  w_testo := w_testo_tfa;
  w_testo := replace(w_testo,'#30', w_c30);
  w_testo := replace(w_testo,'#29', w_c29);
  w_testo := replace(w_testo,'#28', w_c28);
  w_testo := replace(w_testo,'#27', w_c27);
  w_testo := replace(w_testo,'#26', w_c26);
  w_testo := replace(w_testo,'#25', w_c25);
  w_testo := replace(w_testo,'#24', w_c24);
  w_testo := replace(w_testo,'#23', w_c23);
  w_testo := replace(w_testo,'#22', w_c22);
  w_testo := replace(w_testo,'#21', w_c21);
  w_testo := replace(w_testo,'#20', w_c20);
  w_testo := replace(w_testo,'#19', w_c19);
  w_testo := replace(w_testo,'#18', w_c18);
  w_testo := replace(w_testo,'#17', w_c17);
  w_testo := replace(w_testo,'#16', w_c16);
  w_testo := replace(w_testo,'#15', w_c15);
  w_testo := replace(w_testo,'#14', w_c14);
  w_testo := replace(w_testo,'#13', w_c13);
  w_testo := replace(w_testo,'#12', w_c12);
  w_testo := replace(w_testo,'#11', w_c11);
  w_testo := replace(w_testo,'#10', w_c10);
  w_testo := replace(w_testo,'#9' , w_c9);
  w_testo := replace(w_testo,'#8' , w_c8);
  w_testo := replace(w_testo,'#7' , w_c7);
  w_testo := replace(w_testo,'#6' , w_c6);
  w_testo := replace(w_testo,'#5' , w_c5);
  w_testo := replace(w_testo,'#4' , w_c4);
  w_testo := replace(w_testo,'#3' , w_c3);
  w_testo := replace(w_testo,'#2' , w_c2);
  w_testo := replace(w_testo,'#1' , w_c1);

<< fine >>

  if nvl(w_flag_ansc,'N') = 'S' and w_aggiungi_nota = 1 then
     if instr(w_testo,'(*)') > 0 then
        w_testo := w_testo||'[(*) numero unico comunale in attesa di validazione ANSC]';
     end if;
  end if;

  return w_testo;

exception
  when errore then
       raise_application_error(-20999, w_errore);
  when others then
       w_errore := 'errore (formula: '||a_formula||')';
       raise_application_error(-20999, w_errore);
end;
/
