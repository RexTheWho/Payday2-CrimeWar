Hooks:PostHook(GameSetup, "init_managers", "init_friendly_fire", function(self, managers)
	managers.slot._masks.bullet_impact_targets = managers.slot._masks.bullet_impact_targets_ff
end)