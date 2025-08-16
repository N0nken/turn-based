extends Node

var json = JSON.new()

func read_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	var content = file.get_as_text()
	return content

func read_json(filepath):
	var stringContent = read_file(filepath)
	var error = json.parse(stringContent)
	if error == OK:
		var data_received = json.data
		return data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", stringContent, " at line ", json.get_error_line())
