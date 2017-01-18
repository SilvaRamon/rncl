require 'rnl-scope'

local rnlDOMObj = {}
local rnl_scopeObj = {}

local function rnl_init()
	--converte os JSON do NCL DOM e scope que estão rnl-scope.lua para tabelas lua
	JSON = (loadfile "JSON.lua")()
	rnlDOMObj = JSON:decode(rnlDOM_JSON())
	rnl_scopeObj = JSON:decode(rnl_scope_JSON())
end

--seletor de elemento no DOM. Sintaxe: $('mediaLivro')['descriptor']['region']['top']. Futuramente usar sintaxe de objeto: $('mediaLivro').descriptor
--[[# = function(nclElm)
	local domElm = rnlDOM[nclElm] or nil
	if domElm ~= nil then
		if domElm["tag"] == "media" then
			descElm = rnlDOM["descriptor"] or nil
			if descElm ~= nil then
				domElm["descriptor"] = descElm
				regElm = rnlDOM["region"] or nil
				if regElm ~= nil then
					domElm["descriptor"]["region"] = regElm
				end
			end
		elseif domElm["tag"] == "descriptor" then
			regElm = rnlDOM["region"] or nil
			if regElm ~= nil then
				domElm["region"] = regElm
			end
		end
	end
	return domElm
end--]]


--[[function rnl_setLuaProperty(propName, propValue)
    local evt = {
        class = 'ncl',
        type  = 'attribution',
        name  = propName,
        value = propValue,
    }
    evt.action = 'start'; event.post(evt)
    evt.action = 'stop' ; event.post(evt)
end--]]

--tratador de eventos de data binding em midias que usam diretivas React NCL
--function rnl_handler (evt)

--end

rnl_init()
--event.register(rnl_handler)

--metodos de acesso ao DOM e ao scope

print(rnlDOMObj)
print(rnl_scopeObj)
