-- La consulta trae datos de la facturacion. Un resumen mostrando 
-- cantidad de ordenes de medicos para la OS. Cantidad de OS valor facturado. 
-- El from esta armado por subconsultas que arman la tabla que se pasara al select principal.
-- Parametros de entrada: Fecha Inicio Fin
-- CREACION 05102020 SHIFTHA

SELECT %NOLOCK
Dados.Unidad,
Dados.Procedencia,
Dados.Convenio,
--SUM(Dados.CantidadOrdenes) CantidadOrdenes,
CONVERT(VARCHAR(7),(SUM(Dados.CantidadOrdenes))) CantidadOrdenes,
SUM(Dados.QuantidadeOs) CantidadOS,
SUM(Dados.QuantidadeProcedimentos) CantidadExamenes,
SUM(Dados.ValorBrutoFatura) As ValorBrutoFacturado
FROM
   (SELECT %NOLOCK
   (SELECT %NOLOCK Posto||'-'||Posto->UnidadeAtendimentoId->Descricao FROM dado.ArqOrdemServico AOS WHERE AOS.Id = osp.os) Unidad,
   (SELECT %NOLOCK Posto||'-'||Posto->Descricao FROM dado.ArqOrdemServico AOS WHERE AOS.Id = osp.os) Procedencia,
   osc.FontePagadora->Descricao As Convenio,
   --COUNT(DISTINCT DCOrden.OS) AS CantidadOrdenes,
   CASE 
	WHEN len(DCOrden.resposta) = 10 THEN COUNT(DISTINCT DCOrden.resposta)
	WHEN len(DCOrden.resposta) = 21 THEN COUNT(DISTINCT DCOrden.resposta) + 1
	WHEN len(DCOrden.resposta) = 32 THEN COUNT(DISTINCT DCOrden.resposta) + 2
   END CantidadOrdenes,
   COUNT(DISTINCT osc.Os) As QuantidadeOs,
   COUNT(DISTINCT osp.Procedimento) As QuantidadeProcedimentos,
   (SELECT %NOLOCK SUM(ValorBrutoFatura) FROM dado.TblOsCobranca WHERE osc.Os = Os) As ValorBrutoFatura
   FROM dado.TblOsCobranca osc  
   JOIN dado.TblLogOperacao l ON osc.Os = l.Dado2 AND l.LogId = '055'
   JOIN dado.TblOsProcedimentoAC osp ON osp.Os = osc.Os
   LEFT JOIN dado.TblOsDadoCadastral DCOrden ON osc.Os = DCOrden.OS AND DCOrden.DadoCadastral = 3
   JOIN dado.TblOsGuia OSGUI ON DCOrden.Resposta = OSGUI.NumeroGuia AND OSGUI.StatusAtual = 'Verificada'
           WHERE l.Data BETWEEN ? AND ?
           GROUP BY osc.FontePagadora, osc.Os) As Dados
       GROUP BY Dados.Convenio
