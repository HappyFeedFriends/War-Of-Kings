ursa_overpower_custom = class({
	OnSpellStart = function(self)
		local caster = self:GetCaster()

		caster:AddNewModifier(caster,self, 'modifier_ursa_overpower_custom_buff', {

		})
	end,
})