extends Node

#Player
var PlayerBody = CharacterBody2D
var PlayerDmgZone: Area2D
var PlayerDmgAmt: int
var PlayerDmgCount: int = 0
var PlayerAlive: bool
var PlayerFullMoon: bool
var PlayerHeath: int


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

#Guldan
var GuldanDmgZone: Area2D
var GuldanDmgAmt: int
var GuldanHealth: float

#Powerups
var PowerupCounter: int = 0
var DoubleJumpUnlocked: bool = false
var DoubleJumpAvailable: bool = false
var InvincibilityUnlocked: bool = false
var InvincibilityAvailable: bool = false
var FuryUnlocked: bool = false
var FuryAvailable: bool = false
