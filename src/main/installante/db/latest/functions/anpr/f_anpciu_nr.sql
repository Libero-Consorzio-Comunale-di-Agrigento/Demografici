--liquibase formatted sql
--changeset amonopoli:202604211120_1 runOnChange:true stripComments:false
create or replace function F_ANPCIU_NR
(a_id			IN 	number
,a_servizio_rif		IN	varchar2 default NULL
)

return number

IS

w_tipo_invio	varchar2(255) := f_ANPR_valore_inp('TIPO_INVIO',1,10,'X','S');
w_cod_dest	varchar2(255) := f_ANPR_valore_inp('COD_DEST',1,10,'X','S');

w_anno		number;
w_numero	number;

w_servizio_init	number;
w_servizio_rif	varchar2(255);

w_id_operazione	number;

begin
 if a_id is null then
    if a_servizio_rif is not null then
       if w_cod_dest = 'ANPR01' and (substr(a_servizio_rif,1,1) in ('3','N','7') and substr(a_servizio_rif,1,4) != '3005') then
          w_servizio_rif  := '3000';
          w_servizio_init := 300000;
       elsif w_cod_dest = 'ANPR01' and (substr(a_servizio_rif,1,1) in ('4') or substr(a_servizio_rif,1,4) = '3005') then
          w_servizio_rif  := '3000';
          w_servizio_init := 300000;
       elsif w_cod_dest > 'ANPR01' and (substr(a_servizio_rif,1,1) in ('3') and substr(a_servizio_rif,1,4) != '3005') then
          w_servizio_rif  := '3000';
          w_servizio_init := 300000;
       elsif w_cod_dest > 'ANPR01' and (substr(a_servizio_rif,1,1) in ('4','N','7') or substr(a_servizio_rif,1,4) = '3005') then
          w_servizio_rif  := '4000';
          w_servizio_init := 400000;
       elsif substr(a_servizio_rif,1,1) = '6' then
          w_servizio_rif  := '6000';
          w_servizio_init := 600000;
       elsif substr(a_servizio_rif,1,4) = '1014' then
          w_servizio_rif  := '1014';
          w_servizio_init := 200000;
       elsif nvl(substr(a_servizio_rif,5,3),' ') in ('DOC','MSI') then
          w_servizio_rif  := '1014';
          w_servizio_init := 200000;
       elsif substr(a_servizio_rif,1,1) = 'P' then
          w_servizio_rif  := '5000';
          w_servizio_init := 500000;
       else
          w_servizio_rif  := '';
          w_servizio_init := 0;
       end if;
    else
       w_servizio_rif  := '';
       w_servizio_init := 0;
    end if;
    begin 
      select anno, numero + 1
        into w_anno, w_numero
        from anpn01
       where anno                     = to_char(sysdate,'yyyy')
         and nvl(servizio_rif,'XXXX') = nvl(w_servizio_rif,'XXXX')
      ; 
      update anpn01
         set numero = w_numero
       where anno  	              = w_anno
         and nvl(servizio_rif,'XXXX') = nvl(w_servizio_rif,'XXXX')
      ;
    exception
      when no_data_found then
           w_anno 	:= to_char(sysdate,'yyyy');
           w_numero	:= w_servizio_init + 1;
           begin
             insert into anpn01 (anno, numero, servizio_rif)
             values (w_anno, w_numero, w_servizio_rif)
	     ;
           exception
             when others then
                  w_anno         := '';
                  w_numero       := '';
                  w_servizio_rif := '';
           end;
      when others then
           w_anno 	  := '';
	   w_numero	  := '';
	   w_servizio_rif := '';
    end;

    if w_anno is not null and w_numero is not null then
       w_id_operazione := w_anno||lpad(w_numero,6,'0');
    else 
       w_id_operazione := to_number(null);
    end if;

 elsif a_id is not null then
    w_id_operazione := a_id;
 end if;

 return w_id_operazione;

end;
/
