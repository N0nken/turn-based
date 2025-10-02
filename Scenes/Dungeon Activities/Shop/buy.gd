class_name BuyButton
extends Button


func set_price(price : int) -> void:
	self.text = "Buy: " + str(price)
