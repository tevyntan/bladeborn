extends Node

#Player
var PlayerBody = CharacterBody2D
var PlayerDmgZone: Area2D
var PlayerDmgAmt: int
var PlayerAlive: bool
var PlayerFullMoon: bool
var PlayerHeath: int

var DoubleJumpAvailable: bool

#Satyr
var SatyrDmgZone: Area2D
var SatyrDmgAmt: int

#Satyr_spirit
var SatyrSpiritDmgZone: Area2D
var SatyrSpiritDmgAmt: int

#Mage
var MageDmgZone: Area2D
var MageDmgAmt: int

#Mage_spirit
var MageSpiritDmgZone: Area2D
var MageSpiritDmgAmt: int

#Golem
var GolemDmgZone: Area2D
var GolemDmgAmt: int
