--liquibase formatted sql
--changeset snocca:202302031831 runOnChange:true stripComments:false
create or replace procedure CIVMOR_FI
(a_ufficio		IN	number,
 a_anno			IN	number,
 a_atto			IN	number,
 a_parte		IN	number,
 a_serie		IN	varchar2,
 a_cognome_nome_new	IN 	varchar2,
 a_cognome_nome_old	IN 	varchar2,
 a_ufficio_old		IN	number,
 a_anno_old		IN	number,
 a_atto_old		IN	number,
 a_parte_old		IN	number,
 a_serie_old		IN	varchar2)
IS

w_cognome		varchar2(255);
w_nome		varchar2(255);
begin
  if UPDATING then
   if a_ufficio||a_anno||a_atto||a_parte||a_serie != a_ufficio_old||a_anno_old||a_atto_old||a_parte_old||a_serie_old then
      begin
        update civana
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civcom
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civann
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civtli_annotazioni
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civdpa
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civttr
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civtes
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civdic
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civtte
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civchi
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civdmo
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civgmo
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civtli
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civtli_formule
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civocc
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civmar
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civfas
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 5
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
      end;
   end if;
  end if;

  w_cognome	:= substr(a_cognome_nome_new,1,instr(a_cognome_nome_new,'/')-1);
  w_nome    	:= substr(a_cognome_nome_new,instr(a_cognome_nome_new,'/')+1);

  begin
    insert into civocc
           (tipo_atto, ufficio, anno, parte, serie, atto, 
            cognome, nome, cognome_cn, nome_cn,
            sesso, nato_morto)
    select 5, a_ufficio, a_anno, a_parte, a_serie, a_atto, 
           w_cognome,        
           w_nome,          
           to_char(null), to_char(null),          
           to_char(null), to_char(null)
      from dual
     where not exists (select 'x' from civocc
                        where ufficio		= a_ufficio
                          and anno		= a_anno
                          and atto		= a_atto
                          and parte		= a_parte	
                          and nvl(serie,' ') = nvl(a_serie,' ')
                          and tipo_atto	= 5)
    ;
  end;

  if UPDATING then
     if nvl(a_cognome_nome_new,' ') != nvl(a_cognome_nome_old,' ') then
        begin
          update civocc
	     set cognome	= w_cognome,
	         nome		= w_nome,
		 cognome_cn	= to_char(null),
		 nome_cn	= to_char(null),
		 sesso		= to_char(null),
		 nato_morto	= to_char(null)
           where ufficio	= a_ufficio
             and anno		= a_anno
 	     and atto		= a_atto
	     and parte		= a_parte	
	     and nvl(serie,' ') = nvl(a_serie,' ')
	     and tipo_atto	= 5
         ;
       end;
     end if;
  end if;
  
end;
/
