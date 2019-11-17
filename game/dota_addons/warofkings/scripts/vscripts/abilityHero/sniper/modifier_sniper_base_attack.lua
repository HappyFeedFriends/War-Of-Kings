modifier_sniper_base_attack = ({
	IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT} end,
    GetModifierBaseAttackTimeConstant    = function(self) return 0.7 end,
})
