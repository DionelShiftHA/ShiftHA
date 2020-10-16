--La consulta trae datos de la Getion de contrato. Convenio examen y datos de la Gestion de contrato 
--siempre que el examen tenga gestion.
--Creacion 09062020 SHIFTHA

SELECT 
	GC.FontePagadoraId->Id CodigoConvenio,
	GC.FontePagadoraId->CodigoCliente->PessoaJuridicaId->Apelido SiglaConvenio,
	GC.FontePagadoraId->CodigoCliente->PessoaJuridicaId->NomeFantasia DescripcionConveio,
	GC.FontePagadoraId->Tabela->descricao TablaPrecio,
	GCE.ProcedimentoId->ID CodigoExamen,
	GCE.ProcedimentoId->Mnemonico Sigla, 
	GCE.ProcedimentoId->Descricao Descripcion,
	GCE.TabelaPrecoId->Descricao TablaPreciosGC,
	GCE.TabelaPrecoId->Status EstadoTablaPreciosGC,
	GCEC.UnidadeFinanceiraId->Descricao UnidadFinancieraGC,
	GCEC.Porcentagem "%GC",
	GCEC.Quantidade QtdeGC
FROM
	dado.TblGestaoContrato GC
JOIN
	dado.TblGestaoContratoExcecao GCE ON GC.Id = GCE.GestaoContratoId
JOIN
	dado.TblGestaoContratoExcecaoComponente GCEC ON GCE.Id = GCEC.GestaoContratoExcecaoId