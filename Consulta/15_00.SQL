--La consulta trae datos de los convenio con su grupo y la unidad financiera 
--Creada 04062020 SHIFTHA

SELECT 
	CONV.ID CodigoConvenio,
	CONV.CodigoCliente->PessoaJuridicaId->Apelido SiglaConvenio,
    CONV.CodigoCliente->PessoaJuridicaId->NomeFantasia DescripcionConveio,
	CONV.Status EstadoConvenio,
    CONV.Grupo->Descricao Grupo,
    PRE.Descricao TablaPrecio,
    PRE.Status EstadoTPrecio,
	U.UnidadeId->ValorAtual ValorActual
FROM
	dado.TblConvenio CONV
JOIN
	dado.TblPreco PRE ON   CONV.Tabela = PRE.ID
JOIN
    dado.TblComponentePrecoFontePagadora U ON CONV.ID = U.FontePagadoraId