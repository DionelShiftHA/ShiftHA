-- La consulta trae dfatps del paciente que autorizo las preguntas //solo imprime (3,7,9)//
--Elaborado por Shiftha 21/08/2020
--Se agregan parámetros de fecha de entrada. Correspondientes a la 
--fecha de OS.
--Actualizado 02092020 SHIFTHA

SELECT
OS.Data FechadeOs,
OS.CodigoOs OS,
AP.PessoaFisica->ID,
AP.PessoaFisica->Nome Nombre,
AP.PessoaFisica->CPF DNI,
AP.PessoaFisica->Sexo Sexo,
AP.PessoaFisica->DataNascimento FechaNacimiento,
OS.Paciente->PessoaFisica->TelefoneNumero Telefono,
OS.Paciente->PessoaFisica->Email Email,
AP.AutorizacaoResultado CodigoRespuesta,
--(Select 'Não autorizo a entrega/consulta de resultados exceto à minha pessoa ou responsável.' from Dado.ArqPaciente AP2 Where AutorizacaoResultado LIKE '%1%' and AP2.ID = AP.ID)Descripción1,
--(Select 'Autorizo a entrega de resultados a outras pessoas com meu protocolo de retirada de exames.' from Dado.ArqPaciente AP2 Where AutorizacaoResultado LIKE '%2%' and AP2.ID = AP.ID)Descripción2,
(Select 'Autorizo meu médico assistente a receber/consultar o resultado (FAX/correio/internet/sistema/telefone/e-mail).' from Dado.ArqPaciente AP2 Where AutorizacaoResultado LIKE '%3%' and AP2.ID = AP.ID)Descripción3,
--(Select 'Autorizo a emissão de uma senha para que eu possa consultar meus resultados de exames online.' from Dado.ArqPaciente AP2 Where AutorizacaoResultado LIKE '%4%' and AP2.ID = AP.ID)Descripción4,
--(Select 'Autorizo o envio de NOVA SENHA para consultar meus resultados na internet para meu e-mail, mediante minha solicitação.' from Dado.ArqPaciente AP2 Where AutorizacaoResultado LIKE '%5%' and AP2.ID = AP.ID)Descripción5,
--(Select 'Autorizo o envio de SMS informando que os resultados estão prontos.' from Dado.ArqPaciente AP2 Where AutorizacaoResultado LIKE '%6%' and AP2.ID = AP.ID)Descripción6,
(Select 'Autorizo o envio de e-mail informando que meus resultados estão prontos.' from Dado.ArqPaciente AP2 Where AutorizacaoResultado LIKE '%7%' and AP2.ID = AP.ID)Descripción7,
--(Select 'Instruções específicas.' from Dado.ArqPaciente AP2 Where AutorizacaoResultado LIKE '%8%' and AP2.ID = AP.ID)Descripción8,
(Select 'Autorizo o envio dos resultados por e-mail.' from Dado.ArqPaciente AP2 Where AutorizacaoResultado LIKE '%9%' and AP2.ID = AP.ID) Descripción9,
AP.Status Estado
From dado.ArqPaciente AP
JOIN dado.ArqOrdemServico OS ON AP.ID = OS.Paciente
WHERE AP.AutorizacaoResultado <> '' AND OS.Data BETWEEN ? AND ?
ORDER BY AP.PessoaFisica->ID ASC