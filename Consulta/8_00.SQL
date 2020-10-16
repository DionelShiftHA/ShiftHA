--La consulta trae los datos de tipo de envio y descripcion de envio
--de los examenes
--Creacion 18052020 SHIFTHA

SELECT
        EXAI.ProcedimentoId->Id1 CodigoExamen,
	EXAI.ProcedimentoId->Mnemonico SiglaExamen,
	EXAI.ProcedimentoId->Descricao DescripcionExamen,
        CASE
        WHEN EXAI.InstrucaoId->Tipo = 'Paciente' THEN 'Paciente'
        WHEN EXAI.InstrucaoId->Tipo = 'Encaminhamento' THEN 'Envio'
        ELSE 'Otro'
        END "TipoInstruccion",
	EXAI.InstrucaoId->Valor Instruccion
FROM
	dado.tblExameInstrucao EXAI
WHERE
       EXAI.ProcedimentoId->Status = 'Ativo'
ORDER BY
       EXAI.ProcedimentoId->Descricao