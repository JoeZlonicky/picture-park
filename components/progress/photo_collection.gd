class_name PhotoCollection
extends RefCounted


signal modified(changes: Dictionary[PhotoData, bool])


var _photos: Dictionary[PhotoData, Photo] = {}


# Adds photo and returns a dictionary of each capture and whether it's new
func add_photo(photo: Photo) -> Dictionary[PhotoData, bool]:
	var added: Dictionary[PhotoData, bool] = {}
	for capture in photo.captures:
		var new_photo := not _photos.has(capture)
		_photos[capture] = photo
		if new_photo:
			added[capture] = true
		else:
			added[capture] = false
	modified.emit(added)
	return added


func get_all_captures() -> Array[PhotoData]:
	return _photos.keys()


func has_photo(of: PhotoData) -> bool:
	return _photos.has(of)


func get_photo(of: PhotoData) -> Photo:
	return _photos.get(of)
