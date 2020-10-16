--La consulta trae datos del convenio y la unidad financiera
--que tiene asignada.
--Creacion 08092020
	
select 
	CFP.UnidadeId->id CodigoUF,
	CFP.UnidadeId->Descricao DescripcionUF,
	CFP.UnidadeId->ValorAtual ValorAtualUF,
	CFP.FontePagadoraId->Id CodigoConvenio,
	CFP.FontePagadoraId->CodigoCliente->PessoaJuridicaId->Apelido SiglaConvenio,
	CFP.FontePagadoraId->CodigoCliente->PessoaJuridicaId->NomeFantasia DescripcionConveio
from 
	dado.TblComponentePrecoFontePagadora CFP
GROUP BY 
	CFP.FontePagadoraId->Id