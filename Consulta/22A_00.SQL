--FINAL CON PARAMETRO
--La siguiente consulta trae resultados de covid 19 para los examenes pasados en el 
--where de la consulta
--Ademas tiene una subconsulta donde trae el dato de la fecha y hora de la ultima firma
--Creacion 28072020 SHIFTHA
--LOS PARAMETROS DE ENTRADA SON FECHA DE FIRMA
--LA CONSULTA SE PUEDE UTILIZAR PARA CUALQUIER EXAMEN
--Actualizada 29072020

SELECT 
     RES.Procedimento->Os->Paciente->PessoaFisica->Nome NombrePaciente,
	 RES.Procedimento->Os->Paciente->PessoaFisica->PaisId->Descricao Nacionalidad,
	 RES.Procedimento->Os->CodigoOs NumeroDeLaOS,
	 RES.Procedimento->Os->Paciente->PessoaFisica->Cpf DNI,
     RES.Procedimento->Procedimento->Mnemonico SiglaExamen,
     RES.Procedimento->Procedimento->Descricao DescripcionExamen,
	 RES.Parametro->Apelido SiglaParametro,
     RES.Parametro->Descricao DescripcionParametro,
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
	 END Resultado
FROM
     dado.TblResultado RES
join
   dado.TblOsExameSolicitante EXA ON  RES.Procedimento = EXA.OsProcedimento
WHERE
	RES.Procedimento->Os->Data BETWEEN ? AND ? 
    AND RES.Procedimento->Procedimento->Mnemonico IN('COVID19','COVIDH','COV19AUT','COVIDATM','COVIDDOM','COVHISPO')
	AND RES.Procedimento->Status IN('AS','CW','DP','DW','EE','EM','EN','EX','IA','IF','IH','IP','LE','OK','RP')
	AND RES.LogAssinaturaId IS NOT NULL
	AND RES.Processo <> 1
GROUP BY RES.Procedimento,RES.Parametro