--La consulta trae datos del paciente para un examen especifico
--pasado como parametro de la consulta
--CREACION 28082020 SHIFTHA
--PARAMETROS: FECHA INICIO,FECHAFIN,SIGLA EXAMEN
--Se actualizo la consulta agregando la edad del paciente
--Actualizacion 27102020

SELECT 
	OPR.OS->Data FechaOS,
	OPR.OS->CodigoOs OS,
	OPR.Procedimento->Mnemonico SiglaExamen,
	OPR.Procedimento->Mnemonico Descripcion,
	OPR.OS->Paciente->PessoaFisica->Nome Paciente,
	OPR.OS->Paciente->PessoaFisica->Cpf  DNI,
	OPR.OS->Paciente->PessoaFisica->DataNascimento FechaNacimiento,
	CASE
        WHEN DATEDIFF(dd,OPR.OS->Paciente->PessoaFisica->DataNascimento,OPR.DataOs) <= 30 
		     THEN CONVERT(VARCHAR(4),FLOOR(DATEDIFF(dd,OPR.OS->Paciente->PessoaFisica->DataNascimento,OPR.DataOs))) || ' Dias' 
		WHEN (DATEDIFF(dd,OPR.OS->Paciente->PessoaFisica->DataNascimento,OPR.DataOs) >30 AND DATEDIFF(dd,OPR.OS->Paciente->PessoaFisica->DataNascimento,OPR.DataOs) <= 365)
		      THEN  CONVERT(VARCHAR(4),FLOOR((DATEDIFF(dd,OPR.OS->Paciente->PessoaFisica->DataNascimento,OPR.DataOs) / 30))) || ' Meses'
		WHEN (DATEDIFF(dd,OPR.OS->Paciente->PessoaFisica->DataNascimento,OPR.DataOs) > 365) 
		      THEN FLOOR(CONVERT(VARCHAR(4),(DATEDIFF(dd,OPR.OS->Paciente->PessoaFisica->DataNascimento,OPR.DataOs) / 365))) || ' A#os'
        ELSE ''
        END Edad,	
	OPR.OS->Paciente->PessoaFisica->TelefoneNumero Telefono,
	OPR.OS->Paciente->PessoaFisica->EnderecoLogradouro Direccion,
	OPR.OS->Paciente->PessoaFisica->EnderecoNumero Altuira,
	OPR.OS->Paciente->PessoaFisica->Email Email
FROM
	dado.TblOsProcedimento OPR
WHERE
	OPR.OS->Data BETWEEN ? AND ?
	AND OPR.Procedimento->Mnemonico = ?