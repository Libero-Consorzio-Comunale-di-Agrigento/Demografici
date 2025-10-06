--liquibase formatted sql
--changeset amonopoli:202402051315_1 runOnChange:true stripComments:false
create or replace package CIVSMAT is                                            

flag				number(1) := 0;
                                                                                
cma_riga2                      varchar2(2000);                                  
cma_riga3                      varchar2(2000);                                  
cma_riga5                      varchar2(2000);                                  
cma_riga7                      varchar2(2000);                                  
cma_riga8                      varchar2(2000);                                  
cma_riga10                     varchar2(2000);                                  
cma_riga11                     varchar2(2000);                                  
cma_riga13                     varchar2(2000);                                  
cma_riga15                     varchar2(2000);                                  
cma_riga16                     varchar2(2000);                                  
cma_riga18                     varchar2(2000);                                  
cma_riga19                     varchar2(2000);                                  
otto_inch                      varchar2(2000);                                  
conta_righe                    number(3) := 0;                                  
numero_righe                   number(3) := 0;                                  
campo1                         varchar2(2000);                                  
doc_riga7                      varchar2(2000);                                  
doc_riga7_null                 varchar2(2000);                                  
doc_riga9                      varchar2(2000);                                  
dfi_riga1                      varchar2(2000);                                  
dfi_riga2                      varchar2(2000);                                  
dfi_riga4                      varchar2(2000);                                  
dfi_riga6                      varchar2(2000);                                  
dfi_riga7                      varchar2(2000);                                  
dfi_riga9                      varchar2(2000);                                  
dfi_riga11                     varchar2(2000);                                  
dfi_riga12                     varchar2(2000);                                  
nel                            varchar2(2000);                                  
luogo_mat                      varchar2(2000);                                  
rito2                          varchar2(2000);                                  
ministro1                      varchar2(2000);                                  
non                            varchar2(2000);                                  
art_riga1                      varchar2(2000);                                  
art_riga3                      varchar2(2000);                                  
art_riga4                      varchar2(2000);                                  
art_riga6                      varchar2(2000);                                  
riga_stato_civile              varchar2(2000);                                  
residenza_m                    varchar2(2000);                                  
cittadinanza_m                 varchar2(2000);                                  
com_nas_f                      varchar2(2000);                                  
atto_nas_f                     varchar2(2000);                                  
parte_nas_f                    varchar2(2000);                                  
prof_f                         varchar2(2000);                                  
cittadinanza_f                 varchar2(2000);                                  
rma_documento                  varchar2(2000);                                  
descritto                      varchar2(2000);                                  
cognome_nome_m                 varchar2(2000);                                  
test_1                         varchar2(2000);                                  
tte_nato_1                     varchar2(2000);                                  
tte_com_nas_2                  varchar2(2000);                                  
tte_data_nas_2                 varchar2(2000);                                  
tte_residenza_2                varchar2(2000);                                  
doc_documento                  varchar2(2000);                                  
doc_riga1                      varchar2(2000);                                  
doc_riga3                      varchar2(2000);                                  
doc_riga4                      varchar2(2000);                                  
doc_riga6                      varchar2(2000);                                  
convenzioni                    varchar2(2000);                                  
comune_ann                     varchar2(2000);                                  
giorno_tr                      varchar2(2000);                                  
ore_tr                         varchar2(2000);                                  
minuti_tr                      varchar2(2000);                                  
comune_tr                      varchar2(2000);                                  
motivo_tr                      varchar2(2000);                                  
comune                         varchar2(2000);                                  
ministro                       varchar2(2000);                                  
qualita_1                      varchar2(2000);                                  
cognome_m                      varchar2(2000);                                  
com_nas_m                      varchar2(2000);                                  
data_nas1_m                    varchar2(2000);                                  
atto_nas_m                     varchar2(2000);                                  
parte_nas_m                    varchar2(2000);                                  
cma_firma_mar                  varchar2(2000);                                  
data_tras                      varchar2(2000);                                  
anno_tras                      varchar2(2000);                                  
ministro_1                     varchar2(2000);                                  
ministro_2                     varchar2(2000);                                  
tli_riga                       varchar2(2000);                                  
sei_inch                       varchar2(2000);                                  
salto                          number(3) := 0;                                  
anno_mat                       varchar2(2000);                                  
giorno_mat                     varchar2(2000);                                  
mese_mat                       varchar2(2000);                                  
ore_mat                        varchar2(2000);                                  
minuti_mat                     varchar2(2000);                                  
comune_mat                     varchar2(2000);                                  
rito1                          varchar2(2000);                                  
rito3                          varchar2(2000);                                  
ministro2                      varchar2(2000);                                  
art_riga2                      varchar2(2000);                                  
art_riga5                      varchar2(2000);                                  
cma_riga1                      varchar2(2000);                                  
cma_riga4                      varchar2(2000);                                  
cma_riga6                      varchar2(2000);                                  
cma_riga9                      varchar2(2000);                                  
cma_riga12                     varchar2(2000);                                  
cma_riga14                     varchar2(2000);                                  
cma_riga17                     varchar2(2000);                                  
cma_firma                      varchar2(2000);                                  
tte_data_nas_1                 varchar2(2000);                                  
tte_prof_1                     varchar2(2000);                                  
tte_residenza_1                varchar2(2000);                                  
test_2                         varchar2(2000);                                  
tte_nato_2                     varchar2(2000);                                  
tte_prof_2                     varchar2(2000);                                  
doc_il                         varchar2(2000);                                  
presentato                     varchar2(2000);                                  
doc_riga2                      varchar2(2000);                                  
doc_riga5                      varchar2(2000);                                  
doc_riga8                      varchar2(2000);                                  
doc_riga10                     varchar2(2000);                                  
doc_riga11                     varchar2(2000);                                  
doc_riga12                     varchar2(2000);                                  
dfi_riga3                      varchar2(2000);                                  
dfi_riga5                      varchar2(2000);                                  
dfi_riga8                      varchar2(2000);                                  
dfi_riga10                     varchar2(2000);                                  
chi_riga1                      varchar2(2000);                                  
chi_riga2                      varchar2(2000);                                  
chi_riga3                      varchar2(2000);       
chi_riga4                      varchar2(2000);                                  
chi_riga5                      varchar2(2000);                                                             
chi_riga6                      varchar2(2000);                                                             
chi_riga7_null                 varchar2(2000);                                                             
chi_riga7                      varchar2(2000);                                                             
chi_riga8                      varchar2(2000);                                                             
chi_riga9                      varchar2(2000);                                                             
chi_riga10                     varchar2(2000);                                                             
chi_riga11                     varchar2(2000);                                                             
anno_testata                   varchar2(2000);                                  
giorno                         varchar2(2000);                                  
mese                           varchar2(2000);                                  
ore                            varchar2(2000);                                  
minuti                         varchar2(2000);                                  
ufficiale                      varchar2(2000);                                  
motivo                         varchar2(2000);                                  
qualita_2                      varchar2(2000);                                  
nomi                           varchar2(2000);                                  
data_nas2                      varchar2(2000);                                  
serie_nas_m                    varchar2(2000);                                  
prof_m                         varchar2(2000);                                  
cognome_f                      varchar2(2000);                                  
data_nas1_f                    varchar2(2000);                                  
serie_nas_f                    varchar2(2000);                                  
residenza_f                    varchar2(2000);                                  
rma_il                         varchar2(2000);                                  
munito                         varchar2(2000);                                  
cognome_nome_f                 varchar2(2000);                                  
tte_com_nas_1                  varchar2(2000);                                  
ufficio                        number(2) := 0;                                  
anno                           number(4) := 0;                                  
atto                           number(4) := 0;                                  
parte                          number(1) := 0;                                  
serie                          varchar2(2000);                                  
dx_sx                          varchar2(2000);                                  
salto_atti                     number(2) := 0;                                  
cognome_mat_m                  varchar2(2000);                                  
nome_mat_m                     varchar2(2000);                                  
cognome_mat_f                  varchar2(2000);                                  
nome_mat_f                     varchar2(2000);                                  
anno_tr                        varchar2(2000);                                  
mese_tr                        varchar2(2000);                                  
ufficiale_tr                   varchar2(2000);                                  
comune_or                      varchar2(2000); 
--
-- 07/05/2002 - A. Monopoli
stampa_pagine			 number;
-- 
-- 23/01/2003
natura				 varchar2(1);
cod_pro_res_m			 number;
cod_com_res_m			 number;
comune_residenza_m		 varchar2(2000); 
cod_pro_res_f			 number;
cod_com_res_f			 number;
comune_residenza_f		 varchar2(2000); 
cod_pro_utente			 number;
cod_com_utente			 number;
comune_utente			 varchar2(2000);

data_convenzioni			 varchar2(2000);

--
-- campi aggiunti per la stampa del testo a margine
-- Katia 28/05/2004
w_scelta_conv			 	number(1);
w_legge_conv_1			 	varchar2(50);
w_legge_conv_2			 	varchar2(50);
w_legge_conv_3			 	varchar2(50);
w_numero_lib			 	varchar2(10);
w_data_lib			 	varchar2(34);
w_data_firma_lib		 	varchar2(12);
w_stampa_lib			 	varchar2(1);

comune_tras_1			 	varchar2(2000);
atto_tras_1				 varchar2(2000);
parte_tras_1			 	varchar2(2000);
serie_tras_1			 	varchar2(2000);
ufficio_tras_1			 	varchar2(2000);
anno_tras_1				 varchar2(2000);
data_comunicazione_1		 	varchar2(2000);
num_comunicazione_1		 	varchar2(2000);
comune_firma_1			 	varchar2(2000);
data_firma_1			 	varchar2(2000);
comune_tras_2			 	varchar2(2000);
atto_tras_2				varchar2(2000);
parte_tras_2			 	varchar2(2000);
serie_tras_2				varchar2(2000);
ufficio_tras_2			 	varchar2(2000);
anno_tras_2				varchar2(2000);
data_comunicazione_2		 	varchar2(2000);
num_comunicazione_2		 	varchar2(2000);
comune_firma_2			 	varchar2(2000);
data_firma_2			 	varchar2(2000);
ufficiale_prov			 	varchar2(2000);

stampa_solo_margine		 	varchar2(2000); 
stampa_tr1				varchar2(2000);
stampa_tr2				varchar2(2000);
stampa_min				varchar2(2000);

len_clob				number;
riga					number;                          
campo_clob				clob;
w_campo_clob		 		varchar2(32000);
w_pos_acapo				number;
w_pos_spazio				number;
w_testo					varchar2(70);
w_spazi					number;
w_spazio				varchar2(4);  
numero_car       			NUMBER(10);            
quanti_spazi     			NUMBER(10);             
dove             			NUMBER(10);             
direction        			number(1);            
rel_pos          			NUMBER(10);             
testo_iniziale   			varchar2(2000);
testo_finale   				varchar2(2000);

--
-- 06/03/2007 - A. Monopoli
--
testo_annotazione			varchar2(4000);
data_annotazione			varchar2(255);
seq_annotazione			        number;
w_testo_ann				varchar2(4000);
w_testo_ann_255				varchar2(4000);
len_w_testo_ann_255			number;

w_box_libero				number;
atti_box_inp		                varchar2(255);
box_skip_iniziale			number;
box_totale_righe			number;
box_conta_skip			        number;
box_skip				number;


cognome_mat_m_occ			varchar2(2000);
nome_mat_m_occ				VARCHAR2(2000);
cognome_mat_f_occ			VARCHAR2(2000);
nome_mat_f_occ    			varchar2(2000);

--
-- 13/05/2014 - A. Monopoli
--
w_atti_li_inp			varchar2(255) := nvl(rtrim(f_valore_inp('ATTI_LI',1,30,'X','')),'li');

CURSOR SEL_FLAG IS
	select decode(sign(50 - nvl(cilet.chiave,0)),-1,0,1)  
          from cilet
         where lettere (+) = anno_tras
;
FETCH_SEL_FLAG			varchar2(2000) := '
          into flag
';
                                                                              
                                                                                
CURSOR SEL_CIVMAT IS                                                            
        select nvl(rtrim(spo.cognome_m),                                        
                   substr(mat.cognome_nome_m,1,instr(mat.cognome_nome_m,'/')-1)),                                                                                                                                                                              
               nvl(rtrim(spo.nome_m),                                           
                   substr(mat.cognome_nome_m,instr(mat.cognome_nome_m,'/')+1)), 
               nvl(rtrim(spo.cognome_f),                                        
                   substr(mat.cognome_nome_f,1,instr(mat.cognome_nome_f,'/')-1)),                                                                                                                                                                              
               nvl(rtrim(spo.nome_f),                                           
                   substr(mat.cognome_nome_f,instr(mat.cognome_nome_f,'/')+1)), 
               mat.convenzioni,
	       decode(sign(a.cod_provincia-199),-1,
	         decode(lpad(a.cod_provincia,3,'0')||lpad(a.cod_comune,3,'0'),
	           '015195','SAN GIULIANO M.SE, li', a.descrizione||', li'),
	         decode(lpad(b.cod_provincia,3,'0')||lpad(b.cod_comune,3,'0'),
	           '015195','SAN GIULIANO M.SE, li', b.descrizione||', li')),
	       mat.natura,
	       b.cod_provincia, b.cod_comune, b.descrizione,
	       c.cod_provincia, c.cod_comune, c.descrizione,
	       d.cod_provincia, d.cod_comune, d.descrizione,
	       to_char(to_date(mat.data_convenzioni,'j'),'dd/mm/yyyy')
          from arccom a, arccom b,arccom c,arccom d,
		   civspo spo,civmat mat                                     
         where a.cod_provincia (+)  = mat.cod_pro_mat                                 
           and a.cod_comune    (+)  = mat.cod_com_mat                                 
           and (b.cod_provincia,b.cod_comune) = (select pro_cliente,com_cliente from menuditta)
           and c.cod_provincia (+)  = cod_pro_res_m                                 
           and c.cod_comune    (+)  = cod_com_res_m                                 
           and d.cod_provincia (+)  = cod_pro_res_f                                 
           and d.cod_comune    (+)  = cod_com_res_f                                 
           and nvl(spo.serie(+),' ') = nvl(mat.serie,' ')                       
           and spo.parte(+)          = mat.parte                                
           and spo.atto(+)        = mat.atto                                    
           and spo.anno(+)        = mat.anno                                    
           and spo.ufficio(+)  	  = mat.ufficio                                 
           and spo.tipo_atto(+)          = 4                                    
           and nvl(mat.serie,' ') = nvl(civsmat.serie,' ')                      
           and mat.parte          = civsmat.parte                               
           and mat.atto           = civsmat.atto                                
           and mat.anno           = civsmat.anno                                
           and mat.ufficio        = civsmat.ufficio                             
;                                                                               
FETCH_SEL_CIVMAT                 varchar2(2000) := '                            
          into cognome_mat_m,nome_mat_m,cognome_mat_f,nome_mat_f,               
               convenzioni,comune_ann,
		   natura,
		   cod_pro_utente, cod_com_utente, comune_utente,
		   cod_pro_res_m, cod_com_res_m, comune_residenza_m,
		   cod_pro_res_f, cod_com_res_f, comune_residenza_f,
		   data_convenzioni                                           
';                                                                              

CURSOR SEL_CIVOCC IS           
      select decode(occ.atto,'', civsmat.cognome_mat_m, occ.cognome),
		 decode(occ.atto,'', civsmat.nome_mat_m, occ.nome),
		 decode(occ.atto,'', civsmat.cognome_mat_f, occ.cognome_cn),
		 decode(occ.atto,'', civsmat.nome_mat_f, occ.nome_cn)
        from civocc occ, civmat mat
       where nvl(occ.serie(+),' ')	= nvl(mat.serie,' ')                   
         and occ.parte		(+)	= mat.parte                                 
         and occ.atto     	(+)	= mat.atto                                     
         and occ.anno     	(+)	= mat.anno                                     
         and occ.ufficio 	(+)	= mat.ufficio    
	   and occ.tipo_atto 	(+)	= 4
         and nvl(mat.serie,' ') 	= nvl(civsmat.serie,' ')                      
         and mat.parte          	= civsmat.parte                               
         and mat.atto           	= civsmat.atto                                
         and mat.anno           	= civsmat.anno                                
         and mat.ufficio        	= civsmat.ufficio            
;                                                                               
FETCH_SEL_CIVOCC             varchar2(2000) := '                            
          into cognome_mat_m_occ,nome_mat_m_occ,cognome_mat_f_occ,nome_mat_f_occ                     
';                                                                        
                                                                                
CURSOR SEL_CIVTLI IS                                                            
        select riga_clob                                       
          from civtli                                                           
         where nvl(serie,' ')   = nvl(civsmat.serie,' ')                        
           and parte             = civsmat.parte                                
           and atto      	= civsmat.atto                                        
           and anno      	= civsmat.anno                                        
           and ufficio   	= civsmat.ufficio                                     
           and tipo_atto         = 4                                            
           and cod_riga = 1                                                      
;                                                                               
FETCH_SEL_CIVTLI                 varchar2(2000) := '                            
          into campo_clob                                                         
';                                                                              

                                                                              
                                                                                
                                                                             
                                                                                
                                                                                
CURSOR SEL_CMA IS                                                               
        select rpad(nvl(cma.riga1,'_'),68,'_'),                                 
               rpad(nvl(cma.riga2,'_'),70,'_'),                                 
               rpad(nvl(cma.riga3,'_'),70,'_'),                                 
               rpad(nvl(cma.riga4,'_'),70,'_'),                                 
               rpad(nvl(cma.riga5,'_'),70,'_'),                                 
               rpad(nvl(cma.riga6,'_'),70,'_'),                                 
               rpad(nvl(cma.riga7,'_'),70,'_'),                                 
               rpad(nvl(cma.riga8,'_'),70,'_'),                                 
               rpad(nvl(cma.riga9,'_'),70,'_'),                                 
               rpad(nvl(cma.riga10,'_'),70,'_'),                                
               rpad(nvl(cma.riga11,'_'),70,'_'),                                
               rpad(nvl(cma.riga12,'_'),70,'_'),                                
               rpad(nvl(cma.riga13,'_'),70,'_'),                                
               rpad(nvl(cma.riga14,'_'),70,'_'),                                
               rpad(nvl(cma.riga15,'_'),70,'_'),                                
               rpad(nvl(cma.riga16,'_'),70,'_'),                                
               rpad(nvl(cma.riga17,'_'),70,'_'),                                
               rpad(nvl(cma.riga18,'_'),70,'_'),                                
               rpad(nvl(cma.riga19,'_'),70,'_'),                                
               rpad(cma.firma,34,'_'),                                          
               rtrim(cma.firma)                                                 
          from civcma cma                                                       
         where nvl(cma.serie,' ')     	= nvl(civsmat.serie,' ')                 
           and cma.parte                     = civsmat.parte                    
           and cma.atto      		= civsmat.atto                                   
           and cma.anno      		= civsmat.anno                                   
           and cma.ufficio   		= civsmat.ufficio                                
;                                                                               
FETCH_SEL_CMA                    varchar2(2000) := '                            
          into cma_riga1,cma_riga2,cma_riga3,cma_riga4,cma_riga5,               
               cma_riga6,cma_riga7,cma_riga8,cma_riga9,cma_riga10,              
               cma_riga11,cma_riga12,cma_riga13,cma_riga14,cma_riga15,          
               cma_riga16,cma_riga17,cma_riga18,cma_riga19,cma_firma,           
               cma_firma_mar                                                    
';                                                                              
                                                                                
                                                                                
CURSOR SEL_DFI IS                                                               
        select rpad(nvl(dfi.riga1,'_'),68,'_'),                                 
               rpad(nvl(dfi.riga2,'_'),70,'_'),                                 
               rpad(nvl(dfi.riga3,'_'),70,'_'),                                 
               rpad(nvl(dfi.riga4,'_'),70,'_'),                                 
               rpad(nvl(dfi.riga5,'_'),68,'_'),                                 
               rpad(nvl(dfi.riga6,'_'),70,'_'),                                 
               rpad(nvl(dfi.riga7,'_'),70,'_'),                                 
               rpad(nvl(dfi.riga8,'_'),70,'_'),                                 
               rpad(nvl(dfi.riga9,'_'),68,'_'),                                 
               rpad(nvl(dfi.riga10,'_'),70,'_'),                                
               rpad(nvl(dfi.riga11,'_'),70,'_'),                                
               rpad(nvl(dfi.riga12,'_'),70,'_')                                 
          from civdfi dfi                                                       
         where nvl(dfi.serie,' ')     	= nvl(civsmat.serie,' ')                 
           and dfi.parte                     = civsmat.parte                    
           and dfi.atto      		= civsmat.atto                                   
           and dfi.anno      		= civsmat.anno                                   
           and dfi.ufficio   		= civsmat.ufficio                                
;                                                                               
FETCH_SEL_DFI                    varchar2(2000) := '                            
          into dfi_riga1,dfi_riga2,dfi_riga3,dfi_riga4,dfi_riga5,               
               dfi_riga6,dfi_riga7,dfi_riga8,dfi_riga9,dfi_riga10,              
               dfi_riga11,dfi_riga12                                            
';                                                                              
                                                                                
                                                                                
CURSOR SEL_DMA_ART IS                                                           
        select decode(sign(50 - nvl(cilet.chiave,0)),
			-1,'millenovecento','duemila')||rpad(nvl(anno_mat,'_'),37,'_'),                                             
               rpad(giorno_mat,19,'_'),rpad(mese_mat,11,'_'),                   
               rpad(ore_mat,18,'_'),rpad(nvl(minuti_mat,'_'),19,'_'),           
               rpad(comune_mat,66,'_'),nvl(nel,'__'),rpad(luogo_mat,63,'_'),    
               rpad(rito1,39,'_'),rpad(nvl(rito2,'_'),70,'_'),                  
               rpad(nvl(rito3,'_'),70,'_'),                                     
               rpad(ministro1,70,'_'),rpad(nvl(ministro2,'_'),70,'_'),          
               rpad(nvl(non,'_'),9,'_'),                                        
               rpad(nvl(art.riga1,'_'),70,'_'),                                 
               rpad(nvl(art.riga2,'_'),70,'_'),                                 
               rpad(nvl(art.riga3,'_'),70,'_'),                                 
               rpad(nvl(art.riga4,'_'),70,'_'),                                 
               rpad(nvl(art.riga5,'_'),70,'_'),                                 
               rpad(nvl(art.riga6,'_'),70,'_')                                  
          from cilet,civart art,civdma dma                                            
         where cilet.lettere (+) = upper(anno_mat)
           and nvl(art.serie,' ')	= nvl(dma.serie,' ')                          
           and art.parte                = dma.parte                             
           and art.atto      		= dma.atto                                       
           and art.anno      		= dma.anno                                       
           and art.ufficio 		= dma.ufficio                                      
           and nvl(dma.serie,' ')       = nvl(civsmat.serie,' ')          
           and dma.parte                = civsmat.parte                    
           and dma.atto      		= civsmat.atto                                   
           and dma.anno      		= civsmat.anno                                   
           and dma.ufficio   		= civsmat.ufficio                                
;                                                                               
FETCH_SEL_DMA_ART                varchar2(2000) := '                            
          into anno_mat,giorno_mat,mese_mat,ore_mat,minuti_mat,                 
               comune_mat,nel,luogo_mat,rito1,rito2,rito3,                      
               ministro1,ministro2,non,art_riga1,art_riga2,art_riga3,           
               art_riga4,art_riga5,art_riga6                                    
';                                                                              
                                                                                
                                                                                
CURSOR SEL_INCH IS                                                              
        select chr(27)||chr(48),chr(27)||chr(50)                                
          from dual                                                             
;                                                                               
FETCH_SEL_INCH                   varchar2(2000) := '                            
          into otto_inch,sei_inch                                               
';                                                                              
                                                                                
                                                                                
CURSOR SEL_MAR IS                                                               
	  select rpad(data_tras,25,'_'),rpad(anno_tras,15,'_'),                   
               rpad(ministro_1,20,'_'),rpad(nvl(ministro_2,'_'),34,'_'),
		   rpad(comune_tras_1,34,'_'),
		   rpad(atto_tras_1,6,'_'),
		   rpad(decode(parte_tras_1,'1','I','2','II',parte_tras_1),2,'_'),
		   serie_tras_1,ufficio_tras_1,anno_tras_1,
               to_char(to_date(data_comunicazione_1,'j'),'dd/mm/yy'),
		   num_comunicazione_1,comune_firma_1,
               to_char(to_date(data_firma_1,'j'),'dd/mm/yyyy'),
		   rpad(comune_tras_2,34,'_'),
		   rpad(atto_tras_2,6,'_'),
		   rpad(decode(parte_tras_1,'1','I','2','II',parte_tras_2),2,'_'),
		   serie_tras_2,ufficio_tras_2,anno_tras_2,
               to_char(to_date(data_comunicazione_2,'j'),'dd/mm/yy'),
		   num_comunicazione_2,comune_firma_2,
               to_char(to_date(data_firma_2,'j'),'dd/mm/yyyy'),
		   ufficiale_prov,mar.stampa_tr1,mar.stampa_tr2,mar.stampa_min,
               mar.scelta_conv, rpad(mar.legge_conv_1,14,'_'), rpad(mar.legge_conv_2,34,'_'), 
               rpad(mar.legge_conv_3,34,'_'),mar.stampa_lib,rpad(mar.numero_lib,10,'_'),
               decode(mar.data_lib,null,'__________',to_char(to_date(mar.data_lib,'j'),'dd/mm/yyyy'))||'._______________________',
               decode(mar.data_firma_lib,null,'__________',to_char(to_date(mar.data_firma_lib,'j'),'dd/mm/yyyy'))
          from civdpa dpa, civmar mar, civmat mat
         where nvl(dpa.serie(+),' ')= nvl(mat.serie,' ')                        
           and dpa.parte 	(+)   = mat.parte                                
           and dpa.atto		(+) 	= mat.atto                                        
           and dpa.anno      	(+)	= mat.anno                                        
           and dpa.ufficio   	(+)	= mat.ufficio                                     
           and dpa.tipo_atto	(+)   = 4                                            
           and nvl(mar.serie(+),' ')= nvl(mat.serie,' ')                        
           and mar.parte 	(+)   = mat.parte                                
           and mar.atto		(+) 	= mat.atto                                        
           and mar.anno      	(+)	= mat.anno                                        
           and mar.ufficio   	(+)	= mat.ufficio                                     
           and mar.tipo_atto	(+)   = 4                                            
           and nvl(mat.serie,' ')	= nvl(civsmat.serie,' ')                        
           and mat.parte            = civsmat.parte                                
           and mat.atto      		= civsmat.atto                                        
           and mat.anno      		= civsmat.anno                                        
           and mat.ufficio   		= civsmat.ufficio                                     
;                                                                               
FETCH_SEL_MAR                    varchar2(2000) := '                            
          into data_tras,anno_tras,ministro_1,ministro_2,
		   comune_tras_1,
		   atto_tras_1,parte_tras_1,serie_tras_1,ufficio_tras_1,
		   anno_tras_1,data_comunicazione_1,
		   num_comunicazione_1,comune_firma_1,data_firma_1,
		   comune_tras_2,
		   atto_tras_2,parte_tras_2,serie_tras_2,ufficio_tras_2,anno_tras_2,
		   data_comunicazione_2,num_comunicazione_2,comune_firma_2,data_firma_2,
		   ufficiale_prov,stampa_tr1,stampa_tr2,stampa_min ,
                   w_scelta_conv, w_legge_conv_1, w_legge_conv_2, w_legge_conv_3,
                   w_stampa_lib,w_numero_lib,w_data_lib,w_data_firma_lib
	                          
';                                                                              
                                                                                
                                                                                
CURSOR SEL_PARAMETRI IS                                                         
        select ltrim(substr(parametri,1,2),'0'),substr(parametri,3,4),          
               ltrim(substr(parametri,7,4),'0'),substr(parametri,11,1),         
               substr(parametri,12,1),substr(parametri,13,1),                   
               rtrim(inp.valore),
	         substr(parametri,14,1),substr(parametri,15,1),
	       f_valore_inp('ATTI_MAT1',9,1,'9','')                                                
          from arcinp inp,tabrep                                                
         where inp.parametro        = 'SALTO_ATTI'                              
           and chiave            = 'SMAT'                                       
           and terminale         = nvl(userenv('terminal'),'CIVSMAT')
;                                                                               
FETCH_SEL_PARAMETRI              varchar2(2000) := '                            
          into ufficio,anno,atto,parte,serie,dx_sx,                             
               salto_atti,stampa_pagine,stampa_solo_margine,
	       w_box_libero                                                       
';                                                                              
                                                                                
                                                                                
CURSOR SEL_RMA_DOC_CHI IS                                                       
        select nvl(rma.il,'_'),nvl(rma.documento,'_'),nvl(descritto,'_'),       
               nvl(munito,'_'),rpad(cognome_nome_f,70,'_'),                     
               rpad(cognome_nome_m,70,'_'),                                     
               nvl(doc.il,'_'),nvl(doc.documento,'_'),                          
               nvl(presentato,'_'),                                             
               rpad(nvl(doc.riga1,'_'),47,'_'),                                 
               rpad(nvl(doc.riga2,'_'),70,'_'),                                 
               rpad(nvl(doc.riga3,'_'),70,'_'),                                 
               rpad(nvl(doc.riga4,'_'),70,'_'),                                 
               rpad(nvl(doc.riga5,'_'),70,'_'),                                 
               rpad(nvl(doc.riga6,'_'),70,'_'),                                 
               rpad(nvl(doc.riga7,'_'),70,'_'),                                 
               doc.riga7,
               rpad(nvl(doc.riga8,'_'),70,'_'),                                 
               rpad(nvl(doc.riga9,'_'),70,'_'),                                 
               rpad(nvl(doc.riga10,'_'),70,'_'),                                
               rpad(nvl(doc.riga11,'_'),70,'_'),                                
               rpad(nvl(doc.riga12,'_'),70,'_'),                                
               rpad(nvl(chi.riga1,'_'),68,'_'),                                 
               rpad(nvl(chi.riga2,'_'),70,'_'),                                 
               rpad(nvl(chi.riga3,'_'),70,'_'),                                  
               rpad(nvl(chi.riga4,'_'),70,'_'),                                  
               rpad(nvl(chi.riga5,'_'),70,'_'),                                  
               rpad(nvl(chi.riga6,'_'),70,'_'),  
	         chi.riga7,                                
               rpad(nvl(chi.riga7,'_'),70,'_'),                                  
               rpad(nvl(chi.riga8,'_'),70,'_'),                                  
               rpad(nvl(chi.riga9,'_'),70,'_'),                                  
               rpad(nvl(chi.riga10,'_'),70,'_'),                                  
               rpad(nvl(chi.riga11,'_'),70,'_')                                  
          from civchi chi,civdoc doc,civrma rma                                 
         where nvl(chi.serie,' ')	= nvl(rma.serie,' ')                          
           and chi.parte                = rma.parte                             
           and chi.atto      		= rma.atto                                       
           and chi.anno      		= rma.anno                                       
           and chi.ufficio 		= rma.ufficio                                      
           and chi.tipo_atto                = 4                                 
           and nvl(doc.serie,' ')        = nvl(rma.serie,' ')                   
           and doc.parte                = rma.parte                             
           and doc.atto  	     	= rma.atto                                      
           and doc.anno      		= rma.anno                                       
           and doc.ufficio 		= rma.ufficio                                      
           and nvl(rma.serie,' ')             = nvl(civsmat.serie,' ')          
           and rma.parte                     = civsmat.parte                    
           and rma.atto      		= civsmat.atto                                   
           and rma.anno      		= civsmat.anno                                   
           and rma.ufficio   		= civsmat.ufficio                                
;                                                                               
FETCH_SEL_RMA_DOC_CHI            varchar2(2000) := '                            
          into rma_il,rma_documento,descritto,munito,                           
               cognome_nome_f,cognome_nome_m,                                   
               doc_il,doc_documento,presentato,                                 
               doc_riga1,doc_riga2,doc_riga3,doc_riga4,doc_riga5,doc_riga6,
		   doc_riga7,doc_riga7_null,
		   doc_riga8,doc_riga9,doc_riga10,doc_riga11,doc_riga12,              
               chi_riga1,chi_riga2,chi_riga3,chi_riga4,chi_riga5,chi_riga6,                                    
 	         chi_riga7_null,chi_riga7,chi_riga8,chi_riga9,chi_riga10,
		   chi_riga11                                   
';                                                                              
                                                                                
                                                                                
CURSOR SEL_SALTO IS                                                             
        select 'x'                                                              
          from anaana                                                           
         where rownum < civsmat.salto                                           
           and matricola < 1000
;                                                                               
FETCH_SEL_SALTO                  varchar2(2000) := '                            
          into campo1                                                           
';                                                                              
                                                                                
                                                                                
CURSOR SEL_TES_SPO IS                                                           
        select decode(sign(50 - nvl(cilet.chiave,0)),
			-1,'millenovecento','duemila')||rpad(nvl(anno_testata,'_'),37,'_'),                                             
               rpad(giorno,19,'_'),rpad(mese,11,'_'),                           
               rpad(ore,18,'_'),rpad(nvl(minuti,'_'),19,'_'),                   
               rpad(ufficiale,59,'_')||decode(civsmat.parte,2,'______',''),     
               rpad(comune,42,'_'),rpad(tes.motivo,68,'_'),                     
               rpad(ministro,58,'_'),rpad(nvl(qualita_1,'_'),70,'_'),           
               rpad(nvl(qualita_2,'_'),70,'_'),                                 
               rpad(cognome_m,32,'_'),                                          
               rpad(nome_m,34,'_')||lpad(rpad(nome_f,34,'_'),36,' '),           
               rpad(com_nas_m,29,'_'),rpad(data_nas1_m,32,'_'),                 
               rpad(data_nas2_m,34,'_')||lpad(rpad(data_nas2_f,34,'_'),36,' '), 
               rpad('_'||atto_nas_m,9,'_'),                                     
               rpad(nvl(parte_nas_m,'_'),6,'_'),                                
               rpad(nvl(serie_nas_m,'_')||decode(anno_atto_nas_m,'','',' / '||anno_atto_nas_m),8,'_'),                                
               rpad(nvl(stato_civile_m,'_'),34,'_')||                           
               lpad(rpad(nvl(stato_civile_f,'_'),34,'_'),36,' '),               
               rpad(nvl(prof_m,'_'),32,'_'),rpad(nvl(residenza_m,'_'),26,'_'),  
               rpad(nvl(cittadinanza_m,'_'),24,'_'),                            
               rpad(cognome_f,32,'_'),rpad(com_nas_f,29,'_'),                   
               rpad(data_nas1_f,32,'_'),                                        
               rpad('_'||atto_nas_f,9,'_'),                                     
               rpad(nvl(parte_nas_f,'_'),6,'_'),                                
               rpad(nvl(serie_nas_f,'_')||decode(anno_atto_nas_f,'','',' / '||anno_atto_nas_f),8,'_'),                                
               rpad(nvl(prof_f,'_'),32,'_'),rpad(nvl(residenza_f,'_'),26,'_'),  
               rpad(nvl(cittadinanza_f,'_'),24,'_')                             
          from cilet,civspo spo,civtes tes                                            
         where cilet.lettere (+)        = upper(anno_testata)
           and nvl(spo.serie,' ')	= nvl(tes.serie,' ')                          
           and spo.parte                = tes.parte                             
           and spo.atto      		= tes.atto                                       
           and spo.anno      		= tes.anno                                       
           and spo.ufficio 		= tes.ufficio                                      
           and spo.tipo_atto                 = tes.tipo_atto                    
           and nvl(tes.serie,' ')        = nvl(civsmat.serie,' ')               
           and tes.parte                = civsmat.parte                         
           and tes.atto      		= civsmat.atto                                   
           and tes.anno      		= civsmat.anno                                   
           and tes.ufficio 		= civsmat.ufficio                                  
           and tes.tipo_atto                = 4                                 
;                                                                               
FETCH_SEL_TES_SPO                varchar2(2000) := '                            
          into anno_testata,giorno,mese,ore,minuti,                             
               ufficiale,comune,motivo,                                         
               ministro,qualita_1,qualita_2,                                    
               cognome_m,nomi,                                                  
               com_nas_m,data_nas1_m,data_nas2,atto_nas_m,                      
               parte_nas_m,serie_nas_m,riga_stato_civile,prof_m,                
               residenza_m,cittadinanza_m,                                      
               cognome_f,com_nas_f,data_nas1_f,atto_nas_f,                      
               parte_nas_f,serie_nas_f,prof_f,                                  
               residenza_f,cittadinanza_f                                       
';                                                                              
                                                                                
                                                                                
CURSOR SEL_TTE IS                                                               
        select rpad(translate(test_1,'/',' '),70,'_'),tte.nato_1,               
               decode(tte.com_nas_1,'',
		 rpad('___'||tte.com_nas_1,66,'_'),                               
		 rpad('in '||tte.com_nas_1,66,'_')),                               
               rpad(tte.data_nas_1,68,'_'),rpad(tte.prof_1,68,'_'),             
               rpad(tte.residenza_1,61,'_'),                                    
               rpad(translate(test_2,'/',' '),68,'_'),tte.nato_2,               
               decode(tte.com_nas_2,'',
		 rpad('___'||tte.com_nas_2,66,'_'),                               
		 rpad('in '||tte.com_nas_2,66,'_')),                               
               rpad(tte.data_nas_2,68,'_'),                                     
               rpad(tte.prof_2,68,'_'),rpad(tte.residenza_2,61,'_')             
          from civtte tte                                                       
         where nvl(tte.serie,' ')	= nvl(civsmat.serie,' ')                      
           and tte.parte                = civsmat.parte                         
           and tte.atto      		= civsmat.atto                                   
           and tte.anno      		= civsmat.anno                                   
           and tte.ufficio 		= civsmat.ufficio                                  
           and tte.tipo_atto                = 4                                 
;                                                                               
FETCH_SEL_TTE                    varchar2(2000) := '                            
          into test_1,tte_nato_1,tte_com_nas_1,tte_data_nas_1,                  
               tte_prof_1,tte_residenza_1,                                      
               test_2,tte_nato_2,tte_com_nas_2,tte_data_nas_2,                  
               tte_prof_2,tte_residenza_2                                       
';                                                                              
                                                                                
                                                                                
CURSOR SEL_TTR IS                                                               
        select decode(sign(50 - nvl(cilet.chiave,0)),
			-1,'millenovecento','duemila')||rpad(nvl(anno_tr,'_'),37,'_'),                                             
               rpad(giorno_tr,19,'_'),rpad(mese_tr,11,'_'),                     
               rpad(ore_tr,18,'_'),rpad(nvl(minuti_tr,'_'),19,'_'),             
               rpad(ufficiale_tr,64,'_'),rpad(comune_tr,42,'_'),                
               rpad(motivo_tr,68,'_'),rpad(comune_or,70,'_')                    
          from cilet,civttr                                                           
         where cilet.lettere (+) = upper(anno_tr)
           and nvl(serie,' ') = nvl(civsmat.serie,' ')                          
           and parte              = civsmat.parte                               
           and atto           = civsmat.atto                                    
           and anno           = civsmat.anno                                    
           and ufficio        = civsmat.ufficio                                 
           and tipo_atto      = 4                                               
;                                                                               
FETCH_SEL_TTR                    varchar2(2000) := '                            
          into anno_tr,giorno_tr,mese_tr,ore_tr,minuti_tr,ufficiale_tr,         
               comune_tr,motivo_tr,comune_or                                    
';                                                                              

CURSOR SEL_TES_SPO_TTE IS                                                               
        select decode(sign(50 - nvl(cilet.chiave,0)),
                 -1,rpad('millenovecento'||anno_testata,37,'_'),
                    rpad('duemila'||anno_testata,37,'_')),
               rpad(giorno,19,'_'),rpad(mese,11,'_'),
               rpad(ore,18,'_'),rpad(nvl(minuti,'_'),19,'_'),
               rpad(ufficiale,59,'_')||decode(civsmat.parte,2,'______',''),
               rpad(comune,42,'_'),rpad(tes.motivo,68,'_'),
               rpad(ministro,58,'_'),rpad(nvl(qualita_1,'_'),70,'_'),
               rpad(nvl(qualita_2,'_'),70,'_'),
               rpad(cognome_m,32,'_'),
               rpad(nome_m,34,'_')||lpad(rpad(nome_f,34,'_'),36,' '),
               rpad(com_nas_m,29,'_'),rpad(data_nas1_m,32,'_'),
               rpad(data_nas2_m,34,'_')||lpad(rpad(data_nas2_f,34,'_'),36,' '),
               rpad('_'||atto_nas_m,9,'_'),
               rpad(nvl(parte_nas_m,'_'),6,'_'),
               rpad(nvl(serie_nas_m,'_')||decode(anno_atto_nas_m,'','',' / '||anno_atto_nas_m),8,'_'),
               rpad(nvl(stato_civile_m,'_'),34,'_')||
               lpad(rpad(nvl(stato_civile_f,'_'),34,'_'),36,' '),
               rpad(nvl(prof_m,'_'),32,'_'),rpad(nvl(residenza_m,'_'),26,'_'),
               rpad(nvl(cittadinanza_m,'_'),24,'_'),
               rpad(cognome_f,32,'_'),rpad(com_nas_f,29,'_'),
               rpad(data_nas1_f,32,'_'),
               rpad('_'||atto_nas_f,9,'_'),
               rpad(nvl(parte_nas_f,'_'),6,'_'),
               rpad(nvl(serie_nas_f,'_')||decode(anno_atto_nas_f,'','',' / '||anno_atto_nas_f),8,'_'),
               rpad(nvl(prof_f,'_'),32,'_'),rpad(nvl(residenza_f,'_'),26,'_'),
               rpad(nvl(cittadinanza_f,'_'),24,'_'),
               rpad(translate(nvl(test_1,'_'),'/',' '),70,'_'),
               nvl(tte.nato_1,'_'),
               decode(tte.com_nas_1,'',
		 rpad('___'||nvl(tte.com_nas_1,'_'),66,'_'),
		 rpad('in '||nvl(tte.com_nas_1,'_'),66,'_')),
               rpad(nvl(tte.data_nas_1,'_'),68,'_'),
               rpad(nvl(tte.prof_1,'_'),68,'_'),
               rpad(nvl(tte.residenza_1,'_'),61,'_'),
               rpad(translate(nvl(test_2,'_'),'/',' '),68,'_'),
               nvl(tte.nato_2,'_'),
               decode(tte.com_nas_2,'',
		 rpad('___'||nvl(tte.com_nas_2,'_'),66,'_'),
		 rpad('in '||nvl(tte.com_nas_2,'_'),66,'_')),
               rpad(nvl(tte.data_nas_2,'_'),68,'_'),
               rpad(nvl(tte.prof_2,'_'),68,'_'),
               rpad(nvl(tte.residenza_2,'_'),61,'_')
          from cilet,civtte tte,civspo spo,civtes tes
         where cilet.lettere (+)        = upper(anno_testata)
           and nvl(spo.serie,' ')       = nvl(tes.serie,' ')
           and spo.parte                = tes.parte
           and spo.atto                 = tes.atto
           and spo.anno                 = tes.anno
           and spo.ufficio              = tes.ufficio
           and spo.tipo_atto            = tes.tipo_atto
           and nvl(tte.serie(+),' ')    = nvl(tes.serie,' ')
           and tte.parte        (+)     = tes.parte
           and tte.atto         (+)     = tes.atto
           and tte.anno         (+)     = tes.anno
           and tte.ufficio      (+)     = tes.ufficio
           and tte.tipo_atto    (+)     = tes.tipo_atto
           and nvl(tes.serie,' ')       = nvl(civsmat.serie,' ')
           and tes.parte                = civsmat.parte
           and tes.atto                 = civsmat.atto
           and tes.anno                 = civsmat.anno
           and tes.ufficio              = civsmat.ufficio
           and tes.tipo_atto            = 4
;                                                                               
FETCH_SEL_TES_SPO_TTE            varchar2(2000) := '                            
          into anno_testata,giorno,mese,ore,minuti,
               ufficiale,comune,motivo,
               ministro,qualita_1,qualita_2,
               cognome_m,nomi,
               com_nas_m,data_nas1_m,data_nas2,atto_nas_m,
               parte_nas_m,serie_nas_m,riga_stato_civile,prof_m,
               residenza_m,cittadinanza_m,
               cognome_f,com_nas_f,data_nas1_f,atto_nas_f,
               parte_nas_f,serie_nas_f,prof_f,
               residenza_f,cittadinanza_f,
               test_1,tte_nato_1,tte_com_nas_1,tte_data_nas_1,
               tte_prof_1,tte_residenza_1,
               test_2,tte_nato_2,tte_com_nas_2,tte_data_nas_2,
               tte_prof_2,tte_residenza_2
';     

CURSOR SEL_MARGINE_ANN IS
	select f_testo_annotazione(ann.tipo_atto,ann.ufficio,ann.anno,ann.atto,ann.parte,ann.serie,ann.formula,ann.stato,ann.data_reg,ann.sequenza,ann.stampa),
               to_char(to_date(ann.data_reg,'j'),'dd/mm/yyyy'),ann.sequenza,
               nvl(f_valore_inp('ATTI_BOX',1,1,'X','S'),'N'),
               box.skip_iniziale, box.totale_righe
          from  civbox box, civann ann
         where box.tipo_atto (+)    	= ann.tipo_atto
           and box.parte       (+)    	= ann.parte
           and nvl(box.serie (+),' ') 	= nvl(ann.serie,' ')
           and box.sequenza  (+)    	= ann.sequenza
           and ann.tipo_atto        	= 4
           and ann.ufficio        	= civsmat.ufficio
           and ann.anno            	= civsmat.anno
           and ann.atto            	= civsmat.atto
           and ann.parte        	= civsmat.parte
           and nvl(ann.serie,' ')    	= nvl(civsmat.serie,' ')
           and ann.stato        	= 'E'
           and ann.stampa        	= 'S'
       order by ann.data_reg, ann.sequenza
;
FETCH_SEL_MARGINE_ANN		 varchar2(2000) := '
          into testo_annotazione, data_annotazione, seq_annotazione,
               atti_box_inp, box_skip_iniziale, box_totale_righe
';                                                                         
                                                                                
procedure main;    
procedure CTR_SALTO_ATTI;
procedure STAMPA_NOMI_MARGINE;
procedure STAMPA_CONV_MARGINE;                                                             
procedure STAMPA_TESTO_MARGINE;
procedure STAMPA_MARGINE_LIB;
procedure TR_CIVTLI;                                                            
procedure TR_CIVTLI_1;                                                          
procedure TR_SALTO;                                                             
procedure TR_SALTO_1; 
procedure inizializza_clob;                                                           
procedure conta_num_righe;                                                          
procedure STAMPA_MARGINE_ANN;
                                                                                
end;                                                                            
/                                                                               
