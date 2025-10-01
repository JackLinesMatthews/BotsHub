#include <Array.au3>
#include 'MyModsConfig.au3'

Func IsModIWant($item)
	Local $ModStruct = GetModStruct($item)
	If Not $modstruct Then Return False
	Local $Type = DllStructGetData($item, 'Type')
	; Daggers
	If $Type = 32 Then
		If $MyMods_DaggerTangZealous = True Then
			If StringInStr($ModStruct, '01001825') > 0 Then
				Return True
			EndIf
		EndIf
		If $MyMods_DaggerTangVampiric = True Then
			If StringInStr($ModStruct, '00032825') > 0 Then
				Return True
			EndIf
		EndIf
	EndIf
	; Sword
	If $Type = 27 Then
		If $MyMods_SwordPommelEnchanting = True Then
			If StringInStr($ModStruct, '1400B822') > 0 Then
				Return True
			EndIf
		EndIf
		If $MyMods_SwordHiltZealous = True Then
			If StringInStr($ModStruct, '01001825') > 0 Then
				Return True
			EndIf
		EndIf
	EndIf
	; Staff
	If $Type = 26 Then
		If $MyMods_StaffWrappingFortitude = True Then
			If StringInStr($ModStruct, '001E4823') > 0 Then
				Return True
			EndIf
		EndIf
		If $MyMods_StaffWrappingEnchanting = True Then
			If StringInStr($ModStruct, '1400B822') > 0 Then
				Return True
			EndIf
		EndIf
		If $MyMods_StaffHeadInsightful = True Then
			If StringInStr($ModStruct, '0500D822') > 0 Then
				Return True
			EndIf
		EndIf
	EndIf
	; Shield
	If $Type = 24 Then
		If $MyMods_ShieldHandleDevotion = True Then
			If StringInStr($ModStruct, '002D6823') > 0 Then
				Return True
			EndIf
		EndIf
		If $MyMods_ShieldHandleFortitude = True Then
			If StringInStr($ModStruct, '001E4823') > 0 Then
				Return True
			EndIf
		EndIf
	EndIf
	; HCT 20
	If StringInStr($ModStruct, '00140828') > 0 Then
		; Aptitude Not Attitude or Adept Staff Head
		If ($MyMods_AptitudeNotAttitude = True And ($Type = 22 Or $Type = 26)) Then
			Return True
		EndIf
		; Focus Core Of Aptitude
		If ($MyMods_FocusCoreAptitude = True And $Type = 12) Then
			Return True
		EndIf
	EndIf
	; HCT 10
	If StringInStr($ModStruct, '000A0822') > 0 Then
		; Don't Think Twice or Swift Staff Head
		If ($MyMods_StaffHeadSwift = True And $Type = 26) Then
			Return True
		EndIf
		; Focus Core Of Swiftness
		If ($MyMods_FocusCoreSwift = True And $Type = 12) Then
			Return True
		EndIf
	EndIf
	; HSR 20
	If StringInStr($ModStruct, '00142828') > 0 Then
		; Forget Me Not
		If ($MyMods_ForgetMeNot = True And $Type = 12) Then
			Return True
		EndIf
		; Wand Wrapping of Memory
		If ($MyMods_WandWrappingMemory = True And $Type = 22) Then
			Return True
		EndIf
	EndIf
	; Hale And Hearty
	If $MyMods_HaleAndHearty = True Then
		If StringInStr($ModStruct, '05320823') > 0 Then
			Return True
		EndIf
	EndIf
	; Sheltered By Faith
	If $MyMods_ShelteredByFaith = True Then
		If StringInStr($ModStruct, '02008820') > 0 Then
			Return True
		EndIf
	EndIf
	; Measure For Measure
	If $MyMods_MeasureForMeasure = True Then
		If StringInStr($ModStruct, '1F0208243E0432251') > 0 Then
			Return True
		EndIf
	EndIf
	; Strength and Honor
	If $MyMods_StrengthAndHonor = True Then
		If StringInStr($ModStruct, '0F327822') > 0 Then
			Return True
		EndIf
	EndIf
	; Guided By Fate
	If $MyMods_GuidedByFate = True Then
		If StringInStr($ModStruct, '0F006822') > 0 Then
			Return True
		EndIf
	EndIf
	; Through Thick and Thin
	If $MyMods_ThroughThickAndThin = True Then
		If StringInStr($ModStruct, '0A0118A1') > 0 Then
			Return True
		EndIf
	EndIf
	; Not the Face
	If $MyMods_NotTheFace = True Then
		If StringInStr($ModStruct, '0A0018A1') > 0 Then
			Return True
		EndIf
	EndIf
	; Leaf on the Wind
	If $MyMods_LeafOnTheWind = True Then
		If StringInStr($ModStruct, '0A0318A1') > 0 Then
			Return True
		EndIf
	EndIf
	; Sleep Now in the Fire
	If $MyMods_SleepNowInTheFire = True Then
		If StringInStr($ModStruct, '0A0518A1') > 0 Then
			Return True
		EndIf
	EndIf
	; Riders on the Storm
	If $MyMods_RidersOnTheStorm = True Then
		If StringInStr($ModStruct, '0A0418A1') > 0 Then
			Return True
		EndIf
	EndIf
	; The Riddle of Steel
	If $MyMods_TheRiddleOfSteel = True Then
		If StringInStr($ModStruct, '0A0218A1') > 0 Then
			Return True
		EndIf
	EndIf
	; Like A Rolling Stone
	If $MyMods_LikeARollingStone = True Then
		If StringInStr($ModStruct, '0A0B18A1') > 0 Then
			Return True
		EndIf
	EndIf
	; Armor
	If $MyMods_SuperiorVigor = True Then
		If StringInStr($ModStruct, 'C202EA27') > 0 Then
			Return True
		EndIf
	EndIf
	If $MyMods_WindWalkerInsignia = True Then
		If StringInStr($ModStruct, '040430A5060518A7') > 0 Then
			Return True
		EndIf
	EndIf
	If $MyMods_ShamansInsignia = True Then
		If StringInStr($ModStruct, '080430A50005F8A') > 0 Then
			Return True
		EndIf
	EndIf
	If $MyMods_SuperiorDomination = True Then
		If StringInStr($ModStruct, '30250302E821770') > 0 Then
			Return True
		EndIf
	EndIf
	If $MyMods_ProdigyInsignia = True Then
		If StringInStr($ModStruct, 'C60330A5000528A7') > 0 Then
			Return True
		EndIf
	EndIf
	If $MyMods_BlessedInsignia = True Then
		If StringInStr($ModStruct, 'C8A3D20370800006B080D20330A5000AF8A0000000C0') > 0 Then
			Return True
		EndIf
	EndIf
	If $MyMods_SuperiorEarthPrayers = True Then
		If StringInStr($ModStruct, '32BE82109033025') > 0 Then
			Return True
		EndIf
	EndIf
	Return False
EndFunc