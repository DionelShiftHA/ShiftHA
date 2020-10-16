--La consulta trae datos de la facturacion. 
--Cantidad de recipientes, cantidad de examenes, valores facturados. 
--Recibe fecha como parametros de entrada

SELECT
Dados.Grupo,
Dados.Convenio,
Dados.Bairro,
SUM(Dados.QuantidadeOs) As "Cantidad de OS",
SUM(Dados.QuantidadeRecipientes) As "Cantidad de Recipientes",
SUM(Dados.QuantidadeProcedimentos) As "Cantidad de Exámenes",
SUM(Dados.ValorBrutoFatura) As "Valor bruto Facturado",
SUM(Dados.ValorBrutoBalcao) As "Valor bruto Ventanilla",
SUM(Dados.RecebidoBalcao) As "Valor recibido Ventanilla"
FROM
   (SELECT
   osc.FontePagadora->Grupo->Descricao As Grupo,
   osc.FontePagadora->Descricao As Convenio,
   (SELECT b.BairroDescricao FROM dado.TblCepBairro b WHERE b.Id = $LISTGET(osc.FontePagadora->CodigoCliente->PessoaJuridicaId->EnderecoBairro, 1)) AS Bairro,
   COUNT(DISTINCT osc.Os) As QuantidadeOs,
   COUNT(DISTINCT l.Dado1) As QuantidadeRecipientes,
   COUNT(DISTINCT osp.Procedimento) As QuantidadeProcedimentos,
   (SELECT SUM(ValorBrutoFatura) FROM dado.TblOsCobranca WHERE osc.Os = Os) As ValorBrutoFatura,
   (SELECT SUM(ValorBrutoBalcao) FROM dado.TblOsCobranca WHERE osc.Os = Os) As ValorBrutoBalcao,
   (SELECT SUM(RecebidoBalcao) FROM dado.TblOsCobranca WHERE osc.Os = Os) As RecebidoBalcao
   FROM dado.TblOsCobranca osc
   INNER JOIN dado.TblLogOperacao l ON osc.Os = l.Dado2 AND l.LogId = '055'
   INNER JOIN dado.TblOsProcedimentoAC osp ON osp.Os = osc.Os
           WHERE l.Data BETWEEN ? AND ?
           GROUP BY osc.FontePagadora, osc.Os) As Dados
       GROUP BY Dados.Convenio