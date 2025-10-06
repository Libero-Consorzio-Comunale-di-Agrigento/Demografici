--liquibase formatted sql
--changeset amonopoli:202304281620 runOnChange:true stripComments:false
create or replace function f_CIV_esiste_atto 
(a_tipo_atto	IN	number
,a_NATURA 	IN	varchar	
,a_COD_REC 	IN	number
,a_UFFICIO 	IN	number
,a_ANNO 	IN	number
,a_ATTO 	IN	number
,a_PARTE 	IN	number
,a_SERIE 	IN	varchar
,a_VERSIONE 	IN	number
)

return varchar2

IS            

cursor sel_cit is
select atto||
         DECODE(ANNO, '', '', ' - Anno '||ANNO||' ')||
         DECODE(UFFICIO, '','', ' - Ufficio '||UFFICIO) des_atto
  from CIVCIT
 where ((COD_REC in (0,3) and a_COD_REC in (0,3)) 
        or
        (COD_REC = a_COD_REC and a_COD_REC not in (0,3) and nvl(VERSIONE,0) = nvl(a_VERSIONE,0))
       ) 
   and UFFICIO  = a_UFFICIO 
   and ANNO     = a_ANNO 
   and ATTO     = a_ATTO
   and rownum   = 1
;

cursor sel_mat is
select atto||
         DECODE(PARTE, '', '', ' - Parte '||PARTE||
         DECODE(SERIE, '', '', ' - Serie '||SERIE))||
         DECODE(ANNO, '', '', ' - Anno '||ANNO||' ')||
         DECODE(UFFICIO, '','', ' - Ufficio '||UFFICIO) des_atto
  from CIVMAT
 where ((COD_REC in (0,3) and a_COD_REC in (0,3)) 
        or
        (COD_REC = a_COD_REC and a_COD_REC not in (0,3) and nvl(VERSIONE,0) = nvl(a_VERSIONE,0))
       ) 
   and UFFICIO        = a_UFFICIO 
   and ANNO           = a_ANNO  
   and ATTO           = a_ATTO  
   and PARTE          = a_PARTE  
   and nvl(SERIE,' ') = nvl(a_SERIE,' ')
   and rownum   = 1
;

cursor sel_mor is
select atto||
          DECODE(PARTE, '', '', ' - Parte '||PARTE||
          DECODE(SERIE, '', '', ' - Serie '||SERIE))||
          DECODE(ANNO, '', '', ' - Anno '||ANNO||' ')||
          DECODE(UFFICIO, '','', ' - Ufficio '||UFFICIO) des_atto
  from CIVMOR
 where ((COD_REC in (0,3) and a_COD_REC in (0,3)) 
        or
        (COD_REC = a_COD_REC and a_COD_REC not in (0,3) and nvl(VERSIONE,0) = nvl(a_VERSIONE,0))
       ) 
   and UFFICIO        = a_UFFICIO  
   and ANNO           = a_ANNO  
   and ATTO           = a_ATTO  
   and PARTE          = a_PARTE  
   and nvl(SERIE,' ') = nvl(a_SERIE,' ')
   and rownum   = 1
;

cursor sel_nas is
select atto||
         DECODE(PARTE, '', '', ' - Parte '||PARTE||
         DECODE(SERIE, '', '', ' - Serie '||SERIE))||
         DECODE(ANNO, '', '', ' - Anno '||ANNO||' ')||
         DECODE(UFFICIO, '','', ' - Ufficio '||UFFICIO) des_atto
  from CIVNAS
 where ((COD_REC in (0,3) and a_COD_REC in (0,3))
        or
        (COD_REC = a_COD_REC and a_COD_REC not in (0,3) and nvl(VERSIONE,0) = nvl(a_VERSIONE,0))
       ) 
   and UFFICIO        = a_UFFICIO 
   and ANNO           = a_ANNO 
   and ATTO           = a_ATTO 
   and PARTE          = a_PARTE 
   and nvl(SERIE,' ') = nvl(a_SERIE,' ')
   and rownum   = 1
;

cursor sel_pub is
select atto||
          DECODE(ANNO, '', '', ' - Anno '||ANNO||' ')||
          DECODE(UFFICIO, '','', ' - Ufficio '||UFFICIO) des_atto
  from civpub
 where ((COD_REC in (0,3) and a_COD_REC in (0,3)) 
        or
        (COD_REC = a_COD_REC and a_COD_REC not in (0,3) and nvl(VERSIONE,0) = nvl(a_VERSIONE,0))
       ) 
   and UFFICIO        = a_UFFICIO 
   and ANNO           = a_ANNO 
   and ATTO           = a_ATTO 
   and PARTE          = a_PARTE 
   and nvl(SERIE,' ') = nvl(a_SERIE,' ')
   and rownum   = 1
;

cursor sel_uci is
select atto||
          DECODE(PARTE, '', '', ' - Parte '||PARTE)||
          DECODE(ANNO, '', '', ' - Anno '||ANNO||' ')||
          DECODE(UFFICIO, '','', ' - Ufficio '||UFFICIO) des_atto
  from civuci
 where ((NATURA = a_NATURA and a_NATURA = 'V')
        or
        (NATURA != 'V' and a_NATURA != 'V')
       )
   and ((COD_REC in (0,3) and a_COD_REC in (0,3))
        or
        (COD_REC = a_COD_REC and a_COD_REC not in (0,3) and nvl(VERSIONE,0) = nvl(a_VERSIONE,0))
       )
   and UFFICIO        = a_UFFICIO
   and ANNO           = a_ANNO
   and ATTO           = a_ATTO
   and nvl(PARTE, -5) = nvl(a_PARTE, -5)
   and nvl(SERIE,' ') = nvl(a_SERIE,' ')
   and rownum   = 1
;

w_errore	varchar2(4000);

begin
  w_errore := '';

  if a_tipo_atto = 1 and a_COD_REC is not null and a_UFFICIO is not null and a_ANNO is not null and a_ATTO is not null and a_VERSIONE is not null then
     for rec_cit in sel_cit loop
         w_errore := 'Atto Numero '||rec_cit.des_atto||' gia'' presente.';
     end loop;

  elsif a_tipo_atto = 2 and a_COD_REC is not null and a_UFFICIO is not null and a_ANNO is not null and a_ATTO is not null and a_PARTE is not null and a_VERSIONE is not null then
     for rec_nas in sel_nas loop
         w_errore := 'Atto Numero '||rec_nas.des_atto||' gia'' presente.';
     end loop;

  elsif a_tipo_atto = 3 and a_COD_REC is not null and a_UFFICIO is not null and a_ANNO is not null and a_ATTO is not null and a_PARTE is not null and a_VERSIONE is not null then
     for rec_pub in sel_pub loop
         w_errore := 'Atto Numero '||rec_pub.des_atto||' gia'' presente.';
     end loop;
  
  elsif a_tipo_atto = 4 and a_COD_REC is not null and a_UFFICIO is not null and a_ANNO is not null and a_ATTO is not null and a_PARTE is not null and a_VERSIONE is not null then
     for rec_mat in sel_mat loop
         w_errore := 'Atto Numero '||rec_mat.des_atto||' gia'' presente.';
     end loop;

  elsif a_tipo_atto = -4 and a_NATURA is not null and a_COD_REC is not null and a_UFFICIO is not null and a_ANNO is not null and a_ATTO is not null and a_VERSIONE is not null then
     for rec_uci in sel_uci loop
         w_errore := 'Atto Numero '||rec_uci.des_atto||' gia'' presente.';
     end loop;

  elsif a_tipo_atto = 5 and a_COD_REC is not null and a_UFFICIO is not null and a_ANNO is not null and a_ATTO is not null and a_PARTE is not null and a_VERSIONE is not null then
     for rec_mor in sel_mor loop
         w_errore := 'Atto Numero '||rec_mor.des_atto||' gia'' presente.';
     end loop;
  end if;

  return w_errore;

exception
  when others then
       w_errore := 'Errore generico nel controllo di esistenza dell''atto';
       return w_errore;
end;
/
