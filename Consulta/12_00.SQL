
--La consulta trae la O.S con datos del paciente
--Como parametros hay que pasarle rango de decha de registro de la O.S
--Creada 04062020 SHIFTHA

SELECT 
	OS.CodigoOs OS,
	OS.Data FechaOS,
    OS.Paciente->PessoaFisica->Nome NombrePaciente,
    OS.Paciente->PessoaFisica->DataNascimento FechaNacimiento,
    OS.Paciente->PessoaFisica->cpf DNI
FROM
	dado.ArqOrdemServico OS
WHERE
        (OS.Data BETWEEN ? AND ?) AND (OS.OsStatus = 1)
ORDER BY
        OS.Data	