SELECT
	EXA.ID CodigoExamen,
    EXA.Mnemonico SiglaExamen, 
    EXA.Descricao DescripcionExamen,
    EXA.Material->ID CodigoMaterial,
    EXA.Material->Descricao DescripcionMaterial,
	REC.id CodigoRecipiente,
    REC.Descricao DescricpionRecipiente,
	EXA.ImpressaoOrdem OrdenImpresion,
	EXA.SetorPadrao->Id CodigoSector,
	EXA.SetorPadrao->Descricao DescricpionSector,
	EXA.PrazoRotinaTipo TipoDePlazo,
	EXA.PrazoCodigoRotina Plazo,
	EXA.PrazoMinimoTipo PlazoMinimoTipo,
	EXA.PrazoMinimo PlazoMinimo
FROM 
    dado.tblExame EXA
JOIN
	dado.TblExame_Recipientes EXAR ON EXA.ID = EXAR.TblExame
JOIN
	dado.TblRecipiente REC ON EXAR.Recipiente = REC.id