; Author: caustic-kronos (aka Kronos, Night, Svarog)
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

; ==== Constants ====
Global Const $VoltaicFarmInformations = 'For best results, have :' & @CRLF _
	& '- completed EotN story once' & @CRLF _
	& '- a full and efficient 7-hero-team' & @CRLF _
	& '- a hero with Frozen Soil' & @CRLF _
	& '- a build that can be run from skill 1 to 8 (no complex combos or conditional skills)' & @CRLF _
	& 'In NM, bot takes 13min (with cons), 15min (without cons) on average' & @CRLF _
	& 'Not tested in HM.'
Global Const $VOLTAIC_FARM_DURATION = 16 * 60 * 1000
Global Const $VSAggroRange = $RANGE_LONGBOW + 100
Global Const $VSAggroRangeRun = $RANGE_SPELLCAST + 100

Global $VOLTAIC_FARM_SETUP = False

Global $LAST_ROOM_OPTIONS[]
$LAST_ROOM_OPTIONS['openChests'] = True
$LAST_ROOM_OPTIONS['chestOpenRange'] = $RANGE_SPIRIT
$LAST_ROOM_OPTIONS['flagHeroesOnFight'] = True

;~ Main method to farm Voltaic
Func VoltaicFarm($STATUS)
	; Need to be done here in case bot comes back from inventory management
	If GetMapID() <> $ID_Umbral_Grotto Then DistrictTravel($ID_Umbral_Grotto, $DISTRICT_NAME)

	If Not $VOLTAIC_FARM_SETUP Then
		SetupVoltaicFarm()
		$VOLTAIC_FARM_SETUP = True
	EndIf

	If $STATUS <> 'RUNNING' Then Return 2

	Return VoltaicFarmLoop()
EndFunc


;~ Voltaic farm setup
Func SetupVoltaicFarm()
	Info('Setting up farm')
	If IsHardmodeEnabled() Then
		SwitchMode($ID_HARD_MODE)
	Else
		SwitchMode($ID_NORMAL_MODE)
	EndIf
	Info('Preparations complete')
EndFunc


;~ Farm loop
Func VoltaicFarmLoop()
	ResetFailuresCounter()
	Info('Making way to portal')
	MoveTo(-23200, 7100)
	Move(-22735, 6339)
	RndSleep(1000)
	WaitMapLoading($ID_Verdant_Cascades)

	AdlibRegister('HeroicRefrainMaintenance', 3000)
	AdlibRegister('TrackGroupStatus', 10000)

	Local $timer = TimerInit()

	While Not IsRunFailed() And GetMapID() == $ID_Verdant_Cascades
		MoveAggroAndKill(-19887, 6074, '1', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		Info('Making way to Slavers')
		MoveAggroAndKill(-10273, 3251, '2', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-6878, -329, '3', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-3041, -3446, '4', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(3571, -9501, '5', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(10764, -6448, '6', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(13063, -4396, '7', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		If IsRunFailed(3) Then
			AdlibUnregister('TrackGroupStatus')
			Return 1
		EndIf

		Info('At the Troll Bridge - TROLL TOLL')
		MoveAggroAndKill(18054, -3275, '8', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(20966, -6476, '9', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(25298, -9456, '10', $VSAggroRangeRun, Null, ParagonHrFight, ParagonHrMove)
		If IsRunFailed(3) Then
			AdlibUnregister('TrackGroupStatus')
			Return 1
		EndIf

		AdlibUnregister('HeroicRefrainMaintenance')
		Move(25729, -9360)
		Info('Entering Slavers')
		While Not WaitMapLoading($ID_Slavers_Exile)
			Sleep(50)
		WEnd
	WEnd

	MoveTo(-16797, 9251)
	MoveTo(-17835, 12524)
	Move(-18300, 12527)

	; The map has the same ID as slavers
	While Not WaitMapLoading()
		Sleep(50)
	WEnd
	Info('Now in Justicar')
	AdlibRegister('HeroicRefrainMaintenance', 3000)
	Sleep(500)
	GoToNPC(GetNearestNPCToCoords(-12135, -18210))
	RndSleep(250)
	Dialog(132)
	RndSleep(500)

	If IsHardmodeEnabled() Then UseConset()

	Sleep(1000)
	While Not IsRunFailed() And Not IsAgentInRange(GetMyAgent(), -18500, -8000, 1250)
		; Waiting to be alive before retrying
		While Not IsGroupCurrentlyAlive()
			Sleep(2000)
		WEnd
		UseMoraleConsumableIfNeeded()
		UseConsumable($ID_Legionnaire_Summoning_Crystal, False)
		MoveAggroAndKill(-13500, -15750, 'In front of the door', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-12500, -15000, 'Before the bridge', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-10400, -14800, 'After the bridge', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-11500, -13300, 'First group', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-13400, -11500, 'Second group', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-13700, -9550, 'Third group', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-14100, -8600, 'Fourth group', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-15000, -7500, 'Fourth group, again', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-16500, -8000, 'Fifth group', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-18500, -8000, 'To the shrine', $VSAggroRange, Null, ParagonHrFight, ParagonHrMove)
	WEnd
	$groupFailuresCount = 0
	While Not IsRunFailed(3) And Not IsAgentInRange(GetMyAgent(), -17500, -14250, 1250)
		; Waiting to be alive before retrying
		While Not IsGroupCurrentlyAlive()
			Sleep(2000)
		WEnd
		UseMoraleConsumableIfNeeded()
		UseConsumable($ID_Legionnaire_Summoning_Crystal, False)
		MoveAggroAndKill(-18500, -11500, 'Pre-Boss group', 1550, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-17700, -12500, 'Boss group', 1550, Null, ParagonHrFight, ParagonHrMove)
		MoveAggroAndKill(-17500, -14250, 'Final group', 1550, Null, ParagonHrFight, ParagonHrMove)
	WEnd
	If IsRunFailed(3) Then
		AdlibUnregister('TrackGroupStatus')
		AdlibUnregister('HeroicRefrainMaintenance')
		Return 1
	EndIf
	; Chest
	Move(-17500, -14250)
	Info('Opening chest')
	Sleep(5000)
	TargetNearestItem()
	ActionInteract()
	Sleep(2500)
	PickUpItems()
	Info('Finished Run')
	AdlibUnregister('TrackGroupStatus')
	AdlibUnregister('HeroicRefrainMaintenance')
	Return 0
EndFunc