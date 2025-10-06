--liquibase formatted sql
--changeset amonopoli:202303231755_6 runOnChange:true stripComments:false
create or replace function f_CIV_testo_formula_CIA
(a_tipo_formula		in   varchar2
,a_tipo_atto   		in   number
,a_ufficio     		in   number
,a_anno        		in   number
,a_parte       		in   number
,a_serie       		in   varchar2
,a_atto        		in   number
,a_natura      		in   varchar2
,a_terminalista		in   varchar2
)

return varchar2

IS

w_tipo_formula		varchar2(255) := upper(a_tipo_formula);

w_comune_utente     	varchar2(255);
w_provincia_utente  	varchar2(255);
w_comune_firma     	varchar2(255);
w_data			varchar2(255);

w_cod_comune_utente	varchar2(255);

w_tipo_atto         	varchar2(255);
w_parte_serie       	varchar2(255);

w_terminalista		varchar2(255) := f_get_nome_terminalista(a_terminalista);

w_firme_chiusura	varchar2(4000);

w_testo            	varchar2(4000);
w_testo_finale         	varchar2(4000);

begin
  begin
    select c.descrizione, p.descrizione, lpad(c.cod_provincia,3,'0')||lpad(c.cod_comune,3,'0'), initcap(c.descrizione),
           to_char(sysdate,'dd/mm/yyyy')
      into w_comune_utente, w_provincia_utente, w_cod_comune_utente, w_comune_firma, w_data
      from arcpro p
         , arccom c
     where (c.cod_provincia, c.cod_comune) = (select pro_cliente, com_cliente from menuditta)
       and p.cod_provincia = c.cod_provincia
    ;
  exception
    when others then
         w_comune_utente := '';
         w_provincia_utente := '';
  end;

  begin 
     select decode(a_tipo_atto, 1, 'cittadinanza', 2, 'nascita', 4, 'matrimonio', 5, 'morte', -4, 'unione civile')
          , decode(a_parte, 1, ', Parte I', 2, ', Parte II')||decode(a_serie, '', '', ' Serie '||a_serie)
       into w_tipo_atto, w_parte_serie
       from dual
     ;
  exception
    when others then
         w_tipo_atto   := '';
         w_parte_serie := '';
  end;

/*
  w_testo := 'COMUNE DI '||w_comune_utente;

--  w_testo := w_testo||chr(10)||
--              'Provincia di '||w_provincia_utente; 

  w_testo := w_testo||chr(10)||
              'Ufficio dello Stato Civile';

  if w_cod_comune_utente in ('083097') then 	-- taormina
     w_testo := w_testo||chr(10)||
                 'Ai sensi dell''art. 18, comma 2, del D.P.R. N. 445/2000 il sottoscritto ufficiale dello Stato Civile, '||
                 'attesta la conformità all''originale della presente copia sottoscritta sul documento originale da '||
                 replace(ltrim(f_CIV_firme_chiusura_CIA(a_tipo_atto,a_ufficio,a_anno,a_parte,a_serie,a_atto,a_natura),'f.to '),'f.to','/' );
  else
     w_testo := w_testo||chr(10)||
                 'La presente copia è conforme all''atto originale di '||w_tipo_atto||', '||
                 'N. '||a_atto||w_parte_serie||', dell''anno '||a_anno||', '||
                 'esistente presso questo ufficio.';
  end if;

  w_testo := w_testo||chr(10)||
              initcap(w_comune_utente)||', li '||to_char(sysdate,'dd/mm/yyyy');

  w_testo := w_testo||chr(10)||
              'L''UFFICIALE DELLO STATO CIVILE';

  w_testo := w_testo||chr(10)||
              w_terminalista;
*/

  begin 
    select testo
      into w_testo
      from civfaa
     where tipo_atto    = a_tipo_atto
       and tipo_formula = w_tipo_formula
       and flag_cia     is not null
     ;
  exception
    when others then
         w_testo := '';
  end;     

  w_testo_finale := w_testo;

  if instr(w_testo,'<') > 0 and instr(w_testo,'>') > 0 then   
     w_testo_finale := replace(w_testo_finale, '<COMUNE>', w_comune_utente);
     w_testo_finale := replace(w_testo_finale, '<PROVINCIA>', w_provincia_utente);
     w_testo_finale := replace(w_testo_finale, '<DES_TIPO_ATTO>', w_tipo_atto);
     w_testo_finale := replace(w_testo_finale, '<ATTO>', a_atto);
     w_testo_finale := replace(w_testo_finale, '<PARTE_SERIE>', w_parte_serie);        
     w_testo_finale := replace(w_testo_finale, '<ANNO>', a_anno);
     w_testo_finale := replace(w_testo_finale, '<COMUNE_FIRMA>', w_comune_firma);
     w_testo_finale := replace(w_testo_finale, '<DATA>', w_data);
     w_testo_finale := replace(w_testo_finale, '<TERMINALISTA>', w_terminalista);

     if instr(w_testo_finale,'<FIRME_CHIUSURA>') > 0 then
        w_firme_chiusura := replace(ltrim(f_CIV_firme_chiusura_CIA(a_tipo_atto,a_ufficio,a_anno,a_parte,a_serie,a_atto,a_natura),'f.to '),'f.to','/');
        w_testo_finale := replace(w_testo_finale, '<FIRME_CHIUSURA>', w_firme_chiusura);    
     end if;
  end if;
              
  return w_testo_finale;
                
end;
/
