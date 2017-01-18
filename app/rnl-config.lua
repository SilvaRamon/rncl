--rnl-config.lua
--Registra o nome do arquivo da app React NCL e da app resultante
--Registra as variáveis de ligação do usuário

--Obs: arquivos sempre relativos à raiz
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

--escreva aqui qualquer script que será executado antes da compilação, com o único objetivo de editar rnl_scope acima
