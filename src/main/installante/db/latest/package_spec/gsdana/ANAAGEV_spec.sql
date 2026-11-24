--liquibase formatted sql
--changeset amonopoli:202606111410_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ANAAGEV is
w_matricola                     number(8);
w_data_reg                      number(7);
p_evento                        number(2) := 0;
p_data_eve                      number(7) := 0;
p_pratica                       number(4) := 0;
p_anno_pratica                  number(4) := 0;
p_pratica_new                   number(4) := 0;
p_anno_pratica_new              number(4) := 0;
p_cod_pro_eve_new               number(3) := 0;
p_cod_com_eve_new               number(3) := 0;
p_data_reg_new                  number(7) := 0;
p_cod_pro_iscr_aire_new         number(3) := 0;
p_cod_com_iscr_aire_new         number(3) := 0;
w_terminalista                  varchar2(255);
w_note_par                      varchar2(2000);
w_trattamento                   number(2);
w_anagrafe                      varchar2(3);
w_tipo_evento                   varchar2(1);
w_conta_cp4                     number;
w_cod_eve                       number;
w_cod_eve_pr                    number;
r_cod_pro_eve_old               number;
r_cod_com_eve_old               number;
r_cod_pro_iscr_aire_old         number;
r_cod_com_iscr_aire_old         number;
cp4_numero_dic_new              number;
w_cp4_anno_pratica              number := 0;
w_cp4_pratica                   number := 0;
w_cp4_numero_dic                number := 0;
w_cp4_anno_dic                  number := 0;
tratta_ana                      number;
protocollo_aire                 number(4) := 0;

rep_sessione			varchar2(2000);

w_fase_log			varchar2(255) := 'AGEV';
w_parametri_log			varchar2(2000);
w_note_log			varchar2(2000);
w_terminalista_log		varchar2(255);

cursor sel_dati_matricola is
 select matricola,min(cod_mov) cod_mov,cod_eve,cod_eve_pr,max(data_reg) data_reg,
           max(cod_pro_eve) cod_pro_eve_old,max(cod_com_eve) cod_com_eve_old,
           max(cod_pro_iscr_aire) cod_pro_iscr_aire_old,max(cod_com_iscr_aire) cod_com_iscr_aire_old
          from anaeve
         where (p_evento = 2
            and ((cod_eve_pr = 3 and cod_mov = 1)
                 or cod_eve_pr = 2)
            and data_eve       in (p_data_eve,p_data_eve - 1)
            and pratica        = p_pratica
        and anno_pratica   = p_anno_pratica )
         or (p_evento != 2
             and cod_eve_pr     = p_evento
             and data_eve       in (p_data_eve,p_data_eve - 1)
             and pratica        = p_pratica
                 and anno_pratica   = p_anno_pratica)
         group by matricola,cod_eve,cod_eve_pr
;
CURSOR  sel_anacp4 is
  select anno_pratica cp4_anno_pratica, pratica cp4_pratica, anno_dic cp4_anno_dic, numero_dic cp4_numero_dic
          from anacp4
         where anno_pratica     = p_anno_pratica
           and pratica         = p_pratica
            and (((p_anno_pratica != p_anno_pratica_new and p_pratica!= p_pratica_new) 
                 and not exists (select 'x'
                                   from anacp4 b
                                  where b.pratica     = nvl(p_pratica_new, b.pratica)
                                    and b.anno_pratica= nvl(p_anno_pratica_new, b.anno_pratica)))
                or (p_pratica = p_pratica_new and 
                    p_anno_pratica = p_anno_pratica_new)) 
     order by numero_dic;

PROCEDURE MAIN (sessione in varchar2, w_messaggio_1 IN OUT varchar2, w_messaggio_2 IN OUT varchar2, w_messaggio_3 IN OUT varchar2);
PROCEDURE TR_MAIN (w_messaggio_1 IN OUT varchar2, w_messaggio_2 IN OUT varchar2, w_messaggio_3 IN OUT varchar2);
procedure UPD_ANAA01;
procedure UPD_ANAA0M;
procedure UPD_ANAANA;
procedure UPD_ANAEVE;
procedure UPD_ANAMOV;
procedure UPD_ANATPR;
procedure UPD_ANATPR_1;
procedure UPD_ANACRE;
procedure UPD_ANACRM;
procedure UPD_ANASAP;
procedure UPD_ANASAP_1;
procedure UPD_ANASAP_7;
procedure UPD_ANACP4;
procedure UPD_ANACPM;
procedure UPD_ANAAP4;
procedure UPD_ANAAPM;
procedure INS_GSDLOG;
function  VERSIONE RETURN varchar2;
end ANAAGEV;
/
