--La consulta trae resultados de los exámenes con código :(1505,1506,1508)
--Creación 03072020 SHIFTHA

SELECT 
     RES.Procedimento->Os->Data FechaOS,
     RES.Procedimento->Os->CodigoOs NumeroDeLaOS,
     RES.Procedimento->Procedimento->Mnemonico SiglaExamen,
     RES.Procedimento->Procedimento->Descricao DescripcionExamen,
	 RES.Parametro->Apelido SiglaParametro,
     RES.Parametro->Descricao DescripcionParametro,
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
    AND RES.Procedimento->Procedimento->ID IN(1505,1506,1508)
	AND RES.Procedimento->Status IN('AS','CW','DP','DW','EE','EM','EN','EX','IA','IF','IH','IP','LE','OK','RP')
	AND RES.LogAssinaturaId IS NOT NULL
	AND RES.Processo <> 1
GROUP BY RES.Procedimento,RES.Parametro