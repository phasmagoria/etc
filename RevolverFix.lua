--revolver fix---yt/stripehvh
local cb = gui.Checkbox(gui.Reference("RAGE", "WEAPON", "REVOLVER", "Accuracy"), "rbot_revolver_autocock_ex", "Fixed Auto-Revolver", false)

local cnt = 0
local function on_create_move(cmd)
    local me = entities.GetLocalPlayer()
    if cb:GetValue() and me ~= nil then
        local wep = me:GetPropEntity("m_hActiveWeapon")

        if wep ~= nil and wep:GetWeaponID() == 64 then
            cnt = cnt + 1
            if cnt <= 15 then
                cmd:SetButtons(cmd:GetButtons() | (1 << 0))
            else
                cnt = 0
                
                local m_flPostponeFireReadyTime = wep:GetPropFloat("m_flPostponeFireReadyTime")
                if m_flPostponeFireReadyTime > 0 and m_flPostponeFireReadyTime < globals.CurTime() then
                    cmd:SetButtons(cmd:GetButtons() & ~(1 << 0))
                end
            end
        end
    end
end

local gui_set = gui.SetValue;
local gui_get = gui.GetValue;
local userid_to_index = client.GetPlayerIndexByUserID;
local get_local_player = client.GetLocalPlayerIndex;

local function on_item_equip(Event)
	-- returns if the current event is not the item_equip event
	if (Event:GetName() ~= 'item_equip') then
		return;
	end

	local local_player, userid, item, weptype = get_local_player(), Event:GetInt('userid'), Event:GetString('item'), Event:GetInt('weptype');

	-- checks if the local players index is equal to the player that called the event
	if (local_player == userid_to_index(userid)) then
		if (item == "deagle" or weptype == 9) then
			gui_set("msc_fakelag_enable", false);
		else
			gui_set("msc_fakelag_enable", true);
		end
	end
end

client.AllowListener('item_equip');
callbacks.Register("FireGameEvent", "on_item_equip", on_item_equip);
