--liquibase formatted sql
--changeset amonopoli:202606101435_11 runOnChange:true stripComments:false
create or replace procedure ANAMOV_FI
(a_matricola		IN	number
,a_cod_mov		IN	number
,a_cod_eve		IN	number
,a_cod_variazione	IN	varchar2
,a_data_eve		IN	number
,a_data_reg		IN	number
,a_cod_pro_eve		IN	number
,a_cod_com_eve		IN	number
,a_cod_pro_iscr_aire	IN	number
,a_cod_com_iscr_aire	IN	number
,a_nazionalita_prec	IN	varchar2
,a_nazionalita		IN	varchar2
,a_cognome_nome_prec	IN	varchar2
,a_cognome_nome		IN	varchar2
,a_sesso_prec		IN	varchar2
,a_sesso		IN	varchar2
,a_annullamento		IN	varchar2
,a_elettorale		IN OUT 	varchar2
,a_cod_via_new		IN	number
,a_num_civ_new		IN	number
,a_suffisso_new		IN	varchar2
,a_interno_new		IN	number
,a_sub_interno_new	IN	varchar2
,a_scala_new		IN	varchar2
,a_piano_new		IN	varchar2
,a_via_aire_new		IN	varchar2
,a_cod_pro_aire_new	IN	number
,a_cod_com_aire_new	IN	number
,a_zipcode_new		IN	varchar2
,a_anno_pratica		IN	number
,a_pratica		IN	number
,a_nucleo_arrivo	IN	number
,a_cod_fam		IN	number
,a_intestatario		IN	varchar2
)

IS

w_matricola			number := a_matricola;
w_cod_mov			number := a_cod_mov;
w_cod_eve			number := a_cod_eve;
w_cod_variazione		varchar2(255) := a_cod_variazione;
w_data_eve			number := a_data_eve;
w_data_reg  			number := a_data_reg;
w_cod_pro_eve			number := a_cod_pro_eve;
w_cod_com_eve			number := a_cod_com_eve;
w_cod_pro_iscr_aire		number := a_cod_pro_iscr_aire;
w_cod_com_iscr_aire		number := a_cod_com_iscr_aire;
w_nazionalita_prec		varchar2(255) := a_nazionalita_prec;
w_nazionalita     		varchar2(255) := a_nazionalita;
w_cognome_nome_prec		varchar2(255) := a_cognome_nome_prec;
w_cognome_nome     		varchar2(255) := a_cognome_nome;
w_sesso_prec			varchar2(255) := a_sesso_prec;
w_sesso       	 	 	varchar2(255) := a_sesso;
w_annullamento       	 	varchar2(255) := a_annullamento;
w_elettorale       	 	varchar2(255) := a_elettorale;

w_motivo			number := null;
w_tipo_movimento		varchar2(255) := null;
w_elettore			varchar2(255);
w_data_nas			number;
w_iscr_aire			varchar2(255);

w_semestre			number := null;
w_data_inizio_semestre		number := null;
w_data_fine_semestre		number := null;

w_errore			varchar2(4000);
errore				exception;

w_controllo			number;

begin
--
-- 18/06/2010 (AM) prima emissione
-- 19/07/2018 (AM) sistemato controllo su tipo_movimento 'E' nel caso di immi di soggetto con elettore = 'SI'
-- 19/01/2024 (AM) gestito aggiornamento del motivo nel caso di perfezionamento iscrizione, su movimento di preliminare ancora presente in ELEMOV
--

  if w_elettorale is null and w_annullamento is null then

<< SEL_ANAMOV >>
     begin
       select decode(dmo.cod_mo, 8,
	    	    decode(w_nazionalita, 'I',
	 	      decode(w_nazionalita_prec, 'I', dmo.cod_mo, 3),
	              13),
		    dmo.cod_mo),
		  decode(dmo.cod_mo, 8,
		    decode(w_nazionalita, 'I',
		      decode(w_nazionalita_prec, 'I', dmo.tipo_movimento, 'I'),
		      'C'),
		    dmo.tipo_movimento),
		  decode(dmo.tipo_movimento, 'E', to_number(null), w_cod_pro_eve),
		  decode(dmo.tipo_movimento, 'E', to_number(null), w_cod_com_eve),
		  decode(ele.stato,'E','SI','NO'),
		  decode(dmo.tipo_movimento, 'E', to_char(null),
                to_char(w_cod_pro_iscr_aire)||to_char(w_cod_com_iscr_aire)),
		  ana.data_nas
         into w_motivo, w_tipo_movimento, w_cod_pro_eve, w_cod_com_eve,
              w_elettore, w_iscr_aire, w_data_nas
   	   from anadce dce, eledmo dmo, eleana ele, anaana ana
        where dmo.cod_mo                  = dce.motivo_ele
	    and dce.cod_mov                 = w_cod_mov
	    and dce.cod_eve                 = w_cod_eve
	    and nvl(dce.cod_variazione,' ') = nvl(w_cod_variazione,' ')
	    and dce.flag_ele                = 'S'
	    and ele.matricola (+)           = ana.matricola
	    and ana.matricola               = w_matricola
	    and ((dmo.tipo_movimento in ('I','C') and w_nazionalita = 'I')
		   or
		   (dmo.tipo_movimento = 'C' and dce.anagrafe = 'AIR')
		   or
		   (dmo.tipo_movimento = 'E' and dce.tipo_evento in ('I','C','E'))
		   or
		   (dmo.tipo_movimento = 'E' and dce.tipo_evento = 'R' and 'I' in (w_nazionalita, w_nazionalita_prec) and
		    (nvl(w_cognome_nome_prec,' ') != nvl(w_cognome_nome,' ')
		     or nvl(w_sesso_prec,' ') 	 != nvl(w_sesso,' ')
		     or nvl(w_nazionalita_prec,' ')  != nvl(w_nazionalita,' ')
		     or w_cod_eve 			 = 98)))
       ;
     exception
       when others then
            w_motivo 	     := null;
   	      w_tipo_movimento := null;
     end; 
  end if;

  if w_motivo is not null and w_tipo_movimento is not null then
<< DETERMINA_SEMESTRE_DATE_SEM >>
     begin
       select decode(sign(to_char(sysdate,'mm') - 6),1,2,1)
         into w_semestre
         from dual
       ;
       select to_char(to_date(decode(w_semestre,1,'1/7/','1/1/')||
                    decode(w_semestre,1,to_number(to_char(sysdate,'yyyy') - 18),
                                        to_number(to_char(sysdate,'yyyy') - 17)),
                'dd/mm/yyyy'),'j'),
              to_char(to_date(decode(w_semestre,1,'31/12/','30/6/')||
                    decode(w_semestre,1,to_number(to_char(sysdate,'yyyy') - 18),
                                        to_number(to_char(sysdate,'yyyy') - 17)),
                'dd/mm/yyyy'),'j')
         into w_data_inizio_semestre, w_data_fine_semestre
         from dual
        where w_semestre is not null
       ;
     exception
       when others then
            w_semestre             := null;
            w_data_inizio_semestre := null;
            w_data_fine_semestre   := null;
     end;

<< TR_ANAMOV >>
--RAISE_APPLICATION_ERROR(-20999,'matricola: '||w_matricola||' - tipo_movimento: '||w_tipo_movimento||' - motivo: '||w_motivo||' - elettore: '||w_elettore);
     if w_tipo_movimento = 'C' then goto CANCELLAZIONI; end if;
     if w_tipo_movimento = 'E' then goto ISCRIZIONI_CANCELLAZIONI; end if;

<< ISCRIZIONI >>
--RAISE_APPLICATION_ERROR(-20999,'matricola: '||w_matricola||' - iscrizione');
-- dbms_output.put_line ('tratta_iscr'||eleemel.matricola||' '||eleemel.motivo);
     if w_data_nas >= nvl(w_data_inizio_semestre,0) then goto FINE; end if;
     if w_elettore = 'SI' then goto ELETTORE; end if;
     goto INS_MOV;

<< ELETTORE >>
     begin
       delete from elemov
        where matricola    = a_matricola
          and ((nvl(revisione,'FR') = 'FR' and flag_trattato is null)
               or (nvl(revisione,'FR') != 'FR' and sospensione = 'SI'))
--               or (nvl(revisione,'FR') != 'FR' and sospensione is null and flag_trattato is null))
       ;
     exception  
       when others then
            w_errore := 'Errore in eliminazione Movimento - '||w_tipo_movimento||' ('||SQLERRM||')';
            raise errore;
     end;

     goto INS_MOV_CAMBIO_IND;

<< CANCELLAZIONI >>
--RAISE_APPLICATION_ERROR(-20999,'matricola: '||w_matricola||' - cancellazione');
-- dbms_output.put_line ('tratta_canc'||eleemel.matricola||' '||eleemel.motivo);
     begin
       delete from elemov
        where matricola    = a_matricola
          and ((nvl(revisione,'FR') = 'FR' and flag_trattato is null)
               or (nvl(revisione,'FR') != 'FR' and sospensione = 'SI'))
--               or (nvl(revisione,'FR') != 'FR' and sospensione is null and flag_trattato is null))
       ;
     exception  
       when others then
            w_errore := 'Errore in eliminazione Movimento - '||w_tipo_movimento||' ('||SQLERRM||')';
            raise errore;
     end;

     if w_elettore = 'NO' then goto FINE; end if;
     goto INS_MOV;

<< ISCRIZIONI_CANCELLAZIONI >>
-- dbms_output.put_line ('tratta_iscr_canc'||eleemel.matricola||' '||eleemel.motivo);
    if w_elettore = 'NO' then goto FINE; end if;
    if w_motivo = 9 then goto INS_MOV_CAMBIO_IND; else goto INS_MOV; end if;
    goto FINE; 

<< INS_MOV >>
--RAISE_APPLICATION_ERROR(-20999,'matricola: '||w_matricola||' - ins_mov');
     begin
       insert into elemov 
             (matricola, motivo, tipo_movimento, cod_pro_eve, cod_com_eve, data_eve, revisione)
       select w_matricola, w_motivo, w_tipo_movimento,
              decode(w_iscr_aire,'',w_cod_pro_eve,w_cod_pro_iscr_aire),
              decode(w_iscr_aire,'',w_cod_com_eve,w_cod_com_iscr_aire),
              w_data_eve, 'FR'
         from dual
        where not exists (select 'x'
                            from elemov
                           where matricola      = w_matricola
                             and tipo_movimento = w_tipo_movimento)
       ;
       if SQL%found then
          a_elettorale := 'SI';
       else
          begin
            update elemov 
               set motivo = motivo
             where matricola      = w_matricola
               and tipo_movimento = w_tipo_movimento
               and motivo         = 22
               and ((nvl(revisione,'FR') = 'FR' and flag_trattato is null)
                    or (nvl(revisione,'FR') != 'FR' and sospensione = 'SI'))
            ;
          exception
            when others then
                 null;
          end;
          if SQL%found then
             a_elettorale := 'SI';
          else
             a_elettorale := '';
          end if;
       end if;
     exception
       when others then
            w_errore := 'Errore in inserimento Movimento - '||w_tipo_movimento||' ('||SQLERRM||')';
            raise errore;
     end;

     goto FINE;

<< INS_MOV_CAMBIO_IND >>
--RAISE_APPLICATION_ERROR(-20999,'matricola: '||w_matricola||' - ins_mov_cambio_ind');
     begin
       insert into elemov 
             (matricola, tipo_movimento, motivo, data_eve, revisione)
       select w_matricola, 'E', 9, w_data_eve, 'FR'
         from eleana ele, anaana ana
        where (nvl(a_cod_via_new,0)          != nvl(ele.cod_via_ele,0)              
               or nvl(a_num_civ_new,0)       != nvl(ele.num_civ_ele,0)        
               or nvl(a_suffisso_new,' ')    != nvl(ele.suffisso_ele,' ')    
               or nvl(a_interno_new,0)       != nvl(ele.interno_ele,0)       
               or nvl(a_sub_interno_new,' ') != nvl(ele.sub_interno_ele,' ') 
               or nvl(a_scala_new,' ')       != nvl(ele.scala_ele,' ')       
               or nvl(a_piano_new,' ')       != nvl(ele.piano_ele,' ')       
               or nvl(a_via_aire_new,' ')    != nvl(ele.via_aire_ele,' ')    
               or nvl(a_cod_pro_aire_new,0)  != nvl(ele.cod_pro_aire_ele,0)  
               or nvl(a_cod_com_aire_new,0)  != nvl(ele.cod_com_aire_ele,0)  
               or nvl(a_zipcode_new,' ')	 != nvl(ele.zipcode_ele,' '))
          and ele.matricola   = ana.matricola
          and ana.matricola   = w_matricola
          and not exists (select 'x'
                            from elemov
                           where matricola      = w_matricola
                             and tipo_movimento = 'E')
       ;
       if SQL%found then
          a_elettorale := 'SI';
       else
--RAISE_APPLICATION_ERROR(-20999,'matricola: '||w_matricola||' - tipo_movimento: '||w_tipo_movimento||' - motivo: '||w_motivo||' - elettore: '||w_elettore||' - data_eve '||w_data_eve);
          a_elettorale := '';
       end if;
--RAISE_APPLICATION_ERROR(-20999,'matricola: '||w_matricola||' - ins_mov_cambio_ind - inserito');
     exception
       when others then
            w_errore := 'Errore in inserimento Movimento di Cambio Indirizzo ('||SQLERRM||')';
            raise errore;
     end;
     
     goto FINE;

<< FINE >>
      null;
  end if;

  if INSERTING then
     if a_cod_mov = 1 and a_cod_eve = 17 and a_nucleo_arrivo = 1 then
         begin
           update anaap4
              set cod_fam_dest      = a_cod_fam,
                  presso		= a_intestatario,
                  flag_aggregazione = 'S'
            where flag_aggregazione is null
              and anno_dic		= a_anno_pratica
              and numero_dic		= a_pratica
           ;
         exception
           when others then
                raise_application_error(-20999, 'Errore in aggiornamento FLAG_AGGREGAZIONE ('||SQLCODE||')');
         end;
      end if;
  end if;

exception
  when errore then
       raise_application_error(-20999, w_errore);
  when others then
       raise_application_error(-20999, 'Errore ('||SQLERRM||')');
end;
/
