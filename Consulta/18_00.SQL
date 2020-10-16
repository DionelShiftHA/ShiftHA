--La siguiente consulta trae datos de los convenios y el cliente PJ
--CREACION 02072020 SHIFTHA


SELECT 
	CONV.ID CodigoConvenio,
	CONV.Apelido SiglaConvenio,
	CONV.Descricao DescripcionConveio,
    CONV.CodigoCliente->PessoaJuridicaId->NomeFantasia ClientePJ,
	CONV.CodigoCliente->PessoaJuridicaId->RazaoSocial,
	CONV.Grupo->Descricao Grupo,
	CONV.Status EstadoConvenio
FROM
	dado.TblConvenio CONV
ORDER BY
	CONV.Grupo->Descricao 