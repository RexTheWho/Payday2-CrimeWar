Hooks:PostHook(HUDManager, "init", "BR_init_hud_stuff", function(self)
	self._name_label_slot = managers.slot:get_mask("bullet_impact_targets_ff")
end)

local nl_w_pos = Vector3()
local nl_pos = Vector3()
local nl_dir = Vector3()
local nl_dir_normalized = Vector3()
local nl_cam_forward = Vector3()

function HUDManager:_update_name_labels(t, dt)
	local cam = managers.viewport:get_current_camera()

	if not cam then
		return
	end

	local player = managers.player:local_player()
	local in_steelsight = false

	if alive(player) then
		in_steelsight = player:movement() and player:movement():current_state() and player:movement():current_state():in_steelsight() or false
	end

	local cam_pos = managers.viewport:get_current_camera_position()
	local cam_rot = managers.viewport:get_current_camera_rotation()
	mrotation.y(cam_rot, nl_cam_forward)

	local to_remove = {}
	local panel = nil
	local ray, unit
	if managers.player and alive(managers.player:player_unit()) then
		ray = World:raycast("ray", cam_pos, cam_pos + cam_rot:y() * 100 * 50, "slot_mask", self._name_label_slot, "sphere_cast_radius", 50)
	end

	for _, data in ipairs(self._hud.name_labels) do
		local label_panel = data.panel
		panel = panel or label_panel:parent()
		local pos = nil

		if data.movement then
			if not alive(data.movement._unit) then
				label_panel:set_visible(false)

				to_remove[data.id] = true
			else
				pos = data.movement:m_pos()
				unit = data.movement._unit
				mvector3.set(nl_w_pos, pos)
				mvector3.set_z(nl_w_pos, mvector3.z(data.movement:m_head_pos()) + 30)
				mvector3.set(nl_pos, self._workspace:world_to_screen(cam, nl_w_pos))
				mvector3.set(nl_dir, nl_w_pos)
				mvector3.subtract(nl_dir, cam_pos)
				mvector3.set(nl_dir_normalized, nl_dir)
				mvector3.normalize(nl_dir_normalized)
				local dot = mvector3.dot(nl_cam_forward, nl_dir_normalized)
				
				if dot < 0 or panel:outside(mvector3.x(nl_pos), mvector3.y(nl_pos)) then
					if label_panel:visible() then
						label_panel:set_visible(false)
					end
				else
					label_panel:set_visible((ray and unit and ray.unit == unit) or unit:contour():has_id("mark_unit"))
				end
	
				local offset = data.panel:child("cheater"):h() / 2
	
				if label_panel:visible() then
					label_panel:set_center(nl_pos.x, nl_pos.y - offset)
				end
			end
		end
	end

	for id, _ in pairs(to_remove) do
		self:_remove_name_label(id)
	end
end

Hooks:PostHook(HUDManager, "_create_teammates_panel", "BR_hide_teammates", function(self, hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	for i, panel in pairs(self._teammate_panels) do
		if i ~= HUDManager.PLAYER_PANEL then
			panel._panel:set_alpha(0)
		end
	end
end)