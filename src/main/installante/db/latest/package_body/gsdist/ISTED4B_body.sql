--liquibase formatted sql
--changeset amonopoli:202503211215_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTED4B is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select riga 
  from isted4b_v v, tabrep 
 where v.data_reg between substr(parametri,1,7) and substr(parametri,8,7) 
   and v.data_MOR between substr(parametri,15,7) and substr(parametri,22,7) 
   and chiave = 'ED4B' 
   and terminale = nvl(userenv('terminal'),'ISTED4B')
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
     set valore_default = 'istatel\'||codice_istat||'_D4D5B_'||to_char(sysdate,'yymmdd')||'.txt'
   where parametro 	= 'TXTFILE'
     and voce_menu	= 'ISTED4B'
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
FUNCTION VERSIONE  RETURN varchar2 IS
BEGIN
--
-- 'V1.0 del 05/11/2004'  AM  Prima emissione
-- 'V2.0 del 17/02/2022'  AM  gestione vista isted4b_v
--
   RETURN 'V2.0 del 17/02/2022';
END VERSIONE;
END ISTED4B;
/
