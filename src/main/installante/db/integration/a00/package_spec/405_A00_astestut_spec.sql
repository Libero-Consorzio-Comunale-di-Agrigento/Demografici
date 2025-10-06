--liquibase formatted sql
--changeset amonopoli:202503261020_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE astestut IS
type sttype is record (
nome_stampa        varchar2(20),
data_preparazione   date,
voce_menu     varchar2(8),
passo      number(2),
pagine      number(6),
stato      varchar2(1),
stampa      varchar2(8),
gruppo      varchar2(5),
utente      varchar2(8),
no_prenotazione    number(6),
classe      varchar2(10),
id_repsrv_stampa varchar2(100)
);
type stcurtyp is REF CURSOR return sttype;
procedure open_st_cv( putente in varchar2, pgruppo in varchar2, pente in varchar2, pprenotazione in number, st_cv in out stcurtyp,pnome_stampa in varchar2,pcodice in varchar2, pstato in varchar2, pdata in date, ppagine in number);
procedure stut_lock(putente in varchar2, pstampa in varchar2,id_repsrv_stampa in varchar2, pclasse in varchar2);
procedure stut_update(precord in sttype);
procedure stut_delete(precord in sttype);
END;
/
