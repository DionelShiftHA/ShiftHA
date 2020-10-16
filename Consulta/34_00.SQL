--La consulta trae datos de los perfiles con los examenes que lo componen
--Creada 28052020 SHIFTHA
SELECT 
	EXAP.Id CodigoPerfil,
	EXAP.Mnemonico SiglaPerfil,
	EXAP.Descricao DescripcionPerfil,
	(SELECT LIST(EXA.Mnemonico) 
	 FROM dado.TblExame EXA 
	 WHERE Id %INLIST($LISTFROMSTRING(EXAP.Perfil,CHAR(253)))) AS SiglaExamenes,
	EXAP.PerfilTipo TipoPerfil	
FROM
	dado.TblExame EXAP
WHERE
	EXAP.PerfilTipo <> 'Não definido' AND EXAP.Status = 'Ativo'
ORDER BY	
	EXAP.PerfilTipo,EXAP.Descricao