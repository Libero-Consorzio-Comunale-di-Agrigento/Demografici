--liquibase formatted sql
--changeset amonopoli:202503211241_1 runOnChange:true stripComments:false
create or replace view ISTD7B
	(archivio, punto, 
	 matricola,cognome_nome,sesso,pratica,anno_pratica,
         ufficio,anno,atto,parte,serie, data_eve,
	 data_reg,no_conteggio)
AS
-- nati nel comune (1.1)
select 'NAS','2.1',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_nas,anno_atto_nas,atto_nas,parte_nas,serie_nas,data_nas,data_reg,no_conteggio       
  from anamov mov, anadce dce
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ')	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		= 'N'
   and dce.tipo_evento 			= 'I'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and (cod_pro_nas,cod_com_nas) in (select pro_cliente, com_cliente 
                                       from menuditta
				      union
	 			     select f.cod_provincia,f.cod_comune
				       from arccom f, arccom m
				      where f.cod_pro_fusione = m.cod_provincia
                                        and f.cod_com_fusione = m.cod_comune
                                        and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
UNION
-- nati in altro comune
select 'NAS','2.2',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_nas,anno_atto_nas,atto_nas,parte_nas,serie_nas,data_nas,data_reg,no_conteggio       
  from anamov mov, anadce dce
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		= 'N'
   and dce.tipo_evento 			= 'I'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and cod_pro_nas  			< 199
   and (cod_pro_nas,cod_com_nas) not in (select pro_cliente w_pro, com_cliente w_com 
                                           from menuditta
			   	         union
					 select f.cod_provincia, f.cod_comune
					   from arccom f, arccom m
					  where f.cod_pro_fusione = m.cod_provincia
                                            and f.cod_com_fusione = m.cod_comune
                                            and (m.cod_provincia, m.cod_comune) 
						 = (select pro_cliente, com_cliente from menuditta)) 
UNION
-- nati all'estero
select 'NAS','2.3',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_nas,anno_atto_nas,atto_nas,parte_nas,serie_nas,data_nas,data_reg,no_conteggio       
  from anamov mov, anadce dce
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		= 'N'
   and dce.tipo_evento 			= 'I'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and cod_pro_nas  			>= 199
UNION
-- MORTI NEL COMUNE
select 'MOR','3.1',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_mor,anno_atto_mor,atto_mor,parte_mor,serie_mor,data_mor,data_reg,no_conteggio       
  from anamov mov, anadce dce
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		= 'N'
   and dce.tipo_evento 			= 'C'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and (cod_pro_mor,cod_com_mor) in (select pro_cliente, com_cliente 
                                       from menuditta
				     union
	 			     select f.cod_provincia, f.cod_comune
				       from arccom f, arccom m
				      where f.cod_pro_fusione = m.cod_provincia
                                        and f.cod_com_fusione = m.cod_comune
                                        and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
UNION
-- MORTI IN ALTRO COMUNE
select 'MOR','3.2',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_mor,anno_atto_mor,atto_mor,parte_mor,serie_mor,data_mor,data_reg,no_conteggio       
  from anamov mov, anadce dce, menuditta
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   AND nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		= 'N'
   and dce.tipo_evento 			= 'C'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and cod_pro_mor  			< 199
   and (cod_pro_mor,cod_com_mor) not in (select pro_cliente, com_cliente 
                                           from menuditta
	    	   	 	         union
	 			         select f.cod_provincia, f.cod_comune
				           from arccom f, arccom m
				          where f.cod_pro_fusione = m.cod_provincia
                                            and f.cod_com_fusione = m.cod_comune
                                            and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
UNION
-- MORTI ALL'ESTERO
select 'MOR','3.3',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_mor,anno_atto_mor,atto_mor,parte_mor,serie_mor,data_mor,data_reg,no_conteggio       
  from anamov mov, anadce dce
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		= 'N'
   and dce.tipo_evento 			= 'C'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and cod_pro_mor  			>= 199
UNION
-- ISCRITTI DA ALTRO COMUNE
select 'ISC','5.1',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_nas,anno_atto_nas,atto_nas,parte_nas,serie_nas,data_eve,data_reg,no_conteggio       
  from anamov mov, anadce dce
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio		is null
   and dce.tipo_evento_istat		= 'M'
   and dce.tipo_evento 			= 'I'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and nvl(cod_pro_eve,0) 		< 199
UNION
-- iscritti dall'estero
select 'ISC','5.2',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_nas,anno_atto_nas,atto_nas,parte_nas,serie_nas,data_eve,data_reg,no_conteggio       
  from anamov mov, anadce dce
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		= 'M'
   and dce.tipo_evento 			= 'I'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and nvl(cod_pro_eve,0) 		>= 199
UNION
-- iscritti per altri motivi
select 'ISC','5.3',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_nas,anno_atto_nas,atto_nas,parte_nas,serie_nas,data_eve,data_reg,no_conteggio       
  from anamov mov, anadce dce
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		in ('I','A')
   and dce.tipo_evento 			= 'I'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
UNION
-- cancellati da altro comune
select 'CNC','6.1',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_nas,anno_atto_nas,atto_nas,parte_nas,serie_nas,data_eve,data_reg,no_conteggio       
  from anamov mov, anadce dce 
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		= 'M'
   and dce.tipo_evento 			= 'C'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and nvl(mov.cod_pro_eve,0) 		< 199
UNION
-- cancellati dall'estero
select 'CNC','6.2',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_nas,anno_atto_nas,atto_nas,parte_nas,serie_nas,data_eve,data_reg,no_conteggio       
  from anamov mov, anadce dce
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		= 'M'
   and dce.tipo_evento 			= 'C'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
   and nvl(cod_pro_eve,0) 		>= 199
UNION
--cancellati per altri motivi
select 'CNC','6.3',
       mov.matricola,mov.cognome_nome,sesso,pratica,anno_pratica,
       ufficio_nas,anno_atto_nas,atto_nas,parte_nas,serie_nas,data_eve,data_reg,no_conteggio       
  from anamov mov, anadce dce 
 where mov.cod_mov 	   		= dce.cod_mov
   and mov.cod_eve			= dce.cod_eve
   and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
   and mov.no_conteggio			is null
   and dce.tipo_evento_istat		in ('I','A')
   and dce.tipo_evento 			= 'C'
   and dce.flag_istat			= 'S'
   and dce.anagrafe 			= 'RES'
/
comment on table ISTD7B is 'ISTAT - Dati per Compilazione Modello D7B (view)'
/
