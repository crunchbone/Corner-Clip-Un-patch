local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Limit = 5
local Player = Players.LocalPlayer

local last = 0;
lastLast = 0;

local RParams = RaycastParams.new()



local function raycast(org, pos, ignore)
	RParams.FilterDescendantsInstances = ignore
	local RayCastResult = workspace:Raycast(org,pos*5,RParams)
	if RayCastResult then
		return RayCastResult
	end
end

local function getCorners(part)
	local pos = part.Position
	local size = part.Size
	return {
		Vector3.new( pos.X+(size.X/2), pos.Y, pos.Z+(size.Z/2) ),
		Vector3.new( pos.X+(size.X/2), pos.Y, pos.Z-(size.Z/2) ),
		Vector3.new( pos.X-(size.X/2), pos.Y, pos.Z+(size.Z/2) ),
		Vector3.new( pos.X-(size.X/2), pos.Y, pos.Z-(size.Z/2) )
	}
	 
end

local function alignYAxis(t, y)
	local nt = {}
	for _, vector3 in pairs(t) do
		 table.insert(nt,Vector3.new(vector3.X, y, vector3.Z))
	end
	return nt
end

local function getDistance(pos1, pos2)
	return (pos1-pos2).Magnitude
end

function PlacePart(pos)
	local part = Instance.new("Part")
	part.Size = Vector3.new(0.5, 0.5, 0.5)
	part.Anchored = true
	part.Position = pos
	part.CanCollide = false
	part.BrickColor = BrickColor.new("Really red")
	part.Parent = workspace
	return part
end


RunService.RenderStepped:Connect(function()
	
	
	local character = Player.Character
	if character then
		--For R6
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		
		if humanoidRootPart then
			
			
			
			local rootJoint = humanoidRootPart:FindFirstChild("RootJoint")
	
			if (humanoidRootPart.Rotation.Y == -(last) or  (humanoidRootPart.Rotation.Y > (-(last))-10)  and humanoidRootPart.Rotation.Y < (-(last))+10)  and last ~= 0 and  (humanoidRootPart.Rotation.Y > 10 or humanoidRootPart.Rotation.Y < -10)   then
				last = humanoidRootPart.Rotation.Y
				warn("_Inverse_ "..last)
				
				local rez = raycast(humanoidRootPart.Position, -(humanoidRootPart.CFrame.LookVector), {character})
				
				if rez then
					
					--Find corner 
					local corners = alignYAxis(getCorners(rez.Instance), humanoidRootPart.Position.Y)
					local corner = nil
					
					for index, value  in pairs(corners)  do
						print(value)
						if getDistance(value, humanoidRootPart.Position) <= 0.53 then
							corner = value
							break
						end
					end
					
					if corner ~= nil then
						print(corner)
						PlacePart(corner)
					end
				end
			else
				last = humanoidRootPart.Rotation.Y
			end
		end
	end
end)
