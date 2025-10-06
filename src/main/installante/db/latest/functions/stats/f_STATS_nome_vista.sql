--liquibase formatted sql
--changeset amonopoli:202411191550_1 runOnChange:true stripComments:false
create or replace function f_STATS_nome_vista
(a_tname	IN	varchar2
,a_tipo		IN	varchar2 	default 'S')

return varchar2

IS

w_tname		varchar2(255) := upper(a_tname);
w_tipo		varchar2(255) := upper(a_tipo);
w_nome_vista	varchar2(255);
w_user		varchar2(255);

begin
  if w_tname = 'ANAVBI' then
     w_nome_vista := 'INDIVIDUI_ANA';
  elsif w_tname = 'ANAVBI_STORICO' then
     w_nome_vista := 'INDIVIDUI_ANA_STORICO';
  elsif w_tname = 'ANAVBI_TOTALE' then
     w_nome_vista := 'INDIVIDUI_ANA_TOTALE';
  elsif w_tname = 'ANAVMO' then
     w_nome_vista := 'MOVIMENTI_ANA';
  elsif w_tname = 'ANASTA_V' then
     w_nome_vista := 'STATISTICHE_ANA';

  elsif w_tname like 'ANAVXX_%' then
     if w_tname = 'ANAVXX_ARMA' then
        w_nome_vista := 'ARMA_COD';
     elsif w_tname = 'ANAVXX_DES_ARMA' then
        w_nome_vista := 'ARMA_DES';
     elsif w_tname = 'ANAVXX_ATTIVITA_PROF' then
        w_nome_vista := 'ATTIVITA_PROF_COD';
     elsif w_tname = 'ANAVXX_CORPO' then
        w_nome_vista := 'CORPO_COD';
     elsif w_tname = 'ANAVXX_DES_CORPO' then
        w_nome_vista := 'CORPO_DES';
     elsif w_tname = 'ANAVXX_DATA_STORICO' then
        w_nome_vista := 'DATA_STORICO';
     elsif w_tname = 'ANAVXX_CODICE_VIA' then
        w_nome_vista := 'DENOMINAZIONE_VIA_COD';
     elsif w_tname = 'ANAVXX_DENOMINAZIONE_VIA' then
        w_nome_vista := 'DENOMINAZIONE_VIA_DES';
     elsif w_tname = 'ANAVXX_COD_COMUNE' then
        w_nome_vista := 'COMUNE_COD';
     elsif w_tname = 'ANAVXX_COMUNE' then
        w_nome_vista := 'COMUNE_DES';
     elsif w_tname = 'ANAVXX_ESITO_LEVA' then
        w_nome_vista := 'ESITO_LEVA_COD';
     elsif w_tname = 'ANAVXX_DES_ESITO_LEVA' then
        w_nome_vista := 'ESITO_LEVA_DES';
     elsif w_tname = 'ANAVXX_FLAG_S' then
        w_nome_vista := 'FLAG_S';
     elsif w_tname = 'ANAVXX_FLAG_SI' then
        w_nome_vista := 'FLAG_SI';
     elsif w_tname = 'ANAVXX_GRADO' then
        w_nome_vista := 'GRADO_COD';
     elsif w_tname = 'ANAVXX_DES_GRADO' then
        w_nome_vista := 'GRADO_DES';
     elsif w_tname = 'ANAVXX_GRUPPO_DI_STUDIO' then
        w_nome_vista := 'GRUPPO_DI_STUDIO_COD';
     elsif w_tname = 'ANAVXX_GRUPPO_NAZIONALITA' then
        w_nome_vista := 'GRUPPO_NAZIONALITA_DES';
     elsif w_tname = 'ANAVXX_MOTIVO_DOC' then
        w_nome_vista := 'MOTIVO_DOC_COD';
     elsif w_tname = 'ANAVXX_NAZIONALITA' then
        w_nome_vista := 'NAZIONALITA_COD';
     elsif w_tname = 'ANAVXX_POSIZIONE_PROF' then
        w_nome_vista := 'POSIZIONE_PROF_COD';
     elsif w_tname = 'ANAVXX_PROFESSIONE' then
        w_nome_vista := 'PROFESSIONE_COD';
     elsif w_tname = 'ANAVXX_DES_PROFESSIONE' then
        w_nome_vista := 'PROFESSIONE_DES';
     elsif w_tname = 'ANAVXX_COD_PROVINCIA' then
        w_nome_vista := 'PROVINCIA_COD';
     elsif w_tname = 'ANAVXX_RAPPORTO_PAR' then
        w_nome_vista := 'RAPPORTO_PAR_COD';
     elsif w_tname = 'ANAVXX_DES_RAPPORTO_PAR' then
        w_nome_vista := 'RAPPORTO_PAR_DES';
     elsif w_tname = 'ANAVXX_COD_REGIONE' then
        w_nome_vista := 'REGIONE_COD';
     elsif w_tname = 'ANAVXX_REGIONE' then
        w_nome_vista := 'REGIONE_DES';
     elsif w_tname = 'ANAVXX_SEQUENZA_PAR' then
        w_nome_vista := 'SEQUENZA_PAR_COD';
     elsif w_tname = 'ANAVXX_SESSO' then
        w_nome_vista := 'SESSO_COD';
     elsif w_tname = 'ANAVXX_SEZIONE_ELE' then
        w_nome_vista := 'SEZIONE_ELE';
     elsif w_tname = 'ANAVXX_STATO_ALBO_ELE' then
        w_nome_vista := 'STATO_ALBO_ELE_COD';
     elsif w_tname = 'ANAVXX_STATO_CIVILE' then
        w_nome_vista := 'STATO_CIVILE_COD';
     elsif w_tname = 'ANAVXX_STATO_ELE' then
        w_nome_vista := 'STATO_ELE_COD';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_01' then
        w_nome_vista := 'SUDDIVISIONE_01_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_02' then
        w_nome_vista := 'SUDDIVISIONE_02_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_03' then
        w_nome_vista := 'SUDDIVISIONE_03_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_04' then
        w_nome_vista := 'SUDDIVISIONE_04_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_05' then
        w_nome_vista := 'SUDDIVISIONE_05_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_06' then
        w_nome_vista := 'SUDDIVISIONE_06_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_07' then
        w_nome_vista := 'SUDDIVISIONE_07_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_08' then
        w_nome_vista := 'SUDDIVISIONE_08_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_09' then
        w_nome_vista := 'SUDDIVISIONE_09_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_10' then
        w_nome_vista := 'SUDDIVISIONE_10_DES';
     elsif w_tname = 'ANAVXX_DES_SUDDIVISIONE_CAP' then
        w_nome_vista := 'SUDDIVISIONE_CAP_DES';
     elsif w_tname = 'ANAVXX_TIPO_DI' then
        w_nome_vista := 'TIPO_DI_COD';
     elsif w_tname = 'ANAVXX_DES_TIPO_DI' then
        w_nome_vista := 'TIPO_DI_DES';
     elsif w_tname = 'ANAVXX_TIPO_DS' then
        w_nome_vista := 'TIPO_DS_COD';
     elsif w_tname = 'ANAVXX_DES_TIPO_DS' then
        w_nome_vista := 'TIPO_DS_COD';
     elsif w_tname = 'ANAVXX_TITOLO_STUDIO' then
        w_nome_vista := 'TITOLO_STUDIO_COD';
     elsif w_tname = 'ANAVXX_DES_TITOLO_STUDIO' then
        w_nome_vista := 'TITOLO_STUDIO_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_01' then
        w_nome_vista := 'UNITA_01_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_02' then
        w_nome_vista := 'UNITA_02_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_03' then
        w_nome_vista := 'UNITA_03_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_04' then
        w_nome_vista := 'UNITA_04_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_05' then
        w_nome_vista := 'UNITA_05_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_06' then
        w_nome_vista := 'UNITA_06_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_07' then
        w_nome_vista := 'UNITA_07_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_08' then
        w_nome_vista := 'UNITA_08_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_09' then
        w_nome_vista := 'UNITA_09_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_10' then
        w_nome_vista := 'UNITA_10_DES';
     elsif w_tname = 'ANAVXX_DES_UNITA_CAP' then
        w_nome_vista := 'UNITA_CAP_DES';
     elsif w_tname = 'ANAVXX_COD_EVE' then
        w_nome_vista := 'EVENTO_COD';
     elsif w_tname = 'ANAVXX_COD_MOV' then
        w_nome_vista := 'MOVIMENTO_COD';
     elsif w_tname = 'ANAVXX_DES_COD_EVE' then
        w_nome_vista := 'EVENTO_DES';
     elsif w_tname = 'ANAVXX_DES_COD_MOV' then
        w_nome_vista := 'MOVIMENTO_DES';
     end if;
  end if;

  begin
    select user
      into w_user
      from dual
    ;
  exception
    when others then
         w_user := 'GSD';
  end;

  w_nome_vista := w_user||'_'||w_nome_vista;

  if a_tipo != 'S' then
     w_nome_vista := w_nome_vista||'_'||w_tipo;
  end if;

  return w_nome_vista;

end;
/
