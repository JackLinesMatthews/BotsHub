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

; Possible improvements :
; Replacing shadow form by something to tank assassins and warriors instead might be better

Opt('MustDeclareVars', 1)

; ==== Constantes ====
Global Const $BorealChestRunnerSkillbar = 'OwZjgwf84Q3l0kTQAAAAAAAAAAA'
Global Const $BorealChestRunInformations = 'For best results, have :' & @CRLF _
	& '- 16 in Mysticism' & @CRLF _
	& '- 12 in Shadow Arts' & @CRLF _
	& '- 3 in Deadly Arts' & @CRLF _
	& '- A shield with +30 or +45 health under enchantment or stance' & @CRLF _
	& '- A spear +5 energy +20% enchantment duration' & @CRLF _
	& '- Windwalker insignias on all the armor pieces' & @CRLF _
	& '- A superior vigor rune' & @CRLF _
	& 'Note: in HM, very frequent failures on Am Fah - I suggest cutting that part of the farm if you wish to run in HM'
; Average duration ~ 4m20s
Global Const $BOREAL_FARM_DURATION = (4 * 60 + 20) * 1000

; Skill numbers declared to make the code WAY more readable (UseSkillEx($Pongmei_DwarvenStability) is better than UseSkillEx(1))
Global Const $Boreal_DwarvenStability = 1
Global Const $Boreal_IAmUnstoppable = 2
Global Const $Boreal_Dash = 3

Global $BOREAL_FARM_SETUP = False

;~ Main method to chest farm Boreal
Func BorealChestFarm($STATUS)
	; Need to be done here in case bot comes back from inventory management
	If GetMapID() <> $ID_Boreal_Station Then DistrictTravel($ID_Boreal_Station, $DISTRICT_NAME)
	If Not $BOREAL_FARM_SETUP Then
		SetupBorealFarm()
		$BOREAL_FARM_SETUP = True
	EndIf

	If $STATUS <> 'RUNNING' Then Return 2

	Return BorealChestFarmLoop($STATUS)
EndFunc


;~ Pongmei chest farm setup
Func SetupBorealFarm()
	Info('Setting up farm')
	LeaveGroup()
	LoadSkillTemplate($BorealChestRunnerSkillbar)

	If IsHardmodeEnabled() Then
		SwitchMode($ID_HARD_MODE)
	Else
		SwitchMode($ID_NORMAL_MODE)
	EndIf

    MoveTo(5584, -27924)
    Move(5232, -27891)
    Moveto(3986, -27642)
	RndSleep(1500)
	WaitMapLoading($ID_Ice_Cliff_Chasms, 10000, 2000)

    Move(5232, -27891)
	RndSleep(1500)
	WaitMapLoading($ID_Boreal_Station, 10000, 2000)

	Info('Preparations complete')
EndFunc


;~ Pongmei Chest farm loop
Func BorealChestFarmLoop($STATUS)
	Info('Starting chest farm run')
	If IsHardmodeEnabled() Then
		SwitchMode($ID_HARD_MODE)
	Else
		SwitchMode($ID_NORMAL_MODE)
	EndIf

    Moveto(3986, -27642)
	RndSleep(1500)
	WaitMapLoading($ID_Ice_Cliff_Chasms, 10000, 2000)

	Local $openedChests = 0

	Info('Running to Spot #1')
	AssassinRun(2728, -25294)
    AssassinRun(2900, -22272)
    AssassinRun(-1000, -19801)
    AssassinRun(-2570, -17208)
	$openedChests += FindAndOpenChests($RANGE_COMPASS,null,null,AssassinRun) ? 1 : 0
	Info('Running to Spot #2')
	AssassinRun(-4218, -15219)
	$openedChests += FindAndOpenChests($RANGE_COMPASS,null,null,AssassinRun) ? 1 : 0
	Info('Running to Spot #3')
	AssassinRun(-4218, -15219)
    $openedChests += FindAndOpenChests($RANGE_COMPASS,null,null,AssassinRun) ? 1 : 0
    Info('Running to Spot #4')
	AssassinRun(-4218, -15219)
	$openedChests += FindAndOpenChests($RANGE_COMPASS,null,null,AssassinRun) ? 1 : 0
	Info('Opened ' & $openedChests & ' chests.')
	Local $success = $openedChests > 0 And Not GetIsDead() ? 0 : 1
	BackToBorealStation()
	Return $success
EndFunc


;~ Returning to Boreas Seabed
Func BackToBorealStation()
	Info('Porting to Boreal Station')
	Resign()
	RndSleep(3500)
	ReturnToOutpost()
	WaitMapLoading($ID_Boreal_Station, 10000, 1000)
EndFunc

;~ Main function to run as a Assassin
Func AssassinRun($X, $Y)
	; We could potentially improve bot by avoiding using run stance right before Shadow Form, but that's a very tiny improvement
	;Local Static $shadowFormLastUse = Null
	If FindInInventory($ID_Lockpick)[0] == 0 Then
		Error('Out of lockpicks')
		Return 2
	EndIf

	Move($X, $Y, 0)
	Local $blockedCounter = 0
	Local $me = GetMyAgent()
	Local $energy
	While Not GetIsDead() And ComputeDistance(DllStructGetData($me, 'X'), DllStructGetData($me, 'Y'), $X, $Y) > 100 And $blockedCounter < 15
		If GetEnergy() >= 5 And IsRecharged($Boreal_IAmUnstoppable) And DllStructGetData(GetEffect($ID_Crippled), 'SkillID') <> 0 Then UseSkillEx($Boreal_IAmUnstoppable)

		$energy = GetEnergy()
        If $energy >= 5 And IsRecharged($Boreal_DwarvenStability) Then
            UseSkillEx($Boreal_DwarvenStability)
            RndSleep(260)
        EndIf

        $energy = GetEnergy()
        If $energy >= 5 And IsRecharged($Boreal_Dash) Then
            UseSkillEx($Boreal_Dash)
            RndSleep(20)
        EndIf

		$me = GetMyAgent()
		If DllStructGetData($me, 'MoveX') == 0 And DllStructGetData($me, 'MoveY') == 0 Then
			$blockedCounter += 1
			Move($X, $Y, 0)
		EndIf

		Sleep(250)
		$me = GetMyAgent()
	WEnd
EndFunc
