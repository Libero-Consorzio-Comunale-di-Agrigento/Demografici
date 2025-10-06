--liquibase formatted sql
--changeset amonopoli:202503211223_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDAPP is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select 0, riga
  from istmap_int
 where cod_modello = 'APR4_PERSONE'
UNION
select v_T.progressivo_quest, v_T.progressivo_quest||';'||v_P.riga riga
  from (select v.anno_pratica, v.pratica, v.anno_dic, v.numero_dic, v.riga, v.cod_modello
          from tabrep, istmap_v v
         where v.cod_modello      in ('APR4_PERSONE_I')
           and v.data_definizione between substr(tabrep.parametri,1,7) and substr(tabrep.parametri,8,7) 
           and tabrep.chiave 	  = 'EDAP' 
           and tabrep.terminale   = nvl(userenv('terminal'),'ISTEDAP')
        UNION
        select v.anno_pratica, v.pratica, v.anno_dic, v.numero_dic, v.riga, v.cod_modello
          from tabrep, istmap_v v
         where v.cod_modello      in ('APR4_PERSONE_C')
           and v.data_definizione between substr(tabrep.parametri,1,7) and substr(tabrep.parametri,8,7) 
           and tabrep.chiave 	  = 'EDAP' 
           and tabrep.terminale   = nvl(userenv('terminal'),'ISTEDAP')
         order by 1,2,3,4,5) v_P,
       (select rownum progressivo_quest, v.cod_modello, v.anno_pratica, v.pratica
          from (select v.anno_pratica, v.pratica, v.sequenza, v.cod_modello
                  from tabrep, istmap_v v
                 where v.cod_modello      = 'APR4_TESTATA_I'
                   and v.data_definizione between substr(tabrep.parametri,1,7) and substr(tabrep.parametri,8,7) 
                   and tabrep.chiave 	  = 'EDAP' 
                   and tabrep.terminale   = nvl(userenv('terminal'),'ISTEDAP')
                UNION
                select v.anno_pratica, v.pratica, v.sequenza, v.cod_modello
                  from tabrep, istmap_v v
                 where v.cod_modello      = 'APR4_TESTATA_C'
                   and v.numero_dic       = v.pratica
                   and v.data_definizione between substr(tabrep.parametri,1,7) and substr(tabrep.parametri,8,7) 
                   and tabrep.chiave 	  = 'EDAP' 
                   and tabrep.terminale   = nvl(userenv('terminal'),'ISTEDAP')
                 order by 3,1,2) v) v_T
 where ((v_T.cod_modello = 'APR4_TESTATA_I' and v_P.cod_modello = 'APR4_PERSONE_I')
        or (v_T.cod_modello = 'APR4_TESTATA_C' and v_P.cod_modello = 'APR4_PERSONE_C'))
   and v_P.anno_pratica = v_T.anno_pratica
   and v_P.pratica      = v_T.pratica
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
     set valore_default = 'istatel\'||codice_istat||'_APR4_PERSONE_'||to_char(sysdate,'yymmdd')||'.csv'
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
END ISTEDAPP;
/
