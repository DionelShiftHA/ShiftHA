--La consulta trae datos del degistro de la OS.
--Actualizada 05052020 SHIFTHA
--ORDEN DE LOS PARAMETROS: FechaInicio, FechaFin, CodigoConvenio

SELECT top 1000
        OS.CodigoOs NroOS,
	OS.Paciente->PessoaFisica->Nome As Paciente,
        Os.Paciente->PessoaFisica->Cpf As CI,
        Os.Data FechaOS,
        ISNULL((select DCTipo.Resposta from dado.TblOsDadoCadastral DCTipo where DCTipo.OS = OS.Id and 
                 DCTipo.DadoCadastral = 303),'-') AS Tipo, 
        ISNULL((select DCMUT.Resposta from dado.TblOsDadoCadastral DCMUT where DCMUT.OS = OS.Id and 
                 DCMUT.DadoCadastral = 306),'-') AS Mutualista,
        ISNULL((select DCNRE.Resposta from dado.TblOsDadoCadastral DCNRE where DCNRE.OS = OS.Id and 
                 DCNRE.DadoCadastral = 307),'-') AS NombreResidencial,
        ISNULL((select DCDT.Resposta from dado.TblOsDadoCadastral DCDT where DCDT.OS = OS.Id and 
                 DCDT.DadoCadastral = 308),'-') AS DireccionTecnica,
        ISNULL((select DCTEL.Resposta from dado.TblOsDadoCadastral DCTEL where DCTEL.OS = OS.Id and 
                 DCTEL.DadoCadastral = 309),'-') AS TelefonoDT   
FROM 
   dado.ArqOrdemServico OS
JOIN 
   dado.TblOsProcedimento OSP ON OS.id = OSP.Os
where
   (Os.Data BETWEEN ? AND ?) AND (OSP.FontePagadoraId = ?)
order by OS.ID desc