doom_3 = class({
	OnSpellStart 	= function(self)
		if self.unit and not self.unit:IsNull() and self.unit:IsAlive() then 
			self.unit:RemoveSelf()
			self.unit = nil
		end
		local damage = self:GetSpecialValueFor('damage')

		local caster = self:GetCaster()

		self.unit = CreateUnitByName('npc_war_of_kings_doom_demon', caster:GetOrigin(), true,caster:GetOwner(), caster:GetOwner(), caster:GetTeamNumber())
		self.unit:SetBaseDamageMax(damage)
		self.unit:SetBaseDamageMin(damage)

		self.unit:AddNewModifier(caster, self, 'modifier_kill', {
			duration = self:GetSpecialValueFor('duration')
		})

		self.unit:AddNewModifier(caster, self, 'modifier_rooted', {
			duration = self:GetSpecialValueFor('duration')
		})
	end,
})