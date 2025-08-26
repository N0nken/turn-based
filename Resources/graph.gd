class_name Graph
extends Resource

@export var function := ""
@export var variables : Array[String] = []

func sample(values : Array[float]) -> float:
	var expression := Expression.new()
	expression.parse(function)
	var result = expression.execute(values)
	if expression.has_execute_failed():
		print("expression execution failed: ", expression)
		print(expression.get_error_text())
	return 0.0
