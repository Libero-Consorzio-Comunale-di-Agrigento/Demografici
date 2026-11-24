--liquibase formatted sql
--changeset amonopoli:202512101130 runOnChange:true stripComments:false
create or replace function f_TPR_numera_pratica
(a_anagrafe		in 	varchar2
,a_tipo_evento		in 	varchar2
,a_anno_pratica 	in 	number
,a_provvisorio		in	varchar2
)

return number

IS

w_anagrafe		varchar2(255) := upper(a_anagrafe);
w_tipo_evento   	varchar2(255) := upper(a_tipo_evento);

w_n03_air_u_inp		varchar2(255);

w_pratica		number;

begin
  if w_anagrafe = 'AIR' and w_tipo_evento in ('C','E') then
     w_n03_air_u_inp := f_valore_inp('N03_AIR_U',1,1,'X','S');
     if nvl(w_n03_air_u_inp,'N') = 'S' then
        w_tipo_evento := 'U';
     end if;
  end if;

  if a_anno_pratica is not null and 
     a_anagrafe     is not null and
     a_tipo_evento  is not null
  then
     if a_provvisorio is not null then
        begin
          select nvl(min(pratica),0) - 1
            into w_pratica
            from anatpr
           where anagrafe 	= w_anagrafe
             and tipo_evento 	= w_tipo_evento
             and anno_pratica	= a_anno_pratica
             and pratica        < 0 
          ;
        exception 
          when no_data_found then
               w_pratica := -1;
          when others then 
               w_pratica := '';
        end;

     elsif a_provvisorio is null then
        begin
          select numero + 1
            into w_pratica
            from anan03
           where anagrafe 	= w_anagrafe
             and tipo_evento 	= w_tipo_evento
             and anno 		= a_anno_pratica
          ;
        exception 
          when no_data_found then
               w_pratica := 1;
          when others then 
               w_pratica := '';
        end;

        begin
          insert into anan03
                 (ANAGRAFE, TIPO_EVENTO, ANNO, NUMERO)
          select w_anagrafe, w_tipo_evento, a_anno_pratica, w_pratica
            from dual
           where not exists (select 1 from anan03 b
                              where b.anagrafe    = w_anagrafe
                                and b.tipo_evento = w_tipo_evento
                                and b.anno        = a_anno_pratica)
          ;         
          update anan03
             set numero = w_pratica
           where anagrafe    = w_anagrafe
             and tipo_evento = w_tipo_evento
             and anno        = a_anno_pratica
          ;
        exception
          when others then
               null;
        end;
     end if;

  end if;

  return w_pratica;
end;
/
