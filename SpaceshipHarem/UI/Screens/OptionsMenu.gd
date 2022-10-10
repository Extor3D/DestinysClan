extends Node2D

onready var lang_button = $VBoxContainer/HBoxContainer/VBoxContainer/LangButton

func _ready():
	lang_button.grab_focus()

func _on_BackButton_pressed():
		Global.goto_scene("res://UI/Screens/MainMenu.tscn")

func _on_LangButton_pressed():
	var locale_id = TranslationServer.get_loaded_locales().find(TranslationServer.get_locale()) + 1
	if locale_id >= TranslationServer.get_loaded_locales().size():
		locale_id = 0
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[locale_id])
