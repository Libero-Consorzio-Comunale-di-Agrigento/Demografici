--liquibase formatted sql
--changeset amonopoli:202510270910_1 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'ANSANA';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create table ansana
(id_operazione                number(10) --<idOperazioneComune>2025002569</idOperazioneComune>
--
,id                           varchar2(255) --<id>9631153</id>
,idAnsc                       varchar2(255) --<idAnsc>2025-9631153-160-039010</idAnsc>
,annoAtto                     varchar2(255) --<annoAtto>2025</annoAtto>
,numeroAtto                   varchar2(255) --<numeroatto>160</numeroatto>
,idVersion                    varchar2(255) --<idVersion>100021</idVersion>
,idTipoEvento                 varchar2(255) --<idTipoEvento>1</idTipoEvento>
,idTipoContenuto              varchar2(255) --<idtipocontenuto>3</idtipocontenuto>
,stato                        varchar2(255) --<stato>CONFERMATO</stato>
,idUseCase                    varchar2(255) --<idUsecase>1314</idUsecase>
,descrizioneCasoUso           varchar2(255) --<descrizioneCasoUso>Trascrizione di nascita: Trascrizione atto di nascita resa alla direzione sanitaria</descrizioneCasoUso>
,dataFormazione               varchar2(255) --<dataformazione>2025-10-24</dataformazione>
,idComuneRegistrazione        varchar2(255) --<idComuneRegistrazione>3743</idComuneRegistrazione>
,nomeComuneRegistrazione      varchar2(255) --<nomeComuneRegistrazione>FAENZA</nomeComuneRegistrazione>
,idProvinciaRegistrazione     varchar2(255) --<idProvinciaRegistrazione>39</idProvinciaRegistrazione>
,siglaProvinciaRegistrazione  varchar2(255) --<siglaProvinciaRegistrazione>RA</siglaProvinciaRegistrazione>
--,idComune                     varchar2(255) --<idComune>3743</idComune>
--,idOperazione                 varchar2(255) --<idOperazione>4803959</idOperazione>
--,idEsito                      varchar2(255) --<idEsito>0</idEsito>
--
,INT_id                           varchar2(255) --<id>7932781</id>
,INT_idSoggetto                   varchar2(255) --<idSoggetto>16725818</idSoggetto>
,INT_cognome                      varchar2(255) --<cognome>SVI DATA DOCUMENTO CNA</cognome>
,INT_nome                         varchar2(255) --<nome>FIGLIA</nome>
,INT_sesso                        varchar2(255) --<sesso>F</sesso>
,INT_dataNascita                  varchar2(255) --<dataNascita>2025-10-23</dataNascita>
,INT_codiceFiscale                varchar2(255)
,INT_idComuneNascita              varchar2(255) --<idComuneNascita>7846</idComuneNascita>
,INT_nomeCOmuneNascita            varchar2(255) --<nomeComuneNascita>RAVENNA</nomeComuneNascita>
,INT_idProvinciaNascita           varchar2(255) --<idProvinciaNascita>39</idProvinciaNascita>
,INT_siglaProvinciaNascita        varchar2(255) --<siglaProvinciaNascita>RA</siglaProvinciaNascita>
,INT_idStatoNascita               varchar2(255) --<idStatoNascita>90</idStatoNascita>
,INT_nomeStatoNascita             varchar2(255) --<nomeStatoNascita>ITALIA</nomeStatoNascita>
,INT_idComuneResidenza            varchar2(255) --<idComuneResidenza>3743</idComuneResidenza>
,INT_nomeComuneResidenza          varchar2(255) --<nomeComuneResidenza>FAENZA</nomeComuneResidenza>
,INT_idProvinciaResidenza         varchar2(255) --<idProvinciaResidenza>39</idProvinciaResidenza>
,INT_siglaProvinciaResidenza      varchar2(255) --<siglaProvinciaResidenza>RA</siglaProvinciaResidenza>
,INT_idStatoResidenza             varchar2(255) --<idStatoResidenza>90</idStatoResidenza>
,INT_nomeStatoResidenza           varchar2(255) --<nomeStatoResidenza>ITALIA</nomeStatoResidenza>
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'idx';
w_nome_ogg	varchar2(255) := 'IDX1ANSANA';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx1ansana on ansana (id_operazione)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
comment on table ansana is 'ANSC - Anagrafiche Atti da servizi di Consultazione'
/
