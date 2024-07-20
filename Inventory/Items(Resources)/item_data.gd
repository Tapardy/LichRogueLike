extends Resource
class_name ItemData

enum Type {
	MAIN,
	SUB1
}

enum SubSpellType{
	DAMAGE_INCREASE,
	SIZE_INCREASE,
	SPELL_DUPLICATION,
	NONE
}

@export var type: Type
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
@export var sub_spell_type: SubSpellType
