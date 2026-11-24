--liquibase formatted sql
--changeset amonopoli:202606111405_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ANAELEV is
nucleo_arrivo                   number(1) := 0;
data_nas                        number(7) := 0;
rapporto_par_apm                varchar2(255);
annullamento_apm                varchar2(255);
protocollo_aire                 number(4) := 0;
w_matricola_aire		varchar2(20);
r_protocollo_aire		number(4) := 0;
w_protocollo_aire		number(4) := 0;
cod_mov_prec                    number(2) := 0;
cod_eve_pr_prec                 number(2) := 0;
pratica_prec                    number(4) := 0;
anno_pratica_prec               number(4) := 0;
data_inizio_fam                 number(7) := 0;
cod_fam                         number(7) := 0;
sequenza_par                    number(2) := 0;
cod_via                         number(4) := 0;
suffisso                        varchar2(255);
via_aire                        varchar2(255);
cod_pro_aire                    number(3) := 0;
mov_cod_fam                     number(7) := 0;
trattamento                     number(1) := 0;
conta_righe                     number(2) := 0;
numero_pagina                   number(3) := 0;
titolo                          varchar2(255);
roll                            varchar2(255);
r_matricola                       number(7) := 0;
r_cod_mov                         number(2) := 0;
r_cod_eve                         number(2) := 0;
r_cod_eve_pr                      number(2) := 0;
r_data_reg                        number(7) := 0;
r_id_anaeve                     number(10) := 0;
data_reg_par                    number(7) := 0;
cod_eve_prec                    number(2) := 0;
data_eve_prec                   number(7) := 0;
data_reg_prec                   number(7) := 0;
data_inizio_res                 number(7) := 0;
rapporto_par                    varchar2(255);
num_civ                         number(6) := 0;
interno                         number(4) := 0;
sub_interno                     varchar2(3);
cod_com_aire                    number(3) := 0;
nucleo_partenza                 number(1) := 0;
intestatario                    varchar2(255);
data_decorrenza                 number(7) := 0;
sequenza_par_apm                number(2) := null;
p_evento                        number(2) := 0;
p_data_eve                      number(10) := 0;
p_pratica                       number(4) := 0;
p_anno_pratica                  number(4) := 0;
pratica_dic                     number(4) := 0;
anno_pratica_dic                number(4) := 0;
w_terminalista		        varchar2(255);
w_note_par	        	varchar2(2000);
w_messaggio                     varchar2(2000);

esiste_anatri                   varchar2(255);
esiste_eleana                   varchar2(255);
esiste_elemov                   varchar2(255);
esiste_elemov_51                varchar2(255);
esiste_eleela                   varchar2(255);
esiste_elemla                   varchar2(255);
esiste_elemla_51                varchar2(255);

ele_revisione                   varchar2(255);	-- v2.4
ele_sospensione                 varchar2(255);	-- v2.4
ele_flag_trattato               varchar2(255);	-- v2.4
esiste_elemov_FR                varchar2(255);	-- v2.4
esiste_elemla_FR                varchar2(255);	-- v2.4

w_flag_ripristino		varchar2(1);
w_flag_preliminare		varchar2(1);

w_fase_log			varchar2(255) := 'ELEV';
w_parametri_log			varchar2(2000);
w_note_log			varchar2(2000);
w_terminalista_log		varchar2(255);
w_operazione_log		varchar2(255);
w_return_log			number;

rep_sessione			varchar2(2000);

CURSOR SEL_MATRICOLA IS
select matricola ,min(cod_mov) cod_mov, cod_eve,cod_eve_pr,max(data_reg) data_reg, min(id) id_anaeve
  from anaeve
 where (anaelev.p_evento = 2
            and ((cod_eve_pr = 3 and cod_mov = 1 and cod_eve = 3)
                 or cod_eve_pr = 2)
            and anno_pratica   = anaelev.p_anno_pratica
            and data_eve       in (anaelev.p_data_eve,anaelev.p_data_eve - 1)
            and pratica        = anaelev.p_pratica
       )
       or
       (anaelev.p_evento != 2
             and cod_eve_pr     = anaelev.p_evento
             and anno_pratica   = anaelev.p_anno_pratica
             and data_eve       in (anaelev.p_data_eve,anaelev.p_data_eve - 1)
             and pratica        = anaelev.p_pratica
       )
 group by matricola,cod_eve,cod_eve_pr
;


procedure main (sessione IN varchar2, w_messaggio_1 IN OUT varchar2, w_messaggio_2 IN OUT varchar2, w_messaggio_3 IN OUT varchar2);
procedure tr_main (w_messaggio_1 IN OUT varchar2, w_messaggio_2 IN OUT varchar2, w_messaggio_3 IN OUT varchar2);
procedure DEL_ANAA01;
procedure DEL_ANAA0M;
procedure DEL_ANAANA;
procedure DEL_ANADOC;
procedure DEL_ANAEVE;
procedure DEL_ANAFAM;
procedure DEL_ANAMOV;
procedure DEL_ANAC01;
procedure DEL_ANAC0M;
procedure UPD_ANAANA;
procedure UPD_ANAANA_5;
procedure UPD_ANAANA_91;
procedure UPD_ANAANA_92;
procedure UPD_ANAANA_CN;
procedure UPD_ANAFAM_90;
procedure UPD_ANAFAM_AIRE;
procedure UPD_ANAFAM_RES;
procedure UPD_TABREP_DATA_REG;
procedure UPD_TABREP_NULL;
procedure CONTROLLA_RIFERIMENTI;
procedure CONTROLLA_RIFERIMENTI_51;
procedure CONTROLLO_DIC;
procedure ESTRAI_ANAA01;
procedure ESTRAI_ANAAPM;
procedure ESTRAI_ANAEVE_10_12;
procedure ESTRAI_ANAEVE_10_12_PREC;
procedure ESTRAI_ANAEVE_11;
procedure ESTRAI_ANAEVE_13;
procedure ESTRAI_ANAEVE_PREC;
procedure ESTRAI_ANAC01;
procedure ESTRAI_MAT_AIRE;
procedure UPD_ANATPR;
procedure DEL_ANASAP;
procedure DEL_ANASAP_0;
procedure UPD_ANAAP4;
procedure UPD_ANACP4;
procedure UPD_ANAA01;
procedure INS_ANAMOV_DL_5_2012;
procedure UPD_ANACPM_DL_5_2012;
--procedure UPD_ANACRM_DL_5_2012;
procedure INS_GSDLOG;
function  VERSIONE RETURN varchar2;

end;
/
