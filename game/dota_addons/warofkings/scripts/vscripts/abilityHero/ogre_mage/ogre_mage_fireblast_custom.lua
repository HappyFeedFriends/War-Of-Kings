ogre_mage_fireblast_custom = class({
	OnSpellStart = function(self)
	-- particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()
		local count = 1
		if card:IsAssemblyCard(caster:GetUnitName(),'ogre_mage_upgrade_1',caster:GetOwner():GetPlayerID()) then 
			count = card:GetDataCard(caster:GetUnitName()).Assemblies['ogre_mage_upgrade_1'].data.value
		end
		for i=1,count do

			if i > 1 then
				target = target:GetRandomUnitRadius(1000,{
					team = DOTA_UNIT_TARGET_TEAM_FRIENDLY,
					target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				})
			end
			if target then 
				target:AddNewModifier(caster, self, 'modifier_stunned', {
					duration = self:GetSpecialValueFor('duration'),
				})
				ApplyDamage({
					victim = target,
					damage = self:GetSpecialValueFor('damage'),
					attacker = caster,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				})
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_CUSTOMORIGIN, nil );
				ParticleManager:SetParticleControl(nFXIndex, 0, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex( nFXIndex );
			end
		end
	end,
})