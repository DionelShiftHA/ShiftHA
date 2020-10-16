--La consulta tre datos del la OS y paciente 
--Creacion 08042020 SHIFTHA
SELECT 
	OS.CodigoOs OS,
	OS.Data FechaOS,
        OS.Paciente->PessoaFisica->Nome NombrePaciente,
        OS.Paciente->PessoaFisica->DataNascimento FechaNacimiento,
        CASE
        WHEN DATEDIFF(dd,OS.Paciente->PessoaFisica->DataNascimento,OS.Data) <= 30 
		     THEN CONVERT(VARCHAR(4),FLOOR(DATEDIFF(dd,OS.Paciente->PessoaFisica->DataNascimento,OS.Data))) || ' Dias' 
		WHEN (DATEDIFF(dd,OS.Paciente->PessoaFisica->DataNascimento,OS.Data) >30 AND DATEDIFF(dd,OS.Paciente->PessoaFisica->DataNascimento,OS.Data) <= 365)
		      THEN  CONVERT(VARCHAR(4),FLOOR((DATEDIFF(dd,OS.Paciente->PessoaFisica->DataNascimento,OS.Data) / 30))) || ' Meses'
		WHEN (DATEDIFF(dd,OS.Paciente->PessoaFisica->DataNascimento,OS.Data) > 365) 
		      THEN FLOOR(CONVERT(VARCHAR(4),(DATEDIFF(dd,OS.Paciente->PessoaFisica->DataNascimento,OS.Data) / 365))) || ' A#os'
        ELSE ''
        END Edad,		
        OS.Paciente->Status EstadoPaciente
FROM
	dado.ArqOrdemServico OS
WHERE
        (OS.Data BETWEEN ? AND ?) AND (OS.Categoria = 'Humano') AND (OS.OsStatus = 1)
ORDER BY
        OS.Data