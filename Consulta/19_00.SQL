--La consulta trae resultados de Microbiologia. Se separa el resultado en tipo(Positivo,Negativo,Interno,Parcial)
--Creacion 14102020 SHIFTHA

SELECT 
	acao.CbiId->OsRecipienteProcedimentoId->OsProcedimento->Os->data FechaOS,
	acao.CbiId->OsRecipienteProcedimentoId->OsProcedimento->Os->CodigoOs OS,
	dado.ArqOrdemServico_GetDescricaoPaciente(CbiId->OsRecipienteProcedimentoId->OsProcedimento->Os, 1) Paciente,
	acao.CbiId->OsRecipienteProcedimentoId->OsProcedimento->Procedimento->Mnemonico Sigla,
	acao.CbiId->OsRecipienteProcedimentoId->OsProcedimento->Procedimento->Descricao Examen,
	acao.CbiId->OsRecipienteProcedimentoId->OsProcedimento->Material->Descricao Material,
	(Select RecipienteId->Descricao FROM dado.TblOsRecipiente OSREC WHERE OSREC.ID = acao.CbiId->OsRecipienteProcedimentoId->RecipienteOs) Recipiente,
	acao.CbiId->Cbi As "Nro cbi", insumo.LoteInsumoId->TipoInsumoId->Descricao As "insumo",
	case when TipoLaudo is not null then AcaoId->Descricao||' - '||%EXTERNAL(TipoLaudo) else AcaoId->Descricao end  Accion,
	case when %INTERNAL(acao.TipoLaudo) = 4 then acao.LaudoItemId->Abreviatura||' - '||acao.LaudoItemId->LaudoId->Laudo else null end Microorganismo,
	case when %INTERNAL(acao.TipoLaudo) = 3 then acao.LaudoItemId->Abreviatura||' - '||acao.LaudoItemId->LaudoId->Laudo else null end Negativo,
	case when %INTERNAL(acao.TipoLaudo) = 1 then acao.LaudoItemId->Abreviatura||' - '||acao.LaudoItemId->LaudoId->Laudo else null end Interno,
	case when %INTERNAL(acao.TipoLaudo) = 2 then acao.LaudoItemId->Abreviatura||' - '||acao.LaudoItemId->LaudoId->Laudo else null end Parcial,
	acao.usuarioId->UserId||' - '||acao.UsuarioId->PessoaFisica->Nome Usuario, 
	%EXTERNAL(acao.Data) Fecha,
	%EXTERNAL(acao.Hora) Hora 
FROM 
	dado.TblAcaoCbi acao 
LEFT JOIN 
	dado.TblAcaoCbiLoteInsumo insumo ON acao.ID = insumo.AcaoCbiId
where 
	acao.Data between ? and ?
order by 
	acao.CbiId, acao.Id