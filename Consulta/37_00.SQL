--La consulta trae datos de examen con el recipient y el subrecipiente plazo de examen, etc.
SELECT 
 A.Id Código,
 A.Mnemonico Sigla, 
 A.Descricao DescripciónExamen,
 A.DescricaoLaudo DescripciónOnline,
 B.Descricao Sinónimo,
 A.Status Estado,
 A.Material->Descricao as Material,
 A.Recipiente as "Id Recipiente",
   (SELECT LIST(Descricao) FROM dado.TblRecipiente WHERE Id %INLIST($LISTFROMSTRING(Recipiente,CHAR(253)))) AS "Descripcion Recipiente",
 A.SubRecipiente as "Id SubRecipiente",
 (SELECT LIST(Descricao) FROM dado.TblRecipiente WHERE Id %INLIST($LISTFROMSTRING(SubRecipiente,CHAR(253)))) AS "Descripcion SubRecipiente",
 A.SetorPadrao->Descricao as SectorEstandar,
 A.SetorComplementar->Descricao SectorComplementar,
Case 
    When %INTERNAL(PrazoRotinaUtilizaRotina) = 1 Then
      'R: '||PrazoCodigoRotina||' - '||(SELECT Descricao FROM dado.TblRotinaPrazo WHERE ID1 = PrazoCodigoRotina)
    When %INTERNAL(PrazoRotinaUtilizaRotina) = 0 Then
       Case
          When %INTERNAL(PrazoRotinaTipo) = 1 Then
             PrazoCodigoRotina||' Dia(s) útil(es)'
          When %INTERNAL(PrazoRotinaTipo) = 2  Then
             PrazoCodigoRotina||' Dia(s) Corrido(s)'
          When %INTERNAL(PrazoRotinaTipo) = 3  Then
             PrazoCodigoRotina||' Hora(s)'
       End
  End AS Plazo,
Case
When %INTERNAL(A.PrazoMinimoTipo) = '1' THEN ''||A.PrazoMinimo||' Día(s) útil(es)' 
When %INTERNAL(A.PrazoMinimoTipo) = '2' THEN ''||A.PrazoMinimo||' Día(s) Corrido(s)' 
When %INTERNAL(A.PrazoMinimoTipo) = '3' THEN ''||CONVERT(VARCHAR(8),DATEADD(SECOND,A.PrazoMinimo,0),114)||' Hora(s)' 
End PlazoMinimo
FROM DADO.TBLEXAME A
JOIN dado.TblExameSinonimia B ON B.ProcedimentoId = A.ID
Order by A.id ASC