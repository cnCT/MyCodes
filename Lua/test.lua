local LL = { Level = 1}

function LL:Level( ... )
	-- body
	print("111")
end

for k,v in pairs(LL) do
	print(k,v)
end