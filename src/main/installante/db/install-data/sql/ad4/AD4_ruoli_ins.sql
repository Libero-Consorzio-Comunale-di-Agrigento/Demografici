--liquibase formatted sql
--changeset amonopoli:202501140835 runOnChange:true stripComments:false
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO, 
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'RGSD', 'Responsabile Servizi Demografici', 'DE4GSD', 'DE4GSD', 'U', 
       'S', 'N', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'RGSD')
/
-- ruoli integrati SO4 - modulo CER - Certificazione
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO, 
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'GSDCERSU', 'GSD - Certificazione - Super User', 'DE4GSD', 'DE4GSD', 'U', 
       'S', 'S', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'GSDCERSU')
/
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO, 
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'GSDCERAN', 'GSD - Certificazione - Anagrafe', 'DE4GSD', 'DE4GSD', 'U', 
       'S', 'S', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'GSDCERAN')
/
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO, 
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'GSDCEREL', 'GSD - Certificazione - Elettorale', 'DE4GSD', 'DE4GSD', 'U', 
       'S', 'S', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'GSDCEREL')
/
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO, 
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'GSDCERLM', 'GSD - Certificazione - Leva Militare', 'DE4GSD', 'DE4GSD', 'U', 
       'S', 'S', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'GSDCERLM')
/
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO, 
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'GSDCERSC', 'GSD - Certificazione - Stato Civile', 'DE4GSD', 'DE4GSD', 'U', 
       'S', 'S', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'GSDCERSC')
/
-- ruoli integrati SO4 - modulo CIV - Stato Civile
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO, 
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'GSDCIVSU', 'GSD - Stato Civile - Super User', 'DE4GSD', 'DE4GSD', 'U', 
       'S', 'S', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'GSDCIVSU')
/
-- ruoli integrati SO4 - modulo ANA - Anagrafe
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO,
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'GSDANASU', 'GSD - Anagrafe - Super User', 'DE4GSD', 'DE4GSD', 'U',
       'S', 'S', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'GSDANASU')
/
-- ruoli integrati SO4 - modulo STATS - Indicatori Statistici
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO, 
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'DESTAT', 'STATS - Ruolo Demografici', 'STATS', '', 'U', 
       'S', 'S', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'DESTAT')
/
Insert into AD4_RUOLI
   (RUOLO, DESCRIZIONE, PROGETTO, MODULO, STATO, 
    GRUPPO_LAVORO, GRUPPO_SO, INCARICO, RESPONSABILITA)
select 'DEAMM', 'STATS - Ruolo Amm Demografici', 'STATS', '', 'U', 
       'S', 'S', 'N', 'N'
  from dual
 where not exists (select 1 from ad4_ruoli
                    where ruolo = 'DEAMM')
/
