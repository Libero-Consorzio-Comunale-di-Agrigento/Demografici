--liquibase formatted sql
--changeset amonopoli:202412060935_3 runOnChange:true stripComments:false
create or replace trigger ANADOC_ANPR_TIU
before INSERT
    or UPDATE
on ANADOC
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_servizio		varchar2(255);
w_tipo_operazione	varchar2(255);

w_fascia_ana		number;
w_nazionalita		varchar2(255);
w_cod_pro_utente	number;
w_cod_com_utente	number;
w_flag_DS		varchar2(1);
w_flag_DI		varchar2(1);

w_flag_CDF		varchar2(1);
w_cod_cdf		number;

w_archivio_rif		varchar2(255);

w_integrazione_anpr	varchar2(255) := f_valore_inp('ANPR',1,1,'X','S');

begin
 if nvl(w_integrazione_anpr,'N') = 'S' then
   begin 
     :new.id := F_ANADOC_NR(:new.ID);
   end;

   begin
     select ddo.flag_identita, 
            decode(ddo.cod_do,'PP','S',ddo.flag_stranieri), 
            ddo.flag_cdf,
            m.cod_provincia, 
            m.cod_comune
       into w_flag_DI, w_flag_DS, w_flag_CDF,
            w_cod_pro_utente, w_cod_com_utente
       from arccom m, anaddo ddo
      where (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
        and ddo.cod_do    = :new.tipo_documento
     ;
     if w_flag_DI is not null then
        w_archivio_rif := 'DOC_DI';
     elsif w_flag_DS is not null then
        w_archivio_rif := 'DOC_DS';
     elsif w_flag_CDF is not null then
        w_archivio_rif := 'DOC_CDF';
     elsif :new.tipo_documento in ('PT','CC') then
        w_archivio_rif := 'DOC_PT_CC';
     else
        w_archivio_rif := '';
     end if;
   exception
     when others then
          w_archivio_rif := '';
   end;

   if INSERTING then
--anpr_pkg.INS_LOG('','anadoc_anpr_tiu','inserting'||' - id '||:new.id||' - natura_documento '||:new.natura_documento);
      if :new.natura_documento = 'A' then
         goto fine;
      end if;
   end if;

   if UPDATING then
--anpr_pkg.INS_LOG('','anadoc_anpr_tiu','updating'||' - id '||:new.id);
      if :new.numero                = :old.numero               and
         :new.data_emissione        = :old.data_emissione       and
         nvl(:new.data_scadenza,0)  = nvl(:old.data_scadenza,0) 
      then 
         if :new.natura_documento = 'A' and :old.natura_documento != 'A' then
--            null;
-- 03/06/2019 (AM) non esiste possibilit  di inviare l'annullamento carta tramite WS
--
            goto fine;
         else
            goto fine;
         end if;
      end if;
   end if;

--anpr_pkg.INS_LOG('','anadoc_anpr_tiu','w_archivio_rif '||w_archivio_rif||' - tipo_documento '||:new.tipo_documento||' - progr_documento '||:new.progr_documento);
   if w_archivio_rif is null then
      goto fine;

   elsif w_archivio_rif = 'DOC_CDF' then
      begin
        select ana.fascia, ana.nazionalita, cdf.cod_cdf
          into w_fascia_ana, w_nazionalita, w_cod_cdf
          from anacdf cdf, anaana ana
         where cdf.data_inizio is not null
           and cdf.data_fine   is null 
           and nvl(cdf.stato_cdf,'D') = 'I'
           and cdf.matricola   = ana.matricola
           and ana.matricola = :new.matricola
           and rownum = 1
        ;
      exception
        when others then
             w_fascia_ana := 0;
             w_cod_cdf    := '';
      end;
      if w_fascia_ana = 1 and w_cod_cdf is not null then 
         w_servizio        := '5008';
      else 
         goto fine;
      end if;

      begin
        insert into anpciu
               (SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                MATRICOLA, COD_FAM, ID_ANADOC, DATA_REG, TERMINALISTA)
        select w_servizio, w_tipo_operazione, w_archivio_rif,
               :new.matricola, w_cod_cdf, :new.id, :new.data_reg,
               si4.utente
          from dual
         where not exists (select 'x' 
                             from anpciu ciu, anamov mov
                            where ciu.archivio_rif  = 'MOV'
                              and ciu.anno_rif      = mov.anno_progr
                              and ciu.numero_rif    = mov.numero_progr
                              and ciu.flag_invio_ws is null
                              and mov.matricola     = :new.matricola
                              and mov.cod_mov       in (1,3)
                              and mov.data_reg      >= :new.data_reg)
           and not exists (select 'x' 
                             from anpciu ciu
                            where ciu.archivio_rif  like 'CDF%'
                              and ciu.cod_fam       = w_cod_cdf
                              and ciu.matricola     = :new.matricola
                              and ciu.flag_invio_ws is null)
        ;
      exception
        when others then
             raise_application_error(-20999,'Errore in inserimento ANPCIU - CDF ('||SQLERRM||')');
      end;

--
-- 04/06/2019 (AM) evitato invio della CIE + aggiunto invio CI anche emesse da altri comuni / enti
--          :new.cod_pro_ente = w_cod_pro_utente  and 
--          :new.cod_com_ente = w_cod_com_utente  and 
--
   elsif (w_archivio_rif = 'DOC_DI'             and 
          :new.tipo_documento != 'CE'           and          
          :new.progr_documento = 1)
         OR
         (w_archivio_rif = 'DOC_DS'             and 
          :new.progr_documento = 1)
         OR  
         (:new.tipo_documento = 'PT'            and 
          :new.progr_documento = 1)
         OR
         (:new.tipo_documento = 'CC')
   then
      begin
        select ana.fascia, ana.nazionalita 
          into w_fascia_ana, w_nazionalita 
          from anaana ana
         where ana.matricola = :new.matricola
        ;
      exception
        when others then
             w_fascia_ana := 0;
      end;
--anpr_pkg.INS_LOG('','anadoc_anpr_tiu','w_fascia_ana '||w_fascia_ana||' - w_nazionalita '||w_nazionalita);

      if w_fascia_ana = 0 then
         goto fine;
      elsif w_fascia_ana in (1,3) then 
         w_servizio        := '5008';
      end if;

      w_tipo_operazione := 'C';
      if (w_archivio_rif = 'DOC_DI'            and 
          w_fascia_ana in (1,3))
         OR 
         (w_archivio_rif = 'DOC_DS'            and 
          w_nazionalita != 'I'                 and
          w_fascia_ana in (1))
         OR  
         (:new.tipo_documento = 'PT'           and
          w_fascia_ana in (1,3))
         OR  
         (:new.tipo_documento = 'CC'           and 
          w_fascia_ana in (1,3))
      then
         begin
           insert into anpciu
                  (SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                   MATRICOLA, ID_ANADOC, DATA_REG, TERMINALISTA)
           select w_servizio, w_tipo_operazione, w_archivio_rif,
                  :new.matricola, :new.ID, :new.data_reg,
                  si4.utente
             from dual
            where not exists (select 'x' 
                                from anpciu ciu, anamov mov
                               where ciu.archivio_rif  = 'MOV'
                                 and ciu.anno_rif      = mov.anno_progr
                                 and ciu.numero_rif    = mov.numero_progr
                                 and ciu.flag_invio_ws is null
                                 and ciu.servizio      = '1002'
                                 and mov.matricola     = :new.matricola
                                 and mov.cod_mov       in (1,3)
                                 and mov.data_reg      >= :new.data_reg)
           ;
--            where not exists (select 'x' from anamov mov
--                               where mov.matricola = :new.matricola
--                                 and mov.cod_mov   in (1,3)
--                                 and mov.data_reg  > :new.data_reg)
--              and not exists (select 'x' from anpciu ciu
--                               where ciu.archivio_rif  = w_archivio_rif
--                                 and ciu.flag_invio_ws is null
--                                 and ciu.matricola     = :new.matricola
--                                 and ciu.data_reg      = :new.data_reg)
--           ;
--anpr_pkg.INS_LOG('','anadoc_anpr_tiu',:new.id||' - inserito');
         exception
           when others then
                raise_application_error(-20999,'Errore in inserimento ANPCIU ('||SQLERRM||')');
         end;
      end if;
   end if;
 end if; -- nvl(w_integrazione_anpr,'N') = 'S'

<< fine >>
null;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANADOC_ANPR_TIU */
/
