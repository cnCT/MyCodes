-- avoid memory leak
collectgarbage("setpause", 100)
--collectgarbage("setpause", 0.3)
collectgarbage("setstepmul", 5000)
-- collectgarbage("setstepmul", 100)
DEBUG_MODE = true
local OPEN_CTDUMP = true  			    --CT测试dump
local OPEN_CTTrace = true  			--CT测试trace
local OPEN_CCLOG = true			-- 测试普通日志
local OPEN_ZGLOG = true				-- zhuge
local OPEN_CCNETLOG = true			-- 测试网络日志
GV_MUSICE_EX = ".mp3"

if not DEBUG_MODE then
	OPEN_CTDUMP = false  			    --CT测试dump
	OPEN_CTTrace = false  			--CT测试trace
	OPEN_CCLOG = false			-- 测试普通日志
	OPEN_ZGLOG = false				-- zhuge
	OPEN_CCNETLOG = false			-- 测试网络日志
end

require "scheduler"
require "UI"
-- require "Constants"
-- require "CommonUtils"
-- require "class"
require "LuaLayer"
require "CandyEnum"
require "Localizable"
require "Preload"

GV_docPath = CCFileUtils:sharedFileUtils():getWritablePath()
GV_Instance = {}

CCLOG = function(...)
	if OPEN_CCLOG then
		-- test_print(...)
		print(...)
	    -- print("LUA--"..string.format(...))
	end
end

CCLOGF = function(...)
	if OPEN_CCLOG then
		print(string.format(...))
	end
end

ZGLOG = function( ... )
	if OPEN_ZGLOG then
		print("ZGLUA--"..string.format(...))
	end
end

CCNETLOG = function(...)
	if OPEN_CCNETLOG then
		-- test_print(...)
	    print("NETLUA--"..string.format(...))
	end
end


--打印某对象的值
GF_dump = function(object, label, nesting, nest)
	if DEBUG_MODE and OPEN_CTDUMP then
		if type(nesting) ~= "number" then nesting = 99 end
	    local lookup_table = {}
	    local function _dump(object, label, indent, nest)
	        label = label or "<var>"
	        if type(object) ~= "table" then
	            print(string.format("%s%s = %s", indent, tostring(label), tostring(object)..""))
	        elseif lookup_table[object] then
	            print(string.format("%s%s = *REF*", indent, tostring(label)))
	        else
	            lookup_table[object] = true
	            if nest > nesting then
	                print(string.format("%s%s = *MAX NESTING*", indent, label))
	            else
	                print(string.format("%s%s = {", indent, tostring(label)))
	                local indent2 = indent.."    "
	                for k, v in pairs(object) do
	                    _dump(v, k, indent2, nest + 1)
	                end
	                print(string.format("%s}", indent))
	            end
	        end
	    end
	    _dump(object, label, "- ", 1)
	end
end

GF_dumpPr = function(object, label, nesting, nest)
	if DEBUG_MODE and OPEN_CTDUMP then
		if type(nesting) ~= "number" then nesting = 99 end
	    local lookup_table = {}
	    local function _dump(object, label, indent, nest)
	        label = label or "<var>"
	        if type(object) ~= "table" then
	        	if type(label) ~= "number" then
	        		if type(object) ~= "number" then
	            		print(string.format("%s%s = %s,", indent, tostring(label), "\""..tostring(object).."\""))
	            	else
	            		print(string.format("%s%s = %s,", indent, tostring(label), tostring(object)..""))
	            	end
	            else
	            	print(string.format("%s %s", indent, tostring(object)..","))
	            end
	        elseif lookup_table[object] then
	            print(string.format("%s%s = *REF*", indent, tostring(label)))
	        else
	            lookup_table[object] = true
	            if nest > nesting then
	                print(string.format("%s%s = *MAX NESTING*", indent, label))
	            else
	            	if type(label) ~= "number" then
	                	print(string.format("%s%s = {", indent, tostring(label)))
	                else
	                	print(string.format("%s {", indent))
	                end
	                local indent2 = indent.."    "
	                for k, v in pairs(object) do
	                    _dump(v, k, indent2, nest + 1)
	                end
	                print(string.format("%s },", indent))
	            end
	        end
	    end
	    _dump(object, label, "- ", 1)
	end
end

--CT打印开关
GF_ddump = function( object, label, nesting, nest )
	-- body
	if OPEN_CTDUMP then
		GF_dump( object, label, nesting, nest )
	end
end

GF_trace = function(msg)
	if DEBUG_MODE and OPEN_CTTrace then
		print("----------------------------------------")
		if msg then
			print("traceback for msg : "..msg)
		end
		print(debug.traceback())
		print("----------------------------------------")
	end
end


--初始化随机值
math.randomseed(os.time())
math.random(1241232)	-- 第一次的随机值是不靠谱的，所以初始化先随机一次



--临时持有全局变量------------------------------------------------------------------------
--[[
   临时变量有可能会被垃圾回收掉，可以用这个表缓存一下
]]--
FV_TEMP_RETAIN = {}
function GF_retainObject(key, obj)
	FV_TEMP_RETAIN[key] = obj
end

function GF_releaseObject(key, obj)
	FV_TEMP_RETAIN[key] = nil
end

--复制表
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

--table表操作支持------------------------------------------------------------------------
--复制单表函数
function GF_simpleCopy(ori_tab)
    if (type(ori_tab) ~= "table") then
        return nil;
    end
    local new_tab = {};
    for i,v in pairs(ori_tab) do
        local vtyp = type(v);
        if (vtyp == "table") then
            new_tab[i] = GF_simpleCopy(v);
        elseif (vtyp == "thread") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        elseif (vtyp == "userdata") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        else
            new_tab[i] = v;
        end
    end
    return new_tab;
end
--复制深层表
function GF_deepCopy(object)

    return GF_simpleCopy(object)
end  

--清空表
function GF_clearTable(t)
  for k, v in pairs(t) do
    t[k]= nil -- 删除这个元素
  end
end

--计算表的长度
function GF_getTableLength(t)
  local count = 0
  for k,v in pairs(t) do
    count = count + 1
  end
  return count
end

--文件操作处理---------------------------------------------------------------------------
--判断文件是否存在
function GF_file_exists(path)
	--path = path.."d"
	local file = io.open(path, "rb") 
	if file then 
		file:close()
	end
	return file ~= nil 
	-- return RedCommonUtils:isFileWithPathExists(path)
end

-- 挎贝文件
function GF_copyFile( fromPath, toPath )
	local fromFile = io.open(fromPath, "r")
    local toFile = io.open(toPath, "w")
    local wholeFile = fromFile:read("*all")
	toFile:write(wholeFile)
	io.close(fromFile)
	io.close(toFile)
end


--输出table变量至io
local function serialize (file, o)
	if type(o) == "number" then
    	file:write(o)
   	elseif type(o) == "string" then
       	file:write(string.format("%q", o))
  	elseif type(o) == "table" then
       	file:write("{\n")
       	for k,v in pairs(o) do
       		if type(k) ~= "number" then
          		file:write(" ", k, " = ")
          	end
          	serialize(file, v)
          	file:write(",\n")
		end
       	file:write("}\n")
	elseif type(o) == "boolean" then
		if o then 
			file:write("true")
		else
			file:write("false")
		end
   	else
   		GF_trace("error_when_serialize")
       	error("cannot serialize a " .. type(o))
   	end
end

--输出table变量至io
local function serializeForString (tableName, o)
	local fileString = ""
	if tableName then
		fileString = tableName.."="
	end

	if type(o) == "number" then
    	fileString =  string.format('%s %d', fileString, o)
   	elseif type(o) == "string" then
       	fileString = string.format("%s %q", fileString, o)
  	elseif type(o) == "table" then
       	fileString = string.format("%s{\n", fileString)
       	for k,v in pairs(o) do
       		if type(k) ~= "number" then
          		fileString = string.format("%s %s=%s,\n", fileString, tostring(k), serializeForString(nil, v))
          	else
          		fileString = string.format("%s %s,\n", fileString, serializeForString(nil, v))
          	end
		end
       	fileString = string.format("%s}\n", fileString)
	elseif type(o) == "boolean" then
		if o then 
     	  	fileString = string.format("%s true", fileString)
		else
     	  	fileString = string.format("%s false", fileString)
		end
   	else
   		GF_trace("error_when_serialize")
       	error("cannot serialize a " .. type(o))
   	end

   	return fileString
end

function GF_saveTableToFiles(table, tableName, fileName)
	--GF_saveTableToFileForString(table, tableName, fileName..'d')
	-- local function file_exists( path )
	-- 	local file = io.open(path, "rb") 
	-- 	if file then 
	-- 		file:close()
	-- 	end
	-- 	return file ~= nil
	-- end
	   --assert(fileName~=nil, "saveVarToFile function need fileName")
	   local file = io.open(fileName, "w")
	   -- CCLOG("saving table to "..fileName)
	   -- CCLOG(type(file))
	--变量名名称为必须，否则写入的文件无法读出
	if tableName ~= nil then
		file:write(tableName.." = ")
	else
		error("saveVarToFile function need varName")
	end
	--之后文件以添加的方式写入
	io.close(file)
	file = io.open(fileName, "a")
	serialize(file, table)
	io.close(file)
	-- RedCommonUtils:encryptLuaFile(fileName,fileName.."d")
	-- if file_exists(fileName) then
	-- 	os.remove(fileName)
	-- end
end

function GF_saveTableToFileForString(table, tableName, fileName)
    local tableString = serializeForString(tableName, table)
    RedCommonUtils:encryptStr2File(tableString, fileName)
end

--[[------------------------------------------------------------------
	保存文件
	table		要保存的表
	tableName	保存文件中bable变量的名称，若不指定，则读出的文件无法解析
	fileName	要保存至的文件
--]]------------------------------------------------------------------
function GF_saveTableToFile(table, tableName, fileName)
	GF_saveTableToFileForString(table, tableName, fileName..'d')
end


scheduler = CCDirector:getInstance():getScheduler()

function scheduleOnce(fun, delay, owner)
    local handle
    handle = scheduler:scheduleScriptFunc(function()
            scheduler:unscheduleScriptEntry(handle)
            if owner then
                fun(owner)
            else
                fun()
            end
        end, delay, false)
end

function osClock( ... )
	-- body
	G_time = os.clock()
	return G_time
end

function getDiffTime( ... )
	-- body
	local startTime = G_time or osClock()
	return (os.clock()-startTime)
end

function printClock( str )

	-- body
	-- print(debug.traceback())
	-- print(str,getDiffTime())
end

function Assert( ... )
	-- bodycommon
	assert(...)
end

local function serializeLua(obj)  
    local lua = ""  
    local t = type(obj)  
    if t == "number" then  
        lua = lua .. obj  
    elseif t == "boolean" then  
        lua = lua .. tostring(obj)  
    elseif t == "string" then  
        lua = lua .. string.format("%q", obj)  
    elseif t == "table" then  
        lua = lua .. "{\n"  
    for k, v in pairs(obj) do  
        lua = lua .. "[" .. serializeLua(k) .. "]=" .. serializeLua(v) .. ",\n"  
    end  
    local metatable = getmetatable(obj)  
        if metatable ~= nil and type(metatable.__index) == "table" then  
        for k, v in pairs(metatable.__index) do  
            lua = lua .. "[" .. serializeLua(k) .. "]=" .. serializeLua(v) .. ",\n"  
        end  
    end  
        lua = lua .. "}"  
    elseif t == "nil" then  
        return nil  
    else  
        error("can not serializeLua a " .. t .. " type.")  
    end  
    return lua  
end 

local function unserializeLua(lua)  
    local t = type(lua)  
    if t == "nil" or lua == "" then  
        return nil  
    elseif t == "number" or t == "string" or t == "boolean" then  
        lua = tostring(lua)  
    else  
        error("can not unserializeLua a " .. t .. " type.")  
    end  
    lua = "return " .. lua  
    local func = loadstring(lua)  
    if func == nil then  
        return nil  
    end  
    return func()  
end 

local crypto = {}
local Key = "xxRedSW"
--[[--

使用 XXTEA 算法加密内容

@param string plaintext 明文字符串
@param string key 密钥字符串

@return string  加密后的字符串

]]
function crypto.encryptXXTEA(plaintext, key)
    plaintext = tostring(plaintext)
    key = Key or tostring(key)
    -- return CCCrypto:encryptXXTEA(plaintext, string.len(plaintext), key, string.len(key))
    return plaintext
end

--[[--

使用 XXTEA 算法解密内容

@param string ciphertext 加密后的字符串
@param string key 密钥字符串

@return string  明文字符串

]]
function crypto.decryptXXTEA(ciphertext, key)
    ciphertext = tostring(ciphertext)
    key = Key or tostring(key)
    -- return CCCrypto:decryptXXTEA(ciphertext, string.len(ciphertext), key, string.len(key))
    return ciphertext
end

function GF_getTableFromFile( fileName )
	-- body
	if not string.find(fileName,"/") then
		fileName = GV_docPath..fileName
	end
	local file = io.open(fileName, "r")
	Assert(file,"file is nil")
	local str = file:read("*all")
	str = crypto.decryptXXTEA(str)
	return unserializeLua(str)
end

function GF_saveTableToFileForString(table, fileName)
    local str = crypto.encryptXXTEA(serializeLua(table))
    if not string.find(fileName,"/") then
		fileName = GV_docPath..fileName
	end
    local file = io.open(fileName, "w")
    file:write(str)
	io.close(file)
end

--[[------------------------------------------------------------------
	保存文件
	table		要保存的表
	tableName	保存文件中bable变量的名称，若不指定，则读出的文件无法解析
	fileName	要保存至的文件
--]]------------------------------------------------------------------
function GF_saveTableToFile(table, tableName, fileName)
	GF_saveTableToFileForString(table, fileName)
end

require "ParticleAnimationPlayer"
GV_Instance.particleAnimationPlayer = ParticleAnimationPlayer:instance()