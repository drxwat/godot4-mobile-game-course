extends Node

enum LOCATIONS { START, GAME, SHOP }

signal game_over
signal location_changed(location: LOCATIONS)
