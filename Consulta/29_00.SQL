--La consulta trae datos del paciente para un examen especifico
--pasado como parametro de la consulta
--CREACION 28082020 SHIFTHA
--PARAMETROS: FECHA INICIO,FECHAFIN,SIGLA EXAMEN

SELECT 
	OPR.OS->Data FechaOS,
	OPR.OS->CodigoOs OS,
	OPR.Procedimento->Mnemonico SiglaExamen,
	OPR.Procedimento->Mnemonico Descripcion,
	OPR.OS->Paciente->PessoaFisica->Nome Paciente,
	OPR.OS->Paciente->PessoaFisica->Cpf  DNI,
	OPR.OS->Paciente->PessoaFisica->DataNascimento FechaNacimiento,
	OPR.OS->Paciente->PessoaFisica->TelefoneNumero Telefono,
	OPR.OS->Paciente->PessoaFisica->EnderecoLogradouro Direccion,
	OPR.OS->Paciente->PessoaFisica->EnderecoNumero Altuira,
	OPR.OS->Paciente->PessoaFisica->Email Email
FROM
	dado.TblOsProcedimento OPR
WHERE
	OPR.OS->Data BETWEEN ? AND ?
	AND OPR.Procedimento->Mnemonico = ?