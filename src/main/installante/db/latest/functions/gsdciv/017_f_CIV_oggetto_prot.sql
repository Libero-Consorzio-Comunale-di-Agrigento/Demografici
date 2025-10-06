--liquibase formatted sql
--changeset amonopoli:202310260815_1 runOnChange:true stripComments:false
create or replace function f_CIV_oggetto_PROT
(a_codice_co		IN 	number
,a_tipo_atto		IN	number
,a_ufficio		IN   	number
,a_anno			IN	number
,a_parte		IN 	number
,a_serie		IN	varchar2
,a_atto    		IN	number
,a_formula		IN	varchar2
)

return varchar2

IS

w_oggetto                  varchar2(255);

w_numero_atto_ansc         varchar2(255);

errore                     exception;
w_errore                   varchar2(4000);

w_operazione_log		varchar2(255) := 'f_CIV_oggetto_PROT';

begin
  if a_codice_co is null then
     goto fine;
  end if;
 
<< oggetto_v1 >>
  begin
    select dco.descrizione
      into w_oggetto
      from civdco dco
     where dco.codice_co = a_codice_co
    ;
  exception
    when others then
         w_oggetto := ''; 
  end;

  goto fine;

<< oggetto_v0 >>
  w_numero_atto_ansc := f_CIV_get_numero_atto_ansc(a_tipo_atto,a_ufficio,a_anno,a_parte,a_serie,a_atto);

  if w_numero_atto_ansc is not null then
     begin
       select dco.descrizione||' - '||
              decode(a_formula, '', 
                   decode(a_tipo_atto, 
                  1, 'Atti di Cittadinanza: N. '||w_numero_atto_ansc,
                  2, 'Atti di Nascita: N. '||w_numero_atto_ansc,
                  3, 'Pubblicazioni di Matrimonio: verbale N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno,
                  4, 'Atti di Matrimonio: N. '||w_numero_atto_ansc,
                 -4, 'Atti di Unione Civile: N. '||w_numero_atto_ansc,
                  5, 'Atti di Morte: N. '||w_numero_atto_ansc),
                'Formula '||decode(substr(a_formula,1,1),'5','1'||substr(a_formula,2),a_formula)||
                  decode(a_tipo_atto, 
                    1, ' (su Atto di Cittadinanza N. '||w_numero_atto_ansc||')',
                    2, ' (su Atto di Nascita N. '||w_numero_atto_ansc||')',
                    4, ' (su Atto di Matrimonio N. '||w_numero_atto_ansc||')',
                   -4, ' (su Atto di Unione Civile N. '||w_numero_atto_ansc||')',
                    5, ' (su Atto di Morte N. '||w_numero_atto_ansc||')',
                    6, ' (su Atto di Nascita, generata da Atto di Cittadinanza N. '||w_numero_atto_ansc||')',
                    7, ' (su Atto di Nascita, generata da Atto di Matrimonio N. '||w_numero_atto_ansc||')',
                   -7, ' (su Atto di Nascita, generata da Atto di Unione Civile N. '||w_numero_atto_ansc||')',
                    8, ' (su Atto di Nascita, generata da Atto di Morte N. '||w_numero_atto_ansc||')',
                    9, ' (su Atto di Matrimonio, generata da Atto di Separazioni / Scioglimento di Matrimonio N. '||w_numero_atto_ansc||')',
                   -9, ' (su Atto di Unione Civile, generata da Cessazione / Scioglimento di Unione Civile N. '||w_numero_atto_ansc||')'))                     
         into w_oggetto
         from civdco dco
        where dco.codice_co = a_codice_co
       ;
     exception
       when others then
            w_oggetto := ''; 
            w_errore  := 'Errore in decodifica comunicazione - '||a_codice_co||' ('||sqlerrm||')';
            raise errore;
     end;

  else
     begin
       select dco.descrizione||' - '||
              decode(a_formula, '', 
                   decode(a_tipo_atto, 
                  1, 'Atti di Cittadinanza: N. '||a_atto||' uff.'||a_ufficio||' Anno '||a_anno,
                  2, 'Atti di Nascita: N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno,
                  3, 'Pubblicazioni di Matrimonio: verbale N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno,
                  4, 'Atti di Matrimonio: N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno,
                 -4, 'Atti di Unione Civile: N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno,
                  5, 'Atti di Morte: N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno),
                'Formula '||decode(substr(a_formula,1,1),'5','1'||substr(a_formula,2),a_formula)||
                  decode(a_tipo_atto, 
                    1, ' (su Atto di Cittadinanza N. '||a_atto||' uff.'||a_ufficio||' Anno '||a_anno||')',
                    2, ' (su Atto di Nascita N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno||')',
                    4, ' (su Atto di Matrimonio N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno||')',
                   -4, ' (su Atto di Unione Civile N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno||')',
                    5, ' (su Atto di Morte N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno||')',
                    6, ' (su Atto di Nascita, generata da Atto di Cittadinanza N. '||a_atto||' uff.'||a_ufficio||' Anno '||a_anno||')',
                    7, ' (su Atto di Nascita, generata da Atto di Matrimonio N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno||')',
                   -7, ' (su Atto di Nascita, generata da Atto di Unione Civile N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno||')',
                    8, ' (su Atto di Nascita, generata da Atto di Morte N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno||')',
                    9, ' (su Atto di Matrimonio, generata da Atto di Separazioni / Scioglimento di Matrimonio N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno||')',
                   -9, ' (su Atto di Unione Civile, generata da Cessazione / Scioglimento di Unione Civile N. '||a_atto||decode(a_parte,'','',' p.'||a_parte)||decode(a_serie,'','',' s.'||a_serie)||' uff.'||a_ufficio||' Anno '||a_anno||')'))                     
         into w_oggetto
         from civdco dco
        where dco.codice_co = a_codice_co
       ;
     exception
       when others then
            w_oggetto := ''; 
            w_errore  := 'Errore in decodifica comunicazione - '||a_codice_co||' ('||sqlerrm||')';
            raise errore;
     end;
  end if;

<< fine >>
null;
  
  return w_oggetto;
        
exception
  when errore then
       return null;
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       return null;
end;
/
