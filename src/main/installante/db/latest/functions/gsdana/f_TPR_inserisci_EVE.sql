--liquibase formatted sql
--changeset amonopoli:202510021425 runOnChange:true stripComments:false
create or replace function f_TPR_inserisci_EVE
(a_anagrafe		IN	varchar2
,a_tipo_evento		IN	varchar
,a_anno_pratica		IN	number
,a_pratica		IN	number
,a_terminalista		IN	varchar2
,a_flag_annullamento	IN	varchar2
)

return number

IS

w_anagrafe	varchar2(255) := upper(a_anagrafe);
w_tipo_evento	varchar2(255) := upper(a_tipo_evento);

w_MATRICOLA             number;
w_COD_MOV               number;
w_COD_EVE               number;
w_DATA_INIZIO           number;
w_DATA_EVE              number;
w_COD_PRO_EVE           number;
w_COD_COM_EVE           number;
w_ANNO_PRATICA          number;
w_PRATICA               number;
w_COD_EVE_PR            number;
w_COD_FAM               number;
w_RAPPORTO_PAR		varchar2(255);
w_COD_VIA               number;
w_NUM_CIV               number;
w_SUFFISSO              varchar2(255);
w_INTERNO               number;
w_VIA_AIRE              varchar2(255);
w_COD_PRO_AIRE          number;
w_COD_COM_AIRE          number;
w_DATA_REG              number;
w_DATA_RIC              number;
w_COD_PRO_RIC           number;
w_COD_COM_RIC           number;
w_ANNO_PRATICA_RIC      number;
w_PRATICA_RIC           number;
w_COD_VARIAZIONE        varchar2(255);
w_SCALA                 varchar2(255);
w_PIANO                 varchar2(255);
w_ZIPCODE               varchar2(255);
w_COD_PRO_ISCR_AIRE	number;
w_COD_COM_ISCR_AIRE	number;
w_PROVINCIA_CONTEA      varchar2(255);
w_PRESSO                varchar2(255);
w_SUB_INTERNO           varchar2(255);
w_CIVICO_ESTERNO        varchar2(255);
w_CIVICO_INTERNO        varchar2(255);
w_D_DATA_INIZIO         date;
w_D_DATA_EVE            date;
w_D_DATA_REG            date;
w_D_DATA_RIC            date;
w_COD_FAM_UNIQUE        varchar2(255);
--
w_FLAG_METRICO          VARCHAR2(255);
w_PROGR_SNC             VARCHAR2(255);
w_FLAG_LETTERA          VARCHAR2(255);
w_FLAG_ESPONENTE        VARCHAR2(255);
w_FLAG_NUI              VARCHAR2(255);
w_NUI                   VARCHAR2(255);
w_COLORE                VARCHAR2(255);
w_CORTE                 VARCHAR2(255);
w_INTERNO2              NUMBER;
w_SUB_INTERNO2          VARCHAR2(255);
w_SECONDARIO            VARCHAR2(255);
w_SCALA_ESTERNA         VARCHAR2(255);

cursor sel_apm_perf is
select apm.ist_rp w_ord_1
--
     , dce.cod_mov
     , dce.cod_eve
     , dce.cod_variazione
     , nvl(to_char(tpr.d_data_decorrenza,'j'),tpr.data_pratica) data_eve
     , ap4.cod_fam_prov
     , ap4.cod_pro_eve
     , ap4.cod_com_eve
     , ap4.cod_pro_iscr_aire
     , ap4.cod_com_iscr_aire
     , ana.matricola
     , apm.fascia_ripristino
     , apm.stato_ripristino
  from anadce dce
     , anaana ana
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where dce.anagrafe        = tpr.anagrafe
   and dce.tipo_evento     = tpr.tipo_evento
   and dce.tipo_evento_tpr = tpr.cod_variazione
   and ana.matricola       = apm.matricola
   and apm.flag_soggetto   = 'S'
   and (nvl(apm.annullamento,'N') = 'N' and nvl(a_flag_annullamento,'N') = 'N')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
 order by 1
;

cursor sel_apm_prov is
select nvl(apm.sequenza_par_ripristino,apm.sequenza_par_prec)	w_ord_1
     , apm.ist_rp						w_ord_2
--
     , 12 cod_mov
     , dce.cod_eve
     , dce.cod_eve cod_eve_pr
     , dce.cod_variazione
     , to_char(apm.d_data_inizio_fam_ripristino,'j') data_inizio
     , nvl(to_char(tpr.d_data_decorrenza,'j'),tpr.data_pratica)-1 data_eve
--
     , apm.rapporto_par_ripristino rapporto_par
--
     , apm.cod_fam_ripristino cod_fam
     , f_ana_get_cod_fam_unique(3,apm.cod_fam_ripristino) cod_fam_unique
     , to_char(null) via_aire
     , to_number(null) cod_pro_aire
     , to_number(null) cod_com_aire
     , to_char(null) zipcode
     , to_char(null) provincia_contea
     , to_char(null) presso
--
     , ana.matricola
  from anadce dce
     , anafam fam_prov
     , anaana ana
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where fam_prov.cod_fam_unique = ap4.cod_fam_unique_prov
   and dce.anagrafe        = tpr.anagrafe
   and dce.tipo_evento     = tpr.tipo_evento
   and dce.tipo_evento_tpr = tpr.cod_variazione
   and ana.matricola       = apm.matricola
   and apm.flag_soggetto   = 'S'
   and (apm.annullamento is null and nvl(a_flag_annullamento,'N') = 'N')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
UNION
select nvl(apm.sequenza_par_ripristino,apm.sequenza_par_prec)	w_ord_1
     , apm.ist_rp						w_ord_2
--
     , 13 cod_mov
     , dce.cod_eve
     , dce.cod_eve cod_eve_pr
     , dce.cod_variazione
     , to_char(apm.d_data_inizio_res_ripristino,'j') data_inizio
     , nvl(to_char(tpr.d_data_decorrenza,'j'),tpr.data_pratica)-1 data_eve
--
     , to_char(null) rapporto_par
--
     , to_number(null) cod_fam
     , to_char(null) cod_fam_unique
     , fam_prov.via_aire via_aire
     , fam_prov.cod_pro_aire cod_pro_aire
     , fam_prov.cod_com_aire cod_com_aire
     , fam_prov.zipcode zipcode
     , fam_prov.provincia_contea provincia_contea
     , fam_prov.presso presso
--
     , ana.matricola
  from anadce dce
     , anafam fam_prov
     , anaana ana
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where fam_prov.cod_fam_unique = ap4.cod_fam_unique_prov
   and dce.anagrafe        = tpr.anagrafe
   and dce.tipo_evento     = tpr.tipo_evento
   and dce.tipo_evento_tpr = tpr.cod_variazione
   and ana.matricola       = apm.matricola
   and apm.flag_soggetto   = 'S'
   and (apm.annullamento is null and nvl(a_flag_annullamento,'N') = 'N')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
UNION
select nvl(apm.sequenza_par_ripristino,apm.sequenza_par_prec)	w_ord_1
     , apm.ist_rp						w_ord_2
--
     , 12 cod_mov
     , 90 cod_eve
     , dce.cod_eve cod_eve_pr
     , dce.cod_variazione
     , to_char(apm.d_data_inizio_fam_ripristino,'j') data_inizio
     , nvl(to_char(tpr.d_data_decorrenza,'j'),tpr.data_pratica)-1 data_eve
--
     , apm.rapporto_par_ripristino rapporto_par
--
     , apm.cod_fam_ripristino cod_fam
     , f_ana_get_cod_fam_unique(3,apm.cod_fam_ripristino) cod_fam_unique
     , to_char(null) via_aire
     , to_number(null) cod_pro_aire
     , to_number(null) cod_com_aire
     , to_char(null) zipcode
     , to_char(null) provincia_contea
     , to_char(null) presso
--
     , ana.matricola
  from anadce dce
     , anafam fam_prov
     , anaana ana
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where fam_prov.cod_fam_unique = ap4.cod_fam_unique_prov
   and dce.anagrafe        = tpr.anagrafe
   and dce.tipo_evento     = tpr.tipo_evento
   and dce.tipo_evento_tpr = tpr.cod_variazione
   and ana.matricola       = apm.matricola
   and apm.rapporto_par_ripristino != apm.rapporto_par_prec
   and apm.flag_soggetto   is null
   and (apm.annullamento is null and nvl(a_flag_annullamento,'N') = 'N')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
 order by 1, 2
;

cursor sel_apm_ann is
select eve.id	w_ord_1
     , eve.*
     , eve.rowid rowid_eve
  from anaeve eve
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where eve.cod_mov         in (1,12,13)
   and eve.cod_eve         = 17
   and eve.data_eve        = nvl(to_char(tpr.d_data_decorrenza,'j'),to_char(tpr.d_data_pratica,'j'))
   and eve.matricola       = apm.matricola
   and apm.flag_soggetto   = 'S'
   and (nvl(apm.annullamento,'N') = 'S' or nvl(a_flag_annullamento,'N') = 'S')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
UNION
select eve.id	w_ord_1
     , eve.*
     , eve.rowid rowid_eve
  from anaeve eve
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where eve.cod_mov         = 12
   and eve.cod_eve         = 90
   and eve.data_eve        = nvl(to_char(tpr.d_data_decorrenza,'j'),to_char(tpr.d_data_pratica,'j'))
   and eve.matricola       = apm.matricola
   and apm.flag_soggetto   is null
   and (nvl(apm.annullamento,'N') = 'S' or nvl(a_flag_annullamento,'N') = 'S')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
 order by 1
;

w_return	number;

errore		exception;
w_errore	varchar2(4000);

begin
  w_return := 0;

  if a_anagrafe       is not null and
     a_tipo_evento    is not null and
     a_anno_pratica   is not null and
     a_pratica        is not null
  then
     if w_anagrafe = 'RES' and w_tipo_evento = 'I' then
        for rec in sel_apm_perf loop
            w_MATRICOLA	        := rec.matricola;
            w_COD_MOV           := rec.cod_mov;
            w_COD_EVE           := rec.cod_eve;
            if w_cod_eve = 2 and rec.fascia_ripristino = 2 and rec.stato_ripristino = 51 then
               w_cod_eve := 3;
            end if;
            w_COD_VARIAZIONE    := rec.cod_variazione;
            w_DATA_INIZIO       := '';
            w_DATA_EVE          := rec.data_eve;
            w_COD_PRO_EVE       := rec.cod_pro_eve;
            w_COD_COM_EVE       := rec.cod_com_eve;
            w_COD_PRO_ISCR_AIRE := rec.cod_pro_iscr_aire;
            w_COD_COM_ISCR_AIRE := rec.cod_com_iscr_aire;
            w_ANNO_PRATICA      := a_anno_pratica;
            w_PRATICA           := a_pratica;
            w_COD_EVE_PR        := rec.cod_eve;
            w_COD_FAM           := '';
            w_COD_FAM_UNIQUE    := '';
            w_RAPPORTO_PAR      := '';
            w_COD_VIA           := '';
            w_NUM_CIV           := '';
            w_SUFFISSO          := '';
            w_INTERNO           := '';
            w_SUB_INTERNO       := '';
            w_SCALA             := '';
            w_PIANO             := '';
            w_FLAG_METRICO      := '';
            w_PROGR_SNC         := '';
            w_FLAG_LETTERA      := '';
            w_FLAG_ESPONENTE    := '';
            w_FLAG_NUI          := '';
            w_NUI               := '';
            w_COLORE            := '';
            w_CORTE             := '';
            w_INTERNO2          := '';
            w_SUB_INTERNO2      := '';
            w_SECONDARIO        := '';
            w_SCALA_ESTERNA     := '';
            w_VIA_AIRE          := '';
            w_COD_PRO_AIRE      := '';
            w_COD_COM_AIRE      := '';
            w_ZIPCODE           := '';
            w_COD_PRO_ISCR_AIRE := '';
            w_COD_COM_ISCR_AIRE := '';
            w_PROVINCIA_CONTEA  := '';
            w_PRESSO            := '';
            w_DATA_REG          := to_char(sysdate,'j');
            w_DATA_RIC          := '';
            w_COD_PRO_RIC       := '';
            w_COD_COM_RIC       := '';
            w_ANNO_PRATICA_RIC  := '';
            w_PRATICA_RIC       := '';
            w_CIVICO_ESTERNO    := '';
            w_CIVICO_INTERNO    := '';
            w_D_DATA_INIZIO     := '';
            w_D_DATA_EVE        := '';
            w_D_DATA_REG        := sysdate;
            w_D_DATA_RIC        := '';
            begin
              insert into anaeve
                     (MATRICOLA, COD_MOV, COD_EVE, COD_VARIAZIONE,
                      DATA_INIZIO, DATA_EVE,
                      COD_PRO_EVE, COD_COM_EVE, ANNO_PRATICA, PRATICA, COD_EVE_PR,
                      COD_FAM, COD_FAM_UNIQUE, RAPPORTO_PAR,
                      COD_VIA, NUM_CIV, SUFFISSO, INTERNO, SUB_INTERNO, SCALA, PIANO,
                      FLAG_METRICO, PROGR_SNC, FLAG_LETTERA, FLAG_ESPONENTE,
                      FLAG_NUI, NUI, COLORE, CORTE, INTERNO2, SUB_INTERNO2,
                      SECONDARIO, SCALA_ESTERNA,
                      VIA_AIRE, COD_PRO_AIRE, COD_COM_AIRE, ZIPCODE, COD_PRO_ISCR_AIRE, COD_COM_ISCR_AIRE, PROVINCIA_CONTEA, PRESSO,
                      DATA_REG,
                      DATA_RIC, COD_PRO_RIC, COD_COM_RIC, ANNO_PRATICA_RIC, PRATICA_RIC)
              select w_MATRICOLA, w_COD_MOV, w_COD_EVE, w_COD_VARIAZIONE,
                      w_DATA_INIZIO, w_DATA_EVE,
                      w_COD_PRO_EVE, w_COD_COM_EVE, w_ANNO_PRATICA, w_PRATICA, w_COD_EVE_PR,
                      w_COD_FAM, w_COD_FAM_UNIQUE, w_RAPPORTO_PAR,
                      w_COD_VIA, w_NUM_CIV, w_SUFFISSO, w_INTERNO, w_SUB_INTERNO, w_SCALA, w_PIANO,
                      w_FLAG_METRICO, w_PROGR_SNC, w_FLAG_LETTERA, w_FLAG_ESPONENTE,
                      w_FLAG_NUI, w_NUI, w_COLORE, w_CORTE, w_INTERNO2, w_SUB_INTERNO2,
                      w_SECONDARIO, w_SCALA_ESTERNA,
                      w_VIA_AIRE, w_COD_PRO_AIRE, w_COD_COM_AIRE, w_ZIPCODE, w_COD_PRO_ISCR_AIRE, w_COD_COM_ISCR_AIRE, w_PROVINCIA_CONTEA, w_PRESSO,
                      w_DATA_REG,
                      w_DATA_RIC, w_COD_PRO_RIC, w_COD_COM_RIC, w_ANNO_PRATICA_RIC, w_PRATICA_RIC
                from dual
               where not exists (select 1 from anaeve b
                                  where b.matricola               = w_matricola
                                    and b.cod_mov                 = w_cod_mov
                                    and b.cod_eve                 = w_cod_eve
                                    and nvl(b.cod_variazione,' ') = nvl(w_cod_variazione,' ')
                                    and b.pratica                 = w_pratica
                                    and b.anno_pratica            = w_anno_pratica
                                    and b.data_eve                = w_data_eve)

              ;
              if sql%found then
                 w_return := 1;
              end if;
            exception
              when others then
                   w_errore := 'Errore in ins_anaeve (matricola: '||rec.matricola||')';
                   w_return := -1;
            end;
        end loop;

        for rec in sel_apm_prov loop
            w_MATRICOLA	        := rec.matricola;
            w_COD_MOV           := rec.cod_mov;
            w_COD_EVE           := rec.cod_eve;
            w_COD_VARIAZIONE    := rec.cod_variazione;
            w_DATA_INIZIO       := rec.data_inizio;
            w_DATA_EVE          := rec.data_eve;
            w_COD_PRO_EVE       := '';
            w_COD_COM_EVE       := '';
            w_COD_PRO_ISCR_AIRE := '';
            w_COD_COM_ISCR_AIRE := '';
            w_ANNO_PRATICA      := a_anno_pratica;
            w_PRATICA           := a_pratica;
            w_COD_EVE_PR        := rec.cod_eve_pr;
            w_COD_FAM           := rec.cod_fam;
            w_COD_FAM_UNIQUE    := rec.cod_fam_unique;
            w_RAPPORTO_PAR      := rec.rapporto_par;
            w_COD_VIA           := '';
            w_NUM_CIV           := '';
            w_SUFFISSO          := '';
            w_INTERNO           := '';
            w_SUB_INTERNO       := '';
            w_SCALA             := '';
            w_PIANO             := '';
            w_FLAG_METRICO      := '';
            w_PROGR_SNC         := '';
            w_FLAG_LETTERA      := '';
            w_FLAG_ESPONENTE    := '';
            w_FLAG_NUI          := '';
            w_NUI               := '';
            w_COLORE            := '';
            w_CORTE             := '';
            w_INTERNO2          := '';
            w_SUB_INTERNO2      := '';
            w_SECONDARIO        := '';
            w_SCALA_ESTERNA     := '';
            w_VIA_AIRE          := rec.via_aire;
            w_COD_PRO_AIRE      := rec.cod_pro_aire;
            w_COD_COM_AIRE      := rec.cod_com_aire;
            w_ZIPCODE           := rec.zipcode;
            w_COD_PRO_ISCR_AIRE := '';
            w_COD_COM_ISCR_AIRE := '';
            w_PROVINCIA_CONTEA  := rec.provincia_contea;
            w_PRESSO            := rec.presso;
            w_DATA_REG          := to_char(sysdate,'j');
            w_DATA_RIC          := '';
            w_COD_PRO_RIC       := '';
            w_COD_COM_RIC       := '';
            w_ANNO_PRATICA_RIC  := '';
            w_PRATICA_RIC       := '';
            w_CIVICO_ESTERNO    := '';
            w_CIVICO_INTERNO    := '';
            w_D_DATA_INIZIO     := '';
            w_D_DATA_EVE        := '';
            w_D_DATA_REG        := sysdate;
            w_D_DATA_RIC        := '';
            begin
              insert into anaeve
                     (MATRICOLA, COD_MOV, COD_EVE, COD_VARIAZIONE,
                      DATA_INIZIO, DATA_EVE,
                      COD_PRO_EVE, COD_COM_EVE, ANNO_PRATICA, PRATICA, COD_EVE_PR,
                      COD_FAM, COD_FAM_UNIQUE, RAPPORTO_PAR,
                      COD_VIA, NUM_CIV, SUFFISSO, INTERNO, SUB_INTERNO, SCALA, PIANO,
                      FLAG_METRICO, PROGR_SNC, FLAG_LETTERA, FLAG_ESPONENTE,
                      FLAG_NUI, NUI, COLORE, CORTE, INTERNO2, SUB_INTERNO2,
                      SECONDARIO, SCALA_ESTERNA,
                      VIA_AIRE, COD_PRO_AIRE, COD_COM_AIRE, ZIPCODE, COD_PRO_ISCR_AIRE, COD_COM_ISCR_AIRE, PROVINCIA_CONTEA, PRESSO,
                      DATA_REG,
                      DATA_RIC, COD_PRO_RIC, COD_COM_RIC, ANNO_PRATICA_RIC, PRATICA_RIC)
              select w_MATRICOLA, w_COD_MOV, w_COD_EVE, w_COD_VARIAZIONE,
                      w_DATA_INIZIO, w_DATA_EVE,
                      w_COD_PRO_EVE, w_COD_COM_EVE, w_ANNO_PRATICA, w_PRATICA, w_COD_EVE_PR,
                      w_COD_FAM, w_COD_FAM_UNIQUE, w_RAPPORTO_PAR,
                      w_COD_VIA, w_NUM_CIV, w_SUFFISSO, w_INTERNO, w_SUB_INTERNO, w_SCALA, w_PIANO,
                      w_FLAG_METRICO, w_PROGR_SNC, w_FLAG_LETTERA, w_FLAG_ESPONENTE,
                      w_FLAG_NUI, w_NUI, w_COLORE, w_CORTE, w_INTERNO2, w_SUB_INTERNO2,
                      w_SECONDARIO, w_SCALA_ESTERNA,
                      w_VIA_AIRE, w_COD_PRO_AIRE, w_COD_COM_AIRE, w_ZIPCODE, w_COD_PRO_ISCR_AIRE, w_COD_COM_ISCR_AIRE, w_PROVINCIA_CONTEA, w_PRESSO,
                      w_DATA_REG,
                      w_DATA_RIC, w_COD_PRO_RIC, w_COD_COM_RIC, w_ANNO_PRATICA_RIC, w_PRATICA_RIC
                from dual
               where not exists (select 1 from anaeve b
                                  where b.matricola               = w_matricola
                                    and b.cod_mov                 = w_cod_mov
                                    and b.cod_eve                 = w_cod_eve
                                    and nvl(b.cod_variazione,' ') = nvl(w_cod_variazione,' ')
                                    and b.pratica                 = w_pratica
                                    and b.anno_pratica            = w_anno_pratica
                                    and b.data_eve                = w_data_eve)
              ;
              if sql%found then
                 w_return := 1;
              end if;
            exception
              when others then
                   w_errore := 'Errore in ins_anaeve (matricola: '||rec.matricola||')';
                   w_return := -1;
            end;
        end loop;

        for rec in sel_apm_ann loop
            begin
              delete anaeve
               where matricola = rec.matricola
                 and rowid     = rec.rowid_eve
              ;
            exception
              when others then
                   w_errore := 'Errore in del_anaeve (matricola: '||rec.matricola||')';
                   w_return := -1;
            end;

        end loop;
     end if;
  end if; --if a_anagrafe       is not null and

  return w_return;

end;
/
