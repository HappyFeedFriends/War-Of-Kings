ability_creep_invisible = class({

})

function ability_creep_invisible:OnSwapPathCorner(data) -- custom event
	local newPathCorner = data.newPathCorner
	local nextPathCorner = data.nextPathCorner
	local caster = self:GetCaster()
	if not caster:HasModifier('modifier_invisible') then
		caster:AddNewModifier(caster, self, 'modifier_invisible', {duration = 10})
	end
end
