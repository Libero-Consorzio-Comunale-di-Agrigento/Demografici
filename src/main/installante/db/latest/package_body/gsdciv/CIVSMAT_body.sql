--liquibase formatted sql
--changeset amonopoli:202402051315_2 runOnChange:true stripComments:false
create or replace package body CIVSMAT is                                       
                                                                                
procedure main is                                                               
begin                                                                           
rpt.package_name := 'CIVSMAT';                                                  
--  ********************************************************************        
--  * NOME : CIVSMAT.RPT *                                                      
--  * DATA : 12/09/90 *                                                         
--  * AUTHOR : A. BRANDOLINI *                                                  
--  * FUNZIONE : IL PROGRAMMA STAMPA L''ATTO DI MATRIMONIO COMPLETO * 
--  * DATA : 17/10/03 *                                                         
--  * MODIFY : G: GIOVINETTO *                                                  
--  * MODIFICATO PER L'USO DI CLOB *           
--  ********************************************************************        
--                                                                              
--  TABULAZIONI                                                                 
--  ===========                                                                 
--                                                                              
--  ATTO_DX                                                                     
      rpf.DT(1,'15 84 88 121 ');                                                
--                                                                              
--  ATTO_SX                                                                     
      rpf.DT(11,'8 41 44 113 ');                                                
--                                                                              
--  PROCEDURA                                                                   
--  =========       
      rpt.execute('SEL_PARAMETRI');                                             
      rpt.execute('SEL_INCH');                                                  
      rpf.PRINT(OTTO_INCH,'A10');                                               
      rpt.execute('SEL_CIVMAT');                                                
      rpt.execute('SEL_CMA');                                                   
      rpt.execute('SEL_MAR');                                                   
	civsmat.CTR_SALTO_ATTI;
      if DX_SX = 'D' then goto rpt_DX; end if;                                  
      rpf.T(11);   
      if PARTE = 2 AND SERIE = 'C' then goto rpt_NUMERO_SX; end if;             
      if stampa_solo_margine = 'S' then
	 null;
      else 
         rpf.PRINT('              ');                                              
      end if;
      goto rpt_SALTA_NUMERO_SX;                                                 
<< rpt_NUMERO_SX >>                                                             
      if stampa_solo_margine = 'S' then
	 null;
      else 
         rpf.PRINT('        Numero');                                              
      end if;
<< rpt_SALTA_NUMERO_SX >>                                                       
      civsmat.STAMPA_NOMI_MARGINE;                            
      if PARTE = 2 AND SERIE IN ('A','B') then goto rpt_PROSEGUI_S; else goto rpt_CONV_S; end if;                                                                                                                                                              
<< rpt_PROSEGUI_S >>                                                            
      if PARTE = 2 AND SERIE = 'B' then goto rpt_MAR_2B_S; end if;              
<< rpt_MAR_2A_S >> 
      if nvl(stampa_min,' ') != ' ' then                                                             
         rpf.CS(2);                                                                
         rpf.PRINT('    ');                                                        
         rpf.PRINT(DATA_TRAS,'A25');                                               
         rpf.CS(1);                                                                
         rpf.PRINT('    ');                                                        
         rpf.PRINT(ANNO_TRAS,'A15');                                               
         rpf.CS(1);                                                                
         rpf.PRINT('            ');                                                
         rpf.PRINT(MINISTRO_1,'A20');                                              
         rpf.CS(1);                                                                
         rpf.PRINT(MINISTRO_2,'A33');                                              
--      rpf.CS(43);     
      else
        rpf.CS(9);
      end if;                                                            
      goto rpt_CONV_S;                                                        
<< rpt_MAR_2B_S >> 
      if nvl(stampa_min,' ') != ' ' then                                                              
         if DATA_TRAS is null then goto rpt_CONV_S; end if;                        
         rpf.CS(8);                                                                
         rpf.PRINT(' In data');                                                    
         rpf.PRINT(DATA_TRAS,'A25');                                               
         rpf.N;          
         rpt.execute('SEL_FLAG');
         if flag = 0 then
            rpf.PRINT('millenovecento____');                                          
         else
            rpf.PRINT('duemila___________');                                          
         end if;
         rpf.PRINT(ANNO_TRAS,'A15');                                               
         rpf.N;                                                                    
         rpf.PRINT('ho trasmesso notizia al ministro__');                          
         Rpf.N;                                                                    
         rpf.PRINT('del culto di_');                                               
         rpf.PRINT(MINISTRO_1,'A20');                                              
         rpf.N;                                                                    
         rpf.PRINT(MINISTRO_2,'A33');                                              
         rpf.N;                                                                    
         rpf.PRINT('dell''eseguita trascrizione dell''__');                        
         rpf.N;                                                                    
         rpf.PRINT('atto controscritto con l''indica-__');                         
         rpf.N;                                                                    
         rpf.PRINT('zione della data in cui essa e''___');                         
         rpf.N;                                                                    
         rpf.PRINT('stata effettuata._________________');                          
         rpf.CS(1);                                                                
         rpf.R;                                                                    
         rpf.PRINT('L''UFFICIALE DELLO STATO CIVILE');                             
         rpf.N;                                                                    
         rpf.print('F.to: '||nvl(UFFICIALE_PROV,CMA_FIRMA_MAR),'A34');
         rpf.R; 
      else 
         rpf.CS(20);
      end if;                                                                   
<< rpt_CONV_S >>                        
      civsmat.STAMPA_TESTO_MARGINE;                                        
      if CONVENZIONI is null then goto rpt_MARGINE_LIB; end if;                    
      civsmat.STAMPA_CONV_MARGINE;
<< rpt_MARGINE_LIB >>   
	if w_stampa_lib = 'S' then
           civsmat.STAMPA_MARGINE_LIB;
        end if;
        rpt.report('SEL_MARGINE_ANN','STAMPA_MARGINE_ANN');
<< rpt_NEXT_COL >>   
	rpf.NC;                                                                   
	goto rpt_SX;                                                              
<< rpt_DX >>                                                                    
	rpf.T(1);                                                                 
<< rpt_SX >>    
	if stampa_solo_margine = 'S' then 
	   if DX_SX = 'S' then goto fine_rpf2; end if; 
	   if PARTE = 2 AND SERIE = 'C' then rpf.NC; goto rpt_NUMERO_DX; end if;             
	   rpf.NC;
	   if stampa_solo_margine = 'S' then
	      null;                                                             
	   else 
	      rpf.PRINT('              ');                                              
	   end if;
           goto rpt_SALTA_NUMERO_DX;   
  	end if;                                                           

      if PARTE = 2 AND SERIE = 'C' then goto rpt_TESTO_LIBERO; end if;          
      if PARTE = 1 OR (PARTE = 2 AND SERIE = 'A') then goto rpt_ORIG; end if;   
      rpt.execute('SEL_TTR');                                                   
      rpf.PRINT('       ');                                                     
      rpf.PRINT(ANNO_TR,'A37');                                                 
      rpf.PRINT('    ');                                                        
      rpf.PRINT(GIORNO_TR,'A19');                                               
      rpf.CS(1);                                                                
      rpf.PRINT('       ');                                                     
      rpf.PRINT(MESE_TR,'A11');                                                 
      rpf.PRINT('     ');                                                       
      rpf.PRINT(ORE_TR,'A18');                                                  
      rpf.PRINT('     ');                                                       
      rpf.PRINT(MINUTI_TR,'A19');                                               
      rpf.CS(3);                                                                
      rpf.PRINT('     ');                                                       
      rpf.PRINT(UFFICIALE_TR,'A64');                                            
      rpf.CS(1);                                                                
      rpf.PRINT('                           ');                                 
      rpf.PRINT(COMUNE_TR,'A42');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(MOTIVO_TR,'A68');                                               
      rpf.CS(3);                                                                
      rpf.PRINT(COMUNE_OR,'A70');                                               
      rpf.CS(3);                                                                
<< rpt_ORIG >>                                                                  
--      rpt.execute('SEL_TTE');                                                   
--      rpt.execute('SEL_TES_SPO');                                               
      rpt.execute('SEL_TES_SPO_TTE');                                               
      rpf.PRINT('       ');                                                     
      rpf.PRINT(ANNO_TESTATA,'A37');                                            
      rpf.PRINT('    ');                                                        
      rpf.PRINT(GIORNO,'A19');                                                  
      rpf.CS(1);                                                                
      rpf.PRINT('       ');                                                     
      rpf.PRINT(MESE,'A11');                                                    
      rpf.PRINT('     ');                                                       
      rpf.PRINT(ORE,'A18');                                                     
      rpf.PRINT('     ');                                                       
      rpf.PRINT(MINUTI,'A19');                                                  
      rpf.CS(3);                                                                
      if PARTE = 2 then goto rpt_PARTE_2; end if;                               
      rpf.PRINT('          ');                                                  
      rpf.PRINT(UFFICIALE,'A65');                                               
      rpf.CS(1);                                                                
      rpf.PRINT('                           ');                                 
      rpf.PRINT(COMUNE,'A42');                                                  
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(MOTIVO,'A68');                                                  
      rpf.CS(1);                                                                
      goto rpt_SPOSI;                                                           
<< rpt_PARTE_2 >>                                                               
      rpf.PRINT('    ');                                                        
      rpf.PRINT(UFFICIALE,'A65');                                               
      rpf.CS(1);                                                                
      rpf.PRINT('                           ');                                 
      rpf.PRINT(COMUNE,'A42');                                                  
      rpf.CS(1);                                                                
      if PARTE = 2 AND SERIE = 'B' then goto rpt_SEL_CMA; end if;               
      rpf.PRINT(' ');                                                           
      rpf.PRINT(MOTIVO,'A68');                                                  
      rpf.CS(1);                                                                
<< rpt_SEL_CMA >>                                                               
      rpt.execute('SEL_DMA_ART');                                               
      rpf.PRINT('           ');                                                 
      rpf.PRINT(MINISTRO,'A58');                                                
      rpf.CS(1);                                                                
      rpf.PRINT(QUALITA_1,'A70');                                               
      rpf.CS(1);                                                                
      if PARTE = 2 AND SERIE = 'B' then goto rpt_ANNO_MAT; end if;              
      rpf.PRINT(QUALITA_2,'A70');                                               
      rpf.CS(1);                                                                
<< rpt_ANNO_MAT >>                                                              
      rpf.CS(2);                                                                
      rpf.PRINT('       ');                                                     
      rpf.PRINT(ANNO_MAT,'A37');                                                
      rpf.PRINT('    ');                                                        
      rpf.PRINT(GIORNO_MAT,'A19');                                              
      rpf.CS(1);                                                                
      rpf.PRINT('       ');                                                     
      rpf.PRINT(MESE_MAT,'A11');                                                
      rpf.PRINT('     ');                                                       
      rpf.PRINT(ORE_MAT,'A18');                                                 
      rpf.PRINT('     ');                                                       
      rpf.PRINT(MINUTI_MAT,'A19');                                              
      rpf.CS(1);                                                                
      rpf.PRINT('   ');                                                         
      rpf.PRINT(COMUNE_MAT,'A66');                                              
      rpf.CS(1);                                                                
      rpf.PRINT('   ');                                                         
      rpf.PRINT(NEL,'A2');                                                      
      rpf.PRINT(LUOGO_MAT,'A63');                                               
      rpf.CS(1);                                                                
      rpf.PRINT('                              ');                              
      rpf.PRINT(RITO1,'A39');                                                   
      rpf.CS(1);                                                                
      if PARTE = 2 AND SERIE = 'B' then goto rpt_SALTA_CS; end if;              
      rpf.PRINT(RITO2,'A70');                                                   
      rpf.CS(1);                                                                
      rpf.PRINT(RITO3,'A70');                                                   
      rpf.CS(1);                                                                
<< rpt_SPOSI >>                                                                 
      if PARTE = 2 then goto rpt_SALTA_CS; end if;                              
      rpf.CS(2);                                                                
<< rpt_SALTA_CS >>                                                              
      rpf.PRINT(' ');                                                           
      rpf.PRINT(COGNOME_M,'A32');                                               
      rpf.PRINT('  ');                                                          
      rpf.PRINT(COGNOME_F,'A32');                                               
      rpf.CS(1);                                                                
      rpf.CL;                                                                   
      rpf.PRINT(NOMI,'A70');                                                    
      rpf.end_centertrunc;                                                      
      rpf.CS(1);                                                                
      rpf.PRINT('    ');                                                        
      rpf.PRINT(COM_NAS_M,'A29');                                               
      rpf.PRINT('     ');                                                       
      rpf.PRINT(COM_NAS_F,'A29');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(DATA_NAS1_M,'A32');                                             
      rpf.PRINT('  ');                                                          
      rpf.PRINT(DATA_NAS1_F,'A32');                                             
      rpf.CS(1);                                                                
      rpf.CL;                                                                   
      rpf.PRINT(DATA_NAS2,'A70');                                               
      rpf.end_centertrunc;                                                      
      rpf.CS(1);                                                                
      rpf.PRINT('    ');                                                        
      rpf.PRINT(ATTO_NAS_M,'A9');                                               
      rpf.PRINT(' ');                                                           
      rpf.PRINT(PARTE_NAS_M,'A6');                                              
      rpf.PRINT(' ');                                                           
      rpf.PRINT(SERIE_NAS_M,'A8');                                              
      rpf.PRINT('     ');                                                       
      rpf.PRINT(ATTO_NAS_F,'A9');                                               
      rpf.PRINT(' ');                                                           
      rpf.PRINT(PARTE_NAS_F,'A6');                                              
      rpf.PRINT(' ');                                                           
      rpf.PRINT(SERIE_NAS_F,'A8');                                              
      rpf.CS(1);                                                                
      rpf.CL;                                                                   
      rpf.PRINT('__________________________________  __________________________________');                                                                                                                                                                     
      rpf.end_centertrunc;                                                      
      rpf.CS(1);                                                                
      rpf.CL;                                                                   
      rpf.PRINT(RIGA_STATO_CIVILE,'A70');                                       
      rpf.end_centertrunc;                                                      
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(PROF_M,'A32');                                                  
      rpf.PRINT('  ');                                                          
      rpf.PRINT(PROF_F,'A32');                                                  
      rpf.CS(1);                                                                
      rpf.PRINT('       ');                                                     
      rpf.PRINT(RESIDENZA_M,'A26');                                             
      rpf.PRINT('        ');                                                    
      rpf.PRINT(RESIDENZA_F,'A26');                                             
      rpf.CS(1);                                                                
      rpf.PRINT('         ');                                                   
      rpf.PRINT(CITTADINANZA_M,'A24');                                          
      rpf.PRINT('          ');                                                  
      rpf.PRINT(CITTADINANZA_F,'A24');                                          
      rpf.CS(1);                                                                
      if PARTE = 1 then goto rpt_RMA; end if;                                   
      rpf.CL;                                                                   
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.end_centertrunc;                                                      
      rpf.CS(3);                                                                
      rpf.PRINT(MINISTRO1,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(MINISTRO2,'A70');                                               
      rpf.CS(3);                                                                
      rpf.PRINT('                        ');                                    
      rpf.PRINT('                         ');                                   
      rpf.PRINT(NON,'A9');                                                      
      rpf.CS(1);                                                                
      rpf.PRINT(ART_RIGA1,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(ART_RIGA2,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(ART_RIGA3,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(ART_RIGA4,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(ART_RIGA5,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(ART_RIGA6,'A70');                                               
      rpf.CS(1);                                                                
      if CMA_RIGA1 is null then goto rpt_RIGHE; end if;                         
      rpf.PRINT(' ');                                                           
      rpf.PRINT(CMA_RIGA1,'A68');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA2,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA3,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA4,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA5,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA6,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA7,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA8,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA9,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA10,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA11,'A70');                                              
      rpf.CS(1);                                                                
      if PARTE = 2 AND SERIE = 'B' then goto rpt_FIRMA; end if;                 
      rpf.PRINT(CMA_RIGA12,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA13,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA14,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA15,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA16,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA17,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA18,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(CMA_RIGA19,'A70');                                              
      goto rpt_SE_NP;                                                           
<< rpt_RIGHE >>                                                                 
      rpf.PRINT(' ');                                                           
      rpf.PRINT('____________________________________________________________________');                                                                                                                                                                       
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      if PARTE = 2 AND SERIE = 'B' then goto rpt_FIRMA; end if;                 
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      rpf.CS(1);                                                                
      rpf.PRINT('______________________________________________________________________');                                                                                                                                                                     
      goto rpt_SE_NP;                                                           
<< rpt_FIRMA >>                                                                 
      rpf.CS(6);                                                                
      rpf.PRINT('                                 ');                           
      rpf.PRINT(CMA_FIRMA,'A34');                                               
      goto rpt_SE_NP;                                                           
<< rpt_RMA >>                                                                   
      rpt.execute('SEL_DFI');                                                   
      rpt.execute('SEL_RMA_DOC_CHI');                                           
      rpf.PRINT('                              ');                              
      rpf.PRINT('                             ');                               
      rpf.PRINT(RMA_IL,'A1');                                                   
      rpf.PRINT('     ');                                                       
      rpf.PRINT(RMA_DOCUMENTO,'A1');                                            
      rpf.CS(1);                                                                
      rpf.PRINT('      ');                                                      
      rpf.PRINT(DESCRITTO,'A1');                                                
      rpf.PRINT('      ');                                                      
      rpf.PRINT(MUNITO,'A1');                                                   
      rpf.CS(7);                                                                 
      rpf.PRINT(COGNOME_NOME_F,'A70');                                          
      rpf.CS(3);                                                                
      rpf.PRINT(COGNOME_NOME_M,'A70');                                          
      rpf.CS(5);                                                                
      rpf.PRINT(TEST_1,'A70');                                                  
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(TTE_NATO_1,'A1');                                               
      rpf.PRINT(TTE_COM_NAS_1,'A66');                                           
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(TTE_DATA_NAS_1,'A68');                                          
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(TTE_PROF_1,'A68');                                              
      rpf.CS(1);                                                                
      rpf.PRINT('        ');                                                    
      rpf.PRINT(TTE_RESIDENZA_1,'A61');                                         
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(TEST_2,'A68');                                                  
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(TTE_NATO_2,'A1');                                               
      rpf.PRINT(TTE_COM_NAS_2,'A66');                                           
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(TTE_DATA_NAS_2,'A68');                                          
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(TTE_PROF_2,'A68');                                              
      rpf.CS(1);                                                                
      rpf.PRINT('        ');                                                    
      rpf.PRINT(TTE_RESIDENZA_2,'A61');                                         
      rpf.CS(1);                                                                
      rpf.PRINT('  ');                                                          
      rpf.PRINT(DOC_IL,'A1');                                                   
      rpf.PRINT('     ');                                                       
      rpf.PRINT(DOC_DOCUMENTO,'A1');                                            
      rpf.PRINT('    ');                                                        
      rpf.PRINT(PRESENTATO,'A1');   
	if doc_riga7_null is not null then goto rpt_doc_compresso; end if;
      rpf.PRINT('  ');                                                          
      rpf.PRINT(DOC_RIGA1,'A47');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DOC_RIGA2,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DOC_RIGA3,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DOC_RIGA4,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DOC_RIGA5,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DOC_RIGA6,'A70');                                               
      rpf.CS(1);       
	goto rpt_DFI;                                                         
<< rpt_DOC_COMPRESSO >>
      rpf.PRINT('  ');                                                          
      rpf.PRINT(DOC_RIGA1,'A47');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA2,'A70');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA3,'A70');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA4,'A70');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA5,'A70');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA6,'A70');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA7,'A47');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA8,'A70');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA9,'A70');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA10,'A70');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA11,'A70');                                               
	rpf.N;
      rpf.PRINT(DOC_RIGA12,'A70');                                               
	rpf.N;
<< rpt_DFI >>
      rpf.PRINT(' ');                                                           
      rpf.PRINT(DFI_RIGA1,'A68');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DFI_RIGA2,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DFI_RIGA3,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DFI_RIGA4,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(DFI_RIGA5,'A68');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DFI_RIGA6,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DFI_RIGA7,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DFI_RIGA8,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(' ');                                                           
      rpf.PRINT(DFI_RIGA9,'A68');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(DFI_RIGA10,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(DFI_RIGA11,'A70');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(DFI_RIGA12,'A70');                                              
      rpf.CS(1);    
      if CHI_RIGA7_NULL is not null then GOTO rpt_CHI_COMPRESSO; end if;                                                            
      rpf.PRINT(' ');                                                           
      rpf.PRINT(CHI_RIGA1,'A68');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CHI_RIGA2,'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(CHI_RIGA3,'A70'); 
      rpf.CS(1);                                                                    
      rpf.PRINT(ltrim(CHI_RIGA4,'_'),'A68');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(ltrim(CHI_RIGA5,'_'),'A70');                                               
      rpf.CS(1);                                                                
      rpf.PRINT(ltrim(CHI_RIGA6,'_'),'A70');                                               
      rpf.N;       
      goto rpt_SE_NP;                                                                                                                        
<< rpt_CHI_COMPRESSO >>
      rpf.PRINT(' ');                                                           
      rpf.PRINT(CHI_RIGA1,'A68');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA2,'A70');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA3,'A70');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA4,'A70');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA5,'A70');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA6,'A70');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA7,'A70');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA8,'A70');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA9,'A70');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA10,'A70');                                               
      rpf.N;                                                                    
      rpf.PRINT(CHI_RIGA11,'A70');                                               
      rpf.N;                                                                    
      goto rpt_SE_NP;                                                           
<< rpt_TESTO_LIBERO >>                                                          
      CONTA_RIGHE := 000;                                                                                                 
      rpt.execute('SEL_CIVTLI'); 
	civsmat.inizializza_clob;
	civsmat.conta_num_righe;
	civsmat.inizializza_clob;
      if riga > 62 then goto rpt_RIGHE_124; end if;                     
      civsmat.TR_CIVTLI;                                     
      SALTO := 63 - CONTA_RIGHE;                                                
      rpt.report('SEL_SALTO','TR_SALTO');                                       
      goto rpt_SE_NP;                                                           
<< rpt_RIGHE_124 >>
	if riga > 124 then
	  if stampa_pagine = 3 then
	    civsmat.tr_civtli;
		salto := 63 - conta_righe;
		rpt.report('SEL_SALTO','TR_SALTO');
		if DX_SX = 'D' then
		  rpf.NC;
		end if;
		goto rpt_np; 
	  else       ---- 2 pagine compresse
        civsmat.TR_CIVTLI_1;                                   
		salto := 124 - conta_righe;
		rpt.report('SEL_SALTO','TR_SALTO_1');    
		if DX_SX = 'S' then
		  rpf.NC;
		end if;
		goto rpt_NP;
	  end if;
	else 
	  if STAMPA_PAGINE = 2 then
		civsmat.tr_civtli;
		SALTO := 63 - CONTA_RIGHE;
		rpt.report('SEL_SALTO','TR_SALTO');
		goto rpt_NP;
	  else
		civsmat.TR_CIVTLI_1;
		SALTO := 124 - CONTA_RIGHE;
        rpt.report('SEL_SALTO','TR_SALTO_1');
	  end if;
	end if;
<< rpt_SE_NP >>                                                                 
	if DX_SX = 'S' then goto rpt_NP; end if;                                  
	rpf.NC;                                                                   
	if PARTE = 2 AND SERIE = 'C' then goto rpt_NUMERO_DX; end if;             
	rpf.PRINT('              ');                                              
	goto rpt_SALTA_NUMERO_DX;                                                 
<< rpt_NUMERO_DX >>
	if stampa_solo_margine = 'S' then
           null;                                                             
	else 
	   rpf.PRINT('        Numero');                                              
	end if;
<< rpt_SALTA_NUMERO_DX >>   
      civsmat.STAMPA_NOMI_MARGINE;                            
      if PARTE = 2 AND SERIE IN ('A','B') then goto rpt_PROSEGUI_D; else goto rpt_CONV_D; end if;                                                                                                                                                              
<< rpt_PROSEGUI_D >>                                                            

      if PARTE = 2 AND SERIE = 'B' then goto rpt_MAR_2B_D; end if;              
<< rpt_MAR_2A_D >>
  if nvl(stampa_min,' ') != ' ' then                                                              
      rpf.CS(2);                                                                
      rpf.PRINT('    ');                                                        
      rpf.PRINT(DATA_TRAS,'A25');                                               
      rpf.CS(1);                                                                
      rpf.PRINT('    ');                                                        
      rpf.PRINT(ANNO_TRAS,'A15');                                               
      rpf.CS(1);                                                                
      rpf.PRINT('            ');                                                
      rpf.PRINT(MINISTRO_1,'A20');                                              
      rpf.CS(1);                                                                
      rpf.PRINT(MINISTRO_2,'A33');                                              
--      rpf.CS(43);   
   else 
      rpf.CS(9);
   end if;                                                            
      goto rpt_CONV_D;                                                          
<< rpt_MAR_2B_D >>   
  if nvl(stampa_min,' ') != ' ' then                                                           
      if DATA_TRAS is null then goto rpt_CONV_D; end if;                        
      rpf.CS(8);                                                                
      rpf.PRINT(' In data');                                                    
      rpf.PRINT(DATA_TRAS,'A25');                                               
      rpf.N;          
      rpt.execute('SEL_FLAG');
      if flag = 0 then                                                        
        rpf.PRINT('millenovecento____');                                          
      else
        rpf.PRINT('duemila___________');
      end if;
      rpf.PRINT(ANNO_TRAS,'A15');                                               
      rpf.N;                                                                    
      rpf.PRINT('ho trasmesso notizia al ministro__');                          
      rpf.N;                                                                    
      rpf.PRINT('del culto di_');                                               
      rpf.PRINT(MINISTRO_1,'A20');                                              
      rpf.N;                                                                    
      rpf.PRINT(MINISTRO_2,'A33');                                              
      rpf.N;                                                                    
      rpf.PRINT('dell''eseguita trascrizione dell''__');                        
      rpf.N;                                                                    
      rpf.PRINT('atto controscritto con l''indica-__');                         
      rpf.N;                                                                    
      rpf.PRINT('zione della data in cui essa e''___');                         
      rpf.N;                                                                    
      rpf.PRINT('stata effettuata._________________');                          
      rpf.CS(1);                                                                
      rpf.R;                                                                    
      rpf.PRINT('L''UFFICIALE DELLO STATO CIVILE');                             
      rpf.N;                                                                    
      rpf.print('F.to: '||nvl(UFFICIALE_PROV,CMA_FIRMA_MAR),'A34');
      rpf.R;  
  else
     rpf.CS(20);
  end if;                                                                  
<< rpt_CONV_D >>                                                                
	civsmat.STAMPA_TESTO_MARGINE;
	if CONVENZIONI is not null then 
           civsmat.STAMPA_CONV_MARGINE;
	end if;
	if w_stampa_lib = 'S' then
           civsmat.STAMPA_MARGINE_LIB;                                                                    
	end if;
        rpt.report('SEL_MARGINE_ANN','STAMPA_MARGINE_ANN');
     
<< rpt_NP >>
	rpf.TE;                                                                   
	rpf.PRINT(SEI_INCH,'A10');                                                
	rpf.NP;                                                                   
	goto fine_rpf2;                                                           
<< fine_rpf2 >>                                                                 
rpf.stop;                                                                       
end;                          

procedure CTR_SALTO_ATTI is                                                          
begin
	rpf.t(1);
      if SALTO_ATTI = 1 then goto rpt_SKIP_1; end if;                           
      if SALTO_ATTI = 2 then goto rpt_SKIP_2; end if;                           
      if SALTO_ATTI = 3 then goto rpt_SKIP_3; end if;                           
      if SALTO_ATTI = 4 then goto rpt_SKIP_4; end if;                           
      if SALTO_ATTI = 5 then goto rpt_SKIP_5; end if;                           
      if SALTO_ATTI = 6 then goto rpt_SKIP_6; end if;                           
      if SALTO_ATTI = 7 then goto rpt_SKIP_7; end if;                           
      if SALTO_ATTI = 8 then goto rpt_SKIP_8; end if;                           
      if SALTO_ATTI = 9 then goto rpt_SKIP_9; end if;                           
      if SALTO_ATTI = 10 then goto rpt_SKIP_10; end if;                         
      if SALTO_ATTI = 11 then goto rpt_SKIP_11; end if;                         
      if SALTO_ATTI = 12 then goto rpt_SKIP_12; end if;                         
      if SALTO_ATTI = 13 then goto rpt_SKIP_13; end if;                         
      if SALTO_ATTI = 14 then goto rpt_SKIP_14; end if;                         
      if SALTO_ATTI = 15 then goto rpt_SKIP_15; end if;                         
<< rpt_SKIP_1 >>                                                                
      rpf.print(' ');                                                                 
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_2 >>                                                                
      rpf.print(' ');                                                                 
      rpf.S(1);                                                                 
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_3 >>                                                                
      rpf.print(' ');                                                                 
      rpf.S(2);                                                                 
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_4 >>                                                                
      rpf.print(' ');                                                                 
      rpf.S(3);                                                                 
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_5 >>                                                                
      rpf.print(' ');                                                                 
      rpf.S(4);                                                                 
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_6 >>                                                                
      rpf.print(' ');                                                                 
      rpf.S(5);                                                                 
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_7 >>                                                                
      rpf.print(' ');                                                                 
      rpf.S(6);                                                                 
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_8 >>                                                                
      rpf.print(' ');                                                                 
      rpf.S(7);                                                                 
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_9 >>                                                                
      rpf.print(' ');                                                                 
      rpf.S(8);                                                                 
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_10 >>                                                               
      rpf.print(' ');                                                                 
      rpf.S(9);                                                                
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_11 >>                                                               
      rpf.print(' ');                                                                 
      rpf.S(10);                                                                
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_12 >>                                                               
      rpf.print(' ');                                                                 
      rpf.S(11);                                                                
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_13 >>                                                               
      rpf.print(' ');                                                                 
      rpf.S(12);                                                                
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_14 >>                                                               
      rpf.print(' ');                                                                 
      rpf.S(13);                                                                
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_SKIP_15 >>                                                               
      rpf.print(' ');                                                                 
      rpf.S(14);                                                                
      goto rpt_INIZIO_STAMPA;                                                   
<< rpt_INIZIO_STAMPA >>                                                         
	rpf.TE;
null;
end;
                                                  
procedure STAMPA_NOMI_MARGINE is                                                          
begin      
        rpt.execute('SEL_CIVOCC');    
	if stampa_solo_margine = 'S' then
	   rpf.print(' ');
         rpf.CS(11);                                                                
	else                                                                    
         rpf.PRINT(ATTO,'9999');                                                   
         rpf.CS(3);                                                                
         rpf.PRINT(COGNOME_MAT_M_OCC,'A34');                                           
         rpf.CS(1);                                                                
         rpf.PRINT(NOME_MAT_M_OCC,'A34');                                              
         rpf.CS(2);                                                                
         rpf.PRINT(COGNOME_MAT_F_OCC,'A34');                                           
         rpf.CS(1);                                                                
         rpf.PRINT(NOME_MAT_F_OCC,'A34');  
	end if;
null;                                                                           
end;                        

procedure STAMPA_CONV_MARGINE is                                                          
begin              
 if stampa_solo_margine = 'S' then
   null;
 else                 
   if civsmat.parte = 2 and nvl(civsmat.serie,' ') = 'B' and comune_tras_1 is not null then
     if w_scelta_conv = 2 then
       rpf.PRINT(' ');
       rpf.PRINT('Con dichiarazione resa nell''atto');                         
       rpf.N;
       rpf.PRINT('di  matrimonio  controscritto, gli');
       rpf.N;
       rpf.PRINT('sposi    hanno    dichiarato    di');                          
       rpf.N;
       rpf.PRINT('scegliere  la legge');
       rpf.print(w_legge_conv_1);
       rpf.N;
       if w_legge_conv_2 is not null then
         rpf.print(w_legge_conv_2);
       rpf.N;
       end if;                                               
       if w_legge_conv_3 is not null then
         rpf.print(w_legge_conv_3);
       rpf.N;
       end if;                                   
       rpf.PRINT('da  applicare   ai  loro  rapporti');
       rpf.N;
       rpf.PRINT('patrimoniali ai sensi dell''art.30,');
       rpf.N;
       rpf.PRINT('primo  comma della legge 31 maggio');
       rpf.N;
       rpf.PRINT('1995, n.218.______________________');
       box_conta_skip := box_conta_skip + 20;
     else
       rpf.PRINT(' ');
       rpf.PRINT('Con dichiarazione resa nell''atto');                         
       rpf.N;
       rpf.PRINT('di  matrimonio controscritto,  gli');                          
       rpf.N;
       rpf.PRINT('sposi hanno scelto il regime della');                          
       rpf.N;
       rpf.PRINT('separazione dei beni._____________'); 
       box_conta_skip := box_conta_skip + 8;                         
     end if;
      rpf.cs(1);
      rpf.PRINT(COMUNE_ANN,'A34');  
	rpf.print(data_convenzioni,'A10');                                           
      rpf.CS(1);                                                                
      rpf.R;                                                                    
      rpf.PRINT('L''UFFICIALE DELLO STATO CIVILE');                             
      rpf.N;            
 	rpf.print('F.to: '||nvl(UFFICIALE_PROV,CMA_FIRMA_MAR),'A34');
      rpf.R;
      box_conta_skip := box_conta_skip + 6;                                                                    
   else

      if civsmat.parte = 2 and nvl(civsmat.serie,' ') = 'C' and 
	 stampa_tr1 is null and stampa_tr2 is null 
      then
	 rpf.cs(8);
         box_conta_skip := box_conta_skip + 8;
      end if;                                            
      if w_scelta_conv = 2 then
         rpf.PRINT(' ');
         rpf.PRINT('Con dichiarazione resa nell''atto');                         
         rpf.N;            
         rpf.PRINT('di  matrimonio  controscritto, gli');
         rpf.N;            
         rpf.PRINT('sposi    hanno    dichiarato    di');                          
         rpf.N;            
         rpf.PRINT('scegliere  la legge');
         rpf.print(w_legge_conv_1);
	 rpf.N;            
         if w_legge_conv_2 is not null then
            rpf.print(w_legge_conv_2);
	    rpf.N;            
         end if;                                               
         if w_legge_conv_3 is not null then
            rpf.print(w_legge_conv_3);
	    rpf.N;            
         end if;                                               
      	 rpf.PRINT('da  applicare   ai  loro  rapporti');
	 rpf.N;            
      	 rpf.PRINT('patrimoniali ai sensi dell''art.30,');
	 rpf.N;            
      	 rpf.PRINT('primo  comma della legge 31 maggio');
	 rpf.N;            
      	 rpf.PRINT('1995, n.218.______________________');
	 rpf.N; 
         box_conta_skip := box_conta_skip + 19;           
      else
         rpf.PRINT(' ');                         
         rpf.PRINT('Con dichiarazione resa nell''atto');                         
         rpf.CS(1);                                                                
         rpf.PRINT('di  matrimonio controscritto,  gli');                          
         rpf.CS(1);                                                                
         rpf.PRINT('sposi hanno scelto il regime della');                          
         rpf.CS(1);                                                                
         rpf.PRINT('separazione dei beni._____________');                          
         rpf.CS(1);                                                                
         box_conta_skip := box_conta_skip + 8;
      end if;
      rpf.PRINT(COMUNE_ANN,'A34');  
      rpf.print(data_convenzioni,'A10');                                           
      rpf.CS(1);                                                                
      rpf.R;                                                                    
      rpf.PRINT('L''UFFICIALE DELLO STATO CIVILE');                             
      rpf.CS(1);            
      if civsmat.natura = 'O' then
         rpf.print('______________________________');                                            
      else
   	 rpf.print('F.to: '||nvl(UFFICIALE_PROV,CMA_FIRMA_MAR),'A34');
      end if;
      rpf.R;
      box_conta_skip := box_conta_skip + 5; 
      if w_scelta_conv = 2 then
         if w_legge_conv_2 is null then
            rpf.CS(1);            
            box_conta_skip := box_conta_skip + 1;
         end if;                                               
         if w_legge_conv_3 is null then
            rpf.CS(1);        
            box_conta_skip := box_conta_skip + 1;
	 end if;    
      else
	 rpf.CS(2);
            box_conta_skip := box_conta_skip + 2;
      end if;
   end if;            
 end if;
null;                                                                           
end;

procedure STAMPA_MARGINE_LIB is                                                          
begin   
 if stampa_solo_margine = 'S' then
   null;
 else   
   if CONVENZIONI is not null then
      if civsmat.parte = 1 then
  	 if stampa_tr2 is null then
	    rpf.CS(4);
	 end if;
      elsif civsmat.parte = 2 and nvl(civsmat.serie,' ') = 'A' then
         rpf.CS(4);
      end if;
   else 
      if civsmat.parte = 2 and nvl(civsmat.serie,' ') = 'C' then
	 if stampa_tr1 is null and stampa_tr2 is null then
	    rpf.cs(8);
	 end if;
     end if;
   end if;
   rpf.PRINT('Rilasciato libretto internazionale');                         
   rpf.CS(1);
   rpf.PRINT('di  famiglia n.');
   rpf.print(w_numero_lib);
   rpf.print('in data');
   rpf.CS(1);
   rpf.print(w_data_lib,'A34');
   rpf.CS(1);
   rpf.print('   li,');
   rpf.print(w_data_firma_lib,'A10');
   rpf.CS(1);                                                                
   rpf.R;                                                                    
   rpf.PRINT('L''UFFICIALE DELLO STATO CIVILE');                             
   rpf.CS(1);            
   if civsmat.natura = 'O' then
     rpf.print('______________________________');                                            
   else
     rpf.print('F.to: '||nvl(UFFICIALE_PROV,CMA_FIRMA_MAR),'A34');
   end if;
   rpf.R;       
   rpf.CS(2);
 end if;
null;                                                                           
end;


procedure inizializza_clob is
begin
	len_clob	 := dbms_lob.getlength(campo_clob);
	w_campo_clob := dbms_lob.substr(campo_clob,len_clob,1);
end;
                        

procedure conta_num_righe is
begin
riga := 0;
	while w_campo_clob is not null loop
	 	if length(w_campo_clob) > 70 then 
	 	   w_pos_acapo := instr(substr(w_campo_clob,1,70),chr(10));	
		   if w_pos_acapo > 0 then 
			riga := riga + 1;
  	  	      w_testo := substr(w_campo_clob,1,w_pos_acapo - 1);
		      w_campo_clob := substr(w_campo_clob,w_pos_acapo + 1);
               else
	 	   	w_pos_spazio := instr(rtrim(substr(w_campo_clob,1,70)),' ',-1);
		  if w_pos_spazio > 0 then
		   	w_testo := substr(w_campo_clob,1,w_pos_spazio - 1);
		   	w_campo_clob := substr(w_campo_clob,w_pos_spazio + 1);
			riga := riga + 1;
		  else
		     w_testo := substr(w_campo_clob,1,70);
		     w_campo_clob := substr(w_campo_clob,71);
		     riga := riga + 1;
		  end if;
	         end if;
	      else
	 	   w_pos_acapo := instr(w_campo_clob,chr(10));	
		   if w_pos_acapo > 0 then 
  	  	      w_testo := substr(w_campo_clob,1,w_pos_acapo - 1);
		      w_campo_clob := substr(w_campo_clob,w_pos_acapo + 1);
			riga := riga + 1;
               else
		   	w_testo := w_campo_clob;
		   	w_campo_clob := null;
		   end if;
	 	end if;
	end loop;
end;
 
                                                                                       

procedure TR_CIVTLI is
begin
	while w_campo_clob is not null loop
	  if length(w_campo_clob) > 70 then 
	    w_pos_acapo := instr(substr(w_campo_clob,1,70),chr(10));	
	    if w_pos_acapo > 0 then 
  	      w_testo := rpad(nvl(substr(w_campo_clob,1,w_pos_acapo - 1),'_'),70,'_');
	      w_campo_clob := substr(w_campo_clob,w_pos_acapo + 1);
        else
	      w_pos_spazio := instr(rtrim(substr(w_campo_clob,1,70)),' ',-1);
		  if w_pos_spazio > 0 then
		   	w_testo := substr(w_campo_clob,1,w_pos_spazio - 1);
		   	w_campo_clob := substr(w_campo_clob,w_pos_spazio + 1);
		  else
		    w_testo := substr(w_campo_clob,1,70);
		    w_campo_clob := substr(w_campo_clob,71);
		  end if;

		  w_spazi := length(w_testo) - length(ltrim(w_testo));
		  testo_iniziale := rpad(' ',w_spazi,' ')||substr(ltrim(rtrim(w_testo)),1,instr(ltrim(rtrim(w_testo)),' '));
		  testo_finale   := substr(ltrim(rtrim(w_testo)),instr(ltrim(rtrim(w_testo)),' ')+1);
		  numero_car := length(w_testo);
		  quanti_spazi := 70 - numero_car ;
	      if quanti_spazi > 0 then
            direction := -1;
            rel_pos := 1;
	        testo_finale := replace(testo_finale,' ','|');
       	    for posizione IN 1..quanti_spazi LOOP
	          dove := instr(testo_finale,'|',direction,posizione);
	          if dove = 0 then
                if direction = -1 then
                  direction := 1;
                else
                  direction := -1;
                  rel_pos := rel_pos + 1;
                end if;
                dove := instr(testo_finale,'|',direction,rel_pos);
                if dove = 0 then
                  rel_pos := 1;
                  dove := instr(testo_finale,'|',direction,rel_pos);
                end if;
	          end if;
              testo_finale := substr(testo_finale,1,dove)||' '||
                                substr(testo_finale,dove+1);
            end LOOP;
	        testo_finale := replace(testo_finale,'|',' ');
	        w_testo := testo_iniziale||testo_finale;
          end if;
        end if;
	  else
	    w_pos_acapo := instr(w_campo_clob,chr(10));	
		  if w_pos_acapo > 0 then 
  	  	    w_testo := rpad(nvl(substr(w_campo_clob,1,w_pos_acapo - 1),'_'),70,'_');
		    w_campo_clob := substr(w_campo_clob,w_pos_acapo + 1);
          else
		   	w_testo := rpad(nvl(w_campo_clob,'_'),70,'_');
		   	w_campo_clob := null;
		  end if;
	 	end if;
		rpf.print_civ(w_testo);
		CONTA_RIGHE := CONTA_RIGHE + 1;
		rpf.CS(1);
        if riga > 124 then
		  if CONTA_RIGHE = 62 and STAMPA_PAGINE = 3 then 
			if DX_SX = 'D' then 
			  rpf.NC;                  
		      if stampa_solo_margine = 'S' then
		        null;
	          else                                                                                                     
                rpf.PRINT('        Numero');                                                                                                     
	          end if;
		      civsmat.STAMPA_NOMI_MARGINE;
		      civsmat.STAMPA_TESTO_MARGINE;
              if CONVENZIONI is not null then 
   		        civsmat.STAMPA_CONV_MARGINE;
              end if;
	          if w_stampa_lib = 'S' then
                civsmat.STAMPA_MARGINE_LIB; 
              end if;
            end if;
	        rpf.TE;
            rpf.PRINT(SEI_INCH,'A10');                                                
	        rpf.NP;
            rpf.PRINT(OTTO_INCH,'A10');                                                
            --CONTA_RIGHE := 000;                                                                                                         
	        civsmat.CTR_SALTO_ATTI;
            if DX_SX = 'D' then                                                      
		      rpf.T(11);
              rpf.NC;
	        else                                                      
      	      rpf.T(1);                                                                
	        end if;                                                                           
          elsif conta_righe = 124 and stampa_pagine = 3 then
		    rpf.NC;
			rpf.TE;
			rpf.PRINT(SEI_INCH,'A10');
			rpf.NP;
			rpf.PRINT(OTTO_INCH,'A10');
			CONTA_RIGHE := 000;
			civsmat.CTR_SALTO_ATTI;
			if DX_SX = 'S' then
			  rpf.T(11);
			  rpf.NC;
			else
			  rpf.T(1);
			end if;
		  end if;
		else
          if CONTA_RIGHE = 62 and STAMPA_PAGINE = 2 then
			if DX_SX = 'D' then
			  rpf.NC;
			  if stampa_solo_margine = 'S' then
		        null;
	          else                                                                                                     
                rpf.PRINT('        Numero');                                                                                                     
	          end if;
		      civsmat.STAMPA_NOMI_MARGINE;
		      civsmat.STAMPA_TESTO_MARGINE;
              if CONVENZIONI is not null then 
   		        civsmat.STAMPA_CONV_MARGINE;
              end if;
	          if w_stampa_lib = 'S' then
                civsmat.STAMPA_MARGINE_LIB; 
              end if;
			end if;
			rpf.TE;
			rpf.PRINT(SEI_INCH,'A10');
			rpf.NP;
			rpf.PRINT(OTTO_INCH,'A10');
			CONTA_RIGHE := 000;
			civsmat.CTR_SALTO_ATTI;
			if DX_SX = 'D' then
			  rpf.T(11);
			  rpf.NC;
			else
			  rpf.T(1);
			end if;
		  end if;
		end if;
		if w_pos_acapo > 0 then
		   rpf.n;
		end if;
	end loop;
--	rpf.te;
end;
     

procedure TR_CIVTLI_1 is
begin
	while w_campo_clob is not null loop
	  if length(w_campo_clob) > 70 then 
	    w_pos_acapo := instr(substr(w_campo_clob,1,70),chr(10));	
	    if w_pos_acapo > 0 then 
  	      w_testo := rpad(nvl(substr(w_campo_clob,1,w_pos_acapo - 1),'_'),70,'_');
	      w_campo_clob := substr(w_campo_clob,w_pos_acapo + 1);
        else
	      w_pos_spazio := instr(rtrim(substr(w_campo_clob,1,70)),' ',-1);
		  if w_pos_spazio > 0 then
		   	w_testo := substr(w_campo_clob,1,w_pos_spazio - 1);
		   	w_campo_clob := substr(w_campo_clob,w_pos_spazio + 1);
		  else
		    w_testo := substr(w_campo_clob,1,70);
		    w_campo_clob := substr(w_campo_clob,71);
		  end if;
		  w_spazi := length(w_testo) - length(ltrim(w_testo));
		  testo_iniziale := rpad(' ',w_spazi,' ')||substr(ltrim(rtrim(w_testo)),1,instr(ltrim(rtrim(w_testo)),' '));
		  testo_finale   := substr(ltrim(rtrim(w_testo)),instr(ltrim(rtrim(w_testo)),' ')+1);
		  numero_car := length(w_testo);
		  quanti_spazi := 70 - numero_car ;
	      if quanti_spazi > 0 then
            direction := -1;
            rel_pos := 1;
	        testo_finale := replace(testo_finale,' ','|');
       	    for posizione IN 1..quanti_spazi LOOP
	          dove := instr(testo_finale,'|',direction,posizione);
	          if dove = 0 then
                if direction = -1 then
                  direction := 1;
                else
                  direction := -1;
                  rel_pos := rel_pos + 1;
                end if;
                dove := instr(testo_finale,'|',direction,rel_pos);
                if dove = 0 then
                   rel_pos := 1;
                   dove := instr(testo_finale,'|',direction,rel_pos);
                end if;
	          end if;
              testo_finale := substr(testo_finale,1,dove)||' '||
                                substr(testo_finale,dove+1);
            end LOOP;
	        testo_finale := replace(testo_finale,'|',' ');
	        w_testo := testo_iniziale||testo_finale;
          end if;
        end if;
      else
  	    w_pos_acapo := instr(w_campo_clob,chr(10));	
		if w_pos_acapo > 0 then 
  	  	  w_testo := rpad(nvl(substr(w_campo_clob,1,w_pos_acapo - 1),'_'),70,'_');
		  w_campo_clob := substr(w_campo_clob,w_pos_acapo + 1);
        else
		  w_testo := rpad(nvl(w_campo_clob,'_'),70,'_');
		  w_campo_clob := null;
		end if;
	  end if;
      rpf.print_civ(w_testo);
	  CONTA_RIGHE := CONTA_RIGHE + 1;
	  rpf.n;
      if riga > 124 and stampa_pagine = 2 then
		if CONTA_RIGHE = 124 then
		  if DX_SX = 'D' then
			rpf.NC;
			if stampa_solo_margine = 'S' then
		        null;
	          else                                                                                                     
                rpf.PRINT('        Numero');                                                                                                     
	          end if;
		      civsmat.STAMPA_NOMI_MARGINE;
		      civsmat.STAMPA_TESTO_MARGINE;
              if CONVENZIONI is not null then 
   		        civsmat.STAMPA_CONV_MARGINE;
              end if;
	          if w_stampa_lib = 'S' then
                civsmat.STAMPA_MARGINE_LIB; 
              end if;
		  END IF;
		  rpf.TE;
		  rpf.PRINT(SEI_INCH,'A10');
		  rpf.NP;
		  rpf.PRINT(OTTO_INCH,'A10');
		  CONTA_RIGHE := 000;
		  civsmat.CTR_SALTO_ATTI;
		  if DX_SX = 'D' then
			rpf.T(11);
		    rpf.NC;
		  else
			rpf.T(1);
		  end if;
		end if;
	  END IF;
	  if w_pos_acapo > 0 then
		rpf.n;
	  end if;
	end loop;
end;
                                                                           
                                                                                
procedure TR_SALTO is                                                           
begin                                                                           
       rpf.PRINT('______________________________________________________________________');                                                                                                                                                                    
       rpf.CS(1);                                                               
null;                                                                           
end;                                                                            
                                                                                
procedure TR_SALTO_1 is                                                         
begin                                                                           
       rpf.PRINT('______________________________________________________________________');                                                                                                                                                                    
       rpf.N;                                                                   
null;                                                                           
end;                                                                            

--
-- aggiunto   23/01/2003 - A.Monopoli (Boscoreale)
-- aggiornato 24/06/2003 - A.Monopoli
--
procedure STAMPA_TESTO_MARGINE is
begin
  box_conta_skip := 0;
<< rpt_parte_1 >>
null;
if civsmat.parte = 1 then
  if nvl(stampa_tr1,' ') != ' ' then
	rpf.cs(10);
	rpf.print(COMUNE_TRAS_1,'A34');
	rpf.cs(1);
	rpf.print('  '); 						-- 1-3
	rpf.print(nvl(ATTO_TRAS_1,'      '),'A6');	-- 4-10
	rpf.print('  ');						-- 11-13
	rpf.print(nvl(PARTE_TRAS_1,'  '),'A2');		-- 14-16
	rpf.print(' ');						-- 17-18
	rpf.print(nvl(SERIE_TRAS_1,' '),'A1'); 		-- 19-20
	rpf.print('     ');					-- 21-26
	rpf.print(ANNO_TRAS_1,'A5');				-- 27-30
	rpf.cs(1);
	rpf.print('                 ');			-- 1-18
	rpf.print(nvl(DATA_COMUNICAZIONE_1,'        '),'A8');
	if num_comunicazione_1 is not null then 
   	   rpf.print('N.'||NUM_COMUNICAZIONE_1,'A5');
	end if;
	rpf.cs(1);
	rpf.print('     ');			-- 1-6
	rpf.print(DATA_FIRMA_1,'A10');
	rpf.cs(6);
     box_conta_skip := box_conta_skip + 23;
  else 
     rpf.CS(23);
     box_conta_skip := box_conta_skip + 23;
  end if;

  if nvl(w_box_libero,3) = 2 then
   if nvl(stampa_tr2,' ') != ' ' then
     rpf.cs(1);
     rpf.print('Il presente atto  di matrimonio e''');
     rpf.cs(1);
     rpf.print('stato trascritto  nei registri  di');
     rpf.cs(1);
     rpf.print('Stato Civile del Comune di________');
     rpf.cs(1);
     rpf.print(COMUNE_TRAS_2,'A34');
     rpf.cs(1);
     rpf.print('al N. '||nvl(atto_tras_2,'______'));
     rpf.print('P. '||nvl(parte_tras_2,'__'));
     rpf.print('S. '||nvl(serie_tras_2,'_'));
     rpf.print('anno '||nvl(anno_tras_2,'_____'));
     rpf.cs(1);
     rpf.print('come da comunicazione del');
     rpf.print(nvl(DATA_COMUNICAZIONE_2,'________'),'A8');
     rpf.cs(1);
     rpf.print(nvl(COMUNE_FIRMA_2,'__________'),'A10');
     if rtrim(comune_firma_2) is null then
        rpf.r;
        rpf.print('li');
        rpf.print(nvl(DATA_FIRMA_2,'__________'),'A10');
        rpf.r;
     else
        rpf.print('li');
        rpf.print(nvl(DATA_FIRMA_2,'__________'),'A10');
     end if;
     rpf.cs(1);
     rpf.r;
     rpf.print('L''UFFICIALE DELLO STATO CIVILE');
     rpf.cs(1);
     rpf.print('______________________________');
     rpf.r;
     rpf.cs(1);
     box_conta_skip := box_conta_skip + 11;  --------- contarli
   else 
     rpf.CS(1);
      box_conta_skip := box_conta_skip + 1;
   end if;
  else
   if nvl(stampa_tr2,' ') != ' ' then
     rpf.cs(5);
     rpf.print(COMUNE_TRAS_2,'A24');
     rpf.print('  ');
     rpf.print(ATTO_TRAS_2,'A6');
     rpf.cs(1);
     rpf.print('             ');
     rpf.print(ANNO_TRAS_2,'A5');
     rpf.cs(1);
     rpf.print(' ');
     rpf.print(nvl(DATA_COMUNICAZIONE_2,'        '),'A8');
     if num_comunicazione_2 is not null then 
        rpf.print('N.'||NUM_COMUNICAZIONE_2);
     end if;
     rpf.cs(1);
     rpf.print(rpad(nvl(COMUNE_FIRMA_2,' '),23,' ')||' '||data_firma_2);
     rpf.cs(7);
      box_conta_skip := box_conta_skip + 21;   ------------contarli
   else 
     rpf.CS(19);
     null;
      box_conta_skip := box_conta_skip + 19;
   end if;
  end if;

  goto rpt_fine;
end if;
<< rpt_parte_2a >>
if civsmat.parte = 2 and nvl(civsmat.serie,' ') = 'A' then
  if nvl(stampa_tr1,' ') != ' ' then
      	rpf.cs(17);
	rpf.print(COMUNE_TRAS_1,'A34');
	rpf.cs(1);
	rpf.print('  '); 						-- 1-3
	rpf.print(nvl(ATTO_TRAS_1,'      '),'A6');	-- 4-10
	rpf.print('           ');				-- 11-22
	rpf.print(ANNO_TRAS_1,'A4');				-- 23
	rpf.cs(1);
	rpf.print('                 ');			-- 1-18
	rpf.print(nvl(DATA_COMUNICAZIONE_1,'        '),'A8');
	rpf.print(' ');
	rpf.print(NUM_COMUNICAZIONE_1,'A5');
 	rpf.cs(1);
	rpf.print(rpad(nvl(COMUNE_FIRMA_1,' '),23,' ')||' '||DATA_FIRMA_1);
	rpf.cs(13);
      box_conta_skip := box_conta_skip + 37;
  else 
     	rpf.CS(37);
      box_conta_skip := box_conta_skip + 37;
  end if;
  if nvl(stampa_tr2,' ') != ' ' then
	rpf.print(COMUNE_TRAS_2,'A34');
	rpf.cs(1);
	rpf.print('  '); 				-- 1-3
	rpf.print(nvl(ATTO_TRAS_2,'      '),'A6');		-- 4-10
	rpf.print('           ');		-- 11-22
	rpf.print(ANNO_TRAS_2,'A4');		-- 23
	rpf.cs(1);
	rpf.print('                 ');	-- 1-18
	rpf.print(nvl(DATA_COMUNICAZIONE_2,'        '),'A8');
	rpf.print(' ');
	rpf.print(NUM_COMUNICAZIONE_2,'A5');
 	rpf.cs(1);
	rpf.print(rpad(nvl(COMUNE_FIRMA_2,' '),23,' ')||' '||data_firma_2);
	rpf.cs(7);
       box_conta_skip := box_conta_skip + 14;
  else 
     	rpf.CS(14);
        box_conta_skip := box_conta_skip + 14;
  end if;
  goto rpt_fine;
end if;
<< rpt_parte_2b >>
null;
if civsmat.parte = 2 and serie = 'B' then
  if nvl(stampa_min,' ') != ' ' then 
	if data_tras is null then   
	    rpf.cs(20); 
             box_conta_skip := box_conta_skip + 20;	        
       	end if;
  else 
	null; 
  end if;
  rpf.cs(8);
   box_conta_skip := box_conta_skip + 8;
end if;
if nvl(stampa_tr1,' ') != ' ' then
   rpf.cs(8);
   rpf.print('Il presente atto  di matrimonio e''');
   rpf.cs(1);
   rpf.print('stato trascritto  nei registri  di');
   rpf.cs(1);
   rpf.print('Stato Civile del Comune di________');
   rpf.cs(1);
   rpf.print(COMUNE_TRAS_1,'A34');
   rpf.cs(1);
   rpf.print('al N. '||nvl(atto_tras_1,'______'));
   rpf.print('P. '||nvl(parte_tras_1,'__'));
   rpf.print('S. '||nvl(serie_tras_1,'_'));
   rpf.print('anno '||nvl(anno_tras_1,'_____'));
   rpf.cs(1);
   rpf.print('come da comunicazione del');
   rpf.print(nvl(DATA_COMUNICAZIONE_1,'________'),'A8');
   rpf.cs(1);
   rpf.print(nvl(COMUNE_FIRMA_1,'__________'),'A10');
   if rtrim(comune_firma_1) is null then
-- dbms_output.put_line('comune_1 is null');
      rpf.r;
      rpf.print('li');
      rpf.print(nvl(DATA_FIRMA_1,'__________'),'A10');
      rpf.r;
   else
-- dbms_output.put_line('comune_1 is not null');
      rpf.print('li');
      rpf.print(nvl(DATA_FIRMA_1,'__________'),'A10');
   end if;
   rpf.cs(1);
   rpf.r;
   rpf.print('L''UFFICIALE DELLO STATO CIVILE');
   rpf.cs(1);
   if civsmat.natura = 'T' then
      rpf.print('F.to: '||nvl(UFFICIALE_PROV,CMA_FIRMA_MAR),'A34');
   else
      rpf.print('______________________________');
   end if;
   rpf.r;
   rpf.cs(2);
   box_conta_skip := box_conta_skip + 27;-------------------------------contarli
end if;
if civsmat.parte = 2 and nvl(civsmat.serie,' ') = 'B' then
   goto rpt_fine;
end if;
if nvl(stampa_tr2,' ') != ' ' then
   rpf.cs(2);
   rpf.print('Il presente atto  di matrimonio e''');
   rpf.cs(1);
   rpf.print('stato trascritto  nei registri  di');
   rpf.cs(1);
   rpf.print('Stato Civile del Comune di________');
   rpf.cs(1);
   rpf.print(COMUNE_TRAS_2,'A34');
   rpf.cs(1);
   rpf.print('al N. '||nvl(atto_tras_2,'______'));
   rpf.print('P. '||nvl(parte_tras_2,'__'));
   rpf.print('S. '||nvl(serie_tras_2,'_'));
   rpf.print('anno '||nvl(anno_tras_2,'_____'));
   rpf.cs(1);
   rpf.print('come da comunicazione del');
   rpf.print(nvl(DATA_COMUNICAZIONE_2,'________'),'A8');
   rpf.cs(1);
   rpf.print(nvl(COMUNE_FIRMA_2,'__________'),'A10');
   if rtrim(comune_firma_2) is null then
      rpf.r;
      rpf.print('li');
      rpf.print(nvl(DATA_FIRMA_2,'__________'),'A10');
      rpf.r;
   else
      rpf.print('li');
      rpf.print(nvl(DATA_FIRMA_2,'__________'),'A10');
   end if;
   rpf.cs(1);
   rpf.r;
   rpf.print('L''UFFICIALE DELLO STATO CIVILE');
   rpf.cs(1);
   if civsmat.natura = 'T' then
      rpf.print('F.to: '||nvl(UFFICIALE_PROV,CMA_FIRMA_MAR),'A34');
   else
      rpf.print('______________________________');
   end if;
   rpf.r;
   rpf.cs(2);
   box_conta_skip := box_conta_skip + 21;------------------------------------------contarli
end if;

<< rpt_fine >>
null;
end;

procedure STAMPA_MARGINE_ANN is
begin
 -- dbms_output.put_line('box_conta_skip '||box_conta_skip);
  if nvl(atti_box_inp,'N') != 'S' then
    if civsmat.parte = 1 then
      if stampa_tr2 is null and convenzioni is null and w_stampa_lib is null then
	 null;
      elsif stampa_tr2 is null then
	 rpf.CS(4);
      end if;
    elsif civsmat.parte = 2 and nvl(civsmat.serie,' ') = 'A' then
      if convenzioni is null and w_stampa_lib is null then
	 null;
      elsif convenzioni is not null and w_stampa_lib is not null then
	 null;
      else
	 rpf.cs(4);
      end if;
    elsif civsmat.parte = 2 and nvl(civsmat.serie,' ') = 'B' then
      if stampa_tr1 is null and stampa_tr2 is null and CONVENZIONI is null and w_stampa_lib is null then
	 null;
      elsif stampa_tr1 is null and stampa_tr2 is null then
	 rpf.cs(3);
      end if;
    elsif civsmat.parte = 2 and nvl(civsmat.serie,' ') = 'C' then
--      if nvl(stampa_tr1,' ') = ' ' and nvl(stampa_tr2,' ') = ' ' and CONVENZIONI is null and w_stampa_lib is null then
--         rpf.cs(8);
--      else
--	 rpf.cs(1);
--      end if;
	 rpf.cs(3);
    end if;
  else
    if box_skip_iniziale - box_conta_skip <= 0 then
      rpf.CS(1);
      box_skip := 1;
    else
      box_skip := box_skip_iniziale - box_conta_skip;
      rpf.CS(box_skip);
    end if;
  end if;
 -- rpf.PRINT(box_conta_skip);
 -- rpf.PRINT(box_skip_iniziale);
   if length(testo_annotazione) > 255 then
      w_testo_ann := testo_annotazione;
      while length(w_testo_ann) > 255 loop
	    len_w_testo_ann_255 := instr(substr(w_testo_ann,1,255),' ',-1);
	    w_testo_ann_255 := substr(w_testo_ann,1,len_w_testo_ann_255-1);
	    w_testo_ann := substr(w_testo_ann,len_w_testo_ann_255+1);
	    rpf.PRINT(w_testo_ann_255);
      end loop;
      rpf.PRINT(w_testo_ann);
   else
      rpf.PRINT(testo_annotazione);
      rpf.PRINT(' ');
   end if;

   rpf.N;
   if civsmat.natura = 'O' then
      rpf.print(w_atti_li_inp);
      rpf.print(nvl(DATA_ANNOTAZIONE,'__________'),'A10');
   else
      rpf.print('li');
      rpf.print(nvl(DATA_ANNOTAZIONE,'__________'),'A10');
   end if;
   rpf.N;
   rpf.r;
   rpf.print('L''UFFICIALE DELLO STATO CIVILE');
   rpf.N;
   if civsmat.natura = 'T' then
      rpf.print('F.to: '||nvl(UFFICIALE_PROV,CMA_FIRMA_MAR),'A34');
   else
      rpf.cs(1);
      rpf.print('______________________________');
   end if;
   rpf.r;
--   rpf.cs(2);
   box_conta_skip := box_conta_skip + box_skip + box_totale_righe;
  -- rpf.print(box_conta_skip);	
end;
                                                                                
end;                                                                            
/                                                                               
