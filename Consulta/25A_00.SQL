--La consulta trae datos de las tablas de precio y los examenes asociados (CON FUENTE PAGADORA)
--Actualizada 14052020 SHIFTHA 

SELECT
	PI.ProcedimentoId CodigoExamen,
    PI.ProcedimentoId->Mnemonico SiglaExamen,
	PI.ProcedimentoId->Descricao Descripcion,
	PI.ProcedimentoId->ID CodigoTPrecio,
    PI.TabelaPrecoId->Descricao TablaPrecios,
    PI.TabelaPrecoId->Status EstadoTablaPrecios,
    PI.Codigo CodigoDP,
    (SELECT PICP.Quantidade
	 FROM dado.TblPrecoItemComponentePreco PICP
     WHERE PICP.ComponentePrecoId = 2 AND PICP.PrecoItemId = PI.Id) "CH - Ctde",
	 (SELECT PICP2.Porcentagem
     FROM dado.TblPrecoItemComponentePreco PICP2
     WHERE PICP2.ComponentePrecoId = 2 AND PICP2.PrecoItemId = PI.Id) "CH - %",
(SELECT LIST(CodigoCliente->PessoaJuridicaId->Apelido||' - '||CodigoCliente->PessoaJuridicaId->NomeFantasia || '///')
     FROM dado.TblConvenio CONV
     WHERE CONV.Tabela = PI.TabelaPrecoId) "Fontes pagadoras"
FROM 
	dado.TblPrecoItem PI
WHERE 
	ProcedimentoId->Mnemonico %INLIST ($LISTFROMSTRING('COVIDH'))