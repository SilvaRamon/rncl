--rnl-config.lua
--Registra o nome do arquivo da app React NCL e da app resultante
--Registra as vari�veis de liga��o do usu�rio

--Obs: arquivos sempre relativos � raiz
--Your React NCL app file name
rnl_originNCL = function() return 'myapp.ncl' end
--Your resulting pure NCL file name
rnl_resultNCL = function() return 'mygenapp.ncl' end

--write here the variables that will be binded to the NCL document
rnl_scope = function()
	return {
		--example:
		var1 = 1,
		name = "var2",
		value = "2"

	}
end

--escreva aqui qualquer script que ser� executado antes da compila��o, com o �nico objetivo de editar rnl_scope acima
