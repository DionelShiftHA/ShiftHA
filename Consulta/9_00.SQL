--La consulta trae la unidad de coleta, el convenio y la cantidad de OS cargadas
--para ese convenio en un determinado tiempo
--Creacion 21052020 shfitHA 

SELECT
Dados.UnidadeColeta,
Dados.Convenio,
SUM(Dados.QuantidadeOs) As "Cantidad de OS"
FROM
   (SELECT
   osc.Os,
   osc.FontePagadoraId->Descricao As Convenio,
   COUNT(DISTINCT osc.Os) As QuantidadeOs,
   (SELECT Posto||'-'||Posto->Descricao FROM dado.ArqOrdemServico AOS WHERE AOS.Id = osc.os) UnidadeColeta
   FROM dado.TblOsProcedimento osc
   INNER JOIN dado.TblLogOperacao l ON osc.Os = l.Dado1 AND l.LogId = '001'
   JOIN  dado.TblOsDadoCadastral DCORDEN ON  osc.os = DCORDEN.OS AND DCORDEN.DadoCadastral = 3
   WHERE l.Data BETWEEN ? AND ?
   GROUP BY  osc.Os) As Dados
GROUP BY Dados.UnidadeColeta,Dados.Convenio
ORDER BY Dados.UnidadeColeta