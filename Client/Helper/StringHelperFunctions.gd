class_name Helper
extends Node


static func numberCommas(number) -> String:
	
	var string = str(number)
	
	var stringarray = string.split(".", false)
	
	var og_chararray = stringarray[0].to_ascii()
	
	og_chararray.invert()
	
	var new_char_array = PoolByteArray()
	
	var i = 1
	for character in og_chararray:
		
		if i % 4:
			
			new_char_array.append(character)
			
		else:
			
			new_char_array.append_array(','.to_ascii())
			new_char_array.append(character)
			i += 1
		
		i += 1
	
	new_char_array.invert()
	
	return new_char_array.get_string_from_ascii() + "." + stringarray[1]
	
	
