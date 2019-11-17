LinkLuaModifier ("modifier_lycan_wolves_custom", "abilityHero/lycan/lycan_wolves_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_lycan_wolves", "abilityHero/lycan/lycan_wolves_custom.lua", LUA_MODIFIER_MOTION_NONE)
lycan_wolves_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_lycan_wolves_custom' end,
})

modifier_lycan_wolves_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_EVENT_ON_ATTACK_START,	
	} end,
	OnCreated 				= function(self)
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self.maxCount = self.ability:GetSpecialValueFor('max_count')
		self.damage = self.ability:GetSpecialValueFor('damage')
		self.ability.Wolves = self.ability.Wolves or {}
	end,
	OnRefresh 	= function(self)
		if not self.ability then return end
		self.maxCount = self.ability:GetSpecialValueFor('max_count')
		self.damage = self.ability:GetSpecialValueFor('damage')
	end,
})

function modifier_lycan_wolves_custom:OnAttackStart(data)
	if self.ability:IsCooldownReady() and IsServer() and data.attacker == self.parent and self.parent:GetOwner() then 
		local flag = false
		local IsAssembly = self.parent:IsAssembly('lycan_upgrade_2')
		local itemsParent = {}
		local IsUltimate = self.parent:HasModifier('modifier_lycan_shapeshift')
		if IsAssembly then
			itemsParent = self.parent:GetAllItems()
		end
		for i=1,self.maxCount do
			if self.ability.Wolves[i] and self.ability.Wolves[i]:IsNull() then 
				self.ability.Wolves[i] = nil
			end
			if not self.ability.Wolves[i] or not self.ability.Wolves[i]:IsAlive() then
				self.ability.Wolves[i] = CreateUnitByName('npc_war_of_kings_wolve', self.parent:GetOrigin(), false,self.parent:GetOwner(), self.parent:GetOwner(), self.parent:GetTeamNumber())
				self.ability.Wolves[i]:AddNewModifier(self.parent, self.ability, 'modifier_creep_heroes', {duration = -1})
				self.ability.Wolves[i]:AddNewModifier(self.parent, self.ability, 'modifier_lycan_wolves', {duration = -1})
				self.ability.Wolves[i]:SetBaseDamageMax(self.damage * (IsUltimate and 2 or 1))
				self.ability.Wolves[i]:SetBaseDamageMin(self.damage * (IsUltimate and 2 or 1))
				self.ability.Wolves[i].indexWolve = i
				self.ability.Wolves[i].attackCount = 0 - (IsUltimate and 2 or 0)
				self.ability.Wolves[i].custom_owner = self.parent
				if IsAssembly then 
					self.ability.Wolves[i]:SetHasInventory(false)
					for k,v in pairs(itemsParent) do 
						self.ability.Wolves[i]:AddItemByName(v)
					end
				end
				flag = true
			end
			if not self.ability.Wolves[i]:GetAttackTarget() and self.parent:GetAttackTarget() then
				self.ability.Wolves[i]:SetAttacking(self.parent:GetAttackTarget())
			end
		end
		if flag then 
			self.ability:StartCooldown(self.ability:GetCooldown(self.ability:GetLevel()))
		end
	end
end

modifier_lycan_wolves = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_EVENT_ON_ATTACK_LANDED,	
	} end,
	OnCreated 				= function(self)
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self.attackCount = self.ability:GetSpecialValueFor('attack_count')
	end,
})

function modifier_lycan_wolves:OnAttackLanded(data)
	if data.attacker == self.parent and self.parent.attackCount <= self.attackCount then 
		self.parent.attackCount = self.parent.attackCount + 1
		if self.parent.attackCount >= self.attackCount then 
			self.parent:ForceKill(false)
		end
	end
end