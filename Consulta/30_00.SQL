

--La consulta trae datos de la OS  y paciente e indica si hay deuda en la os.
-- En una columna muestra la deuda de los examenes Covid, y en otra la deuda total
--en caso que asi sea. 
--Creacion 19082020 SHIFTHA Actualizacion 24082020
--Se agrego la condicion de iva del paciente. Con una subconsulta para llegar hasta la tabla de items
--y cruzarlo con la respueta de dado.TblOsDadoCadastral
--Actualizado 27082020

SELECT 
	osc.Os->CodigoOs CodigoOs,
	osc.Os->Data FechaOs,
	osc.Os->Recepcionista->PessoaFisica->Nome Usuario,
	dado.TblConvenio_GetDescricaoFontePagadora(osc.FontePagadora) Convenio,
	 ISNULL((select cruz.Descricao from dado.TblOsDadoCadastral osdc 
	         join dado.TblCruzadoItem cruz on osdc.resposta = cruz.ID  
			 where osdc.OS = osc.OS and osdc.DadoCadastral = 301),'-') AS CondicionIVA, 
	dado.ArqOrdemServico_GetDescricaoPaciente(osc.Os,1) as Paciente,
	osc.Os->Paciente->PessoaFisica->Cpf DNI,
	osc.Os->Paciente->PessoaFisica->EnderecoLogradouro Direccion,
	osc.Os->Paciente->PessoaFisica->EnderecoNumero Altuira,
	osc.Os->Paciente->PessoaFisica->TelefoneNumero Telefono,
	EXA.Solicitante->pessoafisica->nome MedicoSolicitante,
	 CASE
		WHEN (SUM(osc.LiquidoBalcao)-SUM(osc.RecebidoBalcao)) <= 0 THEN 'NO'
	ELSE 'SI'
	END Debe,	
	((SUM(osc.LiquidoBalcao))-(SUM(osc.RecebidoBalcao)))  DeudaCovid,
	(Select ((SUM(osc2.LiquidoBalcao))-(SUM(osc2.RecebidoBalcao))) 
	 from dado.TblOsCobranca osc2
	 where osc2.os = osc.os) DeudaTotalOS
FROM 
	dado.TblOsCobranca as osc
JOIN
   dado.TblOsExameSolicitante EXA ON  OSC.OsProcedimentoId = EXA.OsProcedimento
WHERE 
	osc.Os->Data BETWEEN ? AND ?
	AND osc.Procedimento IN(1531,1534,1541)
GROUP BY 
	osc.Os