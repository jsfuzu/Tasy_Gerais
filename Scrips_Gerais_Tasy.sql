-- Contar quantos registros em uma Tabela
select count(*)
from MATERIAL_ESTAB
where 1 = 1
and cd_material in (91933,91934,91935,91936,91937,91994,91995,91996,91997,92010,92011,91921,92134,91971,92029,92030,92031,92032,92046,92047,
92055,92056,92086,92087,92088,92101,92102,92103,92104,92117,92118,92127,92128,92129,91919,91920,92135,92136,92137,92138,92139,92140,92141,92142,
91972,91973,92105,91943,91964,91965,91966,91967,91968,91969,91970,91990,91991,91992,92040,92043,92083,92084,92085,91923,91924,91925,91926,91927,
91928,91929,91930,91931,91932,85463,76049,91922,91998,92001,91999,92000,92033,92034,92035,92036,92037,92038,92039,92041,92042,92057,92058,92089,
92098,92090,92091,92092,92093,92094,92095,92096,92097,91938,91974,91975,91976,91977,91978,91979,91980,91981,91982,91983,91984,91987,91985,91986,
91988,91989,91993,92048,92049,92050,92051,92052,92053,92054,92059,92060,92061,92062,92063,92064,92065,92066,92067,92068,92069,92070,92071,92072,
92073,92074,92075,92076,92077,92078,92079,92080,92081,92082,92130,92131,91939,91940,91941,91942,91944,91945,91946,91947,91948,91949,91950,91951,
91952,91953,91954,91955,91956,91957,91958,91959,91960,91961,91962,91963,92002,92003,92004,92005,92006,92007,92008,92009,92012,92013,92014,92015,
92016,92017,92018,92019,92020,92021,92022,92023,92024,92025,92027,92028,92026,92044,92045,92099,92100,92106,92107,92108,92109,92110,92111,92112,
92113,92114,92115,92116,92119,92120,92121,92122,92123,92124,92125,92126,92132,92133,92556,92557,92558,92559,92560,92561,92562,92563,92564,92565,
92566,92567,92568,92569,92570,92571,92572,92573,92574,92575,92576,92577,92578,92579,92580,92581,92582,92583,92584,92585,92586,92587,92588,92589,
92591,92590,92592,92597,92599,92600,92601,92602,92603,92604,92605,92606,92607,92608,92609,92610,92611,92612,92613,92614,92615,92616,92617,92618,
92619,92401,92777,92778,92779,92780,92781,92782,92783,92784,92785,92786,92787,92788,92789,92790,92791,92792,92793,92794,92795,92796,92797,92798,
92799,92800,92801,92802,92803,92804,92805,92806,92807,92808,92809,92810,92811,92812,92813,92814,92815,92816,73982,92930,92931,92932,92933,92934,
92935,92936,92938,92939,92940,92941,92942,92943,92944,92945,92946,92947,92948,92949,92950,92951,92952,92953)

-----------------------------------------------------------------------------------------------------------------------------------------------

-- Obter informações de um campo em uma avaliação da Gestão da Qualidade
select  distinct a.*,
             obter_result_avaliacao(a.nr_sequencia,983) Sexo         
    from     qua_avaliacao a,
             qua_avaliacao_result b
    where    a.nr_sequencia = b.nr_seq_avaliacao
    and      nr_seq_tipo_avaliacao = 66
    --and      nr_sequencia = 1370
    and     cd_estabelecimento = 1
    order by a.dt_avaliacao 
-------------------------------------------------------------------------------------------------------------------------------------------------

-- Criar um update na base, informando a GMUD e tratando o campo data corretamente
update CATEGORIA_PLANO set dt_final_vigencia = (to_date('31/12/2022 00:00:01','dd/mm/yyyy hh24:mi:ss')), dt_atualizacao = (to_date('28/02/2023 12:05:00','dd/mm/yyyy hh24:mi:ss')), nm_usuario = 'GMUD000805' where  nr_sequencia = 33768;
--------------------------------------------------------------------------------------------------------------------------------------------------

-- Function de exemplo do Banco do Tasy (Alterada pelo Analista Jesse e criado um novo objeto no Banco)
create or replace function OPTY_OBTER_RESULT_AVALIACAO_QUA(
					nr_seq_avaliacao_p		NUMBER,
					nr_seq_item_p			NUMBER)

					return VARCHAR2 is
-- GMUD000810
/*
  B - Booleano
  D - Descrição
  M - Multiseleção
  S - Seleção Simples
  O - Valor Domínio
  C - Seleção Simples
  L - Cálculo
  T - Título
  V - Valor
  U - Seleção Simples (Radio Group);
*/
type ValorComplemento is record (	ds_valor	varchar2(2000));
type Dados is table of ValorComplemento index by binary_integer;
ds_resultado_w			VARCHAR2(4000);
qt_resultado_w			NUMBER(15,4);
ie_resultado_w			VARCHAR2(02);
cd_funcao_w			NUMBER(05,0);
nr_seq_prontuario_w		number(5);
cd_dominio_w			NUMBER(5);
ds_complemento_w			VARCHAR2(4000);
ds_retorno_w			varchar2(4000);
i				INTEGER;
ds_texto_w			VARCHAR2(255);
pos_w				number(10);
complemento_w			Dados;
ds_comando_w			varchar2(2000);
cursor_long_w     integer;
result_cursor_w   number;
ds_result_long_w  varchar2(4000);
long_len_w  	  number;
buflen_w    	  number := 4000;
curpos_w    	  number := 0;
begin
select		nvl(a.cd_funcao, 0),
		nvl(a.nr_seq_prontuario, 0)
into		cd_funcao_w,
		nr_seq_prontuario_w
from		med_item_avaliar b,
		med_tipo_avaliacao a
where		a.nr_sequencia	= b.nr_seq_tipo
and		b.nr_sequencia	= nr_seq_item_p;
ds_resultado_w			:= '';
select	ie_resultado,
	cd_dominio,
	ds_complemento || ';'
into 	ie_resultado_w,
	cd_dominio_w,
	ds_complemento_w
from 	med_item_avaliar
where nr_sequencia	= nr_seq_item_p;
if	(nr_seq_prontuario_w = 194) then
	begin
	select		max(qt_resultado),
			max(ds_resultado)
	into 		qt_resultado_w,
			ds_resultado_w
	from		atend_check_list_result
	where		nr_seq_checklist	= nr_seq_avaliacao_p
	and		nr_seq_item		= nr_seq_item_p;
	end;
else
	begin
	if	(cd_funcao_w	= 2000) then
		begin
		select		qt_resultado,
				ds_resultado
		into 		qt_resultado_w,
				ds_resultado_w
		from		sac_pesquisa_result
		where		nr_seq_pesquisa	= nr_seq_avaliacao_p
		and		nr_seq_item	= nr_seq_item_p;
		end;
	elsif	(cd_funcao_w	= 4000) then /* Gestão da Qualidade */
		begin
		select		qt_resultado,
				    ds_resultado
		into 		qt_resultado_w,
				    ds_resultado_w
		from		qua_avaliacao_result
		where		nr_seq_avaliacao	= nr_seq_avaliacao_p
		and		    nr_seq_item	= nr_seq_item_p;
		end;
	elsif	(cd_funcao_w	= 299) then /* Ordem de serviço */
		begin
		select		qt_resultado,
				ds_resultado
		into 		qt_resultado_w,
				ds_resultado_w
		from		man_ordem_serv_aval_result
		where		nr_seq_ordem_serv_aval	= nr_seq_avaliacao_p
		and		nr_seq_item		= nr_seq_item_p;
		end;
	elsif	(cd_funcao_w	= 230) then /* Cadastro de Funcionários */
		begin
		select		qt_resultado,
				ds_resultado
		into		qt_resultado_w,
				ds_resultado_w
		from		pessoa_avaliacao_result
		where		nr_seq_avaliacao	= nr_seq_avaliacao_p
		and		nr_seq_item	= nr_seq_item_p;
		end;
	elsif	(cd_funcao_w	= 3004) then /* Cadastro de Funcionários */
		begin
		select		qt_resultado,
				ds_resultado
		into		qt_resultado_w,
				ds_resultado_w
		from		autorizacao_conv_av_result
		where		nr_seq_autor_conv_aval	= nr_seq_avaliacao_p
		and		nr_seq_item		= nr_seq_item_p;
		end;		
	else
		begin
		select		max(qt_resultado),
				max(ds_resultado)
		into 		qt_resultado_w,
				ds_resultado_w
		from		med_avaliacao_result
		where		nr_seq_avaliacao	= nr_seq_avaliacao_p
		and		nr_seq_item	= nr_seq_item_p;
				
		if (ds_resultado_w is null) and
		   (ie_resultado_w = 'P') then
			begin
			cursor_long_w := dbms_sql.open_cursor;
			
			dbms_sql.parse( cursor_long_w, /*Jesse - Altarada tabela para trazer resultados de Avaliações da Gestão da Qualidade*/
							'select ds_result_long from qua_avaliacao_result where nr_seq_avaliacao	= :nr_seq_avaliacao and nr_seq_item	= '||nr_seq_item_p,
							 dbms_sql.native );
			dbms_sql.bind_variable( cursor_long_w, ':nr_seq_avaliacao', nr_seq_avaliacao_p );

			dbms_sql.define_column_long(cursor_long_w, 1);
			result_cursor_w := dbms_sql.execute(cursor_long_w);

			if (dbms_sql.fetch_rows(cursor_long_w)>0) then
				dbms_sql.column_value_long(cursor_long_w, 1, buflen_w, curpos_w ,
										   ds_result_long_w, long_len_w );
			end if;
			dbms_sql.close_cursor(cursor_long_w);
			ds_resultado_w := ''|| ds_result_long_w;
			exception
				when others then
					ds_resultado_w := '';
			end;
		end if;		
		end;
	end if;
	end;
end if;
if	(ie_resultado_w = 'B') then
	begin
	if	(nvl(qt_resultado_w,0) = 0) then
		ds_resultado_w	:= 'N';
	else
		ds_resultado_w	:= 'S';
	end if;
	if(pkg_i18n.get_user_locale()='en_AU') then
		ds_resultado_w := obter_valor_dominio (6,ds_resultado_w);
	end if;
	end;
elsif	(ie_resultado_w = 'D') or
	(ie_resultado_w = 'C') then
	begin
	ds_resultado_w	:= ds_resultado_w;
	end;
elsif	(ie_resultado_w = 'V') then
	ds_resultado_w	:= qt_resultado_w;
elsif	(ie_resultado_w = 'U') then	/*Elemar e Philippe OS 186211*/
	
	if	(cd_dominio_w is null) then
		for i in 0..100 loop
			ds_texto_w		:= substr(ds_complemento_w, 1, instr(ds_complemento_w,';') - 1);
			ds_complemento_w        := replace(ds_complemento_w, ds_texto_w || ';', '');
			if	(i = qt_resultado_w) then
				ds_resultado_w	:= ds_texto_w;
				exit;
			end if;
		end loop;
	else
		if	(ds_resultado_w	is null) then
			begin
				select	nvl(max(ds_valor_dominio),'')
				into	ds_resultado_w
				from	med_valor_dominio
				where	nr_seq_dominio = cd_dominio_w
				and	to_number(vl_dominio) = qt_resultado_w;
			exception
			when others then
				ds_resultado_w	 := null;
			end;
		end if;
	end if;
	if	(nvl(ds_resultado_w,'') = '') then
		ds_resultado_w	:= qt_resultado_w;
	end if;
elsif	(ie_resultado_w = 'L') then
	ds_resultado_w	:= to_char(qt_resultado_w, 'fm999990.00');
elsif	(ie_resultado_w = 'O') or
	(ie_resultado_w = 'S') then
	begin
	if	(qt_resultado_w = 0) or
		(qt_resultado_w is null) then
		ds_resultado_w	:= ds_resultado_w;
	else
		ds_resultado_w	:= qt_resultado_w;
	end if;
	end;
elsif	(ie_resultado_w	= 'Z') then
	begin
	pos_w	:= instr(ds_complemento_w,';');
	i	:= 0;
	while (pos_w	> 0) loop 
		begin
		complemento_w(i).ds_valor	:= substr(ds_complemento_w,1,pos_w-1);
		ds_complemento_w		:= substr(ds_complemento_w,pos_w+1,2000);
		i	:= i+1;
		pos_w	:= instr(ds_complemento_w,';');
		end;
	end loop;
	if	(complemento_w.count	>= 8)then
		ds_comando_w	:= 'select	'||complemento_w(8).ds_valor||
				    ' from	'||complemento_w(6).ds_valor||
				    ' where	'||complemento_w(7).ds_valor  ||' = :ds_result';
		ds_retorno_w	:=	Obter_select_concatenado_bv(	ds_comando_w,
								'ds_result='||ds_resultado_w||';','');
		if	(ds_retorno_w	is not null)then
			ds_resultado_w	:= ds_resultado_w||' - '||ds_retorno_w;
		end if;
	end if;
	end;
end if;
return ds_resultado_w;
end OPTY_OBTER_RESULT_AVALIACAO_QUA;
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Pesquisar atendimento duplicado, a base lógica do script tem aplicação para CPR da Pessoa Física, Nota, etc...

Select
NR_ATENDIMENTO,
substr(obter_nome_pf(t1.cd_pessoa_fisica),1,255) NOME_PESSOA,
to_char(t1.dt_entrada,'dd/mm/yyyy hh24:mi:ss') DATA_ENTRADA,
to_char(t1.dt_alta,'dd/mm/yyyy hh24:mi:ss') DATA_ALTA,
obter_nome_usuario(t1.nm_usuario_atend) USUARIO_ATEND
From atendimento_paciente t1
Where       exists (select dt_entrada, cd_pessoa_fisica
                    from atendimento_paciente t2
                    where t2.dt_entrada = t1.dt_entrada
                    and   t2.cd_pessoa_fisica = t1.cd_pessoa_fisica
                    and cd_estabelecimento = :cd_estabelecimento
                    group by dt_entrada, cd_pessoa_fisica 
                    having count(*) > 1)
                    order by t1.NR_ATENDIMENTO
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Procurar por Tabelas no Tasy
select * from all_all_tables where table_name like '%ATUALIZACAO%'
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Trazer informações com base no dbms_lob, para campo do tipo long, e isso vai depender da versão do Oracle
select (select obter_desc_material(b.cd_material) from paciente_atend_medic b 
                                                  where b.nr_seq_atendimento = 15418 --:nr_seq_atendimento
                                                  and b.nr_seq_diluicao = a.nr_seq_material
                                                  and   b.nr_seq_diluicao is not null
                                                  and   b.ie_agrupador = 3) ||
       (select distinct dbms_lob.substr(wm_concat(obter_desc_material(b.cd_material)),4000,1) from paciente_atend_medic b 
                                                  where b.nr_seq_atendimento = 15418 --:nr_seq_atendimento
                                                  and b.nr_seq_diluicao = a.nr_seq_material
                                                  and   b.nr_seq_diluicao is not null
                                                  and   ((b.ie_agrupador = 9) or (b.ie_agrupador is null))) ds_diluente
from paciente_atend_medic a
where  a.nr_seq_atendimento = 15418 --:nr_seq_atendimento
and    a.nr_seq_diluicao is null
and    a.nr_seq_medic_material is null
and    a.ie_cancelada = 'N'
and    a.nr_seq_solucao is null
and    obter_estrutura_material(a.cd_material, 'G') = 1
order  by a.nr_agrupamento, a.nr_seq_material
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Verifica quais talebas filho de FK			
SELECT
      UC.CONSTRAINT_NAME CONSTRAINT_NAME, UC.TABLE_NAME CHILD_TABLE, UCC.COLUMN_NAME CHILD_COLUMN, UCR.TABLE_NAME PARENT_TABLE,
      UCCR.COLUMN_NAME PARENT_COLUMN
FROM  USER_CONSTRAINTS UC INNER JOIN USER_CONSTRAINTS UCR ON UCR.CONSTRAINT_NAME = UC.R_CONSTRAINT_NAME
      INNER JOIN USER_CONS_COLUMNS UCC ON UCC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME
      AND UC.TABLE_NAME = UCC.TABLE_NAME INNER JOIN USER_CONS_COLUMNS UCCR ON UCCR.CONSTRAINT_NAME = UCR.CONSTRAINT_NAME
      AND UCR.TABLE_NAME = UCCR.TABLE_NAME
      AND UCCR.POSITION = UCC.POSITION
WHERE UCR.TABLE_NAME IN ('REGRA_APRESENTACAO_QUIMIO') --COLOCAR A TABELA PARA SER ANALISADA
      AND UCR.CONSTRAINT_TYPE IN( 'P','U')
ORDER BY CHILD_TABLE, CONSTRAINT_NAME, CHILD_COLUMN

--- Esta query mostra todas as FKs de uma Tabela
SELECT TABLE_NAME,
       CONSTRAINT_NAME 
  FROM USER_CONSTRAINTS 
WHERE TABLE_NAME = 'REGRA_APRESENTACAO_QUIMIO'
   AND CONSTRAINT_TYPE = 'R'
ORDER BY 1,2;

--- Esta query mostra todas as FKs de uma tabela e as colunas que compoe cada uma delas
--- Lembrando que uma FK pode ser composta por mais de uma coluna
--- C = Check; P = Primary Key; R = Foreign Key; U = Unique Key; O = READ ONLY em uma VIEW; V = Check em uma VIEW 
SELECT CONSTRAINT_NAME,COLUMN_NAME,POSITION
  FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME IN
       (SELECT CONSTRAINT_NAME 
          FROM USER_CONSTRAINTS 
        WHERE TABLE_NAME = 'REGRA_APRESENTACAO_QUIMIO'
            AND CONSTRAINT_TYPE = 'R')
ORDER BY 1,2;
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Consultar Usuario por CPF 

select distinct
b.CD_PESSOA_FISICA,
a.NM_USUARIO LOGIN,
a.DS_LOGIN LOGIN_ALTERNATIVO,
A.DS_USUARIO NOME_USUARIO,
b.NM_PESSOA_FISICA,
b.DS_CODIGO_PROF,
b.NR_CPF,
b.NR_IDENTIDADE,
c.NM_GUERRA,
c.NR_CRM,
a.IE_SITUACAO SITUACAO_USUARIO,
c.IE_SITUACAO SITUACAO_MEDICO,
tasy.obter_valor_param_usuario(0,87,0,a.nm_usuario,A.cd_estabelecimento) TIPO_AUT,
tasy.obter_valor_dominio(2071,tasy.obter_valor_param_usuario(0,87,0,a.nm_usuario,A.cd_estabelecimento)) AUTENTICACAO_LOGIN,
tasy.OBTER_NOME_ESTAB(A.CD_ESTABELECIMENTO) ESTAB_PRINCIPAL,
tasy.OBTER_NOME_ESTAB(D.CD_ESTABELECIMENTO) ESTAB_ADICIONAL
    
from tasy.USUARIO A, tasy.PESSOA_FISICA B, tasy.MEDICO C, tasy.USUARIO_ESTABELECIMENTO D, tasy.USUARIO_PERFIL E

where a.cd_pessoa_fisica(+) = b.cd_pessoa_fisica
and a.nm_usuario = d.nm_usuario_param(+)
and a.nm_usuario = e.nm_usuario(+)
and b.cd_pessoa_fisica = c.cd_pessoa_fisica(+)
and b.NR_CPF in ('15210417760')

order by 4
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Instruções gerais para criar uma Job no Tasy
-- SEMPRE INSIRA O NOME DO SCHEMA ANTES DO NOME DO JOB... EXEMPLO: TASY.NOME_JOB
-- CREATE JOB

alter session set current_schema=tasy;
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'NOME_DO_JOB_AQUI',
            job_type => 'PLSQL_BLOCK',
            job_action => 'GERAR_ALTA_AUTOMATICA;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-03-26 01:00:00.000000000 AMERICA/SAO_PAULO','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'freq=daily; byhour=23; byminute=50; bysecond=0;', -- INTERVALO 1 VEZ AO DIA no horário 23:50
            end_date => NULL, 
            enabled => FALSE,
            auto_drop => TRUE,
            comments => '');   

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'NOME_DO_JOB_AQUI', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_RUNS);
  
    DBMS_SCHEDULER.enable(
             name => 'NOME_DO_JOB_AQUI');
END;
/
-- NOTIFICACAO OPCIONAL
BEGIN
DBMS_SCHEDULER.ADD_JOB_EMAIL_NOTIFICATION (
job_name => 'NOME_DO_JOB_AQUI',
recipients => 'destinatario@teste.com.br',
sender => 'remetente@teste.com.br',
subject => 'TASYPRD - Job Notification-%job_owner%.%job_name%-%event_type%',
body => '%event_type% occured on %event_timestamp%. %error_message%',
events => 'JOB_FAILED, JOB_BROKEN, JOB_DISABLED, JOB_STOPPED' );
END;
/
