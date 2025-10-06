--liquibase formatted sql
--changeset amonopoli:202403131710_2 runOnChange:true stripComments:false
create or replace view arccom_storico
AS
select v.*
     , nvl(v.descrizione_al1,v.descrizione) des_comune
     , to_date(v.data_inizio_validita,'j') d_data_inizio_validita
     , to_date(v.data_fine_validita,'j') d_data_fine_validita
     , to_date(v.data_soppressione,'j') d_data_soppressione
     , lpad(v.cod_provincia,3,'0')||
         lpad(v.cod_comune,3,'0')||
         nvl(v.data_inizio_validita,1111111)||
         nvl(v.data_fine_validita,9999999) ID
     , lpad(v.cod_provincia,3,'0')||
         lpad(v.cod_comune,3,'0') ID_ARCCOM
  from (
--
-- comuni italiani attivi
-- (compreso vecchie denominazioni senza data soppressione)
--
select com.cod_provincia, com.cod_comune, com.descrizione, com.descrizione_al1, 
       pro.sigla_provincia, com.codice_catasto,
       pro.data_inizio_validita, pro.data_fine_validita,
       com.data_soppressione, com.cod_pro_fusione, com.cod_com_fusione,
       pro.flag_istat flag_istat, to_char(null) flag_soppresso,
       pro.sigla_provincia des_sigla_provincia
  from arcpro_storico pro, arccom com_f, arccom com
 where pro.cod_provincia                = com.cod_provincia
   and com_f.cod_provincia	(+)	= com.cod_pro_fusione
   and com_f.cod_comune		(+)	= com.cod_com_fusione
   and nvl(com.data_soppressione,com_f.data_soppressione)	is null
   and com.cod_provincia                < 198
UNION
--
-- comuni italiani soppressi
-- (compreso vecchie denoninazioni con data soppressione)
--
select com.cod_provincia, com.cod_comune, com.descrizione, com.descrizione_al1, 
       pro.sigla_provincia, com.codice_catasto,
       pro.data_inizio_validita, 
       decode(pro.data_fine_validita,'',
         nvl(com.data_soppressione,com_f.data_soppressione),
         decode(sign(pro.data_fine_validita-nvl(com.data_soppressione,com_f.data_soppressione)),
           -1,pro.data_fine_validita,nvl(com.data_soppressione,com_f.data_soppressione))),
       nvl(com.data_soppressione,com_f.data_soppressione), com.cod_pro_fusione, com.cod_com_fusione,
       pro.flag_istat flag_istat, 'S' flag_soppresso,
       pro.sigla_provincia des_sigla_provincia
  from arcpro_storico pro, arccom com_f, arccom com
 where pro.cod_provincia                = com.cod_provincia
   and pro.data_inizio_validita         < nvl(com.data_soppressione,com_f.data_soppressione)
   and com_f.cod_provincia	(+)	= com.cod_pro_fusione
   and com_f.cod_comune		(+)	= com.cod_com_fusione
   and nvl(com.data_soppressione,com_f.data_soppressione)	is not null
   and com.cod_provincia                < 198
UNION
--
-- stati esteri: situazione attuale
--
select com.cod_provincia, com.cod_comune, com.descrizione, com.descrizione_al1, 
       sta.sigla,
       sta.codice_catasto,
       sta.data_inizio_validita, sta.data_fine_validita,
       com.data_soppressione, com.cod_pro_fusione, com.cod_com_fusione,
       sta.flag_istat flag_istat, 
       decode(com.data_soppressione,'','','S') flag_soppresso,
       decode(com.cod_comune,0,sta.sigla,sta.descrizione) des_sigla_provincia
  from arcsta_storico sta, arccom com
 where sta.cod_stato            	= com.cod_provincia
   and com.data_soppressione		is null
   and com.cod_provincia		not in (701,702,703)
UNION
select com.cod_provincia, com.cod_comune, com.descrizione, com.descrizione_al1, 
       sta.sigla,
       sta.codice_catasto,
       sta.data_inizio_validita, sta.data_fine_validita,
       com.data_soppressione, com.cod_pro_fusione, com.cod_com_fusione,
       sta.flag_istat flag_istat, 
       decode(com.data_soppressione,'','','S') flag_soppresso,
       decode(com.cod_comune,0,sta.sigla,sta.descrizione) des_sigla_provincia
  from arcsta_storico sta, arccom com
 where sta.cod_stato            	= com.cod_provincia
   and com.data_soppressione		is null
   and com.cod_provincia		in (701,702,703)
   and com.cod_comune			< 500
UNION
--
-- stati esteri: situazione storica
--
select com.cod_provincia, com.cod_comune, 
       decode(com.cod_comune,0,sta.descrizione,com.descrizione),
       decode(com.cod_comune,0,to_char(null),com.descrizione_al1),
       sta.sigla,
       sta.codice_catasto,
       sta.data_inizio_validita, com.data_soppressione,
       com.data_soppressione, com.cod_pro_fusione, com.cod_com_fusione,
       sta.flag_istat flag_istat, 'S' flag_soppresso,
       decode(com.cod_comune,0,sta.sigla,sta.descrizione) des_sigla_provincia
  from arcsta_storico sta, arccom com
 where sta.cod_stato                 	= com.cod_provincia
   and sta.data_inizio_validita		<= com.data_soppressione
   and com.cod_provincia		not in (701,702,703)
UNION
select com.cod_provincia, com.cod_comune, 
       decode(com.cod_comune,0,sta.descrizione,com.descrizione),
       decode(com.cod_comune,0,to_char(null),com.descrizione_al1),
       sta.sigla,
       sta.codice_catasto,
       sta.data_inizio_validita, com.data_soppressione,
       com.data_soppressione,com.cod_pro_fusione, com.cod_com_fusione,
       sta.flag_istat flag_istat, 'S' flag_soppresso,
       decode(com.cod_comune,0,sta.sigla,sta.descrizione) des_sigla_provincia
  from arcsta_storico sta, arccom com
 where sta.cod_stato                 	= com.cod_provincia
   and sta.data_inizio_validita		<= com.data_soppressione
   and com.cod_provincia		in (701,702,703)
   and com.cod_comune			< 500
UNION
--
-- comuni ceduti (fiume - pola - zara)
--
select com.cod_provincia, com.cod_comune, com.descrizione, com.descrizione_al1,
       com.sigla_provincia, com.codice_catasto,
       2400777, nvl(com.data_soppressione,com_f.data_soppressione),
       com.data_soppressione, com.cod_pro_fusione, com.cod_com_fusione,
       'S' flag_istat, 'S' flag_soppresso,
       com.sigla_provincia des_sigla_provincia
  from arccom com_f, arccom com
 where com_f.cod_provincia	(+)	= com.cod_pro_fusione
   and com_f.cod_comune		(+)	= com.cod_Com_fusione
   and com.cod_provincia 		in (701,702,703)   
   and com.cod_comune 			>= 500 
UNION
--
-- comuni NON ISTAT
--
select com.cod_provincia, com.cod_comune, com.descrizione, com.descrizione_al1, 
       com.sigla_provincia, com.codice_catasto,
       2400777, nvl(com.data_soppressione, com_f.data_soppressione),
       nvl(com.data_soppressione,com_f.data_soppressione),
       com.cod_pro_fusione, com.cod_com_fusione,
       '' flag_istat, 
       decode(nvl(com.data_soppressione,com_f.data_soppressione),'','','S') flag_soppresso,
       com.sigla_provincia des_sigla_provincia
  from arccom com_f, arccom com
 where com_f.cod_provincia	(+)	= com.cod_pro_fusione
   and com_f.cod_comune		(+)	= com.cod_com_fusione
   and com.cod_provincia                in (0,198,199)
UNION
select com.cod_provincia, com.cod_comune, com.descrizione, com.descrizione_al1, 
       com.sigla_provincia, com.codice_catasto,
       2400777, com.data_soppressione,
       com.data_soppressione, com.cod_pro_fusione, com.cod_com_fusione,
       '' flag_istat, 
       decode(com.data_soppressione,'','','S') flag_soppresso,
       com.sigla_provincia des_sigla_provincia
  from arccom com
 where com.cod_provincia                > 199
   and not exists (select 'x' from arcsta_storico sta
                    where cod_stato = com.cod_provincia)
) v
/
comment on table arccom_storico is 'Comuni - Archivio Storico (view)'
/
