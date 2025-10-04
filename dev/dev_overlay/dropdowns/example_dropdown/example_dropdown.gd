extends DevDropdown


func setup() -> void:
	add_to_menu("Hello, world!", print_hello)


func print_hello() -> void:
	print("Hello, world!")
