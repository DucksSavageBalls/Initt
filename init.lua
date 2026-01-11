if not game:IsLoaded() then 
		game.Loaded:Wait() 
	end

print("hello")
udreal()

loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxendo902/someinit/refs/heads/main/file1",true))()
      
getgenv().saveinstance = function()
    local Params = {
        RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
        SSI = "saveinstance",
    }
    local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
    local Options = {}
    synsaveinstance(Options)
end

getgenv().getexecutorname = identifyexecutor
getgenv().queueonteleport = queue_on_teleport
getgenv().toclipboard = setclipboard
getgenv().dumpstring = getscriptbytecode
getgenv().setidentity = setthreadidentity
getgenv().getidentity = getthreadidentity
getgenv().setthreadcontext = setthreadidentity
getgenv().getthreadcontext = getthreadidentity
getgenv().getscriptfunction = getscriptclosure
getgenv().replaceclosure = hookfunction
getgenv().isourclosure = isexecutorclosure
getgenv().checkclosure = isexecutorclosure
getgenv().isgameactive = isrbxactive
getgenv().http_request = request
getgenv().http = getgenv().http or {}; getgenv().http.request = request


getgenv().rconsoleclear = function() end
getgenv().rconsolecreate = function()  end
getgenv().rconsoledestroy = function()  end
getgenv().rconsoleinput = function()  return "" end
getgenv().rconsoleprint = function()  end
getgenv().rconsolesettitle = function()  end

getgenv().consoleclear = getgenv().rconsoleclear
getgenv().consolecreate = getgenv().rconsolecreate
getgenv().consoledestroy = getgenv().rconsoledestroy
getgenv().consoleinput = getgenv().rconsoleinput
getgenv().consoleprint = getgenv().rconsoleprint
getgenv().consolesettitle = getgenv().rconsolesettitle
getgenv().rconsolename = getgenv().rconsolesettitle


type RenamingType = "NONE" | "UNIQUE" | "UNIQUE_VALUE_BASED"

type Options = {
renamingType: RenamingType?,
removeDotZero: boolean?,
removeFunctionEntryNote: boolean?,
swapConstantPosition: boolean?,
inlineWhileConditions: boolean?,
showFunctionLineDefined: boolean?,
removeUselessNumericForStep: boolean?,
removeUselessReturnInFunction: boolean?,
sugarRecursiveLocalFunctions: boolean?,
sugarLocalFunctions: boolean?,
sugarGlobalFunctions: boolean?,
sugarGenericFor: boolean?,
showFunctionDebugName: boolean?,
upvalueComment: boolean?
}

local options: Options = {}


local json = (function()
local json = { _version = "1.0.1" }
local encode
local escape_char_map = {
[ "\\" ] = "\\", [ "\"" ] = "\"", [ "\b" ] = "b",
[ "\f" ] = "f", [ "\n" ] = "n", [ "\r" ] = "r", [ "\t" ] = "t",
}
local escape_char_map_inv = { [ "/" ] = "/" }
for k, v in pairs(escape_char_map) do escape_char_map_inv[v] = k end

local function escape_char(c)
return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
end

local function encode_nil(val) return "null" end

local function encode_table(val, stack)
local res = {}
stack = stack or {}
if stack[val] then error("circular reference") end
stack[val] = true

if rawget(val, 1) ~= nil or next(val) == nil then
local n = 0
for k in pairs(val) do
if type(k) ~= "number" then error("invalid table: mixed or invalid key types") end
n = n + 1
end
if n ~= #val then error("invalid table: sparse array") end
for i, v in ipairs(val) do table.insert(res, encode(v, stack)) end
stack[val] = nil
return "[" .. table.concat(res, ",") .. "]"
else
for k, v in pairs(val) do
if type(k) ~= "string" then error("invalid table: mixed or invalid key types") end
table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
end
stack[val] = nil
return "{" .. table.concat(res, ",") .. "}"
end
end

local function encode_string(val)
return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
end

local function encode_number(val)
if val ~= val or val <= -math.huge or val >= math.huge then
error("unexpected number value '" .. tostring(val) .. "'")
end
return string.format("%.14g", val)
end

local type_func_map = {
[ "nil" ] = encode_nil, [ "table" ] = encode_table,
[ "string" ] = encode_string, [ "number" ] = encode_number,
[ "boolean" ] = tostring,
}

encode = function(val, stack)
local t = type(val)
local f = type_func_map[t]
if f then return f(val, stack) end
error("unexpected type '" .. t .. "'")
end

function json.encode(val) return encode(val) end
return json
end)()

local base64 = (function()
local a='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function b(c)
return(c:gsub('.',function(d)local e,a='',d:byte()for f=8,1,-1 do e=e..(a%2^f-a%2^(f-1)>0 and'1'or'0')end;return e end)..'0000'):gsub('%d%d%d?%d?%d?%d?',function(d)if#d<6 then return''end;local g=0;for f=1,6 do g=g+(d:sub(f,f)=='1'and 2^(6-f)or 0)end;return a:sub(g+1,g+1)end)..({'','==','='})[#c%3+1]
end
return{encode=b}
end)()

local api = "http://212.64.211.214:2611"

local getscriptbytecode = getscriptbytecode
local encode = base64.encode
local request = request

local function decompile(s)
local bytecode = getscriptbytecode(s)
local encoded = encode(bytecode)
local has_options = next(options) ~= nil

local response = request {
Url = api .. "/decompile",
Method = "POST",
Headers = {
["Content-Type"] = has_options and "application/json" or "text/plain"
},
Body = has_options and json.encode({
script = encoded,
decompilerOptions = options
}) or encoded,
}

return
response.StatusCode == 200 and response.Body or
response.StatusCode == 429 and "-- Rate limited. Please wait before trying again." or
response.StatusCode == 500 and "-- Decompilation failed!" or
response.StatusCode == 400 and "-- Invalid request or options" or
"-- Something went wrong when decompiling: " .. response.StatusCode
end

local function disassemble(s)
local response = request {
Url = api .. "/disassemble",
Method = "POST",
Headers = {
["Content-Type"] = "text/plain"
},
Body = encode(getscriptbytecode(s))
}

return
response.StatusCode == 200 and response.Body or
response.StatusCode == 429 and "-- Rate limited. Please wait before trying again." or
response.StatusCode == 500 and "-- Disassembly failed!" or
"-- Something went wrong when disassembling: " .. response.StatusCode
end

getgenv().decompile = decompile
getgenv().disassemble = disassemble

getgenv().filtergc = newcclosure(function(filterType, filterOptions, returnOne)
	local matches = {}

    if typeof(filterType) == "function" then
        local matches = {}
        
        for i, v in getgc(true) do
            local success, passed = pcall(filterType, v)
            if success and passed then
				if returnOne then
					return v
				else
                	table.insert(matches, v)
				end
            end
        end

	elseif filterType == "table" then
        for i, v in getgc(true) do
            if typeof(v) ~= "table" then
                continue
            end
            
            local passed = true
            
            if filterOptions.Keys and typeof(filterOptions.Keys) == "table" and passed then
                for _, key in filterOptions.Keys do
                    if rawget(v, key) == nil then
                        passed = false
                        break
                    end
                end
            end
            
            if filterOptions.Values and typeof(filterOptions.Values) == "table" and passed then
                local tableVals = {}
                for _, value in next, v do
                    table.insert(tableVals, value)
                end
                for _, value in filterOptions.Values do
                    if not table.find(tableVals, value) then
                        passed = false
                        break
                    end
                end
            end
            if filterOptions.KeyValuePairs and typeof(filterOptions.KeyValuePairs) == "table" and passed then
                for key, value in filterOptions.KeyValuePairs do
                    if rawget(v, key) ~= value then
                        passed = false
                        break
                    end
                end
            end
            
            if filterOptions.Metatable and passed then
                local success, mt = pcall(getrawmetatable, v)
                if success then
                    passed = filterOptions.Metatable == mt
                else
                    passed = false
                end
            end
            
            if passed then
                if returnOne then
                    return v
                else
                    table.insert(matches, v)
                end
            end
        end
        
    elseif filterType == "function" then
        if filterOptions.IgnoreExecutor == nil then
            filterOptions.IgnoreExecutor = true
        end
        
        for i, v in getgc(false) do
            if typeof(v) ~= "function" then
                continue
            end
            
            local passed = true
            local isCClosure = iscclosure(v)

            if filterOptions.Name and passed then
                local success, funcName = pcall(function()
                    return debug.info(v, "n")
                end)

                if success and funcName then
                    passed = funcName == filterOptions.Name
                else
                    local success2, funcString = pcall(function()
                        return tostring(v)
                    end)
                    if success2 and funcString then
                        passed = string.find(funcString, filterOptions.Name) ~= nil
                    else
                        passed = false
                    end
                end
            end
            
            if filterOptions.IgnoreExecutor == true and passed then
                local success, isExec = pcall(function() return isexecutorclosure(v) end)
                if success then
                    passed = not isExec
                else
                    passed = true
                end
            end

            if isCClosure and (filterOptions.Hash or filterOptions.Constants or filterOptions.Upvalues) then
                passed = false
            end

            if not isCClosure and passed then
                if filterOptions.Hash and passed then
                    local success, hash = pcall(function()
                        return getfunctionhash(v) or ""
                    end)
                    if success and hash then
                        passed = hash == filterOptions.Hash
                    else
                        passed = false
                    end
                end
                
                if filterOptions.Constants and typeof(filterOptions.Constants) == "table" and passed then
                    local success, constants = pcall(function()
                        return debug.getconstants(v) or {}
                    end)

                    if success and constants then
                        local funcConsts = {}
                        for idx, constant in constants do
                            if constant ~= nil then
                                table.insert(funcConsts, constant)
                            end
                        end
                        for _, constant in filterOptions.Constants do
                            if not table.find(funcConsts, constant) then
                                passed = false
                                break
                            end
                        end
                    else
                        passed = false
                    end
                end
                
                if filterOptions.Upvalues and typeof(filterOptions.Upvalues) == "table" and passed then
                    local success, upvalues = pcall(function()
                        return debug.getupvalues(v) or {}
                    end)

                    if success and upvalues then
                        local funcUpvals = {}
                        for idx, upval in upvalues do
                            if upval ~= nil then
                                table.insert(funcUpvals, upval)
                            end
                        end
                        for _, upval in filterOptions.Upvalues do
                            if not table.find(funcUpvals, upval) then
                                passed = false
                                break
                            end
                        end
                    else
                        passed = false
                    end
                end
            end
            
            if passed then
                if returnOne then
                    return v
                else
                    table.insert(matches, v)
                end
            end
        end
        
    else
        error("Expected type 'function' or 'table', got '" .. tostring(filterType) .. "'")
    end
    
    return returnOne and nil or matches
end)


print("bye")
