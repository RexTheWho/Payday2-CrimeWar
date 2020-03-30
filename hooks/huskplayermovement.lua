function HuskPlayerMovement:sync_start_auto_fire_sound()
	if self._state == "mask_off" or self._state == "clean" or self._state == "civilian" then
		return
	end

	if self._auto_firing <= 0 then
		local delay = self._stance.values[3] < 0.7

		if delay then
			self._auto_firing = 1

			local function f(t)
				local equipped_weapon = self._unit:inventory():equipped_unit()
				local start_auto_fire = equipped_weapon:base().start_autofire

				local name = equipped_weapon:base():get_name_id()

				if equipped_weapon then
					if start_auto_fire then
						equipped_weapon:base():start_autofire()
					end
                end

				self._auto_firing = 2
			end

			self:_change_stance(3, f)
		else
			local equipped_weapon = self._unit:inventory():equipped_unit()
			local start_auto_fire = equipped_weapon:base().start_autofire

            if equipped_weapon then
			    if start_auto_fire then
					equipped_weapon:base():start_autofire()
				end
             end

			self:_change_stance(3, false)

			self._auto_firing = 2
		end

		self._aim_up_expire_t = TimerManager:game():time() + 2
	end
end

function HuskPlayerMovement:sync_stop_auto_fire_sound()
	if self._state == "mask_off" or self._state == "clean" or self._state == "civilian" then
		return
	end

	if self._auto_firing > 0 then
		local equipped_weapon = self._unit:inventory():equipped_unit()
		local stop_autofire = equipped_weapon:base().stop_autofire

		local name = equipped_weapon:base():get_name_id()

		if equipped_weapon then
			if stop_autofire then
				equipped_weapon:base():stop_autofire()
			end
		end
		
		self._auto_firing = 0
		local stance = self._stance

		if stance.transition then
			stance.transition.delayed_shot = nil
		end
	end
end
