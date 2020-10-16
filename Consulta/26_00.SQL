--La consulta trae Datos del paciente y la OS para examen de Covid19. Ademas trae
--datos de alta de muestra y comentarios adicionales de la os. Se Separa en 2 comentarios 
--para poder traerlos en la subconsulta.
--Creacion 25082020 SHIFT HA
--El where tiene un select par poder filtrar por la fecha de firma
--LOS PARAMETROS DE ENTRADA SON FECHA DE FIRMA
--Actualizada 27082020

SELECT 
	RES.Procedimento->Os->Data FechaOS,
	RES.Procedimento->Os->CodigoOs OS,
	RES.Procedimento->Os->Paciente->PessoaFisica->Nome NombrePaciente,
	RES.Procedimento->Os->Paciente->PessoaFisica->Cpf DNI,
	(SELECT Data FROM dado.TblLogOperacao WHERE Dado1 = ORP.RecipienteOs AND %INTERNAL(LogId) = '055' HAVING Id = MAX(Id)) As "Data triagem",
	RES.Procedimento->Procedimento->Mnemonico SiglaExamen,
	(select TOP 1 data from dado.TblLogOperacao LOG 
	  where LOG.Dado2 = RES.Procedimento->Os AND LOG.LogId = '013'
	  order by LOG.id DESC) FechaFirma,
	 CASE
       WHEN RES.ResNumerico <> '' THEN RES.ResNumerico
	   WHEN RES.ResAlfaNumerico <> '' THEN RES.ResAlfaNumerico
	 ELSE (SELECT Laudo FROM dado.TblLaudo WHERE ID %Inlist 
          ResLaudo)
	 END Resultado,
	RES.Procedimento->FontePagadoraId->CodigoCliente->PessoaJuridicaId->NomeFantasia Convenio,
	EXA.Solicitante->pessoafisica->nome MedicoSolicitante,
	(SELECT Resposta from dado.ArqObsOs AROS where AROS.Os = RES.Procedimento->OS AND AROS.Pergunta = 2) ComentarioAdicional,
	RES.Procedimento->Os->Paciente->PessoaFisica->TelefoneNumero Telefono,
	RES.Procedimento->Os->Paciente->PessoaFisica->EnderecoLogradouro Direccion,
	RES.Procedimento->Os->Paciente->PessoaFisica->EnderecoNumero Altuira
		
FROM
     dado.TblResultado RES
JOIN
   dado.TblOsExameSolicitante EXA ON  RES.Procedimento = EXA.OsProcedimento	
JOIN
	dado.TblOsRecipienteProcedimento As ORP ON RES.Procedimento = ORP.OsProcedimento
WHERE
	(select top 1 data from dado.TblLogOperacao L where L.Dado2 = RES.Procedimento->Os AND L.LogId = '013') BETWEEN ? AND ? 
    AND RES.Procedimento->Procedimento->Mnemonico IN('COVID19H','COVID19A','COVID19T','COVID19E','COVID19L','INFCOVAN','INFCOVAT','INFCOVES','INFCOVHN','INFCOVLB')
	AND RES.Procedimento->Status IN('AS','CW','DP','DW','EE','EM','EN','EX','IA','IF','IH','IP','LE','OK','RP')
	AND RES.Parametro->Apelido = 'COVID19'
	AND RES.LogAssinaturaId IS NOT NULL
	AND RES.Processo <> 1
GROUP BY RES.Procedimento,RES.Parametro