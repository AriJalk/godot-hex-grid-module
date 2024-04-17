class_name Enums

enum CardType{
	BUILD,
	DELIVER,
	END_ROUND,
}

static func card_type_to_string(type : CardType) -> String:
	match type:
		CardType.BUILD:
			return "Build"
		CardType.DELIVER:
			return "Deliver"
		CardType.END_ROUND:
			return "End Round"
		_:
			return ""
