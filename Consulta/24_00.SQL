--La consulta trae todos los convenios que tienen asociada la tabla de precio... 
--pasada por parámetro.
--Como parámetro se debe pasar el código de la tabla de precios
--Consulta creada 12022020 - Actualizada 14052020 SHIFTHA 

SELECT
 PRE.ID CodigoTPrecio,
   PRE.Descricao TablaPrecio,
   PRE.Status EstadoTPrecio,
   CONV.ID CodigoConvenio,
   CONV.CodigoCliente->PessoaJuridicaId->Apelido,
   CONV.CodigoCliente->PessoaJuridicaId->NomeFantasia,
   U.UnidadeId->ValorAtual ValorActual,
   CONV.Status
from
   dado.TblPreco PRE
join
   dado.TblConvenio CONV ON PRE.ID =  CONV.Tabela 
JOIN
    dado.TblComponentePrecoFontePagadora U ON CONV.ID = U.FontePagadoraId
where 
  PRE.Status = 'Ativo' AND CONV.Status = 'Ativo' AND
  PRE.ID = ?
ORDER BY
   PRE.ID