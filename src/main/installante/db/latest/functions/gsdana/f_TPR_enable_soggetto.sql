--liquibase formatted sql
--changeset amonopoli:202512190840_2 runOnChange:true stripComments:false
create or replace function f_TPR_enable_soggetto
(a_anagrafe 		IN  	varchar2
,a_tipo_evento  	IN  	varchar2
,a_fascia       	IN	number
,a_stato		IN	number
,a_cod_pro_res		IN	number
,a_cod_com_res		IN	number
,a_archivio_rif		IN	varchar2
)

return varchar2

IS

w_anagrafe		varchar2(255) := upper(a_anagrafe);
w_tipo_evento	 	varchar2(255) := upper(a_tipo_evento);
w_comune_res		varchar2(255) := nvl(lpad(a_cod_pro_res,3,'0')||lpad(a_cod_com_res,3,'0'),'000000');
w_archivio_rif		varchar2(255) := upper(a_archivio_rif);

w_comune_cliente	varchar2(255);

w_flag			varchar2(1);

errore			exception;

begin
  if a_anagrafe||a_tipo_evento||a_fascia||a_stato||a_cod_pro_res||a_cod_com_res is not null then
     begin
       select id
         into w_comune_cliente
         from menuditta_v
       ;
     exception
       when others then
            raise errore;
     end;

     if w_anagrafe = 'RES' then
        if w_tipo_evento = 'I' then
           if ((a_fascia = 1 and w_archivio_rif ='ANA') 
               or
               (a_fascia = 1 and w_archivio_rif ='ANP' and w_comune_res = w_comune_cliente) 
                or 
               (a_stato = 50) 
              )
           then
              w_flag := '';
           else 
              w_flag := 'S';
           end if;

        elsif w_tipo_evento in ('E','C','R') then
           if ((a_fascia = 1 and w_archivio_rif ='ANA') 
               or
               (a_fascia = 1 and w_archivio_rif ='ANP' and w_comune_res = w_comune_cliente) 
              )
           then
              w_flag := 'S';
           else 
              w_flag := '';
           end if;
       end if;

     elsif w_anagrafe = 'AIR' then
        if w_tipo_evento = 'I' then
           if a_fascia = 3 or a_stato = 50 then
              w_flag := '';
           else 
              w_flag := 'S';
           end if;

        elsif w_tipo_evento in ('E','C','R') then
           if a_fascia = 3 then
              w_flag := 'S';
           else 
              w_flag := '';
           end if;
       end if;

     end if;
  end if;

  return w_flag;

exception
  when errore then
       return null;
  when others then
       return null;
end;
/
