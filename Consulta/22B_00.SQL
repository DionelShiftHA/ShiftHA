--FINAL SIN PARAMETRO

--La siguiente consulta trae resultados de covid 19 para los examenes pasados en el 
--where de la consulta
--Ademas tiene una subconsulta donde trae el dato de la fecha y hora de la ultima firma
--Creacion 28072020 SHIFTHA
--Se agrega un CASE para determinar el departamente con un SubString
--El where tiene un select par poder filtrar por la fecha de firma
--LOS PARAMETROS DE ENTRADA SON FECHA DE FIRMA
--SE PUEDE UTILIZAR PARA CUALQUIER EXAMEN
--Actualizada 29072020

SELECT 
     RES.Procedimento->Os->Paciente->PessoaFisica->Nome NombrePaciente,
	 RES.Procedimento->Os->Paciente->PessoaFisica->PaisId->Descricao Nacionalidad,
	 RES.Procedimento->Os->CodigoOs OS,
	 RES.Procedimento->Os->Paciente->PessoaFisica->Cpf DNI,
	 'COVID 19' AS Examen,
	 (select TOP 1 data from dado.TblLogOperacao LOG 
	  where LOG.Dado2 = RES.Procedimento->Os AND LOG.LogId = '013'
	  order by LOG.id DESC) FechaFirma,
	  (select TOP 1 Hora from dado.TblLogOperacao LOG 
	  where LOG.Dado2 = RES.Procedimento->Os AND LOG.LogId = '013'
	  order by LOG.id DESC) HoraFirma,
	 CASE
       WHEN RES.ResNumerico <> '' THEN RES.ResNumerico
	   WHEN RES.ResAlfaNumerico <> '' THEN RES.ResAlfaNumerico
	 ELSE (SELECT Laudo FROM dado.TblLaudo WHERE ID %Inlist 
          ResLaudo)
	 END Resultado,
	 CASE
		WHEN SUBSTRING(RES.Procedimento->Os->CodigoOs,1,3) = '146' THEN 'Maldonado'
		WHEN SUBSTRING(RES.Procedimento->Os->CodigoOs,1,3) = '134' THEN 'Durazno'
		WHEN SUBSTRING(RES.Procedimento->Os->CodigoOs,1,3) IN('161','172') THEN 'Canelones'
		WHEN SUBSTRING(RES.Procedimento->Os->CodigoOs,1,3) IN('128','100','099') THEN 'Paysandu'
		WHEN SUBSTRING(RES.Procedimento->Os->CodigoOs,1,3) IN('202','007','201','202','032','160','177') THEN 'Montevideo'
	ELSE ''
	END Departamento		
FROM
     dado.TblResultado RES
join
   dado.TblOsExameSolicitante EXA ON  RES.Procedimento = EXA.OsProcedimento
WHERE
	(select top 1 data from dado.TblLogOperacao L where L.Dado2 = RES.Procedimento->Os AND L.LogId = '013') BETWEEN ? AND ? 
    AND RES.Procedimento->Procedimento->Mnemonico IN('COVID19','COVIDH','COV19AUT','COVIDATM','COVIDDOM','COVHISPO')
	AND RES.Procedimento->Status IN('AS','CW','DP','DW','EE','EM','EN','EX','IA','IF','IH','IP','LE','OK','RP')
	AND RES.LogAssinaturaId IS NOT NULL
	AND RES.Processo <> 1
GROUP BY RES.Procedimento,RES.Parametro