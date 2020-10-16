-- Agregar condicion de medico activo

--La consulta trae datos de medicos que tengan telefono celular cargado.
--Tipo 3 indica que el numero es un celular.
Select 
	conselho TipoMatricula,
	ConselhoNumero Matricula,
	pessoafisica->nome ApellidoNombre,
	especialidade->descricao Especialidad,
	pessoafisica->email Mail,
	PessoaFisica->TelefoneDDD CodArea,
	PessoaFisica->TelefoneNumero Tel,
        PessoaFisica->TelefoneTipo TipoTelefono,
(Select bairrodescricao from dado.TblCepBairro where id=NVL($LISTGET(pessoafisica->enderecobairro,1),'')) as Bairro,
(Select cidadedescricao from dado.TblCeplocalidade where id=NVL($LISTGET(pessoafisica->enderecocidade,1),'')) as Cidade 
from 
	dado.arqsolicitante
where
	Status= 'Ativo' AND
    ((pessoafisica->TelefoneTipo like '%3%') OR (pessoafisica->email IS NOT NULL))
order by 
	pessoafisica->nome