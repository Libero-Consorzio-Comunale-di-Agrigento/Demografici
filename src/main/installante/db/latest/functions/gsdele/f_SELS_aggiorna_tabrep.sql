--liquibase formatted sql
--changeset amonopoli:202603061500_1 runOnChange:true stripComments:false
create or replace function f_SELS_aggiorna_tabrep
(a_da_sezione		IN	number
,a_a_sezione	 	IN	number
,a_da_progr		IN	number
,a_a_progr	 	IN	number
,a_ai_seggi		IN	varchar2
,a_alfabetico		IN	varchar2
,a_storico		IN	varchar2
,a_flag_referendum	IN	varchar2
,a_flag_politiche	IN	varchar2
,a_flag_amministrative	IN	varchar2
,a_vota_solo_per	IN	varchar2
,a_filtro_lettere	IN	varchar2	-- cognomi: A = A-L / M = M-Z
,a_stampa_visto		IN	varchar2
,a_stampa_chiusura	IN	varchar2
,a_tipo_firma		IN	varchar2
,a_verbale		IN	varchar2	-- n.ro verbale CEC (SEZ-1-1 / SEZ-1-2)
,a_data_verbale		IN	varchar2	-- data verbale CEC (SEZ-1-1 / SEZ-1-2)
,a_anno_elezioni	IN	number
,a_progr_elezioni	IN	number
,a_data_elezioni	IN	varchar2
,a_verbale1_3		IN	varchar2	-- n.ro verbale x timbro CEC - blocco liste (SEZ-1-3)
,a_data_verbale1_3	IN	varchar2	-- data verbale x timbro CEC - blocco liste (SEZ-1-3)
,a_verbale2_1		IN	varchar2	-- n.ro verbale x timbro CECir - nuove sez (SEZ-2-1)
,a_data_verbale2_1	IN	varchar2	-- data verbale x timbro CECir - nuove sez (SEZ-2-1)
,a_verbale2_2		IN	varchar2	-- n.ro verbale x timbro CECir - rettifiche semestrale (SEZ-2-2)	
,a_data_verbale2_2	IN	varchar2	-- data verbale x timbro CECir - rettifiche semestrale (SEZ-2-2)
,a_data_verbale2_3	IN	varchar2	-- data verbale x timbro CECir - blocco liste (SEZ-2-3)
,a_timbro1_0		IN	varchar2	-- timbro CEC - chiusura A-L / M-Z (SEZ-1-8 / SEZ-1-9)
,a_timbro1_1		IN	varchar2	-- timbro CEC - autentica nuove sez (SEZ-1-1)
,a_timbro1_2		IN	varchar2	-- timbro CEC - autentica semestrale (SEZ-1-2)
,a_timbro1_3		IN	varchar2	-- timbro CEC - autentica blocco listeu (SEZ-1-3)
,a_timbro2_0		IN	varchar2	-- timbro CECir - chiusura A-L / M-Z (SEZ-2-8 / SEZ-2-9)
,a_timbro2_1		IN	varchar2	-- timbro CECir - autentica nuove sez (SEZ-2-1)
,a_timbro2_2		IN	varchar2	-- timbro CECir - autentica semestrale (SEZ-2-2)
,a_timbro2_3		IN	varchar2	-- timbro CECir - autentica blocco liste (SEZ-2-3)
)

return number
 
IS

w_sesso			varchar2(255) := 'X';
w_doppio_timbro		varchar2(255) := 'N';
w_salto_p		varchar2(255) := 'S';
w_timbro2_4		varchar2(255) := 'N';

w_data_verbale_j	number := to_char(to_date(a_data_verbale,'yyyy-mm-dd'),'j');
w_data_elezioni_j	number := to_char(to_date(a_data_elezioni,'yyyy-mm-dd'),'j');
w_data_verbale1_3_j	number := to_char(to_date(a_data_verbale1_3,'yyyy-mm-dd'),'j');
w_data_verbale2_1_j	number := to_char(to_date(a_data_verbale2_1,'yyyy-mm-dd'),'j');
w_data_verbale2_2_j	number := to_char(to_date(a_data_verbale2_2,'yyyy-mm-dd'),'j');
w_data_verbale2_3_j	number := to_char(to_date(a_data_verbale2_3,'yyyy-mm-dd'),'j');
w_data_verbale2_4_j	number := '';

w_chiave		varchar2(255) := 'SELS';
w_terminale		varchar2(255) := 'ELESELS';
w_parametri		varchar2(2000);

w_return		number := 0;

begin

  w_parametri := w_sesso||
                 lpad(nvl(a_da_sezione,0),4,'0')||
                 lpad(nvl(a_a_sezione,9999),4,'0')||
                 nvl(a_stampa_chiusura,'N')||
                 rpad(nvl(a_verbale,' '),10,' ')||
                 lpad(nvl(w_data_verbale_j,0),7,'0')||
                 nvl(a_ai_seggi,'N')||
                 lpad(nvl(w_data_elezioni_j,0),7,'0')||
                 nvl(w_doppio_timbro,'N')||
                 nvl(a_flag_politiche,'N')||
                 nvl(a_stampa_visto,'N')||
                 nvl(a_alfabetico,'N')||
                 nvl(a_storico,'N')||
                 lpad(nvl(a_da_progr,1),4,'0')||
                 lpad(nvl(a_a_progr,9999),4,'0')||
                 lpad(nvl(a_anno_elezioni,0),4,'0')||
                 lpad(nvl(a_progr_elezioni,0),2,'0')||
                 nvl(a_flag_referendum,'N')||
                 nvl(a_timbro1_1,'N')||
                 nvl(a_timbro1_2,'N')||
                 nvl(a_timbro1_3,'N')||
                 nvl(a_timbro2_1,'N')||
                 nvl(a_timbro2_2,'N')||
                 nvl(a_timbro2_3,'N')||
                 nvl(w_timbro2_4,'N')||
                 nvl(w_salto_p,'N')||
                 rpad(nvl(a_verbale2_1,' '),10,' ')||
                 lpad(nvl(w_data_verbale2_1_j,0),7,'0')||
                 rpad(nvl(a_verbale2_2,' '),10,' ')||
                 lpad(nvl(w_data_verbale2_2_j,0),7,'0')||
                 a_tipo_firma||
                 nvl(a_flag_amministrative,'N')||
                 rpad(nvl(a_vota_solo_per,' '),20,' ')||
                 lpad(nvl(w_data_verbale2_3_j,0),7,'0')||
                 lpad(nvl(w_data_verbale2_4_j,0),7,'0')||
                 rpad(nvl(a_verbale1_3,' '),10,' ')||
                 lpad(nvl(w_data_verbale1_3_j,0),7,'0')||
                 nvl(a_filtro_lettere,'T')||
                 nvl(a_timbro1_0,'N')||
                 nvl(a_timbro2_0,'N');

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
