
local RunService = game:GetService("RunService")

local function RegisterEvent(Event)
	pcall(function()
		if Event:IsA("RemoteEvent") or Event:IsA("RemoteFunction") then
			local Parent = Event.Parent
			Event.Parent = nil
				
			RunService.PreRender:Connect(function()
			    Event.Parent = Parent
			end)
			
			RunService.Heartbeat:Connect(function()
			    Event.Parent = nil
			end)
				
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

for _, Event in next, game:GetDescendants() do
	RegisterEvent(Event)
end
