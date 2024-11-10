
local function RegisterEvent(Event)
	pcall(function()
		if Event:IsA("RemoteEvent") or Event:IsA("RemoteFunction") then
			local Parent = Event.Parent
			Event.Parent = nil

			if Event:IsA("RemoteEvent") then
				Event.OnServerEvent:Connect(function(...)
					local args = {...}
					table.remove(args, 1)
					print(unpack(args))

					Event.Parent = Parent
					Event:FireServer(unpack(args))
					Event.Parent = nil
				end)
			else
				Event.OnServerInvoke = function(...)
					local args = {...}
					table.remove(args, 1)
					
					print(unpack(args))
					
					Event.Parent = Parent
					local res = {Event:InvokeServer(unpack(args))}
					Event.Parent = nil
					
					return unpack(res)
				end
			end
		end
	end)
end

game.DescendantAdded:Connect(RegisterEvent)

for _, Event in game:GetDescendants() do
	RegisterEvent(Event)
end
