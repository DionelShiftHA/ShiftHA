--La consulta trae registro de la OS con el mail que se registro en el momento de la carga
--Ademas trae datos de la ficha del paciente.
--Creacion 27082020 SHIFTHA
SELECT 
	OS.Data FechaOS,
	OS.CodigoOs OS,
	OS.Paciente->PessoaFisica->Nome Paciente,
	OS.Paciente->PessoaFisica->TelefoneNumero Telefono,
	OS.Paciente->PessoaFisica->Email Email,
	OS.Paciente->AutorizacaoResposta MailRegistradoEnOS	
FROM
	dado.ArqOrdemServico OS
WHERE
	OS.Data BETWEEN ? AND ?
	AND OS.Paciente->AutorizacaoResultado LIKE '%9%'