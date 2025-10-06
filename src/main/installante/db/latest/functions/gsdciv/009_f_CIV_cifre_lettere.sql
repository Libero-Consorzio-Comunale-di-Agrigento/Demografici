--liquibase formatted sql
--changeset amonopoli:202302011150 runOnChange:true stripComments:false
create or replace function f_CIV_cifre_lettere
(a_tipo         varchar2
,a_chiave       varchar2
,a_primo        varchar2
,a_minuscolo    varchar2
)

return varchar2

IS

w_primo		 	varchar2(1) := upper(a_primo);

w_giorno           	number;
w_mese             	number;
w_anno             	number;
w_lettere          	varchar2(255);

begin

 if a_chiave is not null then
--
-- a_tipo = 'D' indica 'DATA' (gg/mm/aaaa')
-- a_tipo = 'G' indica 'GIORNO' (gg)
-- a_tipo = 'M' indica 'MESE' (mm)
-- a_tipo = 'A' indica 'ANNO' (aaaa)
-- a_tipo = 'h' indica 'ORE' (hh24)
-- a_tipo = 'm' indica 'MINUTI' (mi)
-- a_tipo = 'U' accede direttamente alla decodifica in CILET
--
  if a_tipo = 'D' then
     begin
       select decode(lettere,'UN',decode(w_primo,'S','PRIMO','UNO'),lettere)
         INTO w_lettere
         from cilet
        where chiave = substr(a_chiave,1,2)
          and tipo   = 'U'
          and rownum = 1
       ;
     exception
       when others then
            w_lettere := a_chiave;
     end;

     begin
       select w_lettere||' '||
              decode(substr(a_chiave,4,2),
                1,'gennaio',
                2,'febbraio',
                3,'marzo',
                4,'aprile',
                5,'maggio',
                6,'giugno',
                7,'luglio',
                8,'agosto',
                9,'settembre',
               10,'ottobre',
               11,'novembre',
               12,'dicembre')
         INTO w_lettere
         from dual
       ;
     exception
       when others then
            w_lettere := w_lettere||' '||a_chiave;
     end;

     begin
       select w_lettere||' '||
               decode(substr(a_chiave,7,2),18,'milleottocent',
                                           19,'millenovecent',
                                           20,'duemil','')||
               decode(substr(a_chiave,9,1),8,'',
               decode(substr(a_chiave,7,1),1,'o',2,'a'))||
               decode(lettere,'UN','UNO',lettere)
         INTO w_lettere
         from cilet
        where chiave = substr(a_chiave,9,2)
          and tipo   = 'U'
          and rownum = 1
       ;
     exception
       when others then
            w_lettere := w_lettere||' '||a_chiave;
     end;

  elsif a_tipo = 'G' then
     begin
       select decode(lettere,'UN',decode(w_primo,'S','PRIMO','UNO'),lettere)
         INTO w_lettere
         from cilet
        where chiave = a_chiave
          and tipo   = 'U'
          and rownum = 1
       ;
     exception
       when others then
            w_lettere := a_chiave;
     end;

  elsif a_tipo = 'M' then
     begin
       select decode(a_chiave,
                1,'gennaio',
                2,'febbraio',
                3,'marzo',
                4,'aprile',
                5,'maggio',
                6,'giugno',
                7,'luglio',
                8,'agosto',
                9,'settembre',
               10,'ottobre',
               11,'novembre',
               12,'dicembre')
         INTO w_lettere
         from dual
       ;
     exception
       when others then
            w_lettere := a_chiave;
     end;

  elsif a_tipo = 'A' then
     begin
       select decode(substr(a_chiave,1,2),18,'milleottocent',
                                          19,'millenovecent',
                                          20,'duemil','')||
              decode(substr(a_chiave,3,1),8,'',
                decode(substr(a_chiave,1,1),1,'o',2,'a'))||
              decode(lettere,'UN','UNO',lettere)
         INTO w_lettere
         from cilet
        where chiave = substr(a_chiave,3,2)
          and tipo   = 'U'
          and rownum = 1
       ;
     exception
       when others then
            w_lettere := a_chiave;
     end;

  elsif a_tipo = 'h' then
     begin
       select decode(a_chiave,0,'ZERO',00,'ZERO',decode(lettere,'UN','UNA',lettere))
         INTO w_lettere
         from cilet
        where chiave = a_chiave
          and tipo   = 'U'
          and rownum = 1
       ;
     exception
       when others then
            w_lettere := a_chiave;
     end;

  elsif a_tipo = 'm' then
     begin
       select decode(a_chiave,0,'ZERO',00,'ZERO',decode(lettere,'UN','UNO',lettere))
         INTO w_lettere
         from cilet
        where chiave = a_chiave
          and tipo   = 'U'
          and rownum = 1
       ;
     exception
       when others then
            w_lettere := a_chiave;
     end;

  else
     begin
       select decode(lettere,'UN',decode(w_primo,'S','PRIMO','UNO'),lettere)
         INTO w_lettere
         from cilet
        where chiave = a_chiave
          and tipo   = a_tipo
          and rownum = 1
       ;
     exception
       when others then
            w_lettere := a_chiave;
     end;
  end if;
  
  if nvl(a_minuscolo,'N') = 'S' then
     w_lettere := lower(w_lettere);
  else
     w_lettere := upper(w_lettere);
  end if;
 end if;
  
 return w_lettere;

end;
/
