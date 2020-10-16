--La consulta trae datos de facturacion y OS.
SELECT
   (SELECT Data FROM dado.ArqOrdemServico os WHERE os.Id = log.Dado2) DataOs,
   (SELECT NroIdentificacaoOsLisOrigem FROM dado.ArqOrdemServico os WHERE os.Id = log.Dado2) CodLisOrigem,
   (SELECT CodigoOs FROM dado.ArqOrdemServico os WHERE os.Id = log.Dado2) CodigoOs,
   (SELECT Posto||'-'||Posto->Descricao FROM dado.ArqOrdemServico os WHERE os.Id = log.Dado2) UnidadeColeta,
   (SELECT TOP 1 FontePagadora->CodigoCliente->PessoaJuridicaId->NomeFantasia FROM dado.TblOsCobranca cob WHERE cob.Os = log.Dado2) FontePagadora,
   (SELECT IdPacienteLisOrigem FROM dado.ArqPaciente pf WHERE pf.Id = (SELECT Paciente FROM dado.ArqOrdemServico os WHERE os.Id = log.dado2)) CI,
   (SELECT Descricao FROM dado.TblExame ex WHERE ex.Id = log.Dado1) Procedimento,
   (SELECT mt.Descricao FROM dado.TblExame ex JOIN dado.tblMaterial  mt ON ex.material = mt.id WHERE ex.Id = log.Dado1) Material,
   (SELECT TOP 1 rp.Descricao FROM dado.TblExame ex JOIN dado.TblRecipiente rp ON ex.recipiente = rp.ID WHERE ex.Id = log.Dado1) Recipiente,
   log.Data DataLiberacao,
   (SELECT TOP 1 Data FROM dado.TblLogOperacao log2 WHERE log2.LogId = '068' AND log2.Dado1 = log.Dado1 AND log2.Dado2 = log.Dado2) DataExportacao,
   (SELECT TOP 1 Fatura->DataFechamento FROM dado.TblOsCobranca cob WHERE cob.Os = log.Dado2 AND ((cob.Composto=log.Dado1) OR (cob.Composto IS NULL AND cob.Procedimento = log.Dado1))) DataFechamento,
   (SELECT SUM(cob.ValorBrutoFatura) FROM dado.TblOsCobranca cob WHERE cob.Os = log.Dado2 AND ((cob.Composto=log.Dado1) OR (cob.Composto IS NULL AND cob.Procedimento = log.Dado1))) ValorFaturado
FROM
   dado.TblLogOperacao log
WHERE
   LogId = '013' AND 
   Data BETWEEN ? AND ? 
GROUP BY
   log.Dado1,log.Dado2
ORDER BY
   log.Dado2