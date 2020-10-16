--Creada 17042020 SHIFTHA
--Ultima actualizacion 20042020 SHIFTHA
--Se agrega filtro de status y filtro RES.LogAssinaturaId IS NOT NULL
--Sin el filtro RES.LogAssinaturaId IS NOT NULL no trae el actual resultado.. 
--Siempre que haya sido modificado. Es por ello que se necesita ese filtro

SELECT 
     RES.Procedimento->Os->Paciente->PessoaFisica->Nome NombrePaciente,
     RES.Procedimento->Os->Paciente->PessoaFisica->Cpf DNI,
     RES.Procedimento->Os->Data FechaOS,
     RES.Procedimento->Os->CodigoOs NroOS,
     RES.Procedimento->FontePagadoraId->CodigoCliente->PessoaJuridicaId->NomeFantasia Convenio,
     EXA.Solicitante->pessoafisica->nome MedicoSolicitante,
     RES.Procedimento->Procedimento->Mnemonico SiglaExamen,
     RES.Procedimento->Procedimento->Descricao DescripcionExamen,
	 RES.Parametro->Apelido SiglaParametro,
     RES.Parametro->Descricao DescripcionParametro,
     NVL(ResAlfaNumerico,'')||NVL((SELECT Laudo FROM dado.TblLaudo WHERE ID %Inlist 
     ResLaudo),'') Resultado

FROM
     dado.TblResultado RES
join
   dado.TblOsExameSolicitante EXA ON  RES.Procedimento = EXA.OsProcedimento
WHERE
     RES.Procedimento->Os->Data BETWEEN ? AND ? 
	 --En la fila debajo se informa la sigla de los examenes que traera la consulta
    AND RES.Procedimento->Procedimento->Mnemonico IN('COVID19H','COVID19A','COVID19T','COVID19E','COVID19L','INFCOVAN','INFCOVAT','INFCOVES','INFCOVHN','INFCOVLB')
	AND RES.Procedimento->Status IN('AS','CW','DP','DW','EE','EM','EN','EX','IA','IF','IH','IP','LE','OK','RP')
	AND RES.LogAssinaturaId IS NOT NULL
GROUP BY RES.Procedimento,RES.Parametro