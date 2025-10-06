--liquibase formatted sql
--changeset amonopoli:202303061001 runOnChange:true stripComments:false
create or replace procedure CIVPUB_FI
(a_ufficio		IN	number,
 a_anno			IN	number,
 a_atto			IN	number,
 a_parte		IN	number,
 a_serie		IN	varchar2,
 a_ufficio_old		IN	number,
 a_anno_old		IN	number,
 a_atto_old		IN	number,
 a_parte_old		IN	number,
 a_serie_old		IN	varchar2)
IS

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
         where tipo_atto      = 3
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
         where tipo_atto      = 3
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
         where tipo_atto      = 3
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
         where tipo_atto      = 3
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
        update civspo
           set ufficio = a_ufficio,
               anno    = a_anno,
               atto    = a_atto,
               parte   = a_parte,
               serie   = a_serie
         where tipo_atto      = 3
           and anno           = a_anno_old
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
         where tipo_atto      = 3
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
         where tipo_atto      = 3
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
         where tipo_atto      = 3
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
         where tipo_atto      = 3
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
         where tipo_atto      = 3
           and anno           = a_anno_old
           and ufficio        = a_ufficio_old
           and parte          = a_parte_old
           and nvl(serie,' ') = nvl(a_serie_old,' ')
           and atto           = a_atto_old
        ;
      end;
   end if;
  end if;
  
end;
/
