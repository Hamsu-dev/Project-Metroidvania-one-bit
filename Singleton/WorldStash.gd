extends Node

var data = {}

func get_id(node):
	var world = get_tree().current_scene
	var level = world.level
	return level.name + "_" + node.name + "_" + str(node.global_position)


func stash(id, key, value):
	data[id] = {}
	data[id][key] = value


func retrieve(id, key):
	if not data.has(id): return
	if not data[id].has(key): return
	return data[id][key]
