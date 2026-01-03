; Author: An anonymous fan of Dhuum
; Copyright 2025 caustic-kronos
;
; Licensed under the Apache License, Version 2.0 (the 'License');
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
; http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an 'AS IS' BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

#include-once
#RequireAdmin
#NoTrayIcon

#include '../lib/GWA2.au3'
#include '../lib/GWA2_ID.au3'
#include '../lib/Utils.au3'


Opt('MustDeclareVars', 1)

; ==== Constantes ====
Global Const $DeldrimorFarmInformations = 'Deldrimor title farm, bring solid heroes composition'
; Average duration ~ 45m
Global Const $DELDRIMOR_FARM_DURATION = 45 * 60 * 1000

;~ Main loop for the norn faction farm
Func DeldrimorTitleFarm($STATUS)
	If GetMapID() <> $ID_Umbral_Grotto Then
		Info('Moving to Rata Sum')
		DistrictTravel($ID_Umbral_Grotto, $DISTRICT_NAME)
		WaitMapLoading($ID_Umbral_Grotto, 10000, 2000)
	EndIf
	DeldrimorTitleSetup()

	AdlibRegister('TrackGroupStatus', 10000)
	Local $result = DeldrimorTitle()
	AdlibUnRegister('TrackGroupStatus')
	; Temporarily change a failure into a pause for debugging :
	;If $result == 1 Then $result = 2
	Return $result
EndFunc   ;==>DeldrimorTitleFarm

Func DeldrimorTitleSetup()
	SwitchMode($ID_HARD_MODE)
	SetTitleDwarven()
EndFunc   ;==>DeldrimorTitleSetup

Func DeldrimorTitle()

	Info("Taking Quest")
	GoNearestNPCToCoords(-23818, 13931)
	RandomSleep(750)
	Dialog(8618497)
	RandomSleep(750)
	GoNearestNPCToCoords(-23818, 13931)
	RandomSleep(750)
	Dialog(0x00000083)
	Dialog(0x00000084)
	RandomSleep(200)
	WaitMapLoading($ID_Secret_Lair_Of_The_Snowmen, 10000, 2000)

	GoNearestNPCToCoords(-14103, 15457)
	RandomSleep(1000)
	Dialog(0x00000084)
	RandomSleep(1000)

	If MoveAggroAndKill(-15988, 10018, 'Snowmen at begining') Then Return 1
	If MoveAggroAndKill(-17986, 6483, '') Then Return 1
	If MoveAggroAndKill(-17574, 2190, 'Snowmen') Then Return 1
	If MoveAggroAndKill(-15361, 2551, 'Cleaning way') Then Return 1
	If MoveAggroAndKill(-14596, 2612, 'Going to shrine') Then Return 1
	If MoveAggroAndKill(-14506, 3963, '') Then Return 1

	GoNearestNPCToCoords(-12512, 3919)
	RandomSleep(500)

	If MoveAggroAndKill(-14556, 4065, '') Then Return 1
	If MoveAggroAndKill(-14596, 2612, '') Then Return 1
	If MoveAggroAndKill(-14583, 1896, '') Then Return 1
	If MoveAggroAndKill(-14262, 974, '') Then Return 1
	If MoveAggroAndKill(-13759, -552, '') Then Return 1
	If MoveAggroAndKill(-13306, -1211, '') Then Return 1
	If MoveAggroAndKill(-12570, -2997, '') Then Return 1

	If MoveAggroAndKill(-13114, -6255, 'Snowman') Then Return 1
	If MoveAggroAndKill(-14367, -9244, 'Snowman') Then Return 1

	GoNearestNPCToCoords(-16025, -10702)
	RandomSleep(500)

	If MoveAggroAndKill(-15396, -10850, 'Ennemy near door') Then Return 1

	If MoveAggroAndKill(-13970, -9719) Then Return 1
	If MoveAggroAndKill(-13047, -10683) Then Return 1

	If MoveAggroAndKill(-10097, -11373, 'Angry Snowman') Then Return 1

	Moveto(-9852, -11078)
	RandomSleep(500)
	RandomSleep(2000)
	MoveTo(-9547, -10960)
	RandomSleep(500)
	Sleep(1000)

	MoveAggroAndKill(-11464, -11034)
	MoveAggroAndKill(-14162, -9527)
	MoveAggroAndKill(-15284, -10824)
	MoveAggroAndKill(-15454, -12245)
	ClearTarget()
	RandomSleep(500)
	TargetNearestItem()
	ActionInteract()
	RandomSleep(500)
	ActionInteract()
	Moveto(-15869, -12119)

	If MoveAggroAndKill(-17287, -13895, 'Snowman') Then Return 1
	If MoveAggroAndKill(-15483, -16565, 'Boss and others') Then Return 1
	If MoveAggroAndKill(-13362, -17430, '') Then Return 1

	If MoveAggroAndKill(-12974, -17414) Then Return 1
	PickUpItems()

	If MoveAggroAndKill(-11215, -18002) Then Return 1
	TargetNearestItem()
	RandomSleep(500)
	ActionInteract()

	MoveAggroAndKill(-11300, -18290)
	MoveAggroAndKill(-9618, -19271)
	MoveAggroAndKill(-7856, -19136)
	MoveAggroAndKill(-7560, -18592)

	Local $chestspawn = False
	Local $TimerGuynotThere = TimerInit()
	Do
		TargetNearestItem()
		Sleep(500)
		If DllStructGetData(GetCurrentTarget(), 'ID') <> 32 Then $chestspawn = True
		If TimerDiff($TimerGuynotThere) > 240000 Then
			CurrentAction("Apparently, Koris is stuck somewhere on the dungeon, go again")
			Sleep(2000)
			Return
		EndIf
	Until $chestspawn = True

	TargetNearestItem()
	ActionInteract()
	RandomSleep(2500)
	PickUpItems()

	Return $SUCCESS


	#cs
	MoveTo(16342, 13855)
	Move(16450, 13300)
	RandomSleep(1000)
	WaitMapLoading($ID_Magus_Stones, 10000, 2000)
	
	Info('Taking Blessing')
	MoveTo(14865, 13160)
	RandomSleep(1000)
	GoNearestNPCToCoords(14865, 13160)
	RandomSleep(1000)
	Dialog(0x84)
	RandomSleep(1000)
	
	If MoveAggroAndKill(16722, 11774, 'Moving') Then Return 1
	If MoveAggroAndKill(17383, 8685, 'Moving') Then Return 1
	
	If MoveAggroAndKill(18162, 6670, 'First Spider Group') Then Return 1
	If MoveAggroAndKill(18447, 4537, 'Second Spider Group') Then Return 1
	If MoveAggroAndKill(18331, 2108, 'Spider Pop') Then Return 1
	If MoveAggroAndKill(17526, 143, 'Spider Pop 2') Then Return 1
	If MoveAggroAndKill(17205, -1355, 'Third Spider Group') Then Return 1
	If MoveAggroAndKill(17366, -5132, "Krait Group") Then Return 1
	If MoveAggroAndKill(18111, -8030, "Krait Group") Then Return 1
	
	Info("Taking Blessing")
	GoNearestNPCToCoords(18409, -8474)
	RandomSleep(2000)
	If MoveAggroAndKill(18613, -11799, "Froggy Group") Then Return 1
	If MoveAggroAndKill(17154, -15669, "Krait Patrol") Then Return 1
	If MoveAggroAndKill(14250, -16744, "Second Patrol") Then Return 1
	If MoveAggroAndKill(12186, -14139, "Krait Patrol") Then Return 1
	If MoveAggroAndKill(12540, -13440, "Krait Patrol") Then Return 1
	If MoveAggroAndKill(13234, -9948, "Krait Group") Then Return 1
	If MoveAggroAndKill(8875, -9065, "Krait Group") Then Return 1
	If MoveAggroAndKill(4671, -8699, "Krait Patrol") Then Return 1
	If MoveAggroAndKill(1534, -5493, "Krait Group") Then Return 1
	Info("Moving")
	If MoveAggroAndKill(1052, -7074) Then Return 1
	If MoveAggroAndKill(-1029, -8724, "Spider Group") Then Return 1
	If MoveAggroAndKill(-3439, -10339, "Krait Group") Then Return 1
	If MoveAggroAndKill(-3024, -12586, "Spider Cave") Then Return 1
	RandomSleep(1000)
	If MoveAggroAndKill(-2797, -13645, "Spider Cave") Then Return 1
	If MoveAggroAndKill(-3393, -15633, "Spider Cave") Then Return 1
	If MoveAggroAndKill(-4635, -16643, "Spider Pop") Then Return 1
	If MoveAggroAndKill(-7814, -17796, "Spider Group") Then Return 1
	
	Info("Taking Blessing")
	GoNearestNPCToCoords(-10109, -17520)
	RandomSleep(2000)
	Info("Moving")
	If MoveAggroAndKill(-9111, -17237) Then Return 1
	If MoveAggroAndKill(-10963, -15506, "Ranger Boss Group") Then Return 1
	If MoveAggroAndKill(-12885, -14651, "Froggy Group") Then Return 1
	If MoveAggroAndKill(-13975, -17857, "Corner Spiders") Then Return 1
	If MoveAggroAndKill(-11912, -10641, "Froggy Group") Then Return 1
	If MoveAggroAndKill(-8760, -9933, "Krait Boss Warrior") Then Return 1
	If MoveAggroAndKill(-14030, -9780, "Froggy Coing Group") Then Return 1
	If MoveAggroAndKill(-12368, -7330, "Froggy Group") Then Return 1
	If MoveAggroAndKill(-16527, -8175, "Froggy Patrol") Then Return 1
	If MoveAggroAndKill(-17391, -5984, "Froggy Group") Then Return 1
	If MoveAggroAndKill(-15704, -3996, "Froggy Patrol") Then Return 1
	Info("Moving")
	If MoveAggroAndKill(-16609, -2607) Then Return 1
	If MoveAggroAndKill(-15476, 186) Then Return 1
	If MoveAggroAndKill(-16480, 2522, "Krait Group") Then Return 1
	If MoveAggroAndKill(-17090, 5252, "Krait Group") Then Return 1
	
	Info("Taking Blessing")
	GoNearestNPCToCoords(-19292, 8994)
	RandomSleep(2000)
	Info("Moving")
	If MoveAggroAndKill(-18640, 8724) Then Return 1
	If MoveAggroAndKill(-18484, 12021, "Krait Patrol") Then Return 1
	If MoveAggroAndKill(-17180, 13093, "Krait Patrol") Then Return 1
	If MoveAggroAndKill(-15072, 14075, "Froggy Group") Then Return 1
	If MoveAggroAndKill(-11888, 15628, "Froggy Group") Then Return 1
	If MoveAggroAndKill(-12043, 18463, "Froggy Boss Warrior") Then Return 1
	If MoveAggroAndKill(-8876, 17415, "Froggy Group") Then Return 1
	If MoveAggroAndKill(-5778, 19838, "Froggy Group") Then Return 1
	If MoveAggroAndKill(-10970, 16860, "Moving Back") Then Return 1
	If MoveAggroAndKill(-9301, 15054, "Moving") Then Return 1
	If MoveAggroAndKill(-5379, 16642, "Krait Group") Then Return 1
	If MoveAggroAndKill(-4430, 17268, "Krait Group") Then Return 1
	If MoveAggroAndKill(-2974, 14197, "Krait Group") Then Return 1
	If MoveAggroAndKill(-5228, 12475, "Boss Patrol") Then Return 1
	If MoveAggroAndKill(-3468, 10837, "Lonely Patrol") Then Return 1
	
	Info("Taking Blessing")
	GoNearestNPCToCoords(-2037, 10758)
	RandomSleep(2000)
	
	If MoveAggroAndKill(-3804, 8017, "Krait Group") Then Return 1
	If MoveAggroAndKill(-1346, 12360, "Moving") Then Return 1
	If MoveAggroAndKill(874, 14367) Then Return 1
	If MoveAggroAndKill(3572, 13698, "Krait Group Standing") Then Return 1
	If MoveAggroAndKill(5899, 14205, "Moving") Then Return 1
	If MoveAggroAndKill(7407, 11867, "Krait Group") Then Return 1
	If MoveAggroAndKill(9541, 9027, "Rider") Then Return 1
	If MoveAggroAndKill(12639, 7537, "Rider Group") Then Return 1
	If MoveAggroAndKill(9064, 7312, "Rider") Then Return 1
	If MoveAggroAndKill(7986, 4365, "Krait group") Then Return 1
	If MoveAggroAndKill(6341, 3029, "Krait Group") Then Return 1
	If MoveAggroAndKill(7097, 92, "Krait Group") Then Return 1
	
	Info("Taking Blessing")
	GoNearestNPCToCoords(4893, 445)
	RandomSleep(2000)
	If MoveAggroAndKill(8943, -985, "Krait Boss") Then Return 1
	If MoveAggroAndKill(10949, -2056, "Krait Patrol") Then Return 1
	If MoveAggroAndKill(13780, -5667, "Rider Patrol") Then Return 1
	
	If MoveAggroAndKill(12444, -793, "Moving Back") Then Return 1
	
	If MoveAggroAndKill(8193, -841, "Moving Back") Then Return 1
	If MoveAggroAndKill(3284, -1599, "Krait Group") Then Return 1
	If MoveAggroAndKill(-76, -1498, "Krait Group") Then Return 1
	If MoveAggroAndKill(578, 719, "Krait Group") Then Return 1
	If MoveAggroAndKill(316, 2489, "Krait Group") Then Return 1
	If MoveAggroAndKill(-1018, -1235, "Moving Back") Then Return 1
	If MoveAggroAndKill(-3195, -1538, "Krait Patrol") Then Return 1
	If MoveAggroAndKill(-6322, -2565, "Krait Group") Then Return 1
	
	Info("Taking Blessing")
	GoNearestNPCToCoords(-9231, -2629)
	RandomSleep(3000)
	
	If MoveAggroAndKill(-11414, 4055, "Leftovers Krait") Then Return 1
	If MoveAggroAndKill(-6907, 8461, "Moving") Then Return 1
	If MoveAggroAndKill(-8689, 11227, "Leftovers Krait and Rider") Then Return 1
	#ce

	Return 0
EndFunc   ;==>DeldrimorTitle
