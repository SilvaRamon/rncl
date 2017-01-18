require 'luaxml'
require "app.rnl-config"

local function readRnl(file)
    local f = io.open(file, "rb")
	if f ~= nil then
		local content = f:read("*all")
		f:close()
		return content
	end
	return ""
end

local dom = {}
local nclText = readRnl('app/'..rnl_originNCL())
local tbNCL = xml.eval(nclText)
local tbRetroAdjust = {}

local function dump(tb)
	JSON = (loadfile "app/reactncl/JSON.lua")()
	x = JSON:encode_pretty(tb)
	print(x)
end

local function insertRetroactive(obj, prop, record)
	if tbRetroAdjust[obj] then
		if tbRetroAdjust[obj][prop] then
			table.insert(tbRetroAdjust[obj][prop], record)
		else
			tbRetroAdjust[obj][prop] = {}
			table.insert(tbRetroAdjust[obj][prop], record)
		end
	else
		tbRetroAdjust[obj] = {}
		tbRetroAdjust[obj][prop] = {}
		table.insert(tbRetroAdjust[obj][prop], record)
	end
end

local function checkDOM(id, property)
	if dom[id] then
		if dom[id][property] then
			return dom[id][property]
		end
	end
	return nil
end

local function checkProperty(property)
	local i, f = string.find(property, "%a[%w-%_]*")--variaveis padrao: "%a[%w-%_]*(%.[%w-%_]*)*"
	if i ~= nil and i == 1 and f == #property then
		return "uservar"
	end

	local i, f = string.find(property, "%#.+")--dom element
	if i ~= nil and i == 1 and f == #property then
		return "dom"
	end

	local i, f = string.find(property, "%d+?px")--px size
	if i ~= nil and i == 1 and f == #property then
		return "size"
	end

	return nil
end

function adjustRetroactiveSet(record, result)
	if p == "rnl-aspect" then
		for k, v in pairs(tb) do
			if k == "id" and v == id then
				rnlAspect()
			end
			if type(k) == "number" and k ~= 0 then--se for filho
				adjustNCL(v, id, prop, value)
			end
		end
	end
	--ajusta no dom
	dom[o][p] = r
	--ajusta no ncl
	adjustNCL(tbNCL, o, p, r)
	--elimina de tbRetroAdjust
	for j, v in pairs(tbRetroAdjust) do
		for k, w in pairs(v) do
			if w.id == id and w.prop == prop then
				v[k] = nil
			end
		end
		if #v == 0 then
			j[v] = nil
		end
		if #j == 0 then
			tbRetroAdjust[j] = nil
		end
	end
end

local function adjustRetroactive(id, prop, result)
	for j, v in pairs(tbRetroAdjust) do
		if j==id and v==prop then
			for k, record in pairs(v) do
				adjustRetroactiveSet(record, result)
			end
		end
	end
end

function rnlAspect(elmId, width, height, dimension, aspect, tb) -- dimension = "width" ou "height"
	local values = {}

	for token in string.gmatch(aspect, "[^:]+") do
		table.insert(values, tonumber(token))

		if #values > 2 then
			print("Parse Error: Invalid argument for rnl-aspect")
			parseError = true
			return
		end
	end

	if #values < 2 then
		print("Parse Error: Invalid argument for rnl-aspect")
		parseError = true
		return
	end

	if type(values[1]) ~= "number" or type(values[2]) ~= "number" then
		print("Parse Error: Argument for rnl-aspect is not a number.")
		parseError = true
		return
	end

	if width ~= nil and height == nil then --se o que foi colocado na regiao com rnl-aspect foi width ou rnl-width
		local patternChk = checkProperty(width)
		if patternChk == "size" then
			local result = (string.gsub( width, "px", "" ) * values[2])/values[1].."px"
			adjustRetroactive(elmId, "height", result) --verifica se existe alguma propriedade aguardando o resultado do calculo dessa propriedade e ajusta todas
			return result
		end
		if patternChk == "dom" then -- se for rnl-width="#nclElement.property"
			local i, f = string.find(width, "%.")
			if i ~= nil then --se for dom obj com propriedade (domObj.property).
				local obj = width:sub(2, i-1)
				local prop = width:sub(i+1, #width)

				local value = checkDOM(obj, prop) --verifica se o valor da propriedade ja foi adicionado no dom

				if value then
					local result = (string.gsub( value, "px", "" ) * values[2])/values[1].."px"
					adjustRetroactive(elmId, "height", result) --verifica se existe alguma propriedade aguardando o resultado do calculo dessa propriedade e ajusta todas
					return result
				else -- se value ainda nao existe no dom, armazenar na tabela de ajuste retroativo
					local record = {id = elmId, prop = "rnl-aspect", nclRef = tb}
					insertRetroactive(obj, prop, record)
					return nil --esse retorno diz pro parse() que a prop rnl-aspect nao sera apagada do ncl pois será ajustada posteriormente
				end
			else
				print("Parse Error: Invalid argument value for rnl-aspect = ".. width)
				parseError = true
				return
			end
		end
		if patternChk == "uservar" then
			local result = rnl_scope()[width] or nil
			if result == nil then
				print("Variable Error: user variable \"".. width.."\" not defined")
				parseError = true
				return
			end
			return rnl_scope()[width]
		end
	end

	if height ~= nil and width == nil then
		local patternChk = checkProperty(height)
		if patternChk == "size" then
			height = tonumber(height:sub(1, -3))
			return (height * values[1])/values[2].."px"
		end
		if patternChk == "dom" then
			local i, f = string.find(height, "%.")
			if i ~= nil then --se for dom obj com propriedade (domObj.property)
				local obj = height:sub(2, i-1)
				local prop = height:sub(i+1, #height)

				local value = checkDOM(obj, prop) -- se a propriedade e o objeto existem no dom

				if value then
					--print(value.." "..obj.." "..prop )
					local result = (value * values[1])/values[2].."px"
					local o, p = checkRetroactive(elmId, "height")

					if o and p then --se a propriedade do elemento precisa ser ajustada para o valor que será retornado
						adjustRetroactive(o, p, result)
					end
					return result
				else
					local record = {id = elmId, prop = "height"}
					insertRetroactive(obj, prop, record)
				end
			else
				print("Parse Error: Invalid argument value for rnl-aspect = ".. height)
				parseError = true
				return
			end
		end
	end
	--print("Parse Error: invalid argument at "..tb[0].."#"..elmId)
	--parseError = true
	--return
end

function rnlWidth()
end
function rnlHeight()
end
function rnlRelTop()
end
function rnlRelLeft()
end
function rnlRelRight()
end
function rnlRelBottom()
end

local function parse(tbl, parent)

	if parseError then
		return
	end

	if tbl[0] == "region" --[[ or tbl[0] == "descriptor" or tbl[0] == "media"--]] then
		if not tbl.id then
			print("Parse error: React NCL requires a "..tbl[0].." element to have an id.")
			parseError = true
			return
		end
	end

	local data = {
		tag = tbl[0],
		parent = parent,
		children = {}
	}


	for k, v in pairs(tbl) do
		local continue = false
		if k == "id" then continue=true end
		if k == 0 then continue=true end
		if parseError then
			return
		end
		if not continue and type(k) == "number" then--se for filho
			local parent = tbl.id or nil
			parse(v, parent)
			if parseError then
				return
			end
			if data.tag == "region" then
				table.insert(data.children, v.id)
			end
			continue = true
		end
		if not continue then--se for propriedade
			if data.tag == "region" then
				if k == "rnl-aspect" then
					if (tbl["width"] or tbl["rnl-width"]) and (tbl["height"] or tbl["rnl-height"]) then
						print("Parse error: rnl-aspect property requires width or height, not both")
						parseError = true
						return
					end
					if tbl["width"] or tbl["rnl-width"] then
						local r = rnlAspect(tbl["id"], tbl["width"] or tbl["rnl-width"], nil, "width", tbl["rnl-aspect"], tbl) --passo toda a tag por referencia para ajuste retroativo no ncl

						if r ~= nil then --se for dom element e já tiver sido colocado no dom
							tbl["height"] = r
							data["height"] = r
							tbl["rnl-aspect"] = nil
						end
					end
					if tbl["height"] or tbl["rnl-height"] then
						local r = rnlAspect(tbl["id"], nil, tbl["height"] or tbl["rnl-height"], "height", tbl["rnl-aspect"], tbl)
						if r ~= nil then --se for dom element e já tiver sido colocado no dom
							tbl["width"] = r
							data["width"] = r
						end
					end
				elseif k == "rnl-width" then
					--tbl.rnl-width = nil
				elseif k == "rnl-height" then
					--tbl.rnl-height = nil
				elseif k == "rnl-rel-top" then
					--tbl.rnl-rel-top = nil
				elseif k == "rnl-rel-left" then
					--tbl.rnl-rel-left = nil
				elseif k == "rnl-rel-right" then
					--tbl.rnl-rel-height = nil
				elseif k == "rnl-rel-bottom" then
					--tbl.rnl-rel-bottom = nil
				else--se não for propriedade rnl--]]
					data[k] = v
				end
			end
		end
	end
	if data.tag == "region" then
		dom[tbl.id] = data
	end
end

local function writeNCL(resultNcl)
	local ncl = '<?xml version="1.0" encoding="ISO-8859-1"?>'.."\n"
	local fWrite = io.open("app/"..rnl_resultNCL(),"w")
	ncl = ncl..tostring(resultNcl)
	fWrite:write(ncl)
	fWrite:close()
end

local function writeScopeData()
	--escreve em data/rnl-scope a partir da tabela rnl_scope em rnl-config.lua e da tabela rnlDOM
	JSON = (loadfile "app/reactncl/JSON.lua")()
	local domWrite = JSON:encode(dom)
	local scopeWrite = JSON:encode(rnl_scope())
	local rnl_scope_file = "--arquivo gerado pelo compiler, formato string JSON\nrnlDOM_JSON = function() \n\treturn '"..tostring(domWrite).."'\nend\nrnl_scope_JSON = function()\n\treturn '"..tostring(scopeWrite).."'\nend"
	local fWrite = io.open("app/reactncl/rnl-scope.lua","w")
	fWrite:write(rnl_scope_file)
	fWrite:close()
end


local parseError = false

--inicia a compilação
--percorre tbNCL, analisa as diretivas rnl-x, analisa os parâmetros passados, computa o resultado de cada diretiva e gera valores, propriedades e nós em tbNCL, rnlDOM e rnl_scope, removendo as propriedades rnl-x de tbNCL
--cada diretiva rnl-x tem uma função correspondente que analisa sintaticamente seu parâmetro e gera o resultado correspondente
--para as analises, construir estruturas de dados auxiliares para ajustes retroativos
local parent = nil
parse(tbNCL, parent)
--no final do parse, converter rnlDOM e rnl_scope para JSON e gerar codigo lua para o arquivo rnl-scope.lua
writeScopeData()
--gerar o NCL final a partir de tbNCL
writeNCL(tbNCL)



--ignore estes comentarios, são só fontes de codigo pra usar
--[[
	tabela de ajuste retroativo
	<region id="r1" rnl-width="r2.height">
	<region id="r3" rnl-height="r2.height">
	<region id="r4" rnl-height="r2.width">
	<region id="r2" height="3px">

	{
		r2 = {
			height = {
				"1" = {
					id="r1",
					prop="width"
				},
				"2" = {
					id="r3",
					prop="height"
				}
			},
			width = {
				"1" = {
					id="r4",
					prop="rnl-aspect",
					nclRef=table(95D83F)
				}
		},


	}

]]
dump(dom)
