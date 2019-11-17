local MODULES =
{
	'card',
	'round',
	'shop',
	'kills',
	'quests',
	'request',
}

for k,v in pairs(MODULES) do

	ModuleRequire(...,v .. "/" .. v )
end 
