-- inherit class
modifier_attribute_all_base = {
    OnCreated = function(self,data)
        self.parent = self:GetParent()
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self:__OnCreated__(data)
        if self.parent.ReCalculateAttributes then
            local agi = self.GetModifierBonusStats_Agility and self:GetModifierBonusStats_Agility() or 0
            local str = self.GetModifierBonusStats_Strength and self:GetModifierBonusStats_Strength() or 0
            local int = self.GetModifierBonusStats_Intellect and self:GetModifierBonusStats_Intellect() or 0

            if agi > 0 then 
                self.parent:ModifyAgility(agi)
            end

            if str > 0 then 
                self.parent:ModifyStrength(str)
            end

            if int > 0 then 
                self.parent:ModifyIntellect(int)
            end

        end
    end,

    OnDestroy = function(self)
        self:__OnDestroy__()
        if self:GetParent().ReCalculateAttributes then
            self.__Destroy = true

            local agi = self.GetModifierBonusStats_Agility and self:GetModifierBonusStats_Agility() or 0
            local str = self.GetModifierBonusStats_Strength and self:GetModifierBonusStats_Strength() or 0
            local int = self.GetModifierBonusStats_Intellect and self:GetModifierBonusStats_Intellect() or 0

            if agi > 0 then 
                self.parent:ModifyAgility(-agi)
            end

            if str > 0 then 
                self.parent:ModifyStrength(-str)
            end

            if int > 0 then 
                self.parent:ModifyIntellect(-int)
            end
           
            -- self:GetParent():ReCalculateAttributes()
        end
    end,
}

modifier_attributes_custom_strength = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self)
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    } end,
    GetModifierPreAttack_BonusDamage = function(self)
        return self:GetStackCount() / 5
    end,
})

modifier_attributes_custom_agility = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self)
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    } end,
    GetModifierAttackSpeedBonus_Constant = function(self)
        return self:GetStackCount() / 3
    end,
})

modifier_attributes_custom_intellect = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self)
    return {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
    } end,
    GetModifierConstantManaRegen = function(self)
        return self:GetStackCount() /42
    end,
    GetModifierSpellAmplify_Percentage = function(self)
        return math.floor(self:GetStackCount() /19)
    end,

    GetModifierExtraManaBonus = function(self)
        return self:GetStackCount() * 15
    end,
})

modifier_attributes_custom_base_strength = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
})

modifier_attributes_custom_base_agility = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
})

modifier_attributes_custom_base_intellect = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
})

modifier_attributes_custom_primary_0 = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self)
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
    end,
    OnCreated               = function(self)
        self.parent = self:GetParent()
        self.modifier = self.parent.hStrModifier
    end,
    GetModifierPreAttack_CriticalStrike     = function(self)
        if not self.modifier then return end
        local str = self.modifier:GetStackCount()
        local chance = math.min(math.floor((0.0005 * str)/(1 + 0.001 * str)*100),75)
        if RollPercentage(chance) then 
            return 100 + math.floor(str/20)
        end
    end,
})

modifier_attributes_custom_primary_1 = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self)
    return {
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
    end,
    OnCreated               = function(self)
        self.parent = self:GetParent()
        self.modifier = self.parent.hAgiModifier
    end,
    GetModifierBaseAttackTimeConstant = function(self)
        if not self.modifier then return end
        local value = self.modifier:GetStackCount()
        return math.min((0.0005 * value)/(1 + 0.001 * value),0.4)
    end,
    GetModifierAttackRangeBonus         = function(self)
        if not self.modifier then return end
        local value = self.modifier:GetStackCount()
        return value / 9
    end,
})

modifier_attributes_custom_primary_2 = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE} end,
    OnCreated               = function(self)
        self.parent = self:GetParent()
        self.modifier = self.parent.hIntModifier
    end,
    GetModifierPercentageCooldown = function(self)
        if not self.modifier then
            return nil
        end
        local value = self.modifier:GetStackCount()
        return math.floor(math.min((0.0009 * value)/(1 + 0.001 * value)*100,75))
    end,

    GetModifierEffectDuration_Custom = function(self)
        if not self.modifier then return end
        local value = self.modifier:GetStackCount() 
        return ((( value / 100 + 1 ) / ( 0.4403 * value / 100 + 1 ) - 1) * 100)
    end,
})