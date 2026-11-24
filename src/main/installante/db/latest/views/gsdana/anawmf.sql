--liquibase formatted sql
--changeset amonopoli:202410091525_4 runOnChange:true stripComments:false
create or replace view ANAWMF
	(MATRICOLA_FAM, COGNOME_NOME, COGNOME, NOME, PATERNITA, MATERNITA,
	 DATA_NAS, DATA_NAS_EDIT, DES_COM_NAS, ATTO_NAS, 
	 SEQUENZA, RAPPORTO_PAR, RAPPORTO_PAR_EDIT,
	 STATO_CIVILE, DATA_MAT_VED, ATTO_MAT_VED, DES_COD_VIA, COGNOME_NOME_CN,
	 SESSO, DI_SESSO, 
	 TITOLO_STUDIO,  DES_TITOLO_STUDIO,  PROFESSIONE, DES_COD_PROF, 
         NAZIONALITA, DES_NAZIONALITA,
	 COD_FISCALE, DES_CF_VALIDATO, DES_COD_FISCALE, 
         DATA_EVE, DES_COM_EVE, DES_COM_ISCR_AIRE,
	 PRATICA_EDIT, VIA_AIRE, DES_COM_AIRE, EVENTO,
	 MATRICOLA,  COD_EVE, COD_MOV, PRATICA, ANNO_PRATICA, DATA_REG,
	 INIBIZIONE_ESPATRIO,
	 MATRICOLA_MILITARE, CLASSE_LEVA, NUMERO_LISTA, DES_ESITO, DES_COM_LEVA, DES_COM_DISTRETTO, 
	 DATA_ARRUOLAMENTO, DATA_CHIAMATA, DATA_CONGEDO, DES_ARMA, DES_CORPO, FORZA, DES_GRADO)
AS
SELECT 
-- MATRICOLA_FAM
	mov.matricola ,
-- COGNOME_NOME
	TRANSLATE(mov.cognome_nome,'/',' ') ,
-- COGNOME
	SUBSTR(mov.cognome_nome,1,instr(mov.cognome_nome,'/')-1) ,
-- NOME
	SUBSTR(mov.cognome_nome,instr(mov.cognome_nome,'/')+1) ,
-- PATERNITA
	'pt. '||mov.paternita ,
-- MATERNITA
	'mt. '||TRANSLATE(mov.maternita,'/',' ') ,
-- DATA_NAS
	decode(mov.anno_nas,'S',
          '00/00/'||TO_CHAR(TO_DATE(mov.data_nas,'j'),'yyyy'),
          TO_CHAR(TO_DATE(mov.data_nas,'j'),'dd/mm/yyyy')),
-- DATA_NAS_EDIT
	DECODE(mov.sesso,'F','nata il ','nato il ')||
	  decode(mov.anno_nas,'S',
	    '00/00/'||TO_CHAR(TO_DATE(mov.data_nas,'j'),'yyyy'),
	    TO_CHAR(TO_DATE(mov.data_nas,'j'),'dd/mm/yyyy')),
-- DES_COM_NAS
	f_comune_al(mov.cod_pro_nas,mov.cod_com_nas,mov.data_nas)||' '||
        f_provincia_stato_al(mov.cod_pro_nas,mov.cod_com_nas,null,'S','S',mov.data_nas),
-- ATTO_NAS
	'atto N. '||mov.atto_nas||' p. '||DECODE(mov.parte_nas,1,'I',2,'II')||
	  DECODE(mov.serie_nas,'','',' s. '||mov.serie_nas)||
	  DECODE(mov.ufficio_nas,0,'','','',' - '||mov.ufficio_nas)||
	  ' / '||mov.anno_atto_nas||' '||
	  f_comune_al(mov.cod_pro_atto_nas,mov.cod_com_atto_nas,mov.data_nas)||' '||
	  f_provincia_stato_al(mov.cod_pro_atto_nas,mov.cod_com_atto_nas,null,'S','S',mov.data_nas),
-- SEQUENZA
	drp.sequenza ,
-- RAPPORTO_PAR
	mov.rapporto_par ,
-- RAPPORTO_PAR_EDIT
	drp.descrizione ,
-- STATO_CIVILE
	decode(dsc.cod_sc,'DV',dsc.descrizione, 'GC',dsc.descrizione, dsc.descrizione_cer) ,
-- DATA_MAT_VED
	case
           when mov.stato_civile in ('CN','UC') then
	        'il '||decode(mov.anno_mat,'S',
	              '00/00/'||TO_CHAR(TO_DATE(mov.data_mat,'j'),'yyyy'),
	              TO_CHAR(TO_DATE(mov.data_mat,'j'),'dd/mm/yyyy'))||
	        ' a '||f_comune_al(mov.cod_pro_mat,mov.cod_com_mat,mov.data_mat)||' '||
	              f_provincia_stato_al(mov.cod_pro_mat,mov.cod_com_mat,null,'S','S',mov.data_mat)  
           when mov.stato_civile in ('VE','VU') then
	        'dal '||TO_CHAR(TO_DATE(mov.data_ved,'j'),'dd/mm/yyyy')||
	        ' a '||f_comune_al(mov.cod_pro_ved,mov.cod_com_ved,mov.data_ved)||' '||
	              f_provincia_stato_al(mov.cod_pro_ved,mov.cod_com_ved,null,'S','S',mov.data_ved)
           when mov.stato_civile in ('DV','GC','GU') then
	        'dal '||TO_CHAR(TO_DATE(mov.data_div,'j'),'dd/mm/yyyy')||
	        ' a '||f_comune_al(mov.cod_pro_div,mov.cod_com_div,mov.data_div)||' '||
	              f_provincia_stato_al(mov.cod_pro_div,mov.cod_com_div,null,'S','S',mov.data_div)
        end,
-- ATTO_MAT_VED
	case 
           when mov.stato_civile in ('CN','UC') then
	        'atto N. '||mov.atto_mat||
	                   DECODE(mov.parte_mat,1,' p. I',2,' p. II')||
	                   DECODE(mov.serie_mat,'','',' s. '||mov.serie_mat)||
	                   DECODE(mov.ufficio_mat,0,'','','',' - '||mov.ufficio_mat)||
	                   ' / '||mov.anno_atto_mat||' '||
	                   DECODE(lpad(mov.cod_pro_atto_mat,3,0)||lpad(mov.cod_com_atto_mat,3,0),'','',
	                  lpad(mov.cod_pro_mat,3,0)||lpad(mov.cod_com_mat,3,0),'',
	        f_comune_al(mov.cod_pro_atto_mat,mov.cod_com_atto_mat,mov.data_mat)||' '||
	        f_provincia_stato_al(mov.cod_pro_atto_mat,mov.cod_com_atto_mat,null,'S','S',mov.data_mat))
           when mov.stato_civile in ('VE','VU') then
                'atto N. '||mov.atto_ved||
	                   DECODE(mov.parte_ved,1,' p. I',2,' p. II')||
	                   DECODE(mov.serie_ved,'','',' s. '||mov.serie_ved)||
	                   DECODE(mov.ufficio_ved,0,'','','',' - '||mov.ufficio_ved)||
	                   ' / '||mov.anno_atto_ved||' '||
	                   DECODE(lpad(mov.cod_pro_atto_ved,3,0)||lpad(mov.cod_com_atto_ved,3,0),'','',
	        lpad(mov.cod_pro_ved,3,0)||lpad(mov.cod_com_ved,3,0),'',
	        f_comune_al(mov.cod_pro_atto_ved,mov.cod_com_atto_ved,mov.data_ved)||' '||
	        f_provincia_stato_al(mov.cod_pro_atto_ved,mov.cod_com_atto_ved,null,'S','S',mov.data_ved))
           when mov.stato_civile in ('DV','GC','GU') then
                decode(mov.atto_div,'','',
                 'atto N. '||mov.atto_div||
	                   DECODE(mov.parte_div,1,' p. I',2,' p. II')||
	                   DECODE(mov.serie_div,'','',' s. '||mov.serie_div)||
	                   DECODE(mov.ufficio_div,0,'','','',' - '||mov.ufficio_div)||
	                   ' / '||mov.anno_atto_div||' '||
	         f_comune_al(mov.cod_pro_atto_div,mov.cod_com_atto_div,mov.data_div)||' '||
	         f_provincia_stato_al(mov.cod_pro_atto_div,mov.cod_com_atto_div,null,'S','S',mov.data_div))
       end,
-- DES_COD_VIA
	DECODE(ARCVIE.denom_uff,'','',
	  'abitante in '||ARCVIE.denom_uff||mov.civico_esterno||mov.civico_interno) ,
-- COGNOME_NOME_CN
	TRANSLATE(mov.cognome_nome_cn,'/',' '),
-- SESSO
	mov.sesso ,
-- DI_SESSO
	DECODE(mov.sesso,'F','di sesso femminile','M','di sesso maschile') ,
-- TITOLO_STUDIO
	ANADTS.descrizione ,
-- DES_TITOLO_STUDIO
	DECODE(ANADTS.descrizione,'','','Titolo di Studio: '||ANADTS.descrizione) ,
-- PROFESSIONE
	DECODE(mov.pensionato,
	  1, NVL(ANADPR.descrizione, DECODE(mov.sesso,'M','PENSIONATO','PENSIONATA')),
	     DECODE(ANADPR.descrizione,'','',ANADPR.descrizione)),
-- DES_COD_PROF
	DECODE(mov.pensionato,
	  1, 'Professione : '||NVL(ANADPR.descrizione, DECODE(mov.sesso,'M','PENSIONATO','PENSIONATA')),
	     DECODE(ANADPR.descrizione,'','','Professione : '||ANADPR.descrizione)),
-- NAZIONALITA
	upper(ANADCI.descrizione) ,
-- DES_NAZIONALITA
	DECODE(mov.nazionalita,'I','Cittadinanza: Italiana','','','Cittadinanza: '||ANADCI.descrizione) ,
-- COD_FISCALE
	mov.cod_fiscale,
-- DES_CF_VALIDATO
	DECODE(mov.cod_fiscale,'','',decode(mov.cf_calcolato,'','(validato)','(non validato)')) ,
-- DES_COD_FISCALE
	DECODE(mov.cod_fiscale,'','',
	  'Cod. Fiscale: '||mov.cod_fiscale||
	  decode(mov.cf_calcolato,'',' (validato)',' (non validato)')) ,
-- DATA_EVE
	TO_CHAR(TO_DATE(mov.data_eve,'j'),'dd/mm/yyyy') ,
-- DES_COM_EVE
	DECODE(g.descrizione,'',
          DECODE(com_ric.descrizione,'','',
            com_ric.descrizione||decode(com_ric.descrizione,'','',' ('||g.sigla_provincia||')')),
          g.descrizione||decode(g0.descrizione,'',' ('||g.sigla_provincia||')',' ('||g0.descrizione||')')) ,
-- DES_COM_ISCR_AIRE
	DECODE(i.descrizione,'','',i.descrizione||
	  decode(i0.descrizione,'', ' ('||i.sigla_provincia||')',' ('||i0.descrizione||')')) ,
-- PRATICA_EDIT
	DECODE(mov.pratica,'','','pratica '||mov.pratica||'/'||mov.anno_pratica) ,
-- VIA_AIRE
	DECODE(mov.via_aire,'','',mov.via_aire) ,
-- DES_COM_AIRE
	DECODE(h.descrizione,'','',h.descrizione||
	  decode(h0.descrizione,'', ' ('||h.sigla_provincia||')',' ('||h0.descrizione||')')) ,
-- EVENTO
--	DECODE(mov.cod_eve,
--	  7,DECODE(mov.sesso,'F','E'' passata nell''A.I.R.E. il', 'E'' passato nell''A.I.R.E. il'),
--	 51,DECODE(mov.sesso,'F','E'' Emigrata il','E'' Emigrato il'),
--	 55,DECODE(mov.sesso,'F','E'' Emigrata il','E'' Emigrato il'),''),
        f_scaw_evento(mov.cod_eve,mov.cod_mov,mov.sesso,mov.cod_variazione,'',''),
-- MATRICOLA
	mov.matricola,
-- COD_EVE
	mov.cod_eve,
-- COD_MOV
	mov.cod_mov,
-- PRATICA
	mov.pratica,
-- ANNO_PRATICA
	mov.anno_pratica,
-- DATA_REG
	nvl(eve_ric.data_Ric,mov.data_reg),
-- INIBIZIONE_ESPATRIO
        decode(ana.val_espatrio,'N','ATTENZIONE: Inibizione all''Espatrio'||
          decode(ana.data_val_espatrio,'','',' fino al '||to_char(to_date(ana.data_val_espatrio,'j'),'dd/mm/yyyy'))),
-- MATRICOLA_MILITARE     
	decode(lev.matricola_mil,'','','Matricola Militare: '||lev.matricola_mil),
-- CLASSE_LEVA            
	decode(lev.classe,'','','Classe di Leva: '||lev.classe),
-- NUMERO_LISTA           
	decode(lev.numero_lista,'','','Numero Lista: '||lev.numero_lista),
-- DES_ESITO                  
	decode(des.descrizione,'','','Esito: '||des.descrizione),
-- DES_COM_LEVA            
	decode(n.descrizione,'','',
          'Comune Leva: '||n.descrizione||' ('||n.sigla_provincia||')'),
-- DES_COM_DISTRETTO       
	decode(o.descrizione,'','',
          'Comune Distretto: '||o.descrizione||' ('||o.sigla_provincia||')'),
-- DATA_ARRUOLAMENTO      
	decode(lev.data_arr,'','',
          'Data Arruolamento: '||to_char(to_date(lev.data_arr,'j'),'dd/mm/yyyy')),
-- DATA_CHIAMATA          
	decode(lev.data_chi,'','',
          'Data Chiamata: '||to_char(to_date(lev.data_chi,'j'),'dd/mm/yyyy')),
-- DATA_CONGEDO           
	decode(lev.data_con,'','',
          'Data Congedo: '||to_char(to_date(lev.data_con,'j'),'dd/mm/yyyy')),
-- DES_ARMA                   
	decode(dar.descrizione,'','','Arma: '||dar.descrizione),
-- DES_CORPO           
	decode(dcr.descrizione,'','','Corpo: '||dcr.descrizione),       
-- FORZA
	decode(lev.forza,'','','Forza: '||translate(lev.forza,';"','  ')),
-- DES_GRADO                  
	decode(dgr.descrizione,'','','Grado: '||dgr.descrizione)
  FROM arccom com_ric,
       arccom g, arccom h, arccom i, 
       arccom g0, arccom h0, arccom i0,
       arccom n, arccom o,
       ANADCI,ARCVIE,ANADTS,ANADPR,
       ANADRP drp,ANADSC dsc,
       levdes des, levdar dar, levdco dcr, levdgr dgr, levruo lev,
       anaana ana, anaeve eve_ric, ANAMOV mov
 WHERE com_ric.cod_provincia (+) = eve_ric.cod_pro_ric
   and com_ric.cod_comune    (+) = eve_ric.cod_com_ric
   and eve_ric.matricola     (+) = mov.matricola
   and eve_ric.cod_mov       (+) = mov.cod_mov
   and eve_ric.cod_eve       (+) = mov.cod_eve
   and eve_ric.data_eve      (+) = mov.data_eve
   and eve_ric.pratica       (+) = mov.pratica
   and eve_ric.anno_pratica  (+) = mov.anno_pratica
   and eve_ric.data_reg      (+) = mov.data_reg
   and g0.cod_provincia (+) = mov.cod_pro_eve
   AND g0.cod_comune    (+) = 0
   AND g.cod_provincia  (+) = mov.cod_pro_eve
   AND g.cod_comune     (+) = mov.cod_com_eve
   AND h0.cod_provincia (+) = mov.cod_pro_aire
   AND h0.cod_comune    (+) = 0
   AND h.cod_provincia  (+) = mov.cod_pro_aire
   AND h.cod_comune     (+) = mov.cod_com_aire
   AND i0.cod_provincia (+) = mov.cod_pro_iscr_aire
   AND i0.cod_comune    (+) = 0
   AND i.cod_provincia  (+) = mov.cod_pro_iscr_aire
   AND i.cod_comune     (+) = mov.cod_com_iscr_aire
   and n.cod_provincia  (+) = lev.cod_pro_lev
   and n.cod_comune     (+) = lev.cod_com_lev
   and o.cod_provincia  (+) = lev.cod_pro_dis
   and o.cod_comune     (+) = lev.cod_com_dis
   and dgr.cod_gr       (+) = lev.grado
   and dcr.cod_co       (+) = lev.corpo
   and dar.cod_ar       (+) = lev.arma   
   and des.cod_es       (+) = lev.esito
   and lev.matricola    (+) = mov.matricola
   AND mov.rapporto_par     = cod_rp (+)
   AND mov.sesso            = drp.sesso (+)
   AND mov.stato_civile     = dsc.cod_sc (+)
   AND mov.sesso            = dsc.sesso (+)
   AND mov.nazionalita      = cod_ci (+)
   AND mov.cod_via          = ARCVIE.cod_via (+)
   AND mov.titolo_studio    = ANADTS.cod_ts (+)
   AND mov.cod_prof         = ANADPR.cod_pr (+) 
   AND mov.sesso            = ANADPR.sesso (+)
   and ana.matricola        = mov.matricola
/
comment on table anawmf is 'Anagrafe - Dati famiglia per Stampe (view)'
/
