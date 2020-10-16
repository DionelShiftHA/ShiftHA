--La consulta trae datos del convenio con el FechaTipoCierre y el Dia

SELECT 
        CONV.ID CodigoConvenio,
        CONV.CodigoCliente->PessoaJuridicaId->Apelido SiglaConvenio,
        CONV.CodigoCliente->PessoaJuridicaId->NomeFantasia DescripcionConvenio,
	CONV.TipoDataFechamento TipoFechaCierre,
	CONV.TipoValorFechamento Dia
FROM 
	dado.TblConvenio CONV
WHERE
        CONV.Status = 'Ativo'
ORDER BY
        CONV.CodigoCliente->PessoaJuridicaId->NomeFantasia