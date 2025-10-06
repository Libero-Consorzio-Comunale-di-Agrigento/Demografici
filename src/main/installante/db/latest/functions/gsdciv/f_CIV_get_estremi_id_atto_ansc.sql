--liquibase formatted sql
--changeset snocca:202401121231 runOnChange:true stripComments:false
create or replace function f_CIV_get_estremi_id_atto_ansc
(a_id_atto_ansc	 IN	varchar2
,a_tipo_dato		 IN	varchar2
)

return varchar2

IS

w_id_atto_ansc	varchar2(255) := a_id_atto_ansc;
w_tipo_dato		  varchar2(255) := upper(a_tipo_dato);

w_anno   varchar2(4);
w_evento_ansc varchar2(20);
w_numero_unico_comuale varchar2(20);
w_cod_istat varchar2(20);

w_pos      number;
w_substr   varchar2(20);
w_return	 varchar2(20);

begin
  w_return := '';

  if w_id_atto_ansc is not null and w_tipo_dato is not null then
    begin
      -- ANNO
      w_pos  := instr(w_id_atto_ansc,'-');
      w_anno := substr(w_id_atto_ansc, 0, (w_pos-1));
      w_substr := substr(w_id_atto_ansc, (w_pos+1));

      -- EVENTO ANSC
      w_pos := instr(w_substr,'-');
      w_evento_ansc := substr(w_substr, 0, (w_pos-1));
      w_substr := substr(w_substr, (w_pos+1));

      -- NUMERO COMUNALE
      w_pos := instr(w_substr,'-');
      w_numero_unico_comuale := substr(w_substr, 0, (w_pos-1));
      w_substr := substr(w_substr, (w_pos+1));

      -- CODICE ISTAT
      w_cod_istat := w_substr;

      if w_tipo_dato = 'ANNO' then
        w_return := w_anno;
      elsif w_tipo_dato = 'EVENTO_ANSC' then
        w_return := w_evento_ansc;
      elsif w_tipo_dato = 'NUMERO_COMUNALE' then
        w_return := w_numero_unico_comuale;
      elsif w_tipo_dato = 'CODICE_ISTAT' then
        w_return := w_cod_istat;
      end if; -- if w_tipo_dato = 'ANNO' then

    exception
       when others then
            w_return := '';
     end;
  end if; -- if w_id_atto_ansc is not null and w_tipo_dato is not null then

  return w_return;
end;
/
