--liquibase formatted sql
--changeset amonopoli:202606100955_2 runOnChange:true stripComments:false
create or replace trigger ANADOI_TIU
before INSERT
    or UPDATE
on ANADOI
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_adoi_ecint_inp 	varchar2(255);

w_sezione_tpr		varchar2(3);
w_foglio_tpr		varchar2(5);
w_numero_tpr		varchar2(5);
w_subalterno_tpr	varchar2(5);

w_cod_via		number;
w_num_civ		number;
w_suffisso		varchar2(255);
w_interno		number;
w_scala			varchar2(255);
w_piano			varchar2(255);
w_sub_interno		varchar2(255);

w_data_pratica          varchar2(255);

w_note                  varchar2(2000);

begin
   :new.id := f_ANADOI_nr(:new.id);
   :new.id_pratica := f_ANA_get_id_pratica(:new.anagrafe,:new.tipo_evento,:new.anno_pratica,:new.pratica);

   begin
     select tpr.id
       into :new.id_anatpr
       from anatpr tpr
      where anagrafe     = :new.anagrafe
        and tipo_evento  = :new.tipo_evento
        and anno_pratica = :new.anno_pratica
        and pratica      = :new.pratica
        and rownum = 1
    ;
   exception
     when others then
--          raise_application_error(-20999, 'id_anatpr non trovato ('||sqlerrm||')');
          null;
   end;

   begin  -- Check DATA Integrity on INSERT or UPDATE
      if INSERTING then
         if :new.data_contratto_locazione is null and :new.d_data_contratto_locazione is not null then
            :new.data_contratto_locazione := to_char(:new.d_data_contratto_locazione,'j');
         elsif :new.d_data_contratto_locazione is null and :new.data_contratto_locazione is not null then
            :new.d_data_contratto_locazione := to_date(:new.data_contratto_locazione,'j');
         end if;
         if :new.data_contratto_comodato is null and :new.d_data_contratto_comodato is not null then
            :new.data_contratto_comodato := to_char(:new.d_data_contratto_comodato,'j');
         elsif :new.d_data_contratto_comodato is null and :new.data_contratto_comodato is not null then
            :new.d_data_contratto_comodato := to_date(:new.data_contratto_comodato,'j');
         end if;
      end if;
 
      if UPDATING then
         if nvl(:old.data_contratto_locazione,0) != nvl(:new.data_contratto_locazione,0) then
            :new.d_data_contratto_locazione := to_date(:new.data_contratto_locazione,'j');
         elsif nvl(:old.d_data_contratto_locazione,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_contratto_locazione,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_contratto_locazione   := to_char(:new.d_data_contratto_locazione,'j');
         end if;
         if nvl(:old.data_contratto_comodato,0) != nvl(:new.data_contratto_comodato,0) then
            :new.d_data_contratto_comodato := to_date(:new.data_contratto_comodato,'j');
         elsif nvl(:old.d_data_contratto_comodato,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_contratto_comodato,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_contratto_comodato   := to_char(:new.d_data_contratto_comodato,'j');
         end if;
      end if;
   end;

  :new.sezione_catasto_tpr    := nvl(:new.sezione_catasto_tpr,:new.sezione_catasto);
  :new.foglio_catasto_tpr     := nvl(:new.foglio_catasto_tpr,:new.foglio_catasto);
  :new.numero_catasto_tpr     := nvl(:new.numero_catasto_tpr,:new.numero_catasto);
  :new.subalterno_catasto_tpr := nvl(:new.subalterno_catasto_tpr,:new.subalterno_catasto);

  if :new.sezione_catasto_tpr||:new.foglio_catasto_tpr||:new.numero_catasto_tpr||:new.subalterno_catasto_tpr is not null then
     w_adoi_ecint_inp := f_valore_inp('ADOI_ECINT',1,1,'X','S');
     if nvl(w_adoi_ecint_inp,'N') = 'S' then
        w_sezione_tpr    := replace(translate(:new.sezione_catasto_tpr,'\/','**'),'*','');
        w_foglio_tpr     := replace(translate(:new.sezione_catasto_tpr,'\/','**'),'*','');
        w_numero_tpr     := replace(translate(:new.sezione_catasto_tpr,'\/','**'),'*','');
        w_subalterno_tpr := replace(translate(:new.sezione_catasto_tpr,'\/','**'),'*','');

        w_note := '(Estremi castastali recuperati da pratica ';

        if :new.tipo_evento = 'I' then
           w_note := w_note||' di Iscrizione';
           w_note := w_note||' N. '||:new.pratica||'/'||:new.anno_pratica;
           begin
             select to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'), 
                    ap4.cod_via, ap4.num_civ, ap4.suffisso, ap4.interno, ap4.scala, ap4.piano, ap4.sub_interno
               into w_data_pratica, w_cod_via, w_num_civ, w_suffisso, w_interno, w_scala, w_piano, w_sub_interno
               from anaap4 ap4, anatpr tpr
              where ap4.anno_pratica = tpr.anno_pratica
                and ap4.pratica      = tpr.pratica
                and tpr.anagrafe     = :new.anagrafe
                and tpr.tipo_evento  = :new.tipo_evento
                and tpr.anno_pratica = :new.anno_pratica
                and tpr.pratica      = :new.pratica
                and rownum = 1
             ;
             w_note := w_note||' del '||w_data_pratica||')';
           exception
             when others then
                  w_note := w_note||')';
           end;

        elsif :new.tipo_evento = 'E' then
           w_note := w_note||' di Cambio Abitazione';
           w_note := w_note||' N. '||:new.pratica||'/'||:new.anno_pratica;
           begin
             select to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'), 
                    cre.cod_via, cre.num_civ, cre.suffisso, cre.interno, cre.scala, cre.piano, cre.sub_interno
               into w_data_pratica, w_cod_via, w_num_civ, w_suffisso, w_interno, w_scala, w_piano, w_sub_interno
               from anacre cre, anatpr tpr
              where cre.anno_pratica = tpr.anno_pratica
                and cre.pratica      = tpr.pratica
                and tpr.anagrafe     = :new.anagrafe
                and tpr.tipo_evento  = :new.tipo_evento
                and tpr.anno_pratica = :new.anno_pratica
                and tpr.pratica      = :new.pratica
                and rownum = 1
             ;
             w_note := w_note||' del '||w_data_pratica||')';
           exception
             when others then
                  w_note := w_note||')';
           end;
        end if;

        begin
          update arcint
             set SEZIONE_CATASTO    = w_sezione_tpr,
                 FOGLIO_CATASTO     = w_foglio_tpr,
                 NUMERO_CATASTO     = w_numero_tpr,     
                 SUBALTERNO_CATASTO = w_subalterno_tpr,
                 NOTE               = decode(note,'',w_note,note||' '||w_note)
           where cod_via              = w_cod_via
             and num_civ              = w_num_civ 
             and nvl(suffisso,' ')    = nvl(w_suffisso,' ')
             and nvl(interno,0)       = nvl(w_interno,0)
             and nvl(scala,' ')       = nvl(w_scala,' ')
             and nvl(piano,' ')       = nvl(w_piano,' ')
             and nvl(sub_interno,' ') = nvl(w_sub_interno,' ')
             and sezione_catasto||foglio_catasto||numero_catasto||subalterno_catasto is null
          ;
        exception
          when others then
               null;
        end;
     end if;
  end if;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;	
end;
/

