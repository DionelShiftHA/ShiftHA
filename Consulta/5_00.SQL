--La consulta trae datos de las etiquetas pre impresas. 
select 
	EPIL.ID Lote, 
	EPIL.Datageracao Fecha, 
	EPIL.Horageracao Hora,
	USR.Apelido Responsable,
	CON.apelido SIGLA,
	ISNULL(CON.CodigoCliente->PessoaJuridicaId->NomeFantasia, POS.Descricao) Destinatario,
	(Select count(EPII.ID) FROM dado.TblEtqPreImpressaItem EPII WHERE EPII.LoteEtiquetaId = EPIL.ID) ETIQUETA
from 
	dado.TblEtqPreImpressaLote EPIL
join 
	dado.TblUsuario USR on EPIL.ResponsavelGeracaoId = USR.ID 
LEFT join 
	dado.tblconvenio CON on EPIL.FontePagadoraId = CON.ID
left join 
	dado.TblPosto POS on EPIL.UnidadeColetaId = POS.ID
ORDER BY 
	EPIL.ID DESC
