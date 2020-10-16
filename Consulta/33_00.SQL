---La consulta tre los datos de plazos en los examenes
--Si tiene rutina, traera la descripcion del plazo
--Si el plazo minimo esta en horas se realiza un convert a varchar para convertir los
--Segundos a horas
--Creacion 14052020 SHIFHA

SELECT
   EXA.ID Codigo,
   EXA.Mnemonico Sigla, 
   EXA.Descricao Descripcion,
   CASE 
     WHEN EXA.PrazoRotinaUtilizaRotina ='Sim' THEN 'SI'
     WHEN EXA.PrazoRotinaUtilizaRotina ='Não' THEN 'NO'
   END UtilizaRutina,
   EXA.PrazoRotinaTipo TipoDePlazo,
   CASE
       WHEN EXA.PrazoRotinaTipo = 'Hora(s)' THEN CONVERT(VARCHAR(8),DATEADD(SECOND,EXA.PrazoCodigoRotina,0),114)
   ELSE CASE 
        WHEN EXA.PrazoRotinaUtilizaRotina ='Não' THEN NVL(EXA.PrazoCodigoRotina,'')||(' ')||NVL(PLA.Descricao,'')
        WHEN EXA.PrazoRotinaUtilizaRotina ='Sim' THEN SUBSTRING(NVL(EXA.PrazoCodigoRotina,'')||(' ')||NVL(PLA.Descricao,''),4,30)
        END
   END Plazo,
   EXA.PrazoMinimoTipo PlazoMinimoTipo,
   CASE
	WHEN EXA.PrazoMinimoTipo = 'Hora(s)' THEN CONVERT(VARCHAR(8),DATEADD(SECOND,EXA.PrazoMinimo,0),114)
	ELSE EXA.PrazoMinimo
	END PlazoMinimo  
FROM 
   dado.tblExame EXA
LEFT JOIN
 dado.TblRotinaPrazo PLA ON EXA.PrazoCodigoRotina = PLA.ID1
WHERE
   EXA.Status = 'Ativo'
ORDER BY 
   EXA.Descricao