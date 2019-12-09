modifier_war_of_kings_passive = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    CheckState				= function(self) return {
    	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_DISARMED] = true,
       -- [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    }  end,
    DeclareFunctions		= function(self) return {MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,MODIFIER_PROPERTY_DISABLE_HEALING} end,
    GetModifierMoveSpeedOverride 	= function(self) return 1200 end,
    GetDisableHealing   = function(self) return 1 end,
})
modifier_fear_creep_custom = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    OnCreated               = function(self)
        if not IsServer() then return end
        local unit = self:GetParent()
        unit.IsFear = true
    end,

    OnDestroy               = function(self)
        if IsServer()  then 
            self:GetParent().IsFearRemove = true
        end
    end,
})
modifier_war_of_kings_passive_unit = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    CheckState				= function(self) return {
    	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }  end,
})

modifier_creep_heroes = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    CheckState              = function(self) return {
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }  end,
})

modifier_building = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    CheckState              = function(self) return {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }  end,
})

modifier_bonus_movespeed_creep = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
    GetModifierMoveSpeedBonus_Percentage    = function(self) return 15 end,
})
modifier_base_movespeed_ancient = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE} end,
    GetModifierMoveSpeedOverride    = function(self) return 170 end,
})

modifier_shield = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

modifier_war_of_kings_bonus_damage = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end,
    GetModifierPreAttack_BonusDamage    = function(self) return self:GetStackCount() end,
})

modifier_war_of_kings_amplify = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end,
    GetModifierSpellAmplify_Percentage    = function(self) return self:GetStackCount() * self.amp end,
})

function modifier_war_of_kings_amplify:OnCreated(data)
    self.amp = (data and data.amplify or 0)
end

modifier_war_of_kings_bonus_attack_damage_special = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end,
    GetModifierPreAttack_BonusDamage    = function(self) return self:GetStackCount() end,
})

modifier_war_of_kings_bonus_attack_speed = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end,
    GetModifierAttackSpeedBonus_Constant    = function(self) return self:GetStackCount() end,
})

modifier_war_of_kings_bonus_amplify = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end,
    GetModifierSpellAmplify_Percentage    = function(self) return self:GetStackCount() end,
})

modifier_war_of_kings_bonus_amplify_special = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end,
    GetModifierSpellAmplify_Percentage    = function(self) return self:GetStackCount() end,
})

modifier_war_of_kings_rogue_critical_damage = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end,
    GetModifierPreAttack_CriticalStrike    = function(self) 
        if IsServer() and self.chance and RollPercentage(self.chance) then
            return self:GetStackCount() 
        end
    end,
})

modifier_war_of_kings_bonus_attack_range = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end,
    GetModifierAttackRangeBonus    = function(self) return self:GetStackCount() end,
})

function modifier_war_of_kings_rogue_critical_damage:OnCreated(data)
    if IsServer() then
        self.chance = data.critical_chance
    end
end

modifier_unique_aura_physical = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    IsAura                  = function(self) return true end,
    GetAuraRadius           = function(self) return -1 end,
    GetAuraSearchTeam       = function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
    GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
    GetAuraSearchType       = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
    GetModifierAura         = function(self) return 'modifier_unique_aura_physical_buff' end,
    OnCreated               = function(self)
        if IsServer() then
            self.pID = self:GetParent():GetPlayerID()
        end
    end,
})
function modifier_unique_aura_physical:GetAuraEntityReject(hEntity)
    return not hEntity.GetBuilding or hEntity.GetBuilding():GetPlayerOwnerID() ~= self.pID
end
modifier_unique_aura_magical = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    IsAura                  = function(self) return true end,
    GetAuraRadius           = function(self) return -1 end,
    GetAuraSearchTeam       = function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
    GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
    GetAuraSearchType       = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
    GetModifierAura         = function(self) return 'modifier_unique_aura_magical_buff' end,
    OnCreated               = function(self)
        if IsServer() then
            self.pID = self:GetParent():GetPlayerID()
        end
    end,
})
function modifier_unique_aura_magical:GetAuraEntityReject(hEntity)
    return not hEntity.GetBuilding or hEntity.GetBuilding():GetPlayerOwnerID() ~= self.pID
end
modifier_unique_aura_midas = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    IsAura                  = function(self) return true end,
    GetAuraRadius           = function(self) return -1 end,
    GetAuraSearchTeam       = function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
    GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
    GetAuraSearchType       = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
    GetModifierAura         = function(self) return 'modifier_unique_aura_midas_buff' end,
    OnCreated               = function(self)
        if IsServer() then
            self.pID = self:GetParent():GetPlayerID()
        end
    end,
})
function modifier_unique_aura_midas:GetAuraEntityReject(hEntity)
    return not hEntity.GetBuilding or hEntity.GetBuilding():GetPlayerOwnerID() ~= self.pID
end
modifier_unique_aura_midas_buff = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_EVENT_ON_ATTACK_LANDED} end,
    OnCreated               = function(self)
        self.parent = self:GetParent()

    end,
})
modifier_unique_aura_midas_buff_cooldown =  class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return false end,
    IsPermanent             = function(self) return true end,
})
function modifier_unique_aura_midas_buff:OnAttackLanded(data)
    if not data.target:IsBoss() and 
        data.attacker == self.parent and 
        not self.parent:HasModifier('modifier_unique_aura_midas_buff_cooldown') and 
        RollPercentage(10) then 
        local target = data.target
        local bounty = target:GetGoldBounty() * 2
        target:SetDeathXP( 2 * target:GetDeathXP() )
        target:EmitSound("DOTA_Item.Hand_Of_Midas")
        local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) 
        ParticleManager:SetParticleControlEnt(midas_particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), false)
        target:SetMinimumGoldBounty( bounty ) 
        target:SetMaximumGoldBounty( bounty )
        target:Kill(nil, self.parent)
        self.parent:AddNewModifier(self.parent, nil, 'modifier_unique_aura_midas_buff_cooldown', {duration = 30})
    end
end

modifier_unique_aura_physical_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE} end,
    GetModifierPercentageManaRegen        = function(self) return -20 end,
})

modifier_unique_aura_magical_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE
    } 
    end,
    GetModifierSpellAmplify_Percentage    = function(self) return 40 end,
    GetModifierConstantManaRegenUnique    = function(self) return 5 end,
    GetModifierPercentageCooldown         = function(self) return 35 end,
})

modifier_unique_aura_all_damage = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
    IsAura                  = function(self) return true end,
    GetAuraRadius           = function(self) return -1 end,
    GetAuraSearchTeam       = function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
    GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
    GetAuraSearchType       = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
    GetModifierAura         = function(self) return 'modifier_unique_aura_all_damage_buff' end,
    OnCreated               = function(self)
        if IsServer() then
            self.pID = self:GetParent():GetPlayerID()
        end
    end,
})
function modifier_unique_aura_all_damage:GetAuraEntityReject(hEntity)
    return not hEntity.GetBuilding or hEntity.GetBuilding():GetPlayerOwnerID() ~= self.pID
end
modifier_unique_aura_all_damage_buff = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return true end,
    IsPermanent             = function(self) return true end,
})