--liquibase formatted sql
--changeset amonopoli:202511271135 runOnChange:true stripComments:false
create or replace function f_ANPR_stringa
(a_stringa   IN   varchar2
,a_non_ammessi   IN   varchar2 default NULL
)
return varchar2
IS

w_comune_cliente	varchar2(255);

w_len_translate      number;
w_stringa      varchar2(4000);
BEGIN
  if a_stringa like 'KOCIJAN%IC' or a_stringa like 'LUCA Y%KI' then
     begin
       select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
         into w_comune_cliente
         from menuditta
       ;
     exception
       when others then
            w_comune_cliente := '000000';
     end;

     if w_comune_cliente = '025006' and a_stringa like 'KOCIJAN%IC' then	-- Belluno
        -- C caron
        w_stringa := 'KOCIJAN'||'&#268;'||'IC';
        goto fine;

     elsif w_comune_cliente = '023089' and a_stringa like 'LUCA Y%KI' then	-- Valeggio s/Mincio (11/03/2024)
        -- U linea / U macron
        w_stringa := 'LUCA Y'||'&#362;'||'KI';
        goto fine;
     end if;
  end if;

-- suffisso - caratteri consentiti: '([0-9À-¿a-zA-Z\- '.,])*'
  if a_non_ammessi is not null then
     w_len_translate := length(a_non_ammessi);
     w_stringa  := translate(a_stringa,a_non_ammessi,rpad(' ',w_len_translate,' '));
  else
     w_stringa   := translate(a_stringa,'/=*\`"^:%_','          ');
  end if;
  if translate(upper(w_stringa),
               upper('ÂãÃáàÁÀäÄéèÉÈëËíìÍÌïÏóòÓÒöÖÔúùÚÙüÜçÇñÑ¿Ž'),
                     '****************************************')
     like '%*%'
  then
     goto diacritici;
  end if;
  goto fine;
<< diacritici >>
  if w_stringa like '%Â%' then
     w_stringa := replace(w_stringa,'Â','&#194;');
  end if;
  if w_stringa like '%Ã%' then
     w_stringa := replace(w_stringa,'Ã','&#195;');
  end if;
  if w_stringa like '%ã%' then
     w_stringa := replace(w_stringa,'ã','&#227;');
  end if;
  if w_stringa like '%Á%' then
     w_stringa := replace(w_stringa,'Á','&#193;');
  end if;
  if w_stringa like '%á%' then
     w_stringa := replace(w_stringa,'á','&#225;');
  end if;
  if w_stringa like '%À%' then
     w_stringa := replace(w_stringa,'À','&#192;');
  end if;
  if w_stringa like '%à%' then
     w_stringa := replace(w_stringa,'à','&#224;');
  end if;
  if w_stringa like '%Ä%' then
     w_stringa := replace(w_stringa,'Ä','&#196;');
  end if;
  if w_stringa like '%ä%' then
     w_stringa := replace(w_stringa,'ä','&#228;');
  end if;
  if w_stringa like '%É%' then
     w_stringa := replace(w_stringa,'É','&#201;');
  end if;
  if w_stringa like '%é%' then
     w_stringa := replace(w_stringa,'é','&#233;');
  end if;
  if w_stringa like '%È%' then
     w_stringa := replace(w_stringa,'È','&#200;');
  end if;
  if w_stringa like '%è%' then
     w_stringa := replace(w_stringa,'è','&#232;');
  end if;
  if w_stringa like '%Ë%' then
     w_stringa := replace(w_stringa,'Ë','&#203;');
  end if;
  if w_stringa like '%ë%' then
     w_stringa := replace(w_stringa,'ë','&#235;');
  end if;
  if w_stringa like '%Í%' then
     w_stringa := replace(w_stringa,'Í','&#205;');
  end if;
  if w_stringa like '%í%' then
     w_stringa := replace(w_stringa,'í','&#237;');
  end if;
  if w_stringa like '%Ì%' then
     w_stringa := replace(w_stringa,'Ì','&#204;');
  end if;
  if w_stringa like '%ì%' then
     w_stringa := replace(w_stringa,'ì','&#236;');
  end if;
  if w_stringa like '%Ï%' then
     w_stringa := replace(w_stringa,'Ï','&#207;');
  end if;
  if w_stringa like '%ï%' then
     w_stringa := replace(w_stringa,'ï','&#239;');
  end if;
  if w_stringa like '%Î%' then
     w_stringa := replace(w_stringa,'Î','&#206;');
  end if;
  if w_stringa like '%Ó%' then
     w_stringa := replace(w_stringa,'Ó','&#211;');
  end if;
  if w_stringa like '%ó%' then
     w_stringa := replace(w_stringa,'ó','&#243;');
  end if;
  if w_stringa like '%Ò%' then
     w_stringa := replace(w_stringa,'Ò','&#210;');
  end if;
  if w_stringa like '%ò%' then
     w_stringa := replace(w_stringa,'ò','&#242;');
  end if;
  if w_stringa like '%Ö%' then
     w_stringa := replace(w_stringa,'Ö','&#214;');
  end if;
  if w_stringa like '%ö%' then
     w_stringa := replace(w_stringa,'ö','&#246;');
  end if;
  if w_stringa like '%Ô%' then
     w_stringa := replace(w_stringa,'Ô','&#212;');
  end if;
  if w_stringa like '%Ú%' then
     w_stringa := replace(w_stringa,'Ú','&#218;');
  end if;
  if w_stringa like '%ú%' then
     w_stringa := replace(w_stringa,'ú','&#250;');
  end if;
  if w_stringa like '%Ù%' then
     w_stringa := replace(w_stringa,'Ù','&#217;');
  end if;
  if w_stringa like '%ù%' then
     w_stringa := replace(w_stringa,'ù','&#249;');
  end if;
  if w_stringa like '%Ü%' then
     w_stringa := replace(w_stringa,'Ü','&#220;');
  end if;
  if w_stringa like '%ü%' then
     w_stringa := replace(w_stringa,'ü','&#252;');
  end if;
  if w_stringa like '%Ç%' then
     w_stringa := replace(w_stringa,'Ç','&#199;');
  end if;
  if w_stringa like '%ç%' then
     w_stringa := replace(w_stringa,'ç','&#231;');
  end if;
  if w_stringa like '%Ñ%' then
     w_stringa := replace(w_stringa,'Ñ','&#209;');
  end if;
  if w_stringa like '%ñ%' then
     w_stringa := replace(w_stringa,'ñ','&#241;');
  end if;
  if w_stringa like '%¿%' then
     w_stringa := replace(w_stringa,'¿','&#138;');
  end if;
  if w_stringa like '%Ž%' then
     w_stringa := replace(w_stringa,'Ž','&#381;');
  end if;
<< fine >>
  return w_stringa;
END;
/