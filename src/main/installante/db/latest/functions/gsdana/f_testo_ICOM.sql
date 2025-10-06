--liquibase formatted sql
--changeset amonopoli:202501131440 runOnChange:true stripComments:false
CREATE OR REPLACE function f_testo_icom
(testo 			IN 	varchar2
,p_matricola 		IN      number
,p_tipo_comunicazione	IN	varchar2
,p_oggetto		IN	varchar2
,p_campo_scadenza	IN	varchar2
)
 
return varchar2

IS
w_testo         varchar2(4000) :=null;
w_testo_finale  varchar2(4000) :=null;
variabile       varchar2(4000) := null;
w_variabile     varchar2(4000) := null;
w_data_scadenza	varchar2(255);

BEGIN
  w_testo := testo;
  begin
  while instr(w_testo,'<') > 0 and instr(w_testo,'>') > 0 loop
     w_testo_finale := w_testo_finale ||substr(w_testo,1,instr(w_testo,'<')-1);
     w_testo := substr(w_testo,instr(w_testo,'<')+1);
     variabile := substr(w_testo,1,instr(w_testo,'>')-1);
     w_variabile := null;
     begin
	select decode(lower(variabile),
--MATRICOLA                      
                 'matricola',matricola,
--CODICE_FAMIGLIA                
                 'codice_famiglia',codice_famiglia,
--COGNOME_NOME                   
                 'cognome_nome',cognome_nome,
--PATERNITA                      
                 'paternita',paternita,
--MATERNITA                      
                 'maternita',maternita,
--INDIRIZZO                      
                 'indirizzo',indirizzo,
--INDIRIZZO_INT                  
                 'indirizzo_int',indirizzo_int,
--SESSO                          
                 'sesso',sesso,
--DATA_NASCITA                   
                 'data_nascita',data_nascita,
--COMUNE_NASCITA                 
                 'comune_nascita',comune_nascita,
--STATO_CIVILE                   
                 'stato_civile',stato_civile,
--COGNOME_NOME_CONIUGE           
                 'cognome_nome_coniuge',cognome_nome_coniuge,
--RAPPORTO_PARENTELA             
                 'rapporto_parentela',rapporto_parentela,
--NAZIONALITA                    
                 'nazionalita',nazionalita,
--CODICE_FISCALE                 
                 'codice_fiscale',codice_fiscale,
--NUMERO_CI                      
                 'numero_ci',numero_ci,
--VALIDITA_ESPATRIO_CI           
                 'validita_espatrio_ci',validita_espatrio_ci,
--DATA_EMISSIONE_CI              
                 'data_emissione_ci',data_emissione_ci,
--DATA_SCADENZA_CI               
                 'data_scadenza_ci',data_scadenza_ci,
--ENTE_EMISSIONE_CI              
                 'ente_emissione_ci',ente_emissione_ci,
--TIPO_DI                        
                 'tipo_di',tipo_di,
--NUMERO_DI                      
                 'numero_di',numero_di,
--VALIDITA_ESPATRIO_DI           
                 'validita_espatrio_di',validita_espatrio_di,
--DATA_EMISSIONE_DI              
                 'data_emissione_di',data_emissione_di,
--DATA_SCADENZA_DI               
                 'data_scadenza_di',data_scadenza_di,
--ENTE_EMISSIONE_DI              
                 'ente_emissione_di',ente_emissione_di,
--MOTIVO_DI                      
                 'motivo_di',motivo_di,
--TIPO_DS                        
                 'tipo_ds',tipo_ds,
--NUMERO_DS                      
                 'numero_ds',numero_ds,
--DATA_EMISSIONE_DS              
                 'data_emissione_ds',data_emissione_ds,
--DATA_SCADENZA_DS               
                 'data_scadenza_ds',data_scadenza_ds,
--ENTE_EMISSIONE_DS              
                 'ente_emissione_ds',ente_emissione_ds,
--MOTIVO_DS                      
                 'motivo_ds',motivo_ds,
--DATA_IAPR                      
                 'data_iapr',data_iapr,
--PRATICA_IAPR                   
                 'pratica_iapr',pratica_iapr,
--DATA_PERFEZIONAMENTO_IAPR
                 'data_perfezionamento_iapr',data_perfezionamento_iapr,
--DATA_CABI                      
                 'data_cabi',data_cabi,
--PRATICA_CABI                   
                 'pratica_cabi',pratica_cabi,
--DATA_PERFEZIONAMENTO_CABI
                 'data_perfezionamento_cabi',data_perfezionamento_cabi,
--DATA
                 'data',data,
               variabile)    
  	 into w_variabile
	 FROM ANAVCO 
        WHERE matricola = p_matricola
	 and rownum = 1;
     exception
	when others then
	  w_variabile := variabile;
     end;
     w_testo_finale := w_testo_finale||w_variabile;
     w_testo := substr(w_testo,instr(w_testo,'>')+1);
   end loop;

   w_testo_finale := w_testo_finale||w_testo;   

   if p_tipo_comunicazione = 'A' then
      w_testo_finale := '{
'||                        '  "content": {
'||                        '    "subject": "'||replace(p_oggetto,'"','\"')||'",
'||                        '    "markdown": "'||replace(replace(w_testo_finale,chr(10),'\n'),'"','\"')||'"';

      w_data_scadenza := '';
      if p_campo_scadenza is not null then
         begin
           select decode(lower(p_campo_scadenza),
--DATA_NASCITA                   
                    'data_nascita',data_nascita,
--DATA_EMISSIONE_CI              
                    'data_emissione_ci',data_emissione_ci,
--DATA_SCADENZA_CI               
                    'data_scadenza_ci',data_scadenza_ci,
--DATA_EMISSIONE_DI              
                    'data_emissione_di',data_emissione_di,
--DATA_SCADENZA_DI               
                    'data_scadenza_di',data_scadenza_di,
--DATA_EMISSIONE_DS              
                    'data_emissione_ds',data_emissione_ds,
--DATA_SCADENZA_DS               
                    'data_scadenza_ds',data_scadenza_ds,
--DATA_IAPR                      
                    'data_iapr',data_iapr,
--DATA_PERFEZIONAMENTO_IAPR
                    'data_perfezionamento_iapr',data_perfezionamento_iapr,
--DATA_CABI                      
                    'data_cabi',data_cabi,
--DATA_PERFEZIONAMENTO_CABI
                    'data_perfezionamento_cabi',data_perfezionamento_cabi,
--DATA
                    'data',data)    
             into w_data_scadenza
             FROM ANAVCO 
            WHERE matricola = p_matricola
              and rownum = 1
           ;
         exception
           when others then
                w_data_scadenza := '';
         end;

--select TO_CHAR(FROM_TZ(CAST(TO_DATE('09/05/2023 23:59:59','DD/MM/YYYY hh24:MI:ss') AS TIMESTAMP ), 'CET' ) AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"') from dual
         if w_data_scadenza is not null then
--            w_data_scadenza := to_char(to_date(w_data_scadenza,'dd/mm/yyyy'),'yyyy-mm-dd')||'T00:00:00.000Z';
            w_data_scadenza := TO_CHAR(FROM_TZ(CAST(TO_DATE(w_data_scadenza||' 23:59:59','DD/MM/YYYY hh24:MI:ss') AS TIMESTAMP ), 'CET' ) AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"');
            w_testo_finale  := w_testo_finale||',
'||                            '    "due_date": "'||w_data_scadenza||'"';
         end if;
      end if;

      w_testo_finale := w_testo_finale||'
'||                        '  }
'||                        '}';
   end if;

   return(w_testo_finale);
   end;
END;
/

