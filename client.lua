ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

RegisterNetEvent('Ise_Logs2')
AddEventHandler('Ise_Logs2', function(Color, Title, Description)
	TriggerServerEvent('Ise_Logs2', Color, Title, Description)
end)

RegisterNetEvent('Ise_Logs3')
AddEventHandler('Ise_Logs3', function(webhook, Color, Title, Description)
	TriggerServerEvent('Ise_Logs3', webhook, Color, Title, Description)
end)

local toggle = false
local PlayerData = {}
local ShowName = false
local gamerTags = {}
local GetBlips = false
local pBlips = {}
local Items = {}     
local Armes = {}   
local ArgentSale = {} 
local ArgentCash = {}
local ArgentBank = {}
local allItemsServer = {}
local allJobsServer = {}
local allGradeForJobSelected = {}
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local noclipActive = false 
local index = 1 
local Admin = {showcoords = false}

function getPosition()
local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
return x,y,z
end
function getCamDirection()
local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
local pitch = GetGameplayCamRelativePitch()
local x = -math.sin(heading*math.pi/180.0)
local y = math.cos(heading*math.pi/180.0)
local z = math.sin(pitch*math.pi/180.0)
local len = math.sqrt(x*x+y*y+z*z)
if len ~= 0 then
x = x/len
y = y/len
z = z/len
end
return x,y,z
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end


function KeyBoardText(TextEntry, ExampleText, MaxStringLength)

AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
blockinput = true

while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
    Citizen.Wait(0)
end

if UpdateOnscreenKeyboard() ~= 2 then
    local result = GetOnscreenKeyboardResult()
    Citizen.Wait(500)
    blockinput = false
    return result
else
    Citizen.Wait(500)
    blockinput = false
    return nil
    end
end

function DrawTxt(text,r,z)
    SetTextColour(Config.ColorCoords_R, Config.ColorCoords_G, Config.ColorCoords_B, Config.ColorCoords_A)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0,0.5)
    SetTextDropshadow(1,0,0,0,255)
    SetTextEdge(1,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(r,z)
 end

 Citizen.CreateThread(function()
     while true do
         if Admin.showcoords then
             x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
             roundx=tonumber(string.format("%.2f",x))
             roundy=tonumber(string.format("%.2f",y))
             roundz=tonumber(string.format("%.2f",z))
             DrawTxt("~r~X:~w~ "..roundx,0.4355, 0.730+0.07)
             DrawTxt("~b~Y:~w~ "..roundy,0.4355, 0.760+0.07)
             DrawTxt("~g~Z:~w~ "..roundz,0.4355, 0.790+0.07)
             DrawTxt("~y~Angle:~w~ "..GetEntityHeading(PlayerPedId()),0.405, 0.820+0.07)
             drawRct2(0.40,0.800,0.2,0.13,0,0,0,255)
         end
         Citizen.Wait(0)
     end
 end)

function drawRct2(x,y,width,height,r,g,b,a)
    DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function DrawPlayerInfo(target)
    drawTarget = target
    drawInfo = true
end

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = 0
end

-----------------------------------------

local adminservice = false
local label = "Activer le mode staff"

function OuvrirAdmin()

	local main = RageUI.CreateMenu(Config.MenuName, " ")
	local perso2 = RageUI.CreateSubMenu(main, "Actions dev", " " )
	local factures = RageUI.CreateSubMenu(main, "Actions factures", " " )
	local job = RageUI.CreateSubMenu(main, "Actions job", " " )
	local meteo = RageUI.CreateSubMenu(main, "Actions dev", " " )
    local setjobMenu = RageUI.CreateSubMenu(options, "SetJob", " " )
    local setjobMenuSub = RageUI.CreateSubMenu(setjobMenu, "Set-Job", " " )
    local setjob2Menu = RageUI.CreateSubMenu(options, "SetJob", " " )
    local setjobMenuSub2 = RageUI.CreateSubMenu(setjobMenu, "Set-Job", " " )
    ------------------------------------------------------------------------------------
    
    ------------------------------------------------------------------------------------
	RageUI.Visible(main, not RageUI.Visible(main))
	while main do
		Citizen.Wait(0)
			RageUI.IsVisible(main, true, true, true, function()
                RageUI.Checkbox(label, nil, adminservice, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    adminservice = Checked;
                end, function()
                    adminservice = true
                    label = "Quitter le mode staff"
                    ExecuteCommand('txAdmin:menu:togglePlayerIDs')
                    TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nActivation du mode staff")
                end, function()
                    adminservice = false
                    label = "Activer le mode staff"
                    ExecuteCommand('txAdmin:menu:togglePlayerIDs')
                    TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nDesactivation du mode staff")
                end)

                RageUI.Separator("~r~Votre rang : ~s~"..playergroup)

                if adminservice then
                    
                    RageUI.Checkbox("Afficher/Cacher coordonnées", description, afficherco,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            afficherco = Checked
                            if Checked then
                                Admin.showcoords = true
                            else
                                Admin.showcoords = false
                                RageUI.CloseAll()
                            end
                        end
                    end)

                    for k,v in pairs(Config.Gestionsoi) do
                    if playergroup == v then
                        RageUI.ButtonWithStyle("DEV", nil, {RightLabel = "→→"},true, function()
                        end, perso2)
                        end
                    end

                    RageUI.ButtonWithStyle("Creer un gang / orga", nil, {RightLabel = "Rcore_Gang"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('managegang')
                        RageUI.CloseAll()
                        end
                    end)

                    

                    RageUI.ButtonWithStyle("Meteo", nil, {RightLabel = "→→"},true, function()
                    end, meteo)

                    RageUI.ButtonWithStyle("Menu Factures", nil, {RightLabel = "→→"},true, function()
                    end, factures)
                    
                    RageUI.ButtonWithStyle("Menu job", nil, {RightLabel = "→→"},true, function()
                    end, job)

                end
            end)     
                    
            RageUI.IsVisible(factures, true, true, true, function()
                RageUI.ButtonWithStyle("Facture - Coffre",nil, {RightLabel = "~y~75.000 ~s~$"}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local montant = 75000
                        if player ~= -1 and distance <= 3.0 then
                            --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_gouv', ("Gouv"), montant)
                            TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture Coffre', 'society_tps', ('tps'))
                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~y~'..montant.. '~s~ $ ', 'CHAR_BANK_FLEECA', 9)
                        else
                            ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                        end 
                        RageUI.CloseAll()
                    end
                end)

                RageUI.ButtonWithStyle("Facture - e.service",nil, {RightLabel = "~y~30.000 ~s~$"}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local montant = 30000
                        if player ~= -1 and distance <= 3.0 then
                            --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_gouv', ("Gouv"), montant)
                            TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture E-service', 'society_tps', ('tps'))
                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~y~'..montant.. '~s~ $ ', 'CHAR_BANK_FLEECA', 9)
                        else
                            ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                        end 
                        RageUI.CloseAll()
                    end
                end)

                RageUI.ButtonWithStyle("Facture - Maison",nil, {RightLabel = "→→"}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                    local montant = 0
                    AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0)
                        Wait(0)
                    end
                        if (GetOnscreenKeyboardResult()) then
                            result = GetOnscreenKeyboardResult()
                            if result then
                                montant = result
                                result = nil
                                if player ~= -1 and distance <= 3.0 then
                                    --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_casino', ("Agence Immo"), montant)
                                    TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture Maison', 'society_tps', ('tps'))
                                    TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~y~'..montant.. '~s~ $ ', 'CHAR_BANK_FLEECA', 9)
                                else
                                    ESX.ShowNotification("~õ~Probleme~s~: Aucuns joueurs proche")
                                end
                            end
                        end
                    end
                end)
            end, function()
            end)
                    
            RageUI.IsVisible(job, true, true, true, function()

                RageUI.ButtonWithStyle("Job en develloppement", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        TriggerEvent('staff:openmenu')
                    end
                end)

                RageUI.ButtonWithStyle("Job benny", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        TriggerEvent('benny:openmenu')
                    end
                end)

                RageUI.ButtonWithStyle("Job EMS", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        TriggerEvent('ambulance:openmenu')
                    end
                end)

                RageUI.ButtonWithStyle("Job LSPD", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        TriggerEvent('lspd:openmenu')
                    end
                end)

                RageUI.ButtonWithStyle("Job LSFD", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        TriggerEvent('lsfd:openmenu')
                    end
                end)

            end, function()
            end)

                    RageUI.IsVisible(perso2, true, true, true, function()

                        
                        
                        RageUI.Separator("~y~ Doorlock : ~s~")
                        RageUI.ButtonWithStyle("Creer", "~y~ ox_doorlock", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand('doorlock')
                                RageUI.CloseAll()
                            end
                        end)
                        RageUI.ButtonWithStyle("Modifier", "~y~ ox_doorlock", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand('doorlock closest')
                                RageUI.CloseAll()
                            end
                        end)
                        
                        --RageUI.Separator("~y~ Setjob : ~s~")
                        --RageUI.ButtonWithStyle("SetJob me", nil, {}, true, function(Hovered, Active, Selected)
                        --end, setjobMenu)
                        --RageUI.ButtonWithStyle("SetJob2 me", nil, {}, true, function(Hovered, Active, Selected)
                        --end, setjob2Menu)

                        RageUI.Separator("~y~ Creer / Supprimer ~s~ ")
                        --RageUI.ButtonWithStyle("Safe Zone", "~y~ Safezone Builder", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        --    if Selected then
                        --        ExecuteCommand('safeZoneBuilder')
                        --        RageUI.CloseAll()
                        --    end
                        --end)                       

                        RageUI.ButtonWithStyle("Radar", "~y~ Radar  Builder", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand('radarbuilder')
                                RageUI.CloseAll()
                            end
                        end)
                        
                        RageUI.Separator("~y~ es_mapper : ~s~")
                        RageUI.ButtonWithStyle("ouvrir / fermer", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerEvent('es_mapper:toggle')
                                RageUI.CloseAll()
                            end
                        end)
                        

                    end, function()
                    end)


        
                RageUI.IsVisible(meteo, true, true, true, function()
                    RageUI.Separator("~y~ Temps ~s~ ")
                
                    RageUI.ButtonWithStyle("Soleil", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('weather extrasunny')
                            RageUI.CloseAll()
                        end
                    end)                
                    RageUI.ButtonWithStyle("Dégager", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("weather clear")
                            RageUI.CloseAll()
                        end
                    end)              
                    RageUI.ButtonWithStyle("Pluie", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("weather rain")
                            RageUI.CloseAll()
                        end
                    end)            
                    RageUI.ButtonWithStyle("Orage", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("weather thunder")
                            RageUI.CloseAll()
                        end
                    end)          
                    RageUI.ButtonWithStyle("Neige", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("weather xmas")
                            RageUI.CloseAll()
                        end
                    end)       
                    RageUI.ButtonWithStyle("Blizzard", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("weather blizzard")
                            RageUI.CloseAll()
                        end
                    end)


                    RageUI.Separator("~y~ Heure ~s~ ")      
                    RageUI.ButtonWithStyle("0 h 00", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("time 0 00")
                            RageUI.CloseAll()
                        end
                    end)    
                    RageUI.ButtonWithStyle("6 h 00", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("time 6 00")
                            RageUI.CloseAll()
                        end
                    end)    
                    RageUI.ButtonWithStyle("12 h 00", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("time 12 00")
                            RageUI.CloseAll()
                        end
                    end)    
                    RageUI.ButtonWithStyle("18 h 00", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("time 18 00")
                            RageUI.CloseAll()
                        end
                    end)  
                    RageUI.ButtonWithStyle("Freezetime", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("freezetime")
                            RageUI.CloseAll()
                        end
                    end)
                    
                                            
                end, function()
                end)


        RageUI.IsVisible(setjobMenu, true, true, true, function()


            RageUI.Separator("↓ ~g~Jobs disponibles ~s~↓")

        for k,v in pairs(allJobsServer) do

            RageUI.ButtonWithStyle(v.LabelSociety, nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                   nameSo = v.NameSociety
                   LabelSo = v.LabelSociety
                   ESX.TriggerServerCallback('devmenu:getAllGrade', function(allGrade)
                    allGradeForJobSelected = allGrade
                   end, v.NameSociety)
                end
            end, setjobMenuSub)

        end
    end, function()
    end)

        RageUI.IsVisible(setjob2Menu, true, true, true, function()


            RageUI.Separator("↓ ~g~Jobs disponibles ~s~↓")
        for k,v in pairs(allJobsServer) do
            RageUI.ButtonWithStyle(v.LabelSociety, nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                   nameSo = v.NameSociety
                   LabelSo = v.LabelSociety
                   ESX.TriggerServerCallback('devmenu:getAllGrade', function(allGrade)
                    allGradeForJobSelected = allGrade
                   end, v.NameSociety)
                end
            end, setjobMenuSub2)

        end        
        end, function()
        end)

        RageUI.IsVisible(setjobMenuSub, true, true, true, function()

            RageUI.Separator("~y~Job sélectionner : "..LabelSo)
        for k,v in pairs(allGradeForJobSelected) do


            RageUI.ButtonWithStyle(v.gradeLabel, nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                   ESX.ShowNotification("Setjob effectuer !")
                   ExecuteCommand("setjob me "..nameSo.." "..v.gradeJob)
                   RageUI.CloseAll()
                end
            end)

        end
    end, function()
    end)

        RageUI.IsVisible(setjobMenuSub2, true, true, true, function()
            RageUI.Separator("~y~Job sélectionner : "..LabelSo)
        for k,v in pairs(allGradeForJobSelected) do
            RageUI.ButtonWithStyle(v.gradeLabel, nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                   ESX.ShowNotification("Setjob effectuer !")
                   ExecuteCommand("setjob2 me "..nameSo.." "..v.gradeJob)
                   RageUI.CloseAll()
                end
            end)

        end       
        end, function()
        end)

        if not RageUI.Visible(main) and not RageUI.Visible(job) and not RageUI.Visible(factures) and not RageUI.Visible(meteo) and not RageUI.Visible(MenuTempsMeteo) and not RageUI.Visible(MenuHeureMeteo) and not RageUI.Visible(perso2) and not RageUI.Visible(setjobMenu) and not RageUI.Visible(setjobMenuSub) and not RageUI.Visible(setjob2Menu) and not RageUI.Visible(setjobMenuSub2) then
            main = RMenu:DeleteType(main, true)
        end
    end
end

function tcheckmoisa()

    ESX.TriggerServerCallback('devmenu:getAllJobs', function(allJobs)
        allJobsServer = allJobs
    end)
end

RegisterCommand('devmenu', function()
    ESX.TriggerServerCallback('BahFaut:getUsergroup', function(group)
        playergroup = group
        for k,v in pairs(Config.AdminRanks) do
        if playergroup == v then
            superadmin = true
            tcheckmoisa()
            OuvrirAdmin()
        else
            superadmin = false
        end
    end
    end)
end, false)

RegisterKeyMapping('devmenu', 'Ouvrir le menu DEV', 'keyboard', 'F10')