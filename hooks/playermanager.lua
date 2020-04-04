function PlayerManager:_internal_load()
	local player = self:player_unit()

	if not player then
		return
	end

	local default_weapon_selection = 2
	local secondary = {factory_id = "wpn_fps_pis_g17", cosmetics = "nil-1-0"}
	local secondary_slot = managers.blackmarket:equipped_weapon_slot("secondaries")
	local texture_switches = managers.blackmarket:get_weapon_texture_switches("secondaries", secondary_slot, secondary)

	player:inventory():add_unit_by_factory_name(secondary.factory_id, default_weapon_selection == 1, false, nil, secondary.cosmetics, texture_switches)

	local primary = {factory_id = "wpn_fps_ass_amcar", cosmetics = "nil-1-0"}

    local primary_slot = managers.blackmarket:equipped_weapon_slot("primaries")
    texture_switches = managers.blackmarket:get_weapon_texture_switches("primaries", primary_slot, primary)

    player:inventory():add_unit_by_factory_name(primary.factory_id, default_weapon_selection == 2, true, nil, primary.cosmetics, texture_switches)

	player:inventory():set_melee_weapon(managers.blackmarket:equipped_melee_weapon())

    
	local peer_id = managers.network:session():local_peer():id()
	local grenade, amount = managers.blackmarket:equipped_grenade()

	if self:has_grenade(peer_id) then
		amount = self:get_grenade_amount(peer_id) or amount
	end

	amount = managers.modifiers:modify_value("PlayerManager:GetThrowablesMaxAmount", amount)

	self:_set_grenade({
		grenade = grenade,
		amount = math.min(amount, self:get_max_grenades())
	})
	self:_set_body_bags_amount(self._local_player_body_bags or self:total_body_bags())
end