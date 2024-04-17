ESX = exports["es_extended"]:getSharedObject()
local allReport = {}
local items = {}

ESX.RegisterServerCallback('BahFaut:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	print(GetPlayerName(source).." - "..group)
	cb(group)
end)


ESX.RegisterServerCallback("devmenu:getAllJobs", function(source, cb)
  local allJobs = {}

  MySQL.Async.fetchAll("SELECT * FROM jobs", {}, function(data)
      for _, v in pairs(data) do
      table.insert(allJobs, {
        NameSociety = v.name,
        LabelSociety = v.label
      })
      end
      cb(allJobs)
  end)
end)

ESX.RegisterServerCallback("devmenu:getAllGrade", function(source, cb, jobName)
  local gradeJobs = {}

  MySQL.Async.fetchAll("SELECT * FROM job_grades WHERE job_name = @job_name", {['job_name'] = jobName}, function(data)
      for _,v in pairs(data) do
      table.insert(gradeJobs, {
        gradeJob = v.grade,
        gradeLabel = v.label
      })
      end
      cb(gradeJobs)
  end)
end)


----------------------------------------------------------------------------------------
WebHook2 = Config.DiscordWebHook
Name = Config.DiscordName
Logo = Config.DiscordLogo
----------------------------------------------------------------------------------------
LogsBlue = 3447003
LogsRed = 15158332
LogsYellow = 15844367
LogsOrange = 15105570
LogsGrey = 9807270
LogsPurple = 10181046
LogsGreen = 3066993
LogsLightBlue = 1752220
----------------------------------------------------------------------------------------
RegisterNetEvent('Ise_Logs2')
AddEventHandler('Ise_Logs2', function(Color, Title, Description)
	Ise_Logs2(Color, Title, Description)
end)

RegisterNetEvent('Ise_Logs3')
AddEventHandler('Ise_Logs3', function(Webhook, Color, Title, Description)
	Ise_Logs3(Webhook, Color, Title, Description)
end)

function Ise_Logs2(Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	                ["text"] = Name,
	                ["icon_url"] = Logo,
	            },
	        }
	    }
	PerformHttpRequest(WebHook2, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

function Ise_Logs3(webhook3, Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	                ["text"] = Name,
	                ["icon_url"] = Logo,
	            },
	        }
	    }
	PerformHttpRequest(webhook3, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end