--liquibase formatted sql
--changeset amonopoli:202503171430 runOnChange:true stripComments:false
create or replace function f_get_campo_COM
(a_cod_provincia	number
,a_cod_comune      	number
,a_descrizione      	varchar2
,a_flag_italiano      	varchar2
,a_flag_estero      	varchar2
,a_flag_attivo      	varchar2
,a_data_rif_j      	number
,a_campo         	varchar2
)

RETURN varchar

IS

w_sigla          	varchar2(255);
w_descrizione      	varchar2(255);
w_sigla_provincia      	varchar2(255);
w_campo         	varchar2(255);
w_errore         	varchar2(255);
errore         		exception;

begin
--
-- campi gestiti:
-- . 'CODICE_COMUNE'
-- . 'COD_PROVINCIA'
-- . 'COD_COMUNE'
-- . 'DESCRIZIONE'
-- . 'SIGLA_PROVINCIA'
-- . 'CAP'
-- . 'TRIBNALE'
-- . 'CODICE_CATASTO'
-- . 'CODICE_CONSOLATO'
-- . 'COD_CONSOLATO'
-- . 'TIPO_CONSOLATO'
-- . 'CEE'
-- . 'COD_TERRITORIO'
-- . 'DATA_SOPPRESSIONE'
-- . 'CODICE_COMUNE_FUSIONE'
-- . 'COD_PRO_FUSIONE'
-- . 'COD_COM_FUSIONE'
--
  if a_cod_provincia is not null and a_cod_comune is not null then
     w_descrizione   := '';
     w_sigla_provincia   := '';
     begin
       select decode(a_campo,
                'CODICE_COMUNE',lpad(com.cod_provincia,3,'0')||lpad(com.cod_comune,3,'0'),
                'COD_PROVINCIA',lpad(com.cod_provincia,3,'0'),
                'COD_COMUNE',lpad(com.cod_comune,3,'0'),
                'DESCRIZIONE',com.descrizione,
                'SIGLA_PROVINCIA',com.sigla_provincia,
                'CAP',lpad(com.cap,5,'0'),
                'TRIBUNALE',lpad(com.tribunale,6,'0'),
                'CODICE_CATASTO',com.codice_catasto,
                'CODICE_CONSOLATO',com.cod_consolato||lpad(com.tipo_consolato,2,'0'),
                'COD_CONSOLATO',com.cod_consolato,
                'TIPO_CONSOLATO',lpad(com.tipo_consolato,2,'0'),
                'INDIRIZZO_CONSOLATO',con.indirizzo,
                'SEDE_CONSOLATO',con.sede,
                'CEE',com.cee,
                'COD_TERRITORIO',com.cod_territorio,
                'DATA_SOPPRESSIONE', to_char(com.data_soppressione),
                'CODICE_COMUNE_FUSIONE', lpad(com.cod_pro_fusione,3,'0')||lpad(com.cod_com_fusione,3,'0'),
                'COD_PRO_FUSIONE', lpad(com.cod_pro_fusione,3,'0'),
                'COD_COM_FUSIONE', lpad(com.cod_com_fusione,3,'0')
              )
         into w_campo
         from arccon con, arccom com
        where con.cod_consolato  (+) = com.cod_consolato
          and con.tipo_consolato (+) = com.tipo_consolato
          and con.stato          (+) = nvl(com.cod_territorio,com.cod_provincia)
          and com.cod_provincia      = a_cod_provincia
          and com.cod_comune         = a_cod_comune
       ;
     exception
       when no_data_found then
--            w_campo := 'no rows';
            raise errore;
       when too_many_rows then
--            w_campo := 'too many';
            raise errore;
       when others then
--            w_campo := SQLERRM;
            raise errore;
     end;
  else
     if a_descrizione like '%(%)%' then
        w_sigla   := ltrim(substr(a_descrizione,instr(a_descrizione,'(')+1));
        w_sigla   := rtrim(substr(w_sigla,1,instr(w_sigla,')')-1));
        if length(w_sigla) > 3 then
           w_descrizione      := a_descrizione;
           w_sigla_provincia   := '';
        else
           w_descrizione      := rtrim(substr(a_descrizione,1,instr(a_descrizione,'(')-1));
           w_sigla_provincia   := w_sigla;
        end if;
     else
        w_descrizione   := a_descrizione;
        w_sigla_provincia   := '';
     end if;
--dbms_output.put_line('w_descrizione: '||w_descrizione);
--dbms_output.put_line('w_sigla_provincia: '||w_sigla_provincia);
     begin
       select decode(a_campo,
                'CODICE_COMUNE',lpad(com.cod_provincia,3,'0')||lpad(com.cod_comune,3,'0'),
                'COD_PROVINCIA',lpad(com.cod_provincia,3,'0'),
                'COD_COMUNE',lpad(com.cod_comune,3,'0'),
                'DESCRIZIONE',com.descrizione,
                'SIGLA_PROVINCIA',com.sigla_provincia,
                'CAP',lpad(com.cap,5,'0'),
                'TRIBUNALE',lpad(com.tribunale,6,'0'),
                'CODICE_CATASTO',com.codice_catasto,
                'CODICE_CONSOLATO',com.cod_consolato||lpad(com.tipo_consolato,2,'0'),
                'COD_CONSOLATO',com.cod_consolato,
                'TIPO_CONSOLATO',lpad(com.tipo_consolato,2,'0'),
                'CEE',com.cee,
                'COD_TERRITORIO',com.cod_territorio,
                'DATA_SOPPRESSIONE', to_char(com.data_soppressione),
                'CODICE_COMUNE_FUSIONE', lpad(com.cod_pro_fusione,3,'0')||lpad(com.cod_com_fusione,3,'0'),
                'COD_PRO_FUSIONE', lpad(com.cod_pro_fusione,3,'0'),
                'COD_COM_FUSIONE', lpad(com.cod_com_fusione,3,'0')
              )
         into w_campo
         from arccom com
        where com.descrizione          = w_descrizione
          and nvl(com.sigla_provincia,' ') = nvl(nvl(w_sigla_provincia,com.sigla_provincia),' ')
          and ((com.cod_provincia < 198 and a_flag_italiano = 'S')
               or
               (com.cod_provincia > 200 and a_flag_estero = 'S')
               or
               (a_flag_italiano is null and a_flag_estero is null)
              )
          and ((com.data_soppressione is null
                and com.cod_pro_fusione is null
                and com.cod_com_fusione is null
                and a_flag_attivo = 'S')
               or
                a_flag_attivo is null)
       ;
     exception
       when no_data_found then
--            w_campo := 'no rows';
            raise errore;
       when too_many_rows then
--            w_campo := 'too many';
            raise errore;
       when others then
--            w_campo := SQLERRM;
            raise errore;
     end;
  end if;
  RETURN w_campo;
exception
  when errore then
       w_errore := 'Errore in ricerca Comuni ('||SQLERRM||')';
       RETURN w_campo;
  when others then
--       w_campo := SQLERRM;
       w_errore := 'Errore ('||SQLERRM||')';
       RETURN w_campo;
end;
/
