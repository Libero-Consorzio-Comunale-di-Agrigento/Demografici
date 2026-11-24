--liquibase formatted sql
--changeset amonopoli:202604011215_1 runOnChange:true stripComments:false
create or replace function F_CIVICO_ESTERNO_ZK
(p_cod_via		IN	number
,p_num_civ		IN	number
,p_suffisso		IN	varchar2
,p_scala		IN	varchar2
,p_piano		IN	varchar2
,p_interno		IN	number
,p_sub_interno		IN	varchar2
,p_PROGR_SNC      	IN	varchar2
,p_NUI            	IN	varchar2
,p_COLORE         	IN	varchar2
,p_CORTE          	IN	varchar2
,p_INTERNO2       	IN	number
,p_SUB_INTERNO2   	IN	varchar2
,p_SECONDARIO     	IN	varchar2	
,p_SCALA_ESTERNA  	IN	varchar2
)

return varchar

IS

cursor sel_dnc is
select dnc.elemento, dnc.flag_esterno, dnc.flag_interno, dnc.sequenza, dnc.separatore
  from arcdnc dnc
 where dnc.flag_esterno	= 'S'
   and dnc.cod_via      = p_cod_via
UNION
select dnc.elemento, dnc.flag_esterno, dnc.flag_interno, dnc.sequenza, dnc.separatore
  from arcdnc dnc
 where dnc.flag_esterno	= 'S'
   and dnc.cod_via      is null
   and not exists (select 1 from arcdnc b
                    where b.cod_via = p_cod_via)
 order by 4 --dnc.sequenza
;

w_civico_esterno	varchar2(255);
w_unita			number;
w_suddivisione		varchar2(255);

w_adnc_civ_0            varchar2(255);

begin
 if p_cod_via is not null then
  for rec in sel_dnc loop
      if rec.elemento like 'F_UNITA%' then
-- 
-- l'elemento che richiama l'unit  territoriale, deve essere inserito nel formato
-- F_UNITA_ + il numero dell'unit  territoriale da gestire
-- es. F_UNITA_1
--
	 if translate(substr(rec.elemento,instr(rec.elemento,'_',-1)+1),'0123456789','9999999999') in ('9','99') then
	    w_unita		:= to_number(substr(rec.elemento,instr(rec.elemento,'_',-1)+1));
	    w_suddivisione	:= rtrim(substr(f_unita_territoriale(w_unita,p_cod_via,p_num_civ,p_suffisso),25));
	    if w_suddivisione is not null then
	       w_civico_esterno := w_civico_esterno||rec.separatore||w_suddivisione;
	    end if;
	 end if;

      elsif rec.elemento = 'NUM_CIV' then
         if p_num_civ is not null then 
            if p_num_civ = 0 then
               w_adnc_civ_0 := f_valore_inp('ADNC_CIV_0',1,1,'X','S');
               if nvl(w_adnc_civ_0,'N') = 'S' then
                  w_civico_esterno := w_civico_esterno||rec.separatore||p_num_civ;
               end if;
            else
               w_civico_esterno := w_civico_esterno||rec.separatore||p_num_civ;
            end if;
         end if;

      elsif rec.elemento = 'SUFFISSO' then
	 if p_suffisso is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_suffisso;
	 end if;

      elsif rec.elemento = 'PROGR_SNC' then
	 if p_progr_snc is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_progr_snc;
	 end if;

      elsif rec.elemento = 'SCALA_ESTERNA' then
	 if p_scala_esterna is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_scala_esterna;
	 end if;

      elsif rec.elemento = 'COLORE' then
	 if p_colore is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_colore;
	 end if;

      elsif rec.elemento = 'CORTE' then
	 if p_colore is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_corte;
	 end if;

      elsif rec.elemento = 'INTERNO' then
	 if p_interno is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_interno;
	 end if;

      elsif rec.elemento = 'SUB_INTERNO' then
	 if p_sub_interno is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_sub_interno;
         end if;

      elsif rec.elemento = 'SCALA' then
	 if p_scala is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_scala;
    	 end if;

      elsif rec.elemento = 'PIANO' then
   	 if p_piano is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_piano;
	 end if;

      elsif rec.elemento = 'NUI' then
   	 if p_nui is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_nui;
	 end if;

      elsif rec.elemento = 'INTERNO2' then
	 if p_interno2 is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_interno2;
	 end if;

      elsif rec.elemento = 'SUB_INTERNO2' then
	 if p_sub_interno2 is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_sub_interno2;
         end if;

      elsif rec.elemento = 'SECONDARIO' then
	 if p_secondario is not null then
	    w_civico_esterno := w_civico_esterno||rec.separatore||p_secondario;
         end if;

      end if;
  end loop;

--  w_civico_esterno := ltrim(w_civico_esterno);
  w_civico_esterno := w_civico_esterno;
 end if;

 return w_civico_esterno;
end;
/
