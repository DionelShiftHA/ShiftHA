--La consulta trae datos de las tablas de precio y los examenes asociados (SIN FUENTE PAGADORA)
--Actualizada 14052020 SHIFTHA 

SELECT
	PI.ProcedimentoId CodigoExamen,
    PI.ProcedimentoId->Mnemonico SiglaExamen,
	PI.ProcedimentoId->Descricao Descripcion,
    PI.TabelaPrecoId->Descricao TablaPrecios,
    PI.TabelaPrecoId->Status EstadoTablaPrecios,
    PI.Codigo CodigoDP,
    (SELECT PICP.Quantidade
	 FROM dado.TblPrecoItemComponentePreco PICP
     WHERE PICP.ComponentePrecoId = 2 AND PICP.PrecoItemId = PI.Id) "CH - Ctde",
	 (SELECT PICP2.Porcentagem
     FROM dado.TblPrecoItemComponentePreco PICP2
     WHERE PICP2.ComponentePrecoId = 2 AND PICP2.PrecoItemId = PI.Id) "CH - %"
FROM 
	dado.TblPrecoItem PI
WHERE 
	ProcedimentoId->Mnemonico %INLIST ($LISTFROMSTRING('COVIDH'))