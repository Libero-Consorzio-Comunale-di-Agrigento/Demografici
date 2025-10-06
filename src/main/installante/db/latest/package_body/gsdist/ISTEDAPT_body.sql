--liquibase formatted sql
--changeset amonopoli:202503211224_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDAPT is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
/******************************************************************************
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    29/07/2003 __     Prima emissione. Da conversione
******************************************************************************/
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select 0, riga
  from istmap_int
 where cod_modello = 'APR4_TESTATA'
UNION
select rownum, rownum||';'||v.riga riga
  from (select v.anno_pratica, v.pratica, v.anno_dic, v.numero_dic, v.sequenza, v.riga
          from tabrep, istmap_v v
         where v.cod_modello      = 'APR4_TESTATA_I'
           and v.data_definizione between substr(tabrep.parametri,1,7) and substr(tabrep.parametri,8,7) 
           and tabrep.chiave 	  = 'EDAP' 
           and tabrep.terminale   = nvl(userenv('terminal'),'ISTEDAP')
        UNION
        select v.anno_pratica, v.pratica, v.anno_dic, v.numero_dic, v.sequenza, v.riga
          from tabrep, istmap_v v
         where v.cod_modello      = 'APR4_TESTATA_C'
           and v.numero_dic       = v.pratica
           and v.data_definizione between substr(tabrep.parametri,1,7) and substr(tabrep.parametri,8,7) 
           and tabrep.chiave 	  = 'EDAP' 
           and tabrep.terminale   = nvl(userenv('terminal'),'ISTEDAP')
         order by 5,1,2,3,4) v
 order by 1
;
BEGIN
p_prenotazione := prenotazione;
p_passo        := passo;
declare 
codice_istat varchar2(10);
begin
  begin
   select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
     into codice_istat
     from menuditta;
  exception
    when others then
      codice_istat := '';
  end;

begin
  update a_selezioni
     set valore_default = 'istatel\'||codice_istat||'_APR4_TESTATA_'||to_char(sysdate,'yymmdd')||'.csv'
   where parametro 	= 'TXTFILE'
     and voce_menu	= 'ISTEDAP'
  ;
end;
commit;
end;
for dati in sel_dati loop
  begin
           P_riga   := P_riga   + 1;
           insert into a_appoggio_stampe
           values ( p_prenotazione
                  , p_passo
                  , P_pagina
                  , P_riga
                  , dati.riga
                  )
           ;
	end;
end loop;
commit;
END MAIN;
END ISTEDAPT;
/
