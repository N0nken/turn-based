class_name Formula
extends Resource

@export var function := ""
@export var variables : Array[String] = []

func sample(values : Array[float]) -> float:
	var expression := Expression.new()
	expression.parse(function, variables)
	var result : float = expression.execute(values)
	if expression.has_execute_failed():
		print("expression execution failed: ", expression)
		print(expression.get_error_text())
	return result
