------------
-- Config --
------------

local btn = true
local point = {"CENTER", UIParent, "CENTER", 120, -50}

----------
-- Core --
----------

local button = CreateFrame("Button", "form", UIParent, "SecureActionButtonTemplate")
	--button:SetPoint("CENTER", UIParent, "CENTER", 120, -50)
	button:SetPoint(unpack(point))
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetClampedToScreen(true)
	button:SetMovable(true)
	button:SetUserPlaced(true)
	button:RegisterForClicks("AnyUp", "AnyDown")
	button:SetText(SLASH_CANCELFORM1:gsub("/(.*)","%1"))
	button:SetNormalFontObject("GameFontNormal")
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext", "/cancelform")
	
	local ntex = button:CreateTexture()
	ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()	
	button:SetNormalTexture(ntex)
	
	local htex = button:CreateTexture()
	htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	button:SetHighlightTexture(htex)
	
	local ptex = button:CreateTexture()
	ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()
	button:SetPushedTexture(ptex)
	
	button:Hide()
	
local function anchor_Tooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	GameTooltip:AddDoubleLine(DRAG_MODEL, "Alt + |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t", 0, 1, 0.5, 1, 1, 1)
	GameTooltip:Show()
end

-- create a drag frame
local anchor = CreateFrame("Frame", nil, form)
	anchor:SetPoint("TOPLEFT", "form", -40, 0)
	anchor:SetSize(40, 40)
	anchor:EnableMouse(true)
	anchor:SetFrameStrata("BACKGROUND")
	--anchor:SetClampedToScreen(true)
	--anchor:SetMovable(true)
	--anchor:SetUserPlaced(true)
	anchor:RegisterForDrag("RightButton")
	anchor:SetScript("OnDragStart", function(self, button)
		if IsAltKeyDown() then
			local frame = self:GetParent()
			frame:StartMoving()
		end
	end)
	anchor:SetScript("OnDragStop", function(self, button)
		local frame = self:GetParent()
		frame:StopMovingOrSizing()
	end)
	-- Show tooltip for drag
	anchor:SetScript("OnEnter", function(self)
		anchor_Tooltip(self)
	end)
	anchor:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	-- Reset / 重置
	SlashCmdList["RESETCF"] = function() 
		--button:SetUserPlaced(false)
		button:ClearAllPoints()
	end
	SLASH_RESETCF1 = "/rcf"

local fb = CreateFrame("Frame")
function fb:OnEvent(event)
	if btn ~= true then return end
	
	local class = select(2, UnitClass("player"))
	local instanceType = select(2, IsInInstance())
	
	if not (class == "DRUID" or class == "SHAMAN" or class == "PRIEST") then return end
	
	if GetShapeshiftForm() > 0 and instanceType == "none" then
		button:Show()
		--SetBindingClick("TAB", "form")
	else
		button:Hide()
	end
end

fb:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED")
fb:RegisterEvent("ZONE_CHANGED_NEW_AREA")
fb:RegisterEvent("PLAYER_ENTERING_WORLD")
fb:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
fb:SetScript("OnEvent", fb.OnEvent)

local errList = {
	[SPELL_FAILED_NOT_MOUNTED] = true,
	[ERR_ATTACK_MOUNTED] = true,
	[ERR_TAXIPLAYERALREADYMOUNTED] = true,	
}

local f = CreateFrame("Frame")
function f:OnEvent(event, key, state)
	if state == SPELL_FAILED_NOT_STANDING then
		DoEmote("stand")
	--elseif state == SPELL_FAILED_NOT_MOUNTED or state == ERR_ATTACK_MOUNTED then
	elseif errList[state] then
		Dismount()	
	end
end

f:RegisterEvent("UI_ERROR_MESSAGE")
f:SetScript("OnEvent", f.OnEvent)

--[[
	SPELL_FAILED_NOT_MOUNTED,
	ERR_ATTACK_MOUNTED,
	ERR_TAXIPLAYERALREADYMOUNTED,
	SPELL_FAILED_NOT_SHAPESHIFT,
	SPELL_FAILED_NO_ITEMS_WHILE_SHAPESHIFTED,
	SPELL_NOT_SHAPESHIFTED,
	SPELL_NOT_SHAPESHIFTED_NOSPACE,
	ERR_CANT_INTERACT_SHAPESHIFTED,
	ERR_NOT_WHILE_SHAPESHIFTED,
	ERR_NO_ITEMS_WHILE_SHAPESHIFTED,
	ERR_TAXIPLAYERSHAPESHIFTED,
	ERR_MOUNT_SHAPESHIFTED
	ERR_EMBLEMERROR_NOTABARDGEOSET
]]--
