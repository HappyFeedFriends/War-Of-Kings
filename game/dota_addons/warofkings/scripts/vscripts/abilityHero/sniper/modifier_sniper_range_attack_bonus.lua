
modifier_sniper_range_attack_bonus = ({
	IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end,
    GetModifierAttackRangeBonus    = function(self) return 350 end,
})