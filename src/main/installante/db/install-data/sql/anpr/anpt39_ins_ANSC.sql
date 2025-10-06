--liquibase formatted sql
--changeset amonopoli:202310201610_2 runOnChange:true stripComments:false
delete anpt39
 where codice in ('S1','S2','S3','S4','S5','S6','S8','S9');

-- ANST113
-- 1 - Art. 40 comma 2 DPR 445/2000
-- 2 - Certificati da produrre all'estero
-- 3 - Procedimenti giudiziari contenziosi
-- 4 - Norme sulla condizione dello straniero e immigrazione
-- 5 - Formalità ipotecarie e catastali
-- 6 - Servizio Elettorale

-- ANPT39
-- S1 - STATO CIVILE - Art. 40 comma 2 DPR 445/2000
-- S2 - STATO CIVILE - Certificati da produrre all'estero
-- S3 - STATO CIVILE - Procedimenti giudiziari contenziosi		
-- S4 - STATO CIVILE - Norme sulla condizione dello straniero e immigrazione		
-- S5 - STATO CIVILE - Formalità ipotecarie e catastali		
-- S6 - STATO CIVILE - Servizio Elettorale		
-- S8 - STATO CIVILE - NON VALIDO PER L'ESTERO (uso matrimonio)		
-- S9 - STATO CIVILE - VALIDO PER L'ESTERO (uso matrimonio)		

insert into anpt39 (CODICE, DESCRIZIONE, FLAG_ESENZIONE, NOTE)
values ('S1', 'STATO CIVILE - Art. 40 comma 2 DPR 445/2000', null, null);

insert into anpt39 (CODICE, DESCRIZIONE, FLAG_ESENZIONE, NOTE)
values ('S2', 'STATO CIVILE - Certificati da produrre all''estero', null, null);

insert into anpt39 (CODICE, DESCRIZIONE, FLAG_ESENZIONE, NOTE)
values ('S3', 'STATO CIVILE - Procedimenti giudiziari contenziosi', null, null);

insert into anpt39 (CODICE, DESCRIZIONE, FLAG_ESENZIONE, NOTE)
values ('S4', 'STATO CIVILE - Norme sulla condizione dello straniero e immigrazione', null, null);

insert into anpt39 (CODICE, DESCRIZIONE, FLAG_ESENZIONE, NOTE)
values ('S5', 'STATO CIVILE - Formalita'' ipotecarie e catastali', null, null);

insert into anpt39 (CODICE, DESCRIZIONE, FLAG_ESENZIONE, NOTE)
values ('S6', 'STATO CIVILE - Servizio Elettorale', null, null);
