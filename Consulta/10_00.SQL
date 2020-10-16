--La consulta trae datos de los exámenes y tiempos de proceso. Ademas las instrucciones
--de envió y el método del proceso analítico
--Creación 26052020 SHIFTHA

SELECT
   EXA.ID Codigo,
   EXA.Mnemonico Sigla, 
   EXA.Descricao Descripcion,
   CASE 
     WHEN EXA.PrazoRotinaUtilizaRotina ='Sim' THEN 'SI'
     WHEN EXA.PrazoRotinaUtilizaRotina ='Não' THEN 'NO'
   END UtilizaRutina,
   EXA.PrazoRotinaTipo TipoDePlazo,
   CASE
       WHEN EXA.PrazoRotinaTipo = 'Hora(s)' THEN CONVERT(VARCHAR(8),DATEADD(SECOND,EXA.PrazoCodigoRotina,0),114)
   ELSE CASE 
        WHEN EXA.PrazoRotinaUtilizaRotina ='Não' THEN NVL(EXA.PrazoCodigoRotina,'')||(' ')||NVL(PLA.Descricao,'')
        WHEN EXA.PrazoRotinaUtilizaRotina ='Sim' THEN SUBSTRING(NVL(EXA.PrazoCodigoRotina,'')||(' ')||NVL(PLA.Descricao,''),4,30)
        END
   END Plazo,
   EXA.PrazoMinimoTipo PlazoMinimoTipo,
   CASE
	WHEN EXA.PrazoMinimoTipo = 'Hora(s)' THEN CONVERT(VARCHAR(8),DATEADD(SECOND,EXA.PrazoMinimo,0),114)
	ELSE EXA.PrazoMinimo
	END PlazoMinimo,
	EXAI.InstrucaoId->Valor Instruccion,
	(select TOP 1 PAE.ProcessoAnaliticoId->Metodo->Descricao 
	from dado.TblProcessoProcedimento PAE
	where PAE.ProcedimentoId = EXA.Id AND PAE.ProcessoAnaliticoId->Metodo->Id IS NOT NULL) Metodo
FROM 
   dado.tblExame EXA
LEFT JOIN
 dado.TblRotinaPrazo PLA ON EXA.PrazoCodigoRotina = PLA.ID1
LEFT JOIN 
	dado.tblExameInstrucao EXAI ON EXA.Id = EXAI.ProcedimentoId 
JOIN
	dado.TblMascara MAS ON EXA.Id = MAS.ProcedimentoId AND MAS.Padrao = 'Sim'
WHERE
   EXA.Status = 'Ativo' AND EXAI.InstrucaoId->Tipo = 'Encaminhamento'
ORDER BY 
   EXA.Descricao
