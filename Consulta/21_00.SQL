--La consulta trae datos de facturacion. Tiene 2 union para anexar las consultas de acuerdo
--a el proceso en que se encuentra la factura.
--Se agrega el valor actual de la unidad financiera.
--Actualizada 21072020 SHIFTHA


SELECT
		OSC.FontePagadora->CodigoCliente->PessoaJuridicaId->Apelido "Fonte pagadora APELIDO", 
                dado.TblConvenio_GetDescricaoFontePagadora(OSC.FontePagadora) "Fonte pagadora",
                OSC.FontePagadora->Grupo->Descricao Grupo,
                %EXTERNAL(OSC.Fatura->Situacao) "Status fatura",
                OSC.Fatura->DataFechamento "Fatura",
                %EXTERNAL(OSC.Fatura->ValorTotal) "Valor",
                COUNT(DISTINCT OSC.Os) "Qtd OS",
                COUNT(OSC.Id) "Qtd Procedimentos",
				U.UnidadeId->ValorAtual ValorActual
FROM dado.TblOsCobranca OSC
JOIN
    dado.TblComponentePrecoFontePagadora U ON OSC.FontePagadora = U.FontePagadoraId
WHERE
                %INTERNAL(OSC.FontePagadora->TipoConvenio) IN ('F','I')
                AND OSC.Fatura->DataFechamento BETWEEN ? AND ?
GROUP BY OSC.FontePagadora, OSC.Fatura
UNION
SELECT
		OSC.FontePagadora->CodigoCliente->PessoaJuridicaId->Apelido "Fonte pagadora APELIDO", 
                dado.TblConvenio_GetDescricaoFontePagadora(OSC.FontePagadora) "Fonte pagadora",
                OSC.FontePagadora->Grupo->Descricao Grupo,
                'A faturar' "Status fatura",
                NULL "Fatura",
                %EXTERNAL(SUM(OSC.ValorBrutoFatura)) "Valor",
                COUNT(DISTINCT OSC.Os) "Qtd OS",
                COUNT(OSC.Id) "Qtd Procedimentos",
				U.UnidadeId->ValorAtual ValorActual
FROM dado.TblOsCobranca OSC
JOIN
    dado.TblComponentePrecoFontePagadora U ON OSC.FontePagadora = U.FontePagadoraId
WHERE
                %INTERNAL(OSC.FontePagadora->TipoConvenio) IN ('F','I')
                AND OSC.Fatura->DataFechamento BETWEEN ? AND ?
GROUP BY OSC.FontePagadora
UNION
SELECT 
		OSC.FontePagadora->CodigoCliente->PessoaJuridicaId->Apelido "Fonte pagadora APELIDO",              
		dado.TblConvenio_GetDescricaoFontePagadora(OSC.FontePagadora) "Fonte pagadora",
               OSC.FontePagadora->Grupo->Descricao Grupo,
                'DEVE DOC' "Status fatura",
                NULL "Fatura",
                %EXTERNAL(SUM(OSC.ValorBrutoFatura)) "Valor",
                COUNT(DISTINCT OSC.Os) "Qtd OS",
                COUNT(OSC.Id) "Qtd Procedimentos",
				U.UnidadeId->ValorAtual ValorActual
FROM dado.TblOsCobranca OSC
JOIN
    dado.TblComponentePrecoFontePagadora U ON OSC.FontePagadora = U.FontePagadoraId
WHERE
                %INTERNAL(OSC.FontePagadora->TipoConvenio) IN ('F','I')
                AND OSC.Fatura->DataFechamento BETWEEN ? AND ?
                AND (SELECT COUNT(*) FROM dado.TblOsDeveDocumento osdd WHERE osdd.Os = OSC.Os) > 0
GROUP BY OSC.FontePagadora