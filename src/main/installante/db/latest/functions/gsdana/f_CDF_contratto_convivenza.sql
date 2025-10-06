--liquibase formatted sql
--changeset amonopoli:202503171200 runOnChange:true stripComments:false
create or replace function f_CDF_contratto_convivenza
(a_matricola	in	number
,a_data_rif	in	number 	default NULL
)
 
return varchar

is

w_data_rif		number;

w_cognome_nome		varchar2(255);
w_sesso			varchar2(255);
w_cognome_nome_cv	varchar2(255);
w_sesso_cv		varchar2(255);

w_testo		varchar2(4000);

cursor sel_doc is
select doc.*
     , den.descrizione des_ente_emissione
     , com.descrizione des_com_ente
     , den_agg.descrizione des_ente_agg
     , com_agg.descrizione des_com_ente_agg
  from arccom com
     , arccom com_agg
     , anaddo ddo
     , anaden den
     , anaden den_agg
     , anadoc doc
 where com.cod_provincia     (+) = doc.cod_pro_ente
   and com.cod_comune        (+) = doc.cod_Com_ente
   and com_agg.cod_provincia (+) = doc.cod_pro_ente_agg
   and com_agg.cod_comune    (+) = doc.cod_com_ente_agg
   and nvl(ddo.flag_cdf,' ')	= 'S'
   and ddo.cod_do	 	= doc.tipo_documento
   and den.cod_en 	(+)	= doc.ente_emissione
   and den_agg.cod_en	(+)	= doc.ente_agg
   and doc.progr_documento	= 1
   and doc.natura_documento	= 'O'
   and w_data_rif 		between doc.data_emissione and nvl(doc.data_scadenza,9999999)
   and doc.matricola            = a_matricola
   and rownum = 1
;

begin
  if a_data_rif is null then
     w_data_rif := to_char(sysdate,'j');
  else
     w_data_rif := a_data_rif;
  end if;

  begin
    select translate(ana.cognome_nome,'/',' ')
         , ana.sesso
         , translate(ana_cv.cognome_nome,'/',' ')
         , ana_cv.sesso
      into w_cognome_nome
         , w_sesso
         , w_cognome_nome_cv
         , w_sesso_cv
      from anaana ana_cv, anaana ana, anacdf cdf
     where ana_cv.matricola (+) = cdf.matricola_cv
       and ana.matricola 	= cdf.matricola
       and w_data_rif 		between cdf.data_inizio and nvl(cdf.data_fine,9999999)
       and cdf.data_inizio	is not null
       and cdf.matricola        = a_matricola
    ;
  exception
    when others then
--         w_testo    := 'sel_ana ('||sqlerrm||')';
         w_testo := '';
  end;
 
     for rec in sel_doc loop
         w_testo := 'Con atto N. '||rec.numero;
         w_testo := w_testo||', in data '||to_char(to_date(rec.data_emissione,'j'),'dd/mm/yyyy')||',';

         if rec.des_ente_emissione like '%AVV%' then
            w_testo := w_testo||' dell''Avvocato '||rec.autore_emissione;
            if rec.des_com_ente_agg is not null then
               w_testo := w_testo||' iscritto all''Ordine di '||rec.des_com_ente_agg;
            end if;

         elsif rec.des_ente_emissione like '%NOTA%'then
            w_testo := w_testo||' depositato presso il Notaio '||rec.autore_emissione;
            if rec.des_com_ente_agg is not null then
               w_testo :=  w_testo||' del Distretto Notarile di '||rec.des_com_ente_agg;
            end if;
         end if;

         w_testo := w_testo||', i conviventi di fatto';
         if w_sesso = 'M' then
            w_testo := w_testo||' Sig. '||w_cognome_nome;
         elsif w_sesso = 'F' then
            w_testo := w_testo||' Sig.ra '||w_cognome_nome;
         end if;

         if w_sesso_cv = 'M' then
            w_testo := w_testo||' e Sig. '||w_cognome_nome_cv;
         elsif w_sesso_cv = 'F' then
            w_testo := w_testo||' e Sig.ra '||w_cognome_nome_cv;
         end if;

         w_testo := w_testo||' hanno disciplinato i propri rapporti patrimoniali sottoscrivendo contratto di convivenza ';
         w_testo := w_testo||' ai sensi dell''art. 1 comma 50 e seguenti della legge 20 maggio 2016, n. 76.';

     end loop;

  return w_testo;      

exception
  when others then
--       w_testo := 'errore ('||sqlerrm||')';
       w_testo := '';
       return w_testo;
end;
/
