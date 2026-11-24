--liquibase formatted sql
--changeset amonopoli:202602131420 runOnChange:true stripComments:false
create or replace function f_LGAA_aggiorna_tabrep
(a_tipo_lista		IN	varchar2
,a_da_progr		IN	number
,a_a_progr	 	IN	number
,a_stampa_chiusura	IN	varchar2
,a_tipo_firma		IN	varchar2
,a_verbale		IN	varchar2	-- n.ro verbale CEC (timbro GEN-1-1 / GEN-1-2)
,a_data_verbale		IN	varchar2	-- data verbale CEC (timbro GEN-1-1 / GEN-1-2)
,a_anno_elezioni	IN	number
,a_progr_elezioni	IN	number
,a_data_elezioni	IN	varchar2
,a_verbale1_3		IN	varchar2	-- n.ro verbale x timbro CEC - blocco liste (GEN-1-3)
,a_data_verbale1_3	IN	varchar2	-- data verbale x timbro CEC - blocco liste (GEN-1-3)
,a_verbale2_1		IN	varchar2	-- n.ro verbale x timbro CECir - nuove sez (GEN-2-1)
,a_data_verbale2_1	IN	varchar2	-- data verbale x timbro CECir - nuove sez (GEN-2-1)
,a_verbale2_2		IN	varchar2	-- n.ro verbale x timbro CECir - rettifiche semestrale (GEN-2-2)
,a_data_verbale2_2	IN	varchar2	-- data verbale x timbro CECir - rettifiche semestrale (GEN-2-2)
,a_data_verbale2_3	IN	varchar2	-- data verbale x timbro CECir - blocco liste (timbro GEN-2-3)
,a_timbro1_1		IN	varchar2	-- timbro CEC - autentica nuove sez (GEN-1-1)
,a_timbro1_2		IN	varchar2	-- timbro CEC - autentica semestrale (GEN-1-2)
,a_timbro1_3		IN	varchar2	-- timbro CEC - autentica blocco liste (GEN-1-3)
,a_timbro2_1		IN	varchar2	-- timbro CECir - autentica nuove sez (GEN-2-1)
,a_timbro2_2		IN	varchar2	-- timbro CECir - autentica semestrale (GEN-2-2)
,a_timbro2_3		IN	varchar2	-- timbro CECir - autentica blocco liste (GEN-2-3)
)
	
return number
 
IS

w_sesso			varchar2(255) := 'X';
w_salto_p		varchar2(255) := 'S';

w_data_verbale_j	number := to_char(to_date(a_data_verbale,'yyyy-mm-dd'),'j');
w_data_elezioni_j	number := to_char(to_date(a_data_elezioni,'yyyy-mm-dd'),'j');
w_data_verbale1_3_j	number := to_char(to_date(a_data_verbale1_3,'yyyy-mm-dd'),'j');
w_data_verbale2_1_j	number := to_char(to_date(a_data_verbale2_1,'yyyy-mm-dd'),'j');
w_data_verbale2_2_j	number := to_char(to_date(a_data_verbale2_2,'yyyy-mm-dd'),'j');
w_data_verbale2_3_j	number := to_char(to_date(a_data_verbale2_3,'yyyy-mm-dd'),'j');


w_chiave		varchar2(255) := 'LGAA';
w_terminale		varchar2(255) := 'ELEGAA3';
w_parametri		varchar2(2000);

w_return		number := 0;

begin
  
  w_parametri := a_tipo_lista||
                 w_sesso||
                 lpad(nvl(a_da_progr,0),6,'0')||
                 lpad(nvl(a_a_progr,999999),6,'0')||
                 nvl(a_stampa_chiusura,'N')||
                 rpad(nvl(a_verbale,' '),10,' ')||
                 lpad(nvl(w_data_verbale_j,0),7,'0')||
                 lpad(nvl(a_anno_elezioni,0),4,'0')||
                 lpad(nvl(a_progr_elezioni,0),2,'0')||
                 lpad(nvl(w_data_elezioni_j,0),7,'0')||
                 nvl(a_timbro1_1,'N')||
                 nvl(a_timbro1_2,'N')||
                 nvl(a_timbro1_3,'N')||
                 nvl(a_timbro2_1,'N')||
                 nvl(a_timbro2_2,'N')||
                 nvl(a_timbro2_3,'N')||
                 nvl(w_salto_p,'N')||
                 rpad(nvl(a_verbale2_1,' '),10,' ')||
                 lpad(nvl(w_data_verbale2_1_j,0),7,'0')||
                 rpad(nvl(a_verbale2_2,' '),10,' ')||
                 lpad(nvl(w_data_verbale2_2_j,0),7,'0')||
                 a_tipo_firma||
                 lpad(nvl(w_data_verbale2_3_j,0),7,'0')||
                 rpad(nvl(a_verbale1_3,' '),10,' ')||
                 lpad(nvl(w_data_verbale1_3_j,0),7,'0');

  begin
    insert into tabrep (chiave, parametri, terminale)
    select w_chiave, w_parametri, w_terminale
      from dual
     where not exists (select 1 from tabrep b
                        where chiave    = w_chiave
                          and terminale = w_terminale)
    ;
    w_return := 1;
    if sql%notfound then
       w_return := 0;
       begin
         update tabrep
            set parametri = w_parametri
          where chiave    = w_chiave
            and terminale = w_terminale
         ;
         w_return := 1;
       exception
         when others then
              w_return := -1;
       end;
    end if;
  exception
    when others then
         w_return := -1;
  end;

  return w_return;

end;
/
