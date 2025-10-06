--liquibase formatted sql
--changeset amonopoli:202503050920 runOnChange:true stripComments:false
create or replace function f_des_stato_x_storico_fam
(a_matricola 	IN  number
,a_cod_mov	IN  number
,a_cod_eve_pr	IN  number
,a_data_eve	IN  number
,a_cod_fam  	IN  number
)

return varchar2

IS

w_des_stato	varchar2(255);
w_data		varchar2(255);
w_cod_ev	number;

cursor sel_eve is
select dev.descrizione||' ('||to_char(to_date(eve.data_eve,'j'),'dd/mm/yyyy')||')' des_stato,
       ' ('||to_char(to_date(eve.data_eve,'j'),'dd/mm/yyyy')||')' data,
       dev.cod_ev
  from anadev dev, anaeve eve
 where dev.cod_ev	= decode(eve.cod_eve, 3, 3 , 90, 90, eve.cod_eve_pr)
   and eve.matricola	= a_matricola
   and eve.cod_mov	= decode(eve.cod_eve, 90, eve.cod_mov,
                            decode(a_cod_eve_pr, 4, 1, 52, 3, a_cod_mov))
   and eve.data_eve	= decode(eve.cod_eve, 90, a_data_eve,
                            decode(a_cod_mov, 1, a_data_eve, 3, a_data_eve, a_data_eve+1))
UNION
select dev.descrizione||' ('||to_char(to_date(ana.data_mor,'j'),'dd/mm/yyyy')||')',
       ' ('||to_char(to_date(ana.data_mor,'j'),'dd/mm/yyyy')||')',
       dev.cod_ev
  from anadev dev, anaana ana
 where cod_ev		= ana.stato
   and ana.stato	= 50
   and ana.data_mor	= a_data_eve+1
   and ana.matricola 	= a_matricola
UNION
select dev.descrizione||' ('||to_char(to_date(decode(ana.stato,1,ana.data_ult_eve,ana.data_nas),'j'),'dd/mm/yyyy')||')',
       ' ('||to_char(to_date(decode(ana.stato,1,ana.data_ult_eve,ana.data_nas),'j'),'dd/mm/yyyy')||')',
       dev.cod_ev
  from anadev dev, anaana ana
 where cod_ev		= a_cod_eve_pr
   and ana.matricola	= a_matricola
   and a_cod_eve_pr	= 1
   and decode(ana.stato,1,ana.data_ult_eve,ana.data_nas) = a_data_eve
order by 3
;

begin
  OPEN sel_eve;
  FETCH sel_eve INTO w_des_stato, w_data, w_cod_ev;
  CLOSE sel_eve;

  if w_des_stato is null then
     if a_cod_mov in (1,3) then
        begin
          select 'TRASFERIMENTO DA ALTRO NUCLEO'||' ('||to_char(to_date(eve.data_eve+1,'j'),'dd/mm/yyyy')||')',
                 ' ('||to_char(to_date(eve.data_eve+1,'j'),'dd/mm/yyyy')||')'
            into w_des_stato, w_data
            from anaeve eve
           where eve.matricola	= a_matricola
             and eve.cod_mov	= decode(a_cod_mov,1,10,12)
             and eve.data_eve	= a_data_eve - 1
             and eve.cod_fam 	!= a_cod_fam
             and rownum = 1
          UNION
          select 'VARIAZIONE RAPPORTO PARENTELA'||' ('||to_char(to_date(eve.data_eve+1,'j'),'dd/mm/yyyy')||')',
                 ' ('||to_char(to_date(eve.data_eve+1,'j'),'dd/mm/yyyy')||')'
            from anaeve eve
           where eve.matricola	= a_matricola
             and eve.cod_mov	= decode(a_cod_mov,1,10,12)
             and eve.data_eve	= a_data_eve - 1
             and eve.cod_fam	= a_cod_fam
             and rownum = 1
          ;
        exception
          when others then
               w_des_stato := '';
               w_data      := '';
        end;

     elsif a_cod_mov in (2,4) then
        begin
          select 'TRASFERIMENTO AD ALTRO NUCLEO'||' ('||to_char(to_date(eve.data_eve+1,'j'),'dd/mm/yyyy')||')',
                 ' ('||to_char(to_date(eve.data_eve+1,'j'),'dd/mm/yyyy')||')'
            into w_des_stato, w_data
            from anaeve eve
           where eve.matricola	= a_matricola
             and eve.cod_mov	= decode(a_cod_mov,2,10,12)
             and eve.data_eve	= a_data_eve
             and rownum = 1
          ;
        exception
          when others then
               w_des_stato := '';
               w_data      := '';
        end;
     end if;
  end if;

  if a_cod_mov = 3 and w_des_stato like 'NASCITA%' then
     w_des_stato := 'ISCRIZIONE AIRE PER NASCITA '||w_data;
  end if;

  return w_des_stato;
end;
/
create or replace view anaana_storico_x_cod_fam
AS
select eve_fam.cod_fam_unique,
       eve_fam.d_data_eve,
       ana.cognome,
       ana.nome,
       ana.rapporto_par,
       f_get_descrizione_drp(ana.rapporto_par,ana.sesso) des_rapporto_par,
       ana.sequenza_par,
       ana.d_data_nas,
       f_comune_al(ana.cod_pro_nas,ana.cod_com_nas,ana.data_nas) des_Com_nas,
       f_provincia_stato_al(ana.cod_pro_nas,ana.cod_com_nas,'','S','',ana.data_nas) sigla_pro_nas,
       ana.cod_pro_nas,
       ana.cod_com_nas,
       ana.matricola,
       ana.fascia cod_mov,
       ana.stato cod_eve,
       ana.stato cod_eve_pr,
       f_des_stato_x_storico_fam(ana.matricola,eve_fam.cod_mov,eve_fam.cod_eve_pr,eve_fam.data_eve,eve_fam.cod_fam) des_stato,
-- id
--       'ANA'||lpad(rownum,10,'0') id
       'ANA'||eve_fam.cod_fam_unique||eve_fam.data_eve||ana.matricola id
  from anaana ana, anaeve_famiglia eve_fam
 where ana.cod_fam_unique  = eve_fam.cod_fam_unique
   and ana.data_inizio_fam <= eve_fam.data_eve
UNION
select eve_fam.cod_fam_unique,
       eve_fam.d_data_eve,
       ana.cognome,
       ana.nome,
       eve.rapporto_par,
       drp.descrizione,
       drp.sequenza,
       ana.d_data_nas,
       f_comune_al(ana.cod_pro_nas,ana.cod_com_nas,ana.data_nas) des_Com_nas,
       f_provincia_stato_al(ana.cod_pro_nas,ana.cod_com_nas,'','S','',ana.data_nas) sigla_pro_nas,
       ana.cod_pro_nas,
       ana.cod_com_nas,
       ana.matricola,
       eve.cod_mov,
       eve.cod_eve,
       eve.cod_eve_pr,
       f_des_stato_x_storico_fam(eve.matricola,eve_fam.cod_mov,eve_fam.cod_eve_pr,eve_fam.data_eve,eve_fam.cod_fam),
-- id
--       'EVE'||lpad(rownum,10,'0') id
       'EVE'||eve_fam.cod_fam_unique||eve_fam.data_eve||eve.matricola id
  from anadrp drp, anaana ana, anaeve eve, anaeve_famiglia eve_fam
 where drp.cod_rp         = eve.rapporto_par
   and drp.sesso          = ana.sesso
   and ana.matricola    = eve.matricola
   and eve.cod_fam_unique = eve_fam.cod_fam_unique
   and eve_fam.data_eve   between eve.data_inizio and eve.data_eve
order by 7,8,3,4
/
comment on table anaana_storico_x_cod_fam is 'Anagrafe - Individui Storico per composizione Famiglia "alla data" (view)'
/
