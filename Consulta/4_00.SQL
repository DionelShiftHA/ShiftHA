--La consulta trae datos de los presupuestos, los cuales fueron convertidos en OS. 

SELECT top 100 
   orc.ID CodPresupuesto,
   orc.Usuario->Pessoafisica->Nome as UsuarioPresupuesto,
   orc.os->Recepcionista->PessoaFisica->nome UsuarioOS,
   orc.Os->Paciente->PessoaFisica->Nome Paciente,
   orc.Data FechaPresupuesto,
   orc.Os->Data FechaOS,
   orc.Os->CodigoOs, 
   orc.FontePagadora->CodigoCliente->PessoaJuridicaId->NomeFantasia Convenio,
  (SELECT SUM(ValorBrutoFatura+LiquidoBalcao) 
  FROM dado.TblOsCobranca osc 
  WHERE osc.Os = orc.Os AND osc.FontePagadora = orc.FontePagadora) as Valor
FROM 
   dado.TblOrcamento orc 
WHERE
   orc.Os->OsStatus = 1 AND
orc.Data BETWEEN ? AND ?