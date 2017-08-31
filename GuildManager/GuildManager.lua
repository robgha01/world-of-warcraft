local GUI = LibStub("AceGUI-3.0")

--Options Interface--
local options = { 
	name = function(info)
			return "Guild Manager 7.1.0 By: Yottabyte"
			end,
    handler = GuildManager,
    type = 'group',
    childGroups = "tab",
    args = {
		gmheader = {
			type = 'header',
			name = function(info)
			if GuildManager:GetGuildName()~=nil then
			return strjoin("","Settings for ",GuildManager.db:GetCurrentProfile())
			else
			return "Guild Manager is disabled as you are not currently in a guild"
			end
			end,
			order = 1,
			},
		recruitment = {
			type = 'group',
			name = "Recruitment",
			desc = "Guild Recruitment Settings",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			order = 2,
			args = {
			zonerecruitment = {
			type = 'group',
			name = "Zone Recruitment",
			desc = "Zone Recruitment Settings",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			order = 1,
			args = {
				cityspam = {
			type = 'toggle',
			name = "CitySpam Enabled?",
			desc = "Should I spam in cities?",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			get = function(info)
						return GuildManager.db.profile.cityspam
					end,
			set = function(info, newValue)
						GuildManager.db.profile.cityspam = newValue
					end,
			order = 1,
		},
				zonespam = {
				type = 'toggle',
				name = "ZoneSpam Enabled?",
				desc = "Should I spam in regular zones?",
				disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.zonespam
						end,
				set = function(info, newValue)
							GuildManager.db.profile.zonespam = newValue
						end,
				order = 2,
			},
				outpvpspam = {
				type = 'toggle',
				name = "Outdoor PVP Zones Enabled?",
				desc = "Should I spam in outdoor pvp zones?",
				disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.outpvpspam
						end,
				set = function(info, newValue)
							GuildManager.db.profile.outpvpspam = newValue
						end,
				order = 3,
			},
				interval = {
			type = 'range',
			name = "Interval",
			desc = "The amount of minutes between spammings in a particular location",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			min = 15,
			max = 120,
			step = 1,			
			get = function(info)
						return GuildManager.db.profile.between
					end,
			set = function(info, newValue)
						GuildManager.db.profile.between = newValue
					end,
			order = 4,
		},
				lastspam = {
					type = 'execute',
					name = "Last time spammed in zone",
					desc = "Spit out to chat the last time someone in this guild has spammed in this zone",
					func = 	function(info)
							local currentzone
							if (GuildManager:IsCity()) then
								currentzone = "City"
							else
                                currentzone = GetZoneText()
                            end
							GuildManager:Print(string.format("The last time spammed in this zone was %s minutes ago", tostring(tonumber(GuildManager:GetTime()) - (tonumber(GuildManager.db.profile.lasttime[currentzone]) or 0))))
						end,
			order = 5,
		},
				manspam = {
					type = 'execute',
					name = "Manual Spam",
					desc = "Spams current zone",
					disabled = function(info)
					if IsGuildLeader()~=true then 
					return true
					else
					return false
					end
					end,
					func = 	function(info)
					if (GuildManager:IsCity()) then 
					GuildManager:SpamZone("City")
					else
					GuildManager:SpamZone(GetZoneText())
					end
					end,
			order = 6,
		},
				msg = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "General Chat Message",
            desc = "The message text that will be broadcast in General/Trade",
            usage = "<Your message here>",
            disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
            get = function(info)
						return GuildManager.db.profile.message
					end,
            set = function(info, newValue)
						GuildManager.db.profile.message = newValue
					end,
			order = 7,
        },
				citychannel = {
			type = 'range',
			name = "City Channel Number",
			desc = "Lets you choose which channel number you would like to recruit on while in a city. NOTE: By default 1 will use General, 2 will use Trade but it varies depending on how you set up your chat channels.",
			min = 1,
			max = 10,
			step = 1,
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,			
			get = function(info)
						return GuildManager.db.profile.citychannel
					end,
			set = function(info, newValue)
						GuildManager.db.profile.citychannel = newValue
					end,
			order = 8,
		},
				zonechannel = {
			type = 'range',
			name = "Zone Channel Number",
			desc = "Lets you choose which channel number you would like to recruit on while in a general zone. NOTE: By default 1 will use General, 3 will use Local Defense but it varies depending on how you set up your chat channels.",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			min = 1,
			max = 10,
			step = 1,			
			get = function(info)
						return GuildManager.db.profile.zonechannel
					end,
			set = function(info, newValue)
						GuildManager.db.profile.zonechannel = newValue
					end,
			order = 9,
		},
				},
			},
			whorecruitment = {
			type = 'group',
			childGroups = "tab",
			name = "Toon Recruitment",
			desc = "Character Recruitment Settings NOTE: You will need to create a macro or modify your macros by adding '/run GuildManager:InviteAction()' to each one. See documentation for details.",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			order = 2,
			args = {		
			runwho = {
					type = 'execute',
					name = "Run Who Search",
					desc = "Begins searching for players. Character Recruitment uses the UI. UI elements such as the Mail Box, The Map, Character Stats, Achievments, etc. will close during the course of a cycle. It is recomended that you run this cycle if you plan to be AFK or doing something that doesnt require the UI as much. Raiding, Questing, etc.",
					
					confirm = true,
					func = 	function(info) 
					GuildManager:RunWhoSearch()
					end,
					order = 1,
					disabled = function(info)
					if GuildManager.db.profile.automatewho==true or IsGuildLeader()~=true then 
					return true
					else
					return false
					end
					end,
			},
			automatewho = {
				type = 'toggle',
				name = "Automate",
				desc = "Search for players automatically & continuously.",
				disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.automatewho
						end,
				set = function(info, newValue)
							GuildManager.db.profile.automatewho = newValue
						end,
				order = 2,
			},
			iqcontrols = {
			type = 'execute',
			name = "Launch IQ Controls?",
			desc = "The Invite Queue is a list of ",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			func = 	function(info)
			GuildManager:IQUI()
				end,
			order = 3,
		},
			targetclass = {
			type = 'toggle',
				name = "Target Specific Classes",
				desc = "Target specific classes when searching for players. Otherwise will target all classes.",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.targetclass
						end,
				set = function(info, newValue)
							GuildManager.db.profile.targetclass = newValue
						end,
				order = 4,
			},
			whispmsg = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Whisper Message",
            desc = "The message text that will be sent to targeted players",
            usage = "<Your message here>",
            disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
            get = function(info)
						return GuildManager.db.profile.whispmessage
					end,
            set = function(info, newValue)
						GuildManager.db.profile.whispmessage = newValue
					end,
			order = 5,
        },	
			minlevel = {
					type = 'range',
					name = "Minimum Level",
					desc = "The minimum level of people you are looking for (used when scanning Who Search results)",
					min = 20,
					max = 110,
					step = 1,	
					disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,		
					get = function(info)
								return GuildManager.db.profile.minlevel
							end,
					set = function(info, newValue)
								if newValue > GuildManager.db.profile.maxlevel then
									GuildManager:Print("Cannot set a minimum level higher than the maximum")
								return
								end
								GuildManager.db.profile.minlevel = newValue
							end,
					order = 6,
				},
			maxlevel = {
					type = 'range',
					name = "Maximum Level",
					desc = "The maximum level of people you are looking for (used when scanning Who Search Results)",
					min = 20,
					max = 110,
					step = 1,	
					disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,		
					get = function(info)
								return GuildManager.db.profile.maxlevel
							end,
					set = function(info, newValue)
								if newValue < GuildManager.db.profile.minlevel then
									GuildManager:Print("Cannot set a maximum level lower than the minimum")
									return
								end
								GuildManager.db.profile.maxlevel = newValue
							end,
					order = 7,
				},
			classsettings = {
			type = 'group',
			name = "Class List",
			desc = "Select the classes you wish to target",
			disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			order = 8,
			disabled = function(info)
								if GuildManager.db.profile.targetclass then return false end
								return true
							end,
			args = {
				DKsearch = {
				type = 'toggle',
				name = "Death Knight",
				desc = "Recruit Death Knights?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.DKsearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.DKsearch = newValue
						end,
				order = 1,
			},	
				DHsearch = {
				type = 'toggle',
				name = "Demon Hunter",
				desc = "Recruit Demon Hunters?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.DHsearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.DHsearch = newValue
						end,
				order = 1,
			},
				Druidsearch = {
				type = 'toggle',
				name = "Druid",
				desc = "Recruit Druids?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Druidsearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Druidsearch = newValue
						end,
				order = 1,
			},	
				Huntersearch = {
				type = 'toggle',
				name = "Hunters",
				desc = "Recruit Hunters?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Huntersearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Huntersearch = newValue
						end,
				order = 1,
			},
				Magesearch = {
				type = 'toggle',
				name = "Mage",
				desc = "Recruit Mages?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Magesearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Magesearch = newValue
						end,
				order = 1,
			},	
				Monksearch = {
				type = 'toggle',
				name = "Monk",
				desc = "Recruit Monks?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Monksearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Monksearch = newValue
						end,
				order = 1,
			},	
				Paladinsearch = {
				type = 'toggle',
				name = "Paladin",
				desc = "Recruit Paladins?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Paladinsearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Paladinsearch = newValue
						end,
				order = 1,
			},	
				Priestsearch = {
				type = 'toggle',
				name = "Priest",
				desc = "Recruit Priests?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Priestsearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Priestsearch = newValue
						end,
				order = 1,
			},	
				Roguesearch = {
				type = 'toggle',
				name = "Rogue",
				desc = "Recruit Rogues?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Roguesearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Roguesearch = newValue
						end,
				order = 1,
			},	
				Shamansearch = {
				type = 'toggle',
				name = "Shaman",
				desc = "Recruit Shamans?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Shamansearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Shamansearch = newValue
						end,
				order = 1,
			},	
				Warlocksearch = {
				type = 'toggle',
				name = "Warlock",
				desc = "Recruit Warlocks?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Warlocksearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Warlocksearch = newValue
						end,
				order = 1,
			},	
				Warriorsearch = {
				type = 'toggle',
				name = "Warrior",
				desc = "Recruit Warriors?",
				disabled = function(info)
				if GuildManager.db.profile.automatewho==true or CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.Warriorsearch
						end,
				set = function(info, newValue)
							GuildManager.db.profile.Warriorsearch = newValue
						end,
				order = 1,
			},	
				},
			},
			},
			},
			invitecontrols = {
			type = 'group',
			childGroups = "tab",
			name = "Invitation Control",
			desc = "Do Not Invite List (Antispam Measure) and Member Cap Settings.",
			order = 3,
			args = {
			dnilcontrols = {
			type = 'execute',
			name = "Launch DNIL Controls?",
			desc = "WARNING: Over time the Do Not Invite List will get huge. If you MUST modify or purge the list be prepared for your UI to freeze for 30-60 seconds while the controls load.",
			confirm = true,
			func = 	function(info)
			GuildManager:DNIUI()
				end,
			order = 1,
		},
			membercap = {
				type = 'range',
					width = "normal",
					name = "Member Maximum",
					desc = "Will stop recruiting if the guild population is at or above a certain threshold. If undefined it will assume 1000.",
					disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
					min = 1,
					max = 1000,
					step = 1,
					get = function(info)
						return GuildManager.db.profile.membercap
							end,
					set = function(info, newValue)
							GuildManager.db.profile.membercap = newValue
							end,
					order = 2,
				},
			whohalt = {
			type = 'execute',
			name = "Stop!",
			desc = "Emergency button that halts a Character Recruitment Cycle",
			func = 	function(info)
			if WhoCycle==1 then
			GuildManager:Print('Halting Character Recruitment Cycle')
			WhoHalt=1
			if GuildManager.db.profile.automatewho==true then
			GuildManager.db.profile.automatewho=false
			GuildManager:Print('Disabling Character Recruitment Automation')
			end
			else
			GuildManager:Print('Character Recruitment Cycle is NOT currently running')
			end
				end,
			order = 3,
		},
			welcomeannounce = {
					type = "select",
					order = 4,
					name = "Announce New Members",
					desc = "Choose to announce when a member is added to the guild",
					disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
					values = {"None","Officer","Guild"},
					get = function(info)
						return GuildManager.db.profile.welcomeannounce
							end,
					set = function(info, newValue)
							GuildManager.db.profile.welcomeannounce = newValue
							end,
					},
			welcomewhisp = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Guild Welcome Whisper",
            desc = "The message text that will be sent to the new guild member. If you don't want to send a whisper, leave blank.",
            usage = "<Your message here>",
            disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
            get = function(info)
						return GuildManager.db.profile.welcomewhisp
					end,
            set = function(info, newValue)
						GuildManager.db.profile.welcomewhisp = newValue
					end,
			order = 5,
        },
			declinewhisp = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Guild Invite Decline Whisper",
            desc = "The message text that will be sent to someone who declines your guild invitation. If you don't want to send a whisper, leave blank.",
            usage = "<Your message here>",
            disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
            get = function(info)
						return GuildManager.db.profile.declinewhisp
					end,
            set = function(info, newValue)
						GuildManager.db.profile.declinewhisp = newValue
					end,
			order = 6,
        },
			whisperinvite = {
				type = 'toggle',
				name = "Invite on Whisper",
				desc = 'Will Invite players to your guild who say "LF Guild" in a whisper message. (whisper is not case-sensetive) WARNING: Cannot be used with Whisper Only! NOTE: Be sure to include this in your Zone Message, Recruitment Message, and/or AFK/DND message so that applicants know what to say! Will NOT invite players on the Black List!',
				disabled = function(info)
				if CanGuildInvite()~=true or GuildManager.db.profile.whisperonly then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.whisperinvite
						end,
				set = function(info, newValue)
							GuildManager.db.profile.whisperinvite = newValue
						end,
				order = 7,
				},
			whisperonly = {
				type = 'toggle',
				name = "Whisper Only",
				desc = 'This will cause only a whisper to go out instead of a whisper and a guild invite. WARNING: Cannot be used with Invite on Whisper! NOTE: There is an issue where guilded members show up in the Who list as not guilded. Using this feature will result in guilded players getting your invite message.',
				disabled = function(info)
				if CanGuildInvite()~=true or GuildManager.db.profile.whisperinvite then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildManager.db.profile.whisperonly
						end,
				set = function(info, newValue)
							GuildManager.db.profile.whisperonly = newValue
						end,
				order = 8,
				},
			},
			},
			
		},
		},
		pruning = {
			type = 'group',
			childGroups = "tab",
			name = "Pruning",
			desc = "Guild Pruning Settings",
			order = 3,
			args = {
				manprune = {
				type = 'execute',
			name = "Prune",
			desc = "Manually remove players from your guild",
			func = 	function(info) 
					GuildManager:GKRun()
					end,
			order = 1,
			disabled = function(info)
								if GuildManager.db.profile.automateprune then return true end
								return false
							end,
				},
				removeinactive = {
				type = 'toggle',
				name = "Remove Inactive",
				desc = "Remove members based on inactivity",
				get = function(info)
							return GuildManager.db.profile.removeinactive
						end,
				set = function(info, newValue)
							GuildManager.db.profile.removeinactive = newValue
						end,
				order = 2,
				},
				removelevels = {
				type = 'toggle',
				name = "Remove Low Levels",
				desc = "Remove Low Level Members",
				get = function(info)
							return GuildManager.db.profile.removelevels
						end,
				set = function(info, newValue)
							GuildManager.db.profile.removelevels = newValue
						end,
				order = 3,
				},
				automateprune = {
				type = 'toggle',
				name = "Automate",
				desc = "Prune members automatically & continuously",
				get = function(info)
							return GuildManager.db.profile.automateprune
						end,
				set = function(info, newValue)
							GuildManager.db.profile.automateprune = newValue
						end,
				order = 4,
				},
				daysinactive = {
				type = 'range',
					width = "normal",
					name = "Days Offline",
					desc = "Inactivity Threshold",
					min = 1,
					max = 365,
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.removeinactive then return false end
								return true
							end,
					get = function(info)
						return GuildManager.db.profile.daysinactive
							end,
					set = function(info, newValue)
							GuildManager.db.profile.daysinactive = newValue
							end,
					order = 5,
				},
				levelthreshold = {
				type = 'range',
					width = "normal",
					name = "Low Level",
					desc = "Low Level Threshhold. Members at or below this level will be removed.",
					min = 1,
					max = 110,
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.removelevels then return false end
								return true
							end,
					get = function(info)
						return GuildManager.db.profile.levelthreshold
							end,
					set = function(info, newValue)
							GuildManager.db.profile.levelthreshold = newValue
							end,
					order = 6,
				 },
				pruneannounce = {
					type = "select",
					order = 7,
					name = "Announce Prunes",
					desc = "Choose to announce why members were removed from the guild.",
					values = {"None","Officer","Guild"},
					get = function(info)
						return GuildManager.db.profile.pruneannounce
							end,
					set = function(info, newValue)
							GuildManager.db.profile.pruneannounce = newValue
							end,
					},
				blackcontrols = {
			type = 'execute',
			name = "Launch Black List Controls?",
			desc = "WARNING: Over time the Black List can get huge. If you MUST modify or purge the list be prepared for your UI to freeze for 30-60 seconds while the controls load.",
			confirm = true,
			func = 	function(info)
			GuildManager:BlackUI()
				end,
			order = 8,
		},
				pruneexemptcontrols = {
			type = 'execute',
			name = "Launch Prune Exempt Controls?",
			desc = "WARNING: Over time the Prune Exemption List can get huge. If you MUST modify or purge the list be prepared for your UI to freeze for 30-60 seconds while the controls load.",
			confirm = true,
			func = 	function(info)
			GuildManager:PruneExemptUI()
				end,
			order = 9,
		},
				exemptalt = {
				type = 'toggle',
				name = "Alts Exempt",
				desc = "Exempts Alts from pruning. MUST HAVE THE WORD 'ALT' in either their public or private note!",
				get = function(info)
							return GuildManager.db.profile.exemptalt
						end,
				set = function(info, newValue)
							GuildManager.db.profile.exemptalt = newValue
						end,
				order = 10,
				},
				exemptranks = {
				type = 'toggle',
				name = "Exempt Ranks",
				desc = "Exempts selected Ranks from pruning",
				get = function(info)
							return GuildManager.db.profile.exemptranks
						end,
				set = function(info, newValue)
							GuildManager.db.profile.exemptranks = newValue
						end,
				order = 11,
				},
				removefromdnil = {
				type = 'toggle',
				name = "Remove from DNIL",
				desc = "Removes a kicked player from the Do Not Invite List so that they may be reinvited in future should they meet your recruitment criteria.",
				get = function(info)
							return GuildManager.db.profile.removefromdnil
						end,
				set = function(info, newValue)
							GuildManager.db.profile.removefromdnil = newValue
						end,
				order = 11,
				},
				ranktable = {
					type = 'group',
					childGroups = "tab",
					name = "Rank Exemption List",
					desc = "List of ranks exempt from pruning.",
					order = 12,
					disabled = function(info)
								if GuildManager.db.profile.exemptranks then return false end
								return true
							end,
					args = {
						exemptrank1 = {
							type = 'toggle',
							name = function(info)
									if GuildControlGetRankName(2)==nil then return "Rank 2" end
									return GuildControlGetRankName(2)
									end,
							desc = "Exempt this rank from pruning?",
							hidden = function(info)
									if GuildControlGetNumRanks()<=1 then 
									GuildManager.db.profile.exemptrank1=false
									return true end
									return false
									end,
							get = function(info)
										return GuildManager.db.profile.exemptrank1
									end,
							set = function(info, newValue)
										GuildManager.db.profile.exemptrank1 = newValue
									end,
							order = 1,
						},
						exemptrank2 = {
						type = 'toggle',
							name = function(info)
									if GuildControlGetRankName(3)==nil then return "Rank 3" end
									return GuildControlGetRankName(3)
									end,
							desc = "Exempt this rank from pruning?",
							hidden = function(info)
									if GuildControlGetNumRanks()<=2 then 
									GuildManager.db.profile.exemptrank2=false
									return true end
									return false
									end,
							get = function(info)
										return GuildManager.db.profile.exemptrank2
									end,
							set = function(info, newValue)
										GuildManager.db.profile.exemptrank2 = newValue
									end,
							order = 2,
						},
						exemptrank3 = {
						type = 'toggle',
							name = function(info)
									if GuildControlGetRankName(4)==nil then return "Rank 4" end
									return GuildControlGetRankName(4)
									end,
							desc = "Exempt this rank from pruning?",
							hidden = function(info)
									if GuildControlGetNumRanks()<=3 then 
									GuildManager.db.profile.exemptrank3=false
									return true end
									return false
									end,
							get = function(info)
										return GuildManager.db.profile.exemptrank3
									end,
							set = function(info, newValue)
										GuildManager.db.profile.exemptrank3 = newValue
									end,
							order = 3,
						},
						exemptrank4 = {
						type = 'toggle',
							name = function(info)
									if GuildControlGetRankName(5)==nil then return "Rank 5" end
									return GuildControlGetRankName(5)
									end,
							desc = "Exempt this rank from pruning?",
							hidden = function(info)
									if GuildControlGetNumRanks()<=4 then 
									GuildManager.db.profile.exemptrank4=false
									return true end
									return false
									end,
							get = function(info)
										return GuildManager.db.profile.exemptrank4
									end,
							set = function(info, newValue)
										GuildManager.db.profile.exemptrank4 = newValue
									end,
							order = 4,
						},
						exemptrank5 = {
						type = 'toggle',
							name = function(info)
									if GuildControlGetRankName(6)==nil then return "Rank 6" end
									return GuildControlGetRankName(6)
									end,
							desc = "Exempt this rank from pruning?",
							hidden = function(info)
									if GuildControlGetNumRanks()<=5 then 
									GuildManager.db.profile.exemptrank5=false
									return true end
									return false
									end,
							get = function(info)
										return GuildManager.db.profile.exemptrank5
									end,
							set = function(info, newValue)
										GuildManager.db.profile.exemptrank5 = newValue
									end,
							order = 5,
						},
						exemptrank6 = {
						type = 'toggle',
							name = function(info)
									if GuildControlGetRankName(7)==nil then return "Rank 7" end
									return GuildControlGetRankName(7)
									end,
							desc = "Exempt this rank from pruning?",
							hidden = function(info)
									if GuildControlGetNumRanks()<=6 then 
									GuildManager.db.profile.exemptrank6=false
									return true end
									return false
									end,
							get = function(info)
										return GuildManager.db.profile.exemptrank6
									end,
							set = function(info, newValue)
										GuildManager.db.profile.exemptrank6 = newValue
									end,
							order = 6,
						},
						exemptrank7 = {
						type = 'toggle',
							name = function(info)
									if GuildControlGetRankName(8)==nil then return "Rank 8" end
									return GuildControlGetRankName(8)
									end,
							desc = "Exempt this rank from pruning?",
							hidden = function(info)
									if GuildControlGetNumRanks()<=7 then 
									GuildManager.db.profile.exemptrank7=false
									return true end
									return false
									end,
							get = function(info)
										return GuildManager.db.profile.exemptrank7
									end,
							set = function(info, newValue)
										GuildManager.db.profile.exemptrank7 = newValue
									end,
							order = 7,
						},
						exemptrank8 = {
						type = 'toggle',
							name = function(info)
									if GuildControlGetRankName(9)==nil then return "Rank 9" end
									return GuildControlGetRankName(9)
									end,
							desc = "Exempt this rank from pruning?",
							hidden = function(info)
									if GuildControlGetNumRanks()<=8 then 
									GuildManager.db.profile.exemptrank8=false
									return true end
									return false
									end,
							get = function(info)
										return GuildManager.db.profile.exemptrank8
									end,
							set = function(info, newValue)
										GuildManager.db.profile.exemptrank8 = newValue
									end,
							order = 8,
						},
						exemptrank9 = {
						type = 'toggle',
							name = function(info)
									if GuildControlGetRankName(10)==nil then return "Rank 10" end
									return GuildControlGetRankName(10)
									end,
							desc = "Exempt this rank from pruning?",
							hidden = function(info)
									if GuildControlGetNumRanks()<=9 then 
									GuildManager.db.profile.exemptrank9=false
									return true end
									return false
									end,
							get = function(info)
										return GuildManager.db.profile.exemptrank9
									end,
							set = function(info, newValue)
										GuildManager.db.profile.exemptrank9 = newValue
									end,
							order = 9,
						},
						},
					},
				
		},
		},
		promotion = {
			type = 'group',
			name = "Promotion",
			desc = "Guild Promotion Settings",
			order = 4,
			args = {
			manpromote = {
				type = 'execute',
			name = "Run Promotions",
			desc = "Manually runs the promoter WARNING: Whenever you move, add, or delete ranks be sure to update your promote settings! Not doing so may have unintended side effects!",
			order = 1,
			confirm = true,
			func = 	function(info) 
					GuildManager:GMPromoteErrorChecking()
					end,
			disabled = function(info)
								if GuildManager.db.profile.automatepromote then return true end
								return false
							end,
				},
			automatepromote = {
			type = 'toggle',
			name = "Automate",
			confirm = true,
			desc = "Will automatically and continously promote members who meet the specificed standards. WARNING: Whenever you move, add, or delete ranks be sure to update your promote settings! Not doing so may have unintended side effects!",
			get = function(info)
					return GuildManager.db.profile.automatepromote
				end,
			set = function(info, newValue)
					GuildManager.db.profile.automatepromote = newValue
				end,
			order = 2,
			},
			demotemode = {
			type = 'toggle',
			name = "Demote Mode",
			desc = "Demotes members who no longer qualify for the rank they hold based on the below settings.",
			get = function(info)
					return GuildManager.db.profile.demotemode
				end,
			set = function(info, newValue)
					GuildManager.db.profile.demotemode = newValue
				end,
			order = 3,
			},
			promoteannounce = {
					type = "select",
					order = 4,
					name = "Announce Promotions/Demotions",
					desc = "Choose to announce why members were promoted or demoted. Will also state how one can become promoted.",
					values = {"None","Officer","Guild"},
					get = function(info)
						return GuildManager.db.profile.promoteannounce
							end,
					set = function(info, newValue)
							GuildManager.db.profile.promoteannounce = newValue
							end,
					},		
			rankpromotesearch = {
			type = 'group',
			name = "Promote From Ranks",
			desc = "Ranks that Guild Promoter will look at when finding qualified candidates",
			order = 6,
			args = {
				rank1promotesearch = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(2)==nil then return "Rank 2" end
					return GuildControlGetRankName(2)
					end,
			desc = "Toggles this rank as a rank that promoter will promote FROM.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=1 then 
									GuildManager.db.profile.rank1promotesearch=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank1promotesearch
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank1promotesearch = newValue
				end,
			order = 1,
			},
				rank2promotesearch = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(3)==nil then return "Rank 3" end
					return GuildControlGetRankName(3)
					end,
			desc = "Toggles this rank as a rank that promoter will promote FROM.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=2 then 
									GuildManager.db.profile.rank2promotesearch=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank2promotesearch
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank2promotesearch = newValue
				end,
			order = 2,
			},
				rank3promotesearch = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(4)==nil then return "Rank 4" end
					return GuildControlGetRankName(4)
					end,
			desc = "Toggles this rank as a rank that promoter will promote FROM.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=3 then 
									GuildManager.db.profile.rank3promotesearch=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank3promotesearch
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank3promotesearch = newValue
				end,
			order = 3,
			},
				rank4promotesearch = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(5)==nil then return "Rank 5" end
					return GuildControlGetRankName(5)
					end,
			desc = "Toggles this rank as a rank that promoter will promote FROM.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=4 then 
									GuildManager.db.profile.rank4promotesearch=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank4promotesearch
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank4promotesearch = newValue
				end,
			order = 4,
			},
				rank5promotesearch = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(6)==nil then return "Rank 6" end
					return GuildControlGetRankName(6)
					end,
			desc = "Toggles this rank as a rank that promoter will promote FROM.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=5 then 
									GuildManager.db.profile.rank5promotesearch=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank5promotesearch
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank5promotesearch = newValue
				end,
			order = 5,
			},
				rank6promotesearch = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(7)==nil then return "Rank 7" end
					return GuildControlGetRankName(7)
					end,
			desc = "Toggles this rank as a rank that promoter will promote FROM.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=6 then 
									GuildManager.db.profile.rank6promotesearch=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank6promotesearch
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank6promotesearch = newValue
				end,
			order = 6,
			},
				rank7promotesearch = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(8)==nil then return "Rank 8" end
					return GuildControlGetRankName(8)
					end,
			desc = "Toggles this rank as a rank that promoter will promote FROM.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=7 then 
									GuildManager.db.profile.rank7promotesearch=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank7promotesearch
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank7promotesearch = newValue
				end,
			order = 7,
			},
				rank8promotesearch = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(9)==nil then return "Rank 9" end
					return GuildControlGetRankName(9)
					end,
			desc = "Toggles this rank as a rank that promoter will promote FROM.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=8 then 
									GuildManager.db.profile.rank8promotesearch=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank8promotesearch
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank8promotesearch = newValue
				end,
			order = 8,
			},
				rank9promotesearch = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(10)==nil then return "Rank 10" end
					return GuildControlGetRankName(10)
					end,
			desc = "Toggles this rank as a rank that promoter will promote FROM.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=9 then 
									GuildManager.db.profile.rank9promotesearch=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank9promotesearch
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank9promotesearch = newValue
				end,
			order = 9,
			},
					},
				},
			rankpromoteplacelevel = {
			type = 'group',
			name = "Promote To By Level",
			desc = "Ranks that Guild Promoter will look at when placing qualified candidates",
			order = 8,
			args = {
				rank1promote = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(2)==nil then return "Rank 2" end
					return GuildControlGetRankName(2)
					end,
			desc = "Toggles this rank as a rank that promoter will promote TO.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=2 then 
									GuildManager.db.profile.rank1promote=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank1promote
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank1promote = newValue
				end,
			order = 3,
			},
				rank1level = {
				type = 'range',
					width = "normal",
					max = 111,
					min = 1,
					name = strjoin(" ",GuildControlGetRankName(2),"Level Threshold"),
					desc = strjoin(" ","Input for",GuildControlGetRankName(2),"Level Threshold"),
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.rank1promote then return false end
								return true
							end,
					hidden = function(info)
									if GuildControlGetNumRanks()<=2 then 
									GuildManager.db.profile.rank1level=111
									return true end
									return false
									end,
					get = function(info)
						return GuildManager.db.profile.rank1level
							end,
					set = function(info, newValue)
							GuildManager.db.profile.rank1level = newValue
							end,
					order = 4,
				},
				rank2promote = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(3)==nil then return "Rank 3" end
					return GuildControlGetRankName(3)
					end,
			desc = "Toggles this rank as a rank that promoter will promote TO.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=3 then 
									GuildManager.db.profile.rank2promote=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank2promote
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank2promote = newValue
				end,
			order = 5,
			},
				rank2level = {
				type = 'range',
					width = "normal",
					max = 111,
					min = 1,
					name = strjoin(" ",GuildControlGetRankName(3),"Level Threshold"),
					desc = strjoin(" ","Input for",GuildControlGetRankName(3),"Level Threshold"),
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.rank2promote then return false end
								return true
							end,
					hidden = function(info)
									if GuildControlGetNumRanks()<=3 then 
									GuildManager.db.profile.rank2level=111
									return true end
									return false
									end,
					get = function(info)
						return GuildManager.db.profile.rank2level
							end,
					set = function(info, newValue)
							GuildManager.db.profile.rank2level = newValue
							end,
					order = 6,
				},
				rank3promote = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(4)==nil then return "Rank 4" end
					return GuildControlGetRankName(4)
					end,
			desc = "Toggles this rank as a rank that promoter will promote TO.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=4 then 
									GuildManager.db.profile.rank3promote=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank3promote
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank3promote = newValue
				end,
			order = 7,
			},
				rank3level = {
				type = 'range',
					width = "normal",
					max = 111,
					min = 1,
					name = strjoin(" ",GuildControlGetRankName(4),"Level Threshold"),
					desc = strjoin(" ","Input for",GuildControlGetRankName(4),"Level Threshold"),
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.rank3promote then return false end
								return true
							end,
					hidden = function(info)
									if GuildControlGetNumRanks()<=4 then 
									GuildManager.db.profile.rank3level=111
									return true end
									return false
									end,
					get = function(info)
						return GuildManager.db.profile.rank3level
							end,
					set = function(info, newValue)
							GuildManager.db.profile.rank3level = newValue
							end,
					order = 8,
				},
				rank4promote = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(5)==nil then return "Rank 5" end
					return GuildControlGetRankName(5)
					end,
			desc = "Toggles this rank as a rank that promoter will promote TO.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=5 then 
									GuildManager.db.profile.rank4promote=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank4promote
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank4promote = newValue
				end,
			order = 9,
			},
				rank4level = {
				type = 'range',
					width = "normal",
					max = 111,
					min = 1,
					name = strjoin(" ",GuildControlGetRankName(5),"Level Threshold"),
					desc = strjoin(" ","Input for",GuildControlGetRankName(5),"Level Threshold"),
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.rank4promote then return false end
								return true
							end,
					hidden = function(info)
									if GuildControlGetNumRanks()<=5 then 
									GuildManager.db.profile.rank4level=111
									return true end
									return false
									end,
					get = function(info)
						return GuildManager.db.profile.rank4level
							end,
					set = function(info, newValue)
							GuildManager.db.profile.rank4level = newValue
							end,
					order = 10,
				},
				rank5promote = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(6)==nil then return "Rank 6" end
					return GuildControlGetRankName(6)
					end,
			desc = "Toggles this rank as a rank that promoter will promote TO.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=6 then 
									GuildManager.db.profile.rank5promote=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank5promote
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank5promote = newValue
				end,
			order = 11,
			},
				rank5level = {
				type = 'range',
					width = "normal",
					max = 111,
					min = 1,
					name = strjoin(" ",GuildControlGetRankName(6),"Level Threshold"),
					desc = strjoin(" ","Input for",GuildControlGetRankName(6),"Level Threshold"),
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.rank5promote then return false end
								return true
							end,
					hidden = function(info)
									if GuildControlGetNumRanks()<=6 then 
									GuildManager.db.profile.rank5level=111
									return true end
									return false
									end,
					get = function(info)
						return GuildManager.db.profile.rank5level
							end,
					set = function(info, newValue)
							GuildManager.db.profile.rank5level = newValue
							end,
					order = 12,
				},
				rank6promote = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(7)==nil then return "Rank 7" end
					return GuildControlGetRankName(7)
					end,
			desc = "Toggles this rank as a rank that promoter will promote TO.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=7 then 
									GuildManager.db.profile.rank6promote=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank6promote
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank6promote = newValue
				end,
			order = 13,
			},
				rank6level = {
				type = 'range',
					width = "normal",
					max = 111,
					min = 1,
					name = strjoin(" ",GuildControlGetRankName(7),"Level Threshold"),
					desc = strjoin(" ","Input for",GuildControlGetRankName(7),"Level Threshold"),
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.rank6promote then return false end
								return true
							end,
					hidden = function(info)
									if GuildControlGetNumRanks()<=7 then 
									GuildManager.db.profile.rank6level=111
									return true end
									return false
									end,
					get = function(info)
						return GuildManager.db.profile.rank6level
							end,
					set = function(info, newValue)
							GuildManager.db.profile.rank6level = newValue
							end,
					order = 14,
				},
				rank7promote = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(8)==nil then return "Rank 8" end
					return GuildControlGetRankName(8)
					end,
			desc = "Toggles this rank as a rank that promoter will promote TO.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=8 then 
									GuildManager.db.profile.rank7promote=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank7promote
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank7promote = newValue
				end,
			order = 15,
			},
				rank7level = {
				type = 'range',
					width = "normal",
					max = 111,
					min = 1,
					name = strjoin(" ",GuildControlGetRankName(8),"Level Threshold"),
					desc = strjoin(" ","Input for",GuildControlGetRankName(8),"Level Threshold"),
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.rank7promote then return false end
								return true
							end,
					hidden = function(info)
									if GuildControlGetNumRanks()<=8 then 
									GuildManager.db.profile.rank7level=111
									return true end
									return false
									end,
					get = function(info)
						return GuildManager.db.profile.rank7level
							end,
					set = function(info, newValue)
							GuildManager.db.profile.rank7level = newValue
							end,
					order = 16,
				},
				rank8promote = {
			type = 'toggle',
			name = function(info)
					if GuildControlGetRankName(9)==nil then return "Rank 9" end
					return GuildControlGetRankName(9)
					end,
			desc = "Toggles this rank as a rank that promoter will promote TO.",
			hidden = function(info)
									if GuildControlGetNumRanks()<=9 then 
									GuildManager.db.profile.rank8promote=false
									return true end
									return false
									end,
			get = function(info)
					return GuildManager.db.profile.rank8promote
				end,
			set = function(info, newValue)
					GuildManager.db.profile.rank8promote = newValue
				end,
			order = 17,
			},
				rank8level = {
				type = 'range',
					max = 111,
					min = 1,
					name = strjoin(" ",GuildControlGetRankName(9),"Level Threshold"),
					desc = strjoin(" ","Input for",GuildControlGetRankName(9),"Level Threshold"),
					step = 1,
					disabled = function(info)
								if GuildManager.db.profile.rank8promote then return false end
								return true
							end,
					hidden = function(info)
									if GuildControlGetNumRanks()<=9 then 
									GuildManager.db.profile.rank8level=111
									return true end
									return false
									end,
					get = function(info)
						return GuildManager.db.profile.rank8level
							end,
					set = function(info, newValue)
							GuildManager.db.profile.rank8level = newValue
							end,
					order = 18,
				},
					},
				},	
			demoteexemptlist = {
					type = 'group',
					childGroups = "tab",
					name = "Player Exemption List",
					desc = "List of players who are exempt from demotion.",
					order = 9,
					disabled = function(info)
								if GuildManager.db.profile.demotemode then return false end
								return true
							end,
					args = {
					demoteexemptcontrols = {
			type = 'execute',
			name = "Launch Demote Exempt Controls?",
			desc = "WARNING: Over time the Demote Exemption List can get huge. If you MUST modify or purge the list be prepared for your UI to freeze for 30-60 seconds while the controls load.",
			confirm = true,
			func = 	function(info)
			GuildManager:DemoteExemptUI()
				end,
			order = 11,
		},
					},
					},
			
			},
		},
		announcments = {
			type = 'group',
			name = "Announcements",
			desc = "Guild Announcment Settings",
			order = 5,
			args = {
				annoucementstats= {
					type = 'execute',
					name = "Annoucement Stats",
					desc = "Prints which message was spammed last and when it was spammed.",
					func = 	function()
					if ValidMessages==1 then
					GuildManager:Print(strjoin(" ","A Guild Annoucnement was made",(GuildManager:GetTime()-GuildManager.db.profile.lastanntime),"minutes ago. Guild Announcement",GuildManager.db.profile.announcenext,"is due to print in",(GuildManager.db.profile.lastanntime+GuildManager.db.profile.nextannouncetime)-GuildManager:GetTime(),"minutes."))
					else
					GuildManager:Print("There Are No Valid Messages!")
					end
							end,
			order = 1,
		},
				annoucementskip= {
					type = 'execute',
					name = "Skip Announcement",
					desc = "Skips the next upcoming announcement and loads the one after that.",
					func = 	function()
					if ValidMessages==1 then
					GuildManager:Print(strjoin(" ","Skipping Guild Announcement",GuildManager.db.profile.announcenext))
					announcementskip=1
					GuildManager:LoadNextAnnouncement()
					announcementskip=0
					GuildManager:Print(strjoin(" ","Guild Announcement",GuildManager.db.profile.announcenext,"Loaded"))
					else 
					GuildManager:Print("There Are No Valid Messages!")
					end
					end,
			order = 2,
		},
				announcmentoverride = {
					type = 'execute',
					name = "Announce Now",
					desc = "Overrides the timer and broadcasts the next upcoming announcment.",
					func = 	function()
					if ValidMessages==1 then
					GuildManager:ExecuteAnnouncement()
					else
					GuildManager:Print("There Are No Valid Messages!")
					end
					end,
			order = 3,
		},
				announcement1 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 1",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildManager.db.profile.announcement1
					end,
            set = function(info, newValue)
						GuildManager.db.profile.announcement1 = newValue
					end,
			order = 4,
        },
				announcementtimer1 = {
					type = 'range',
					name = "Annoucement 1 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildManager.db.profile.announcementtimer1
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementtimer1 = newValue
							end,
					order = 5,
				},
				announcementto1 = {
					type = "select",
					order = 6,
					name = "Announce to Officer/Guild 1",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildManager.db.profile.announcementto1
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementto1 = newValue
							end,
					},
				announcementborder1 = {
					type = "select",
					order = 7,
					name = "Announce Border 1",
					desc = "Border style to wrap around the annoucnement. Great for annoucnements that exceed the single message character limit.",
					values = {"None","Star","Cricle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildManager.db.profile.announcementborder1
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementborder1 = newValue
							end,
					},
				announcement2 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 2",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildManager.db.profile.announcement2
					end,
            set = function(info, newValue)
						GuildManager.db.profile.announcement2 = newValue
					end,
			order = 8,
        },
				announcementtimer2 = {
					type = 'range',
					name = "Annoucement 2 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildManager.db.profile.announcementtimer2
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementtimer2 = newValue
							end,
					order = 9,
				},
				announcementto2 = {
					type = "select",
					order = 10,
					name = "Announce to Officer/Guild 2",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildManager.db.profile.announcementto2
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementto2 = newValue
							end,
					},
				announcementborder2 = {
					type = "select",
					order = 11,
					name = "Announce Border 2",
					desc = "Border style to wrap around the annoucnement. Great for annoucnements that exceed the single message character limit.",
					values = {"None","Star","Cricle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildManager.db.profile.announcementborder2
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementborder2 = newValue
							end,
					},
				announcement3 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 3",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildManager.db.profile.announcement3
					end,
            set = function(info, newValue)
						GuildManager.db.profile.announcement3 = newValue
					end,
			order = 12,
        },
				announcementtimer3 = {
					type = 'range',
					name = "Annoucement 3 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildManager.db.profile.announcementtimer3
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementtimer3 = newValue
							end,
					order = 13,
				},
				announcementto3 = {
					type = "select",
					order = 14,
					name = "Announce to Officer/Guild 3",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildManager.db.profile.announcementto3
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementto3 = newValue
							end,
					},
				announcementborder3 = {
					type = "select",
					order = 15,
					name = "Announce Border 3",
					desc = "Border style to wrap around the annoucnement. Great for annoucnements that exceed the single message character limit.",
					values = {"None","Star","Cricle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildManager.db.profile.announcementborder3
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementborder3 = newValue
							end,
					},
				announcement4 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 4",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildManager.db.profile.announcement4
					end,
            set = function(info, newValue)
						GuildManager.db.profile.announcement4 = newValue
					end,
			order = 16,
        },
				announcementtimer4 = {
					type = 'range',
					name = "Annoucement 4 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildManager.db.profile.announcementtimer4
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementtimer4 = newValue
							end,
					order = 17,
				},
				announcementto4 = {
					type = "select",
					order = 18,
					name = "Announce to Officer/Guild 4",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildManager.db.profile.announcementto4
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementto4 = newValue
							end,
					},
				announcementborder4 = {
					type = "select",
					order = 19,
					name = "Announce Border 4",
					desc = "Border style to wrap around the annoucnement. Great for annoucnements that exceed the single message character limit.",
					values = {"None","Star","Cricle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildManager.db.profile.announcementborder4
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementborder4 = newValue
							end,
					},
				announcement5 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 5",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildManager.db.profile.announcement5
					end,
            set = function(info, newValue)
						GuildManager.db.profile.announcement5 = newValue
					end,
			order = 20,
        },
				announcementtimer5 = {
					type = 'range',
					name = "Annoucement 5 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildManager.db.profile.announcementtimer5
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementtimer5 = newValue
							end,
					order = 21,
				},
				announcementto5 = {
					type = "select",
					order = 22,
					name = "Announce to Officer/Guild 5",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildManager.db.profile.announcementto5
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementto5 = newValue
							end,
					},
				announcementborder5 = {
					type = "select",
					order = 23,
					name = "Announce Border 5",
					desc = "Border style to wrap around the annoucnement. Great for annoucnements that exceed the single message character limit.",
					values = {"None","Star","Cricle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildManager.db.profile.announcementborder5
							end,
					set = function(info, newValue)
							GuildManager.db.profile.announcementborder5 = newValue
							end,
					},


				
		},
		},
	},
}

--Right Click Menu--
local EasyGInv = CreateFrame("Frame","EasyGInvFrame")
EasyGInv:SetScript("OnEvent", function() hooksecurefunc("UnitPopup_ShowMenu", EasyGInvCheck) end)
EasyGInv:RegisterEvent("PLAYER_LOGIN")

local PopupUnits = {"PARTY", "PLAYER", "RAID_PLAYER", "RAID", "FRIEND", "TEAM", "CHAT_ROSTER", "TARGET", "FOCUS", "GUILD", "GUILD_OFFLINE"}

local GInvButtonInfo = {
	text = "Invite To Guild",
	value = "EZ_GINV",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	if tContains(GuildManager.db.profile.GMDNIt, playerrealmname)~=1 then
	table.insert(GuildManager.db.profile.GMDNIt, playerrealmname)
	GMDNIt=GuildManager.db.profile.GMDNIt
	pairsByKeysDNI(GMDNIt)
	end
	GuildInvite(playerrealmname)
	GuildManager:Print(strjoin(" ",playerrealmname,"was invited and added to the Do Not Invite List!"))
	end,
	notCheckable = 1,
}

local DNILaddButtonInfo = {
	text = "Add to DNIL",
	value = "EZ_DNIL",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	table.insert(GuildManager.db.profile.GMDNIt, playerrealmname)
	GMDNIt=GuildManager.db.profile.GMDNIt
	pairsByKeysDNI(GMDNIt)
	GuildManager:Print(strjoin(" ",playerrealmname,"was added to the Do Not Invite List!"))
	end,
	notCheckable = 1,
}

local DNILremoveButtonInfo = {
	text = "Remove from DNIL",
	value = "EZ_DNILREM",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	GuildManager:tremovebyval(GuildManager.db.profile.GMDNIt, playerrealmname)
	GuildManager:Print(strjoin(" ",playerrealmname,"was removed from the Do Not Invite List!"))
	end,
	notCheckable = 1,
}

local BlackaddButtonInfo = {
	text = "Add to Black List",
	value = "EZ_BLACK",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	table.insert(GuildManager.db.profile.GMBlackt, playerrealmname)
	GMBlackt=GuildManager.db.profile.GMBlackt
	pairsByKeysBlack(GMBlackt)
	GuildManager:Print(strjoin(" ",playerrealmname,"was added to the Black List!"))
	if GuildManager.db.profile.pruneannounce==3 then
	SendChatMessage(strjoin(" ",playerrealmname,"has been banned from the guild. They will be autokicked if found on the roster."),"guild", nil,"GUILD")
	end
	if GuildManager.db.profile.pruneannounce==2 then
	SendChatMessage(strjoin(" ",playerrealmname,"has been banned from the guild. They will be autokicked if found on the roster."),"officer", nil,"OFFICER")
	end
	end,
	notCheckable = 1,
}

local BlackremoveButtonInfo = {
	text = "Remove from Black List",
	value = "EZ_BLACKREM",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	GuildManager:tremovebyval(GuildManager.db.profile.GMBlackt, playerrealmname)
	GuildManager:Print(strjoin(" ",playerrealmname,"was removed from the Black List!"))
	if GuildManager.db.profile.pruneannounce==3 then
	SendChatMessage(strjoin(" ",playerrealmname,"is no longer banned from the guild."),"guild", nil,"GUILD")
	end
	if GuildManager.db.profile.pruneannounce==2 then
	SendChatMessage(strjoin(" ",playerrealmname,"is no longer banned from the guild."),"officer", nil,"OFFICER")
	end
	end,
	notCheckable = 1,
}

local KickButtonInfo = {
	text = "Kick from Guild",
	value = "EZ_KICK",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	GuildUninvite(playerrealmname) 
	if tContains(GuildManager.db.profile.GMDNIt, playerrealmname)==1 and GuildManager.db.profile.removefromdnil==true then
	GuildManager:tremovebyval(GuildManager.db.profile.GMDNIt, playerrealmname)
	GuildManager:Print(strjoin(" ",playerrealmname,"was removed from the Do Not Invite List"))
	end
	end,
	notCheckable = 1,
}

local BanButtonInfo = {
	text = "Ban from Guild",
	value = "EZ_BAN",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	GuildUninvite(playerrealmname)
	table.insert(GuildManager.db.profile.GMBlackt, playerrealmname)
	GMBlackt=GuildManager.db.profile.GMBlackt
	pairsByKeysBlack(GMBlackt)
	GuildManager:Print(strjoin(" ",playerrealmname,"was added to the Black List!"))
	if GuildManager.db.profile.pruneannounce==3 then
	SendChatMessage(strjoin(" ",playerrealmname,"has been banned from the guild. They will be autokicked if found on the roster."),"guild", nil,"GUILD")
	end
	if GuildManager.db.profile.pruneannounce==2 then
	SendChatMessage(strjoin(" ",playerrealmname,"has been banned from the guild. They will be autokicked if found on the roster."),"officer", nil,"OFFICER")
	end
	end,
	notCheckable = 1,
}

local PruneaddButtonInfo = {
	text = "Exempt from Pruning",
	value = "EZ_PRUNE",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	table.insert(GuildManager.db.profile.GMPruneExemptt, playerrealmname)
	GMPruneExemptt=GuildManager.db.profile.GMPruneExemptt
	pairsByKeysPruneExempt(GMPruneExemptt)
	GuildManager:Print(strjoin(" ",playerrealmname,"is no longer subject to Auto-Kicks. (Unless Blacklisted)"))
	end,
	notCheckable = 1,
}

local PruneremoveButtonInfo = {
	text = "Unexempt from Pruning",
	value = "EZ_PRUNEREM",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	GuildManager:tremovebyval(GuildManager.db.profile.GMPruneExemptt, playerrealmname)
	GuildManager:Print(strjoin(" ",playerrealmname,"is subject to Auto-Kicks."))
	end,
	notCheckable = 1,
}

local DemoteaddButtonInfo = {
	text = "Exempt from Demotion",
	value = "EZ_DEMOTE",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	table.insert(GuildManager.db.profile.GMDemoteExemptt, playerrealmname)
	GMDemoteExemptt=GuildManager.db.profile.GMDemoteExemptt
	pairsByKeysDemoteExempt(GMDemoteExemptt)
	GuildManager:Print(strjoin(" ",playerrealmname,"is no longer subject to Auto-Demotions."))
	end,
	notCheckable = 1,
}

local DemoteremoveButtonInfo = {
	text = "Unexempt from Demotion",
	value = "EZ_DEMOTEREM",
	func = function()
	if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
	playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
	else
	playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
	end
	GuildManager:tremovebyval(GuildManager.db.profile.GMDemoteExemptt, playerrealmname)
	GuildManager:Print(strjoin(" ",playerrealmname,"is subject to Auto-Demotions."))
	end,
	notCheckable = 1,
}

local CancelButtonInfo = {
	text = "Cancel",
	value = "EZ_CANCEL",
	notCheckable = 1
}

function EasyGInvCheck()
	if IsGuildLeader()==true or IsGuildLeader()~=true then		
		local PossibleButton = getglobal("DropDownList1Button"..(DropDownList1.numButtons)-1)
		if PossibleButton["value"] ~= "EZ_CANCEL" then	
			if (UIDROPDOWNMENU_MENU_LEVEL > 1) then return; end					
			local GoodUnit = false
			for i=1, #PopupUnits do
			if OPEN_DROPDOWNMENUS[1]["which"] == PopupUnits[i] then
				GoodUnit = true
				end
			end
														
			if UIDROPDOWNMENU_OPEN_MENU["unit"] == "target" and ((not UnitIsPlayer("target"))) then
				GoodUnit = false									
			end
			
			if GoodUnit then										
					CreateEasyGInvButton()		
			end
		end
	end
end

function CreateEasyGInvButton()
		local CancelButtonFrame = getglobal("DropDownList1Button"..DropDownList1.numButtons)
		CancelButtonFrame:Hide() 								
		DropDownList1.numButtons = DropDownList1.numButtons - 1		
		if string.match(UIDROPDOWNMENU_OPEN_MENU.name, "-") then
		playerrealmname = UIDROPDOWNMENU_OPEN_MENU.name;
		else
		playerrealmname = strjoin("-",UIDROPDOWNMENU_OPEN_MENU.name,GetRealmName());
		end
		GMRoster = {}
		for i=1,GetNumGuildMembers(true) do local name,_,_,_,_,_,note,officer = GetGuildRosterInfo(i);
		if string.match(name, "-") then
		else
		name = strjoin("-",name,GetRealmName());
		end
		table.insert(GMRoster, name)
		end
		CurrentPlayerName = GetUnitName("player")
		if string.match(CurrentPlayerName, "-") then
		else
		CurrentPlayerName = strjoin("-",CurrentPlayerName,GetRealmName())
		end
		if tContains(GMRoster, playerrealmname)~=1 and CurrentPlayerName~=playerrealmname then
		if tContains(GuildManager.db.profile.GMBlackt, playerrealmname)~=1 then
		if tContains(GuildManager.db.profile.GMDNIt, playerrealmname)~=1 then
		UIDropDownMenu_AddButton(GInvButtonInfo)
		end
		end
		if tContains(GuildManager.db.profile.GMDNIt, playerrealmname)~=1 then
		UIDropDownMenu_AddButton(DNILaddButtonInfo)
		else
		UIDropDownMenu_AddButton(DNILremoveButtonInfo)
		end
		if tContains(GuildManager.db.profile.GMBlackt, playerrealmname)~=1 then
		UIDropDownMenu_AddButton(BlackaddButtonInfo)
		else
		UIDropDownMenu_AddButton(BlackremoveButtonInfo)
		end
		elseif CurrentPlayerName~=playerrealmname then
		UIDropDownMenu_AddButton(KickButtonInfo)
		UIDropDownMenu_AddButton(BanButtonInfo)
		if tContains(GuildManager.db.profile.GMPruneExemptt, playerrealmname)~=1 then
		UIDropDownMenu_AddButton(PruneaddButtonInfo)
		else
		UIDropDownMenu_AddButton(PruneremoveButtonInfo)
		end
		if tContains(GuildManager.db.profile.GMDemoteExemptt, playerrealmname)~=1 then
		UIDropDownMenu_AddButton(DemoteaddButtonInfo)
		else
		UIDropDownMenu_AddButton(DemoteremoveButtonInfo)
		end
		else
		end
		UIDropDownMenu_AddButton(CancelButtonInfo) 
end

local function ChatCmd(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(GuildManager.optionsframe)
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(GuildManager, "gm", "GuildManager", input:trim() ~= "help" and input or "")
	end
end

GuildManager = LibStub("AceAddon-3.0"):NewAddon("GuildManager", "AceTimer-3.0", "AceEvent-3.0", "AceConsole-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceHook-3.0")
GuildManager:RegisterChatCommand("GuildManager", ChatCmd)
GuildManager:RegisterChatCommand("gm", ChatCmd)

local function SetLayout(this)
  dewdrop:Close()
  if not t1 then
    t1 = this:CreateFontString(nil, "ARTWORK")
    t1:SetFontObject(GameFontNormalLarge)
    t1:SetJustifyH("LEFT") 
    t1:SetJustifyV("TOP")
    t1:SetPoint("TOPLEFT", 16, -16)
    t1:SetText(this.name)


    local t2 = this:CreateFontString(nil, "ARTWORK")
    t2:SetFontObject(GameFontHighlightSmall)
    t2:SetJustifyH("LEFT") 
    t2:SetJustifyV("TOP")
    t2:SetHeight(43)
    t2:SetPoint("TOPLEFT", t1, "BOTTOMLEFT", 0, -8)
    t2:SetPoint("RIGHT", this, "RIGHT", -32, 0)
    t2:SetNonSpaceWrap(true)
    local function GetInfo(field)
      return GetAddOnMetadata(this.addon, field) or "N/A"
    end
    t2:SetFormattedText("Notes: %s\nAuthor: %s\nVersion: %s\nRevision: %s", GetInfo("Notes"), GetInfo("Author"), GetInfo("Version"), GetInfo("X-Build"))

    local b = CreateFrame("Button", nil, this, "UIPanelButtonTemplate")
    b:SetWidth(120)
    b:SetHeight(20)
    b:SetText("Options Menu")
    b:SetScript("OnClick", GuildManager.DewOptions)
    b:SetPoint("TOPLEFT", t2, "BOTTOMLEFT", -2, -8)
  end
end

function GuildManager:DewOptions()
	dewdrop:Open('dummy', 'children', function() dewdrop:FeedAceOptionsTable(options) end, 'cursorX', true, 'cursorY', true)
end

local function CreateUIOptionsFrame(addon) 
  local panel = CreateFrame("Frame")
  panel.name = GetAddOnMetadata(addon, "Title") or addon
  panel.addon = addon
  panel:SetScript("OnShow", SetLayout)
  InterfaceOptions_AddCategory(panel)
end

function GuildManager:ToggleActive(state)
	active = state
end

--Table Interfaces--
function GuildManager:IQUI()
local IQframe = GUI:Create("Frame")
IQframe:SetTitle("Invite Queue Control")
IQframe:SetCallback("OnClose", function(widget) GUI:Release(widget) end)
IQframe:SetWidth(350)
IQframe:SetHeight(200)
IQframe:SetLayout("Flow")

local addIQbutton = GUI:Create("Button")
addIQbutton:SetText("Add Name")
addIQbutton:SetWidth(150)
addIQbutton:SetCallback("OnClick", function()
if GMIQAddName~=nil then
if string.match(GMIQAddName, "-") then
else
GMIQAddName = strjoin("-",GMIQAddName,GetRealmName());
end
if tContains(GuildManager.db.profile.GMIQt, GMIQAddName)~=1 then
table.insert(GuildManager.db.profile.GMIQt, GMIQAddName)
GMIQt=GuildManager.db.profile.GMIQt
pairsByKeysIQ(GMIQt)
GuildManager:Print(strjoin(" ",GMIQAddName,"has been added to the Invite Queue"))
else
GuildManager:Print(strjoin(" ",GMIQAddName,"is on the Invite Queue. The list will update when the interface closes."))
end
else
GuildManager:Print("ERROR! You must type a name!")
end
end)
IQframe:AddChild(addIQbutton)

local addIQ = GUI:Create("EditBox")
addIQ:SetLabel("Insert Name:")
addIQ:SetWidth(150)
addIQ:SetCallback("OnEnterPressed", function(GMIQtext) 
for k,v in pairs(GMIQtext) do 
 if (k=="lasttext") then 
 GMIQAddName=v
 end
 end
end)
IQframe:AddChild(addIQ)

local removeIQbutton = GUI:Create("Button")
removeIQbutton:SetText("Remove Name")
removeIQbutton:SetWidth(150)
removeIQbutton:SetCallback("OnClick", function()
if GMIQChoice~=nil then
if tContains(GuildManager.db.profile.GMIQt, GMIQChoice)==1 then
GuildManager:Print(strjoin(" ",GMIQChoice,"was removed from the Invite Queue"))
GuildManager:tremovebyval(GuildManager.db.profile.GMIQt, GMIQChoice)
else
GuildManager:Print(strjoin(" ",GMIQChoice,"is not in the Invite Queue. The list will update when the interface closes."))
end
else
GuildManager:Print("ERROR! You must select a name!")
end
end)
IQframe:AddChild(removeIQbutton)

local IQDropDown = GUI:Create("Dropdown")
IQDropDown:SetList(GuildManager.db.profile.GMIQt)
IQDropDown:SetWidth(150)
IQDropDown:SetCallback("OnValueChanged", function(IQChoice)
 for k,v in pairs(IQChoice) do 
 if (k=="value") then 
 GMIQChoiceindex=v 
 end
 end
 for k,v in pairs(GuildManager.db.profile.GMIQt) do
 if GMIQChoiceindex==k then
 GMIQChoice=v
 end
 end
  end)
IQframe:AddChild(IQDropDown)

local purgeIQbutton = GUI:Create("Button")
purgeIQbutton:SetText("Purge List")
purgeIQbutton:SetWidth(150)
purgeIQbutton:SetCallback("OnClick", function()
if GuildManager.db.profile.GMIQt~={} then
GuildManager.db.profile.GMIQt = {}
GuildManager:Print("The Invite Queue has been purged")
else
GuildManager:Print("The Invite Queue is empty. It will update when the interface closes.")
end
end)
IQframe:AddChild(purgeIQbutton)

local inviteIQbutton = GUI:Create("Button")
inviteIQbutton:SetText("Invite!")
inviteIQbutton:SetWidth(150)
inviteIQbutton:SetCallback("OnClick", function()
if #(GuildManager.db.profile.GMIQt)~=0 then
for k,v in pairs(GuildManager.db.profile.GMIQt) do
if 1==k then
GMIQtop=v
if string.match(GMIQtop, "-") then
else
GMIQtop = strjoin("-",GMIQtop,GetRealmName());
end
if tContains(GuildManager.db.profile.GMDNIt, GMIQtop)~=1 then
table.insert(GuildManager.db.profile.GMDNIt, GMIQtop)
GMDNIt=GuildManager.db.profile.GMDNIt
pairsByKeysDNI(GMDNIt)
end
 end
 end
if GuildManager.db.profile.whisperonly==false then
GuildInvite(GMIQtop)
else
SendChatMessage(GuildManager.db.profile.whispmessage,"WHISPER",nil,GMIQtop)
end
GuildManager:tremovebyval(GuildManager.db.profile.GMIQt, GMIQtop)
else
GuildManager:Print("The Invitation Queue is Empty!")
end
end)
IQframe:AddChild(inviteIQbutton)
end

function GuildManager:DNIUI()
local DNIframe = GUI:Create("Frame")
DNIframe:SetTitle("Do Not Invite List Control")
DNIframe:SetCallback("OnClose", function(widget) GUI:Release(widget) end)
DNIframe:SetWidth(350)
DNIframe:SetHeight(200)
DNIframe:SetLayout("Flow")

local addDNIbutton = GUI:Create("Button")
addDNIbutton:SetText("Add Name")
addDNIbutton:SetWidth(150)
addDNIbutton:SetCallback("OnClick", function()
if GMDNIAddName~=nil then
if string.match(GMDNIAddName, "-") then
else
GMDNIAddName = strjoin("-",GMDNIAddName,GetRealmName());
end
if tContains(GuildManager.db.profile.GMDNIt, GMDNIAddName)~=1 then
table.insert(GuildManager.db.profile.GMDNIt, GMDNIAddName)
GMDNIt=GuildManager.db.profile.GMDNIt
pairsByKeysDNI(GMDNIt)
GuildManager:Print(strjoin(" ",GMDNIAddName,"has been added to the Do Not Invite List."))
else
GuildManager:Print(strjoin(" ",GMDNIAddName,"is on the Do Not Invite List. The list will update when the interface closes."))
end
else
GuildManager:Print("ERROR! You must type a name!")
end
end)
DNIframe:AddChild(addDNIbutton)

local addDNI = GUI:Create("EditBox")
addDNI:SetLabel("Insert Name:")
addDNI:SetWidth(150)
addDNI:SetCallback("OnEnterPressed", function(GMDNItext) 
for k,v in pairs(GMDNItext) do 
 if (k=="lasttext") then 
 GMDNIAddName=v
 end
 end
end)
DNIframe:AddChild(addDNI)

local purgeDNIbutton = GUI:Create("Button")
purgeDNIbutton:SetText("Purge List")
purgeDNIbutton:SetWidth(150)
purgeDNIbutton:SetCallback("OnClick", function()
if GuildManager.db.profile.GMDNIt~={} then
GuildManager.db.profile.GMDNIt = {}
GuildManager:Print("The Do Not Invite List has been purged")
else
GuildManager:Print("The Do Not Invite List is empty. It will update when the interface closes.")
end
end)
DNIframe:AddChild(purgeDNIbutton)
end

function GuildManager:BlackUI()
local Blackframe = GUI:Create("Frame")
Blackframe:SetTitle("Black List Control")
Blackframe:SetCallback("OnClose", function(widget) GUI:Release(widget) end)
Blackframe:SetWidth(350)
Blackframe:SetHeight(200)
Blackframe:SetLayout("Flow")

local addBlackbutton = GUI:Create("Button")
addBlackbutton:SetText("Add Name")
addBlackbutton:SetWidth(150)
addBlackbutton:SetCallback("OnClick", function()
if GMBlackAddName~=nil then
if string.match(GMBlackAddName, "-") then
else
GMBlackAddName = strjoin("-",GMBlackAddName,GetRealmName());
end
if tContains(GuildManager.db.profile.GMBlackt, GMBlackAddName)~=1 then
table.insert(GuildManager.db.profile.GMBlackt, GMBlackAddName)
GMBlackt=GuildManager.db.profile.GMBlackt
pairsByKeysBlack(GMBlackt)
GuildManager:Print(strjoin(" ",GMBlackAddName,"has been added to the Black List."))
if GuildManager.db.profile.pruneannounce==3 then
SendChatMessage(strjoin(" ",GMBlackAddName,"has been added to the Black List and Banned from the guild! They will be autokicked if invited back!"),"guild", nil,"GUILD")
end
if GuildManager.db.profile.pruneannounce==2 then
SendChatMessage(strjoin(" ",GMBlackAddName,"has been added to the Black List and Banned from the guild! They will be autokicked if invited back!"),"officer", nil,"OFFICER")
end
else
GuildManager:Print(strjoin(" ",GMBlackAddName,"is on the Black List. The list will update when the interface closes."))
end
else
GuildManager:Print("ERROR! You must type a name!")
end
end)
Blackframe:AddChild(addBlackbutton)

local addBlack = GUI:Create("EditBox")
addBlack:SetLabel("Insert Name:")
addBlack:SetWidth(150)
addBlack:SetCallback("OnEnterPressed", function(GMBlacktext) 
for k,v in pairs(GMBlacktext) do 
 if (k=="lasttext") then 
 GMBlackAddName=v
 end
 end
end)
Blackframe:AddChild(addBlack)

local removeBlackbutton = GUI:Create("Button")
removeBlackbutton:SetText("Remove Name")
removeBlackbutton:SetWidth(150)
removeBlackbutton:SetCallback("OnClick", function()
if GMBlackChoice~=nil then
if tContains(GuildManager.db.profile.GMBlackt, GMBlackChoice)==1 then
GuildManager:Print(strjoin(" ",GMBlackChoice,"was removed from the Black List"))
if GuildManager.db.profile.pruneannounce==3 then
SendChatMessage(strjoin(" ",GMBlackChoice,"has been removed from the Black List and is no longer Banned from the guild!"),"guild", nil,"GUILD")
end
if GuildManager.db.profile.pruneannounce==2 then
SendChatMessage(strjoin(" ",GMBlackChoice,"has been removed from the Black List and is no longer Banned from the guild!"),"officer", nil,"OFFICER")
end
GuildManager:tremovebyval(GuildManager.db.profile.GMBlackt, GMBlackChoice)
else
GuildManager:Print(strjoin(" ",GMBlackChoice,"is not on the Black List. The list will update when the interface closes."))
end
else
GuildManager:Print("ERROR! You must select a name!")
end
end)
Blackframe:AddChild(removeBlackbutton)

local BlackDropDown = GUI:Create("Dropdown")
BlackDropDown:SetList(GuildManager.db.profile.GMBlackt)
BlackDropDown:SetWidth(150)
BlackDropDown:SetCallback("OnValueChanged", function(BlackChoice)
 for k,v in pairs(BlackChoice) do 
 if (k=="value") then 
 GMBlackChoiceindex=v 
 end
 end
 for k,v in pairs(GuildManager.db.profile.GMBlackt) do
 if GMBlackChoiceindex==k then
 GMBlackChoice=v
 end
 end
  end)
Blackframe:AddChild(BlackDropDown)

local purgeBlackbutton = GUI:Create("Button")
purgeBlackbutton:SetText("Purge List")
purgeBlackbutton:SetWidth(150)
purgeBlackbutton:SetCallback("OnClick", function()
if GuildManager.db.profile.GMBlackt~={} then
GuildManager.db.profile.GMBlackt = {}
GuildManager:Print("The Black List has been purged")
else
GuildManager:Print("The Black List is empty. It will update when the interface closes.")
end
end)
Blackframe:AddChild(purgeBlackbutton)
end

function GuildManager:PruneExemptUI()
local PruneExemptframe = GUI:Create("Frame")
PruneExemptframe:SetTitle("Prune Exemption List Control")
PruneExemptframe:SetCallback("OnClose", function(widget) GUI:Release(widget) end)
PruneExemptframe:SetWidth(350)
PruneExemptframe:SetHeight(200)
PruneExemptframe:SetLayout("Flow")

local addPruneExemptbutton = GUI:Create("Button")
addPruneExemptbutton:SetText("Add Name")
addPruneExemptbutton:SetWidth(150)
addPruneExemptbutton:SetCallback("OnClick", function()
if GMPruneExemptAddName~=nil then
if string.match(GMPruneExemptAddName, "-") then
else
GMPruneExemptAddName = strjoin("-",GMPruneExemptAddName,GetRealmName());
end
if tContains(GuildManager.db.profile.GMPruneExemptt, GMPruneExemptAddName)~=1 then
table.insert(GuildManager.db.profile.GMPruneExemptt, GMPruneExemptAddName)
GMPruneExemptt=GuildManager.db.profile.GMPruneExemptt
pairsByKeysPruneExempt(GMPruneExemptt)
GuildManager:Print(strjoin(" ",GMPruneExemptAddName,"has been added to the Prune Exemption List."))
else
GuildManager:Print(strjoin(" ",GMPruneExemptAddName,"is on the Prune Exemption List. The list will update when the interface closes."))
end
else
GuildManager:Print("ERROR! You must type a name!")
end
end)
PruneExemptframe:AddChild(addPruneExemptbutton)

local addPruneExempt = GUI:Create("EditBox")
addPruneExempt:SetLabel("Insert Name:")
addPruneExempt:SetWidth(150)
addPruneExempt:SetCallback("OnEnterPressed", function(GMPruneExempttext) 
for k,v in pairs(GMPruneExempttext) do 
 if (k=="lasttext") then 
 GMPruneExemptAddName=v
 end
 end
end)
PruneExemptframe:AddChild(addPruneExempt)

local removePruneExemptbutton = GUI:Create("Button")
removePruneExemptbutton:SetText("Remove Name")
removePruneExemptbutton:SetWidth(150)
removePruneExemptbutton:SetCallback("OnClick", function()
if GMPruneExemptChoice~=nil then
if tContains(GuildManager.db.profile.GMPruneExemptt, GMPruneExemptChoice)==1 then
GuildManager:Print(strjoin(" ",GMPruneExemptChoice,"was removed from the Prune Exemption List"))
GuildManager:tremovebyval(GuildManager.db.profile.GMPruneExemptt, GMPruneExemptChoice)
else
GuildManager:Print(strjoin(" ",GMPruneExemptChoice,"is not on the Prune Exemption List. The list will update when the interface closes."))
end
else
GuildManager:Print("ERROR! You must select a name!")
end
end)
PruneExemptframe:AddChild(removePruneExemptbutton)

local PruneExemptDropDown = GUI:Create("Dropdown")
PruneExemptDropDown:SetList(GuildManager.db.profile.GMPruneExemptt)
PruneExemptDropDown:SetWidth(150)
PruneExemptDropDown:SetCallback("OnValueChanged", function(PruneExemptChoice)
 for k,v in pairs(PruneExemptChoice) do 
 if (k=="value") then 
 GMPruneExemptChoiceindex=v 
 end
 end
 for k,v in pairs(GuildManager.db.profile.GMPruneExemptt) do
 if GMPruneExemptChoiceindex==k then
 GMPruneExemptChoice=v
 end
 end
  end)
PruneExemptframe:AddChild(PruneExemptDropDown)

local purgePruneExemptbutton = GUI:Create("Button")
purgePruneExemptbutton:SetText("Purge List")
purgePruneExemptbutton:SetWidth(150)
purgePruneExemptbutton:SetCallback("OnClick", function()
if GuildManager.db.profile.GMPruneExemptt~={} then
GuildManager.db.profile.GMPruneExemptt = {}
GuildManager:Print("The Prune Exemption List has been purged")
else
GuildManager:Print("The Prune Exemption List is empty. It will update when the interface closes.")
end
end)
PruneExemptframe:AddChild(purgePruneExemptbutton)
end

function GuildManager:DemoteExemptUI()
local DemoteExemptframe = GUI:Create("Frame")
DemoteExemptframe:SetTitle("Demote Exemption List Control")
DemoteExemptframe:SetCallback("OnClose", function(widget) GUI:Release(widget) end)
DemoteExemptframe:SetWidth(350)
DemoteExemptframe:SetHeight(200)
DemoteExemptframe:SetLayout("Flow")

local addDemoteExemptbutton = GUI:Create("Button")
addDemoteExemptbutton:SetText("Add Name")
addDemoteExemptbutton:SetWidth(150)
addDemoteExemptbutton:SetCallback("OnClick", function()
if GMDemoteExemptAddName~=nil then
if string.match(GMDemoteExemptAddName, "-") then
else
GMDemoteExemptAddName = strjoin("-",GMDemoteExemptAddName,GetRealmName());
end
if tContains(GuildManager.db.profile.GMDemoteExemptt, GMDemoteExemptAddName)~=1 then
table.insert(GuildManager.db.profile.GMDemoteExemptt, GMDemoteExemptAddName)
GMDemoteExemptt=GuildManager.db.profile.GMDemoteExemptt
pairsByKeysDemoteExempt(GMDemoteExemptt)
GuildManager:Print(strjoin(" ",GMDemoteExemptAddName,"has been added to the Demote Exemption List."))
else
GuildManager:Print(strjoin(" ",GMDemoteExemptAddName,"is on the Demote Exemption List. The list will update when the interface closes."))
end
else
GuildManager:Print("ERROR! You must type a name!")
end
end)
DemoteExemptframe:AddChild(addDemoteExemptbutton)

local addDemoteExempt = GUI:Create("EditBox")
addDemoteExempt:SetLabel("Insert Name:")
addDemoteExempt:SetWidth(150)
addDemoteExempt:SetCallback("OnEnterPressed", function(GMDemoteExempttext) 
for k,v in pairs(GMDemoteExempttext) do 
 if (k=="lasttext") then 
 GMDemoteExemptAddName=v
 end
 end
end)
DemoteExemptframe:AddChild(addDemoteExempt)

local removeDemoteExemptbutton = GUI:Create("Button")
removeDemoteExemptbutton:SetText("Remove Name")
removeDemoteExemptbutton:SetWidth(150)
removeDemoteExemptbutton:SetCallback("OnClick", function()
if GMDemoteExemptChoice~=nil then
if tContains(GuildManager.db.profile.GMDemoteExemptt, GMDemoteExemptChoice)==1 then
GuildManager:Print(strjoin(" ",GMDemoteExemptChoice,"was removed from the Demote Exemption List"))
GuildManager:tremovebyval(GuildManager.db.profile.GMDemoteExemptt, GMDemoteExemptChoice)
else
GuildManager:Print(strjoin(" ",GMDemoteExemptChoice,"is not on the Demote Exemption List. The list will update when the interface closes."))
end
else
GuildManager:Print("ERROR! You must select a name!")
end
end)
DemoteExemptframe:AddChild(removeDemoteExemptbutton)

local DemoteExemptDropDown = GUI:Create("Dropdown")
DemoteExemptDropDown:SetList(GuildManager.db.profile.GMDemoteExemptt)
DemoteExemptDropDown:SetWidth(150)
DemoteExemptDropDown:SetCallback("OnValueChanged", function(DemoteExemptChoice)
 for k,v in pairs(DemoteExemptChoice) do 
 if (k=="value") then 
 GMDemoteExemptChoiceindex=v 
 end
 end
 for k,v in pairs(GuildManager.db.profile.GMDemoteExemptt) do
 if GMDemoteExemptChoiceindex==k then
 GMDemoteExemptChoice=v
 end
 end
  end)
DemoteExemptframe:AddChild(DemoteExemptDropDown)

local purgeDemoteExemptbutton = GUI:Create("Button")
purgeDemoteExemptbutton:SetText("Purge List")
purgeDemoteExemptbutton:SetWidth(150)
purgeDemoteExemptbutton:SetCallback("OnClick", function()
if GuildManager.db.profile.GMDemoteExemptt~={} then
GuildManager.db.profile.GMDemoteExemptt = {}
GuildManager:Print("The Demote Exemption List has been purged")
else
GuildManager:Print("The Demote Exemption List is empty. It will update when the interface closes.")
end
end)
DemoteExemptframe:AddChild(purgeDemoteExemptbutton)
end

--Table Sorters--
function pairsByKeysIQ(GMIQt)
	local GMIQtsort = {}
		for k,v in pairs(GMIQt) do table.insert(GMIQtsort, v) end
		table.sort(GMIQtsort)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if GMIQtsort[i] == nil then return nil
			else return GMIQtsort[i], t[GMIQtsort[i]]
			end
		end
		GuildManager.db.profile.GMIQt=GMIQtsort
end

function pairsByKeysDNI(GMDNIt)
	local GMDNItsort = {}
		for k,v in pairs(GMDNIt) do table.insert(GMDNItsort, v) end
		table.sort(GMDNItsort)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if GMDNItsort[i] == nil then return nil
			else return GMDNItsort[i], t[GMDNItsort[i]]
			end
		end
		GuildManager.db.profile.GMDNIt=GMDNItsort
end

function pairsByKeysBlack(GMBlackt)
	local GMBlacktsort = {}
		for k,v in pairs(GMBlackt) do table.insert(GMBlacktsort, v) end
		table.sort(GMBlacktsort)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if GMBlacktsort[i] == nil then return nil
			else return GMBlacktsort[i], t[GMBlacktsort[i]]
			end
		end
		GuildManager.db.profile.GMBlackt=GMBlacktsort
end

function pairsByKeysPruneExempt(GMPruneExemptt)
	local GMPruneExempttsort = {}
		for k,v in pairs(GMPruneExemptt) do table.insert(GMPruneExempttsort, v) end
		table.sort(GMPruneExempttsort)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if GMPruneExempttsort[i] == nil then return nil
			else return GMPruneExempttsort[i], t[GMPruneExempttsort[i]]
			end
		end
		GuildManager.db.profile.GMPruneExemptt=GMPruneExempttsort
end

function pairsByKeysDemoteExempt(GMDemoteExemptt)
	local GMDemoteExempttsort = {}
		for k,v in pairs(GMDemoteExemptt) do table.insert(GMDemoteExempttsort, v) end
		table.sort(GMDemoteExempttsort)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if GMDemoteExempttsort[i] == nil then return nil
			else return GMDemoteExempttsort[i], t[GMDemoteExempttsort[i]]
			end
		end
		GuildManager.db.profile.GMDemoteExemptt=GMDemoteExempttsort
end

function GuildManager:tremovebyval(tab, val)
   for k,v in pairs(tab) do
     if(v==val) then
       table.remove(tab, k)
       return true
     end
   end
   return false
 end
 
 function Cleantables()
	uncleanGMIQt = GuildManager.db.profile.GMIQt
	cleanGMIQt = {}
	table.foreach(uncleanGMIQt,function(k,v) 
		if string.match(v,"-") then
			table.insert(cleanGMIQt,v)
		else
			newv = strjoin("-",v,GetRealmName())
			table.insert(cleanGMIQt,newv)
		end
 end)
	GuildManager.db.profile.GMIQt = cleanGMIQt
	
	uncleanGMDNIt = GuildManager.db.profile.GMDNIt
	cleanGMDNIt = {}
	table.foreach(uncleanGMDNIt,function(k,v) 
		if string.match(v,"-") then
			table.insert(cleanGMDNIt,v)
		else
			newv = strjoin("-",v,GetRealmName())
			table.insert(cleanGMDNIt,newv)
		end
 end)
	GuildManager.db.profile.GMDNIt = cleanGMDNIt
	
	uncleanGMBlackt = GuildManager.db.profile.GMBlackt
	cleanGMBlackt = {}
	table.foreach(uncleanGMBlackt,function(k,v) 
		if string.match(v,"-") then
			table.insert(cleanGMBlackt,v)
		else
			newv = strjoin("-",v,GetRealmName())
			table.insert(cleanGMBlackt,newv)
		end
 end)
	GuildManager.db.profile.GMBlackt = cleanGMBlackt
	
	uncleanGMPruneExemptt = GuildManager.db.profile.GMPruneExemptt
	cleanGMPruneExemptt = {}
	table.foreach(uncleanGMPruneExemptt,function(k,v) 
		if string.match(v,"-") then
			table.insert(cleanGMPruneExemptt,v)
		else
			newv = strjoin("-",v,GetRealmName())
			table.insert(cleanGMPruneExemptt,newv)
		end
 end)
	GuildManager.db.profile.GMPruneExemptt = cleanGMPruneExemptt
	
	uncleanGMDemoteExemptt = GuildManager.db.profile.GMDemoteExemptt
	cleanGMDemoteExemptt = {}
	table.foreach(uncleanGMDemoteExemptt,function(k,v) 
		if string.match(v,"-") then
			table.insert(cleanGMDemoteExemptt,v)
		else
			newv = strjoin("-",v,GetRealmName())
			table.insert(cleanGMDemoteExemptt,newv)
		end
 end)
	GuildManager.db.profile.GMDemoteExemptt = cleanGMDemoteExemptt
 end

--Setup functions--
function GuildManager:GetGuildName()
	local guildName, guildRankName, guildRankIndex = GetGuildInfo("player")
	return guildName
 end

function GuildManager:OnInitialize()
	GuildRoster()
	GuildNameTest=GuildManager:GetGuildName()
    GuildManager.db = LibStub("AceDB-3.0"):New("GuildManagerDB", {}, "Default")
    GuildManager.db:RegisterDefaults({
        profile = {
            lasttime = {},
            guild = "",
			active = true,
			cityspam = false,
			zonespam = false,
			outpvpspam = false,
			between = 15,
			message = "",
			citychannel = 2,
			zonechannel = 1,
			whisperinvite = false,
			whisperonly = false,
			atuomatewho = false,
			sendginvite = false,
			targetclass = false,
			whispmessage = "",
			minlevel = 20,
			maxlevel = 110,
			DKsearch = false,
			DHsearch = false,
			Druidsearch = false,
			Huntersearch = false,
			Magesearch = false,
			Monksearch = false,
			Paladinsearch = false,
			Priestsearch = false,
			Roguesearch = false,
			Shamansearch = false,
			Warlocksearch = false,
			Warriorsearch = false,
			membercap = 1000,
			welcomeannounce = 1,
			welcomewhisp = "",
			declinewhisp = "",
			removeinactive = false,
			removelevels = false,
			automateprune = false,
			daysinactive = 365,
			levelthreshold = 1,
			pruneannounce = 1,
			exemptalt = false,
			exemptranks = false,
			removefromdnil = false,
			exemptrank1 = false,
			exemptrank2 = false,
			exemptrank3 = false,
			exemptrank4 = false,
			exemptrank5 = false,
			exemptrank6 = false,
			exemptrank7 = false,
			exemptrank8 = false,
			exemptrank9 = false,
			automatepromote = false,
			demotemode = false,
			promoteannounce = 1,
			promotelevel = false,
			rank1promotesearch = false,
			rank2promotesearch = false,
			rank3promotesearch = false,
			rank4promotesearch = false,
			rank5promotesearch = false,
			rank6promotesearch = false,
			rank7promotesearch = false,
			rank8promotesearch = false,
			rank9promotesearch = false,
			rank1promote = false,
			rank2promote = false,
			rank3promote = false,
			rank4promote = false,
			rank5promote = false,
			rank6promote = false,
			rank7promote = false,
			rank8promote = false,
			rank1level = 111,
			rank2level = 111,
			rank3level = 111,
			rank4level = 111,
			rank5level = 111,
			rank6level = 111,
			rank7level = 111,
			rank8level = 111,
			announcement1 = "",
			announcementtimer1 = 60,
			announcementto1 = 1,
			announcementborder1 = 1,
			announcement2 = "",
			announcementtimer2 = 60,
			announcementto2 = 1,
			announcementborder2 = 1,
			announcement3 = "",
			announcementtimer3 = 60,
			announcementto3 = 1,
			announcementborder3 = 1,
			announcement4 = "",
			announcementtimer4 = 60,
			announcementto4 = 1,
			announcementborder4 = 1,
			announcement5 = "",
			announcementtimer5 = 60,
			announcementto5 = 1,
			announcementborder5 = 1,
			nextannouncemessage = "",
			nextannouncetime = 0,
			nextannouncechannel = 1,
			nextannounceborder = 1,
			lastannounced = 0,
			announcenext = 0,
			lastanntime = 0,
			GMPruneExemptt = {},
			GMDemoteExemptt = {},
			GMBlackt = {},
			GMDNIt = {},
			GMIQt = {},
			CurrentGuildLeader = "",
        },
    })
	if not GuildManager.version then GuildManager.version = tonumber(GetAddOnMetadata("GuildManager", "X-Build")) end
    GuildManager.optionsframe = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GuildManager", "Guild Manager")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GuildManager", options)
	if (GuildManager.db.profile.version ~= GuildManager.version) then 
		GuildManager.db.profile.lasttime = {}
		GuildManager.db.profile.version = GuildManager.version
	end		
	active = GuildManager.db.profile.active
end

function GuildManager:OnEnable()
	GuildRoster()
	if GuildManager:GetGuildName()~=nil then
	GuildManager.db:SetProfile(strjoin("","<",GuildManager:GetGuildName(),">"," of ",GetRealmName()))
	else
	GuildManager.db:SetProfile("Default")
	end
	if GuildManager:GetGuildName() == nil then
		GuildManager:ScheduleTimer("OnEnable", .1)
		return
	end
	GuildManager:TurnSelfOn()
end

function GuildManager:TurnSelfOn()
	GuildManager:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	if IsGuildLeader()==false then
	GMDoesNotQualifyNotice = false
	GMFailedNotice = false
	GuildManager:ScheduleRepeatingTimer("ReplaceGM", 1)
	GuildManager:Print("Guild Manager detects that you are not the Guild Master. Guild Manager will check to see if you qualify to be the Guild Master every second. If so that power will be transferred to you.")
	else
	GuildManager:ScheduleRepeatingTimer("MasterTimer", 30)
	GuildManager:Print("Loaded and Fully Operational! Type /guildmanager to manage your options. NOTE: You will need to create a macro or modify your macros by adding '/run GuildManager:InviteAction()' to each one. This is the ONLY way to get Toon Recruitment to work. See documentation on Curse or in the GuildManager addon folder for additional details.")
	end
	Cleantables()
end

function GuildManager:ReplaceGM()
	if GuildMasterAbsent()~=false or CanReplaceGuildMaster()~=false then
		if CanReplaceGuildMaster()==false then
			ReplaceGuildMaster()
			if IsGuildLeader()==false then
				if GMDoesNotQualifyNotice==false then
					GuildManager:Print("ATTENTION! The Guild Master is declared absent but you cannot take control of the guild. Guild Manager will notify you once it can take control.")
					GMDoesNotQualifyNotice = true
				end
			else
				GuildManager:CancelAllTimers()
				GuildManager:Print("ATTENTION! Guild Manager has transferred control of the guild to you.")
				GuildManager:ScheduleRepeatingTimer("MasterTimer", 30)
			end
		else
			ReplaceGuildMaster()
			if IsGuildLeader()==false then
				if GMFailedNotice==false then
					GuildManager:Print("ATTENTION! The Guild Master is declared absent and Guild Manager attempted to take control but failed. Guild Manager will notify you once it can take control.")
					GMFailedNotice = true
				end
			else
				GuildManager:CancelAllTimers()
				GuildManager:Print("ATTENTION! Guild Manager has transferred control of the guild to you.")
				GuildManager:ScheduleRepeatingTimer("MasterTimer", 30)
			end
		end
	end
	ReplaceGuildMaster()
	if IsGuildLeader()~=false then
		GuildManager:CancelAllTimers()
		GuildManager:Print("ATTENTION! Guild Manager has transferred control of the guild to you.")
		GuildManager:ScheduleRepeatingTimer("MasterTimer", 30)
	end
end

--Automation Functions--
function GuildManager:GetTime()
	local hours,minutes = GetGameTime()
	local _, m, d, y = CalendarGetDate()
	return ((d + math.floor( ( 153*m - 457 ) / 5 ) + 365*y + math.floor( y / 4 ) - math.floor( y / 100 ) + math.floor( y / 400 ) + 1721118.5) * 1440) +(hours*60)+(minutes)
end

function GuildManager:MasterTimer()
if GuildManager.db.profile.automateprune==true then
GuildManager:GKRun()--Pruning
end
if GuildManager.db.profile.automatepromote==true then
GuildManager:ScheduleTimer("GMPromoteErrorChecking", 5)
end
GuildManager:ScheduleTimer("RunAnnouncemnts", 10)
GuildManager:ScheduleTimer("CheckZone", 15)
if GuildManager.db.profile.automatewho==true and (WhoCycle==0 or WhoCycle==nil) and GetNumGuildMembers()<=999 and GuildManager.db.profile.membercap>GetNumGuildMembers() then
GuildManager:ScheduleTimer("RunWhoSearch", 20)
end
end

--Registered Event Functions--
local GMframe = CreateFrame("FRAME", "GuildManager");
GMframe:RegisterEvent("CHAT_MSG_SYSTEM");
GMframe:RegisterEvent("ADDON_LOADED");
local function GMWelcome(self, event, ...)
	if event == "CHAT_MSG_SYSTEM" then 
		local msg = ...;
		local PlayerName, PlayerRealm = UnitName("Player")
		if (msg and msg ~= nil) then
			if ((string.find(msg, "has joined the guild") ~= nil)) then
				starts, ends = string.find(msg," ")
				args1 = string.sub(msg, 0, starts-1)
				if (args1 ~= UnitName("player"))then
				if GuildManager.db.profile.welcomeannounce==3 then
				SendChatMessage(strjoin(" ","Please welcome our newest member",args1), "GUILD", nil, arg2);
				end
				if GuildManager.db.profile.welcomeannounce==2 then
				SendChatMessage(strjoin(" ","Please welcome our newest member",args1), "OFFICER", nil, arg2);
				end
				SendChatMessage(GuildManager.db.profile.welcomewhisp,"WHISPER",nil,args1) 
				end
				end
			if ((string.find(msg, strjoin("",PlayerName," has joined the guild"))==1)) then
				GuildManager.db:SetProfile(strjoin("","<",GuildManager:GetGuildName(),">"," of ",GetRealmName()))
				GuildManager:RegisterMyToons()
				end
			if ((string.find(msg, strjoin("",PlayerName," has left the guild"))==1)) or ((string.find(msg, strjoin("",PlayerName," has been kicked out of the guild by"))==1)) then
				GuildManager.db:SetProfile("Default")
				end
			if ((string.find(msg, '" not found.') ~= nil)) then
				starts, ends = string.find(msg," ")
				args1 = string.sub(msg, 2, -13)
				if (args1 ~= UnitName("player"))then
				if tContains(GuildManager.db.profile.GMDNIt, args1)==1 then
				GuildManager:tremovebyval(GuildManager.db.profile.GMDNIt, args1)
				GuildManager:Print(strjoin(" ",args1,"could not be found and was removed from the Do Not Invite List!"))
				end
				end
				end
			if ((string.find(msg, "declines your guild invitation.") ~= nil)) then
				starts, ends = string.find(msg," ")
				args1 = string.sub(msg, 0, -33)
				if (args1 ~= UnitName("player"))then
				SendChatMessage(GuildManager.db.profile.declinewhisp,"WHISPER",nil,args1) 
				end
				end
			if ((string.find(msg, "is declining all guild invitations") ~= nil)) then
				starts, ends = string.find(msg," ")
				args1 = string.sub(msg, 0, starts-1)
				if (args1 ~= UnitName("player"))then
				SendChatMessage(GuildManager.db.profile.declinewhisp,"WHISPER",nil,args1) 
				end
				end
				--You have invited xxxx to join your guild.
				--123456789012345678  123456789012345678901
			if ((string.find(msg, "You have invited") ~= nil)) and ((string.find(msg, "to join your guild.") ~= nil)) then
				args1 = string.sub(msg, 18, -21)
				if (args1 ~= UnitName("player"))then
				SendChatMessage(GuildManager.db.profile.whispmessage,"WHISPER",nil,args1)
				end
				end
			end
		end	
	end	
GMframe:SetScript("OnEvent", GMWelcome);

--*RECRUITMENT*--
local f = CreateFrame("frame")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:SetScript("OnEvent", function(self,event,arg1,arg2)
if string.match(arg2, "-") then
else
arg2 = strjoin("-",arg2,GetRealmName());
end
if IsGuildLeader()==true or IsGuildLeader()~=true then
if GetNumGuildMembers()<=999 and GuildManager.db.profile.membercap>GetNumGuildMembers() and arg1:lower():match("lf guild") and GuildManager.db.profile.whisperinvite==true then
    if tContains(GuildManager.db.profile.GMBlackt, arg2)~=1 then
        if tContains(GuildManager.db.profile.GMIQt, arg2)~=1 then
			table.insert(GuildManager.db.profile.GMIQt, arg2)
			GMIQt=GuildManager.db.profile.GMIQt
			pairsByKeysIQ(GMIQt)
			end
        SendChatMessage("Added to Invite Queue. If you do not get an invite shortly it may be because you are already in a guild, on a trial account or you are incorrectly flagged as being in a guild. If you think it is the last reason, log out and back in then try again!","WHISPER",nil,arg2) 
    else
        SendChatMessage("Invitation Denied! You are currently banned from this guild!","WHISPER",nil,arg2)
    end
    elseif (GetNumGuildMembers()>=1000 or GuildManager.db.profile.membercap<=GetNumGuildMembers()) and arg1:lower():match("lf guild") and GuildManager.db.profile.whisperinvite==true then
    SendChatMessage("Invitation Denied! The guild is currently full!","WHISPER",nil,arg2)
    end
    end
end)

--Zone Recruitment Functions--
function GuildManager:CHAT_MSG_CHANNEL_NOTICE(what, a, b, c, d, e, f, number, channel)
GuildManager:ScheduleTimer("CheckZone", 5)
end
function GuildManager:CheckZone()
if GetNumGuildMembers()<=999 and GuildManager.db.profile.membercap>GetNumGuildMembers() then
local inInstance, instanceType = IsInInstance()
if inInstance==nil then
if (GuildManager:IsCity())==true then
GMzone="City"
elseif (GuildManager:IsCity())~=true then
GMzone=(GetZoneText())
end
end
if GMzone=="City" and GuildManager.db.profile.cityspam==true then
GuildManager:CheckTime(GMzone)
end
if GMzone~="City" and GuildManager.db.profile.zonespam==true then
if GetZonePVPInfo()~="combat" then
GuildManager:CheckTime(GMzone)
end
if GetZonePVPInfo()=="Combat" and GuildManager.db.profile.outpvpspam==true then
GuildManager:CheckTime(GMzone)
end
end
end
end


function GuildManager:IsCity()
if (GetZoneText())=="Stormwind City" then
return true
elseif (GetZoneText())=="Darnassus" then
return true
elseif (GetZoneText())=="City of Ironforge" then
return true
elseif (GetZoneText())=="The Exodar" then
return true
elseif (GetZoneText())=="Shrine of Seven Stars" then
return true
elseif (GetZoneText())=="Stormshield" then
return true
elseif (GetZoneText())=="Lunarfall" then
return true
elseif (GetZoneText())=="Orgrimmar" then
return true
elseif (GetZoneText())=="Thunder Bluff" then
return true
elseif (GetZoneText())=="Undercity" then
return true
elseif (GetZoneText())=="Silvermoon City" then
return true
elseif (GetZoneText())=="Shrine of Two Moons" then
return true
elseif (GetZoneText())=="Warspear" then
return true
elseif (GetZoneText())=="Frostwall" then
return true
elseif (GetZoneText())=="Dalaran" then
return true
elseif (GetZoneText())=="Shattrath City" then
return true
else
return false
end
end

function GuildManager:CheckTime(GMzone)
if GMzone==nil then
	if (GuildManager:IsCity())==true then
	GMzone="City"
	elseif (GuildManager:IsCity())~=true then
	GMzone=(GetZoneText())
	end
end
if GuildManager.db.profile.lasttime[GMzone]==nil then 
GuildManager.db.profile.lasttime[GMzone]=0
end 
timediffspam=(GuildManager:GetTime())-GuildManager.db.profile.lasttime[GMzone]
if timediffspam>=GuildManager.db.profile.between then
GuildManager:SpamZone(GMzone)
end
end
 
function GuildManager:SpamZone(GMzone)
if GMzone=="City" then 
number=GuildManager.db.profile.citychannel
else 
number=GuildManager.db.profile.zonechannel
end
SendChatMessage(GuildManager.db.profile.message,"CHANNEL",nil,number)
GuildManager.db.profile.lasttime[GMzone]=GuildManager:GetTime() 
end

--Character Recruitment Functions--
function GuildManager:RunWhoSearch()
if IsGuildLeader()==true or IsGuildLeader()~=true then
if GuildManager.db.profile.targetclass==true and GuildManager.db.profile.DKsearch==false and GuildManager.db.profile.DHsearch==false and GuildManager.db.profile.Druidsearch==false and GuildManager.db.profile.Huntersearch==false and GuildManager.db.profile.Magesearch==false and GuildManager.db.profile.Paladinsearch==false and GuildManager.db.profile.Priestsearch==false and GuildManager.db.profile.Roguesearch==false and GuildManager.db.profile.Shamansearch==false and GuildManager.db.profile.Warlocksearch==false and GuildManager.db.profile.Warriorsearch==false then
GuildManager:Print('ERROR! You must select a specific class if you opt to target specific classes!')
else
if WhoCycle==1 then
GuildManager:Print('Character Recruitment Cycle Already In Progress')
else
WhoHalt=0
WhoCycle=0
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
GuildManager:LevelRangeSearch()
end
end
else
GuildManager:Print('Character Recruitment Cycle did NOT start! Only Guild Leaders can use this function!')
end
end

function GuildManager:LevelRangeSearch()
if GetNumGuildMembers()<=999 and GuildManager.db.profile.membercap>GetNumGuildMembers() then
if WhoCycle==0 then
GuildManager:Print('Starting Character Recruitment Cycle')
if GuildManager.db.profile.minlevel+4>=GuildManager.db.profile.maxlevel and GuildManager.db.profile.minlevel<GuildManager.db.profile.maxlevel then
ToonMinLevel=GuildManager.db.profile.minlevel
ToonMaxLevel=GuildManager.db.profile.maxlevel
ToonLevel=strjoin('',ToonMinLevel,'-',ToonMaxLevel)
WhoCycle=1
GuildManager:SendWhoLevel()
elseif GuildManager.db.profile.minlevel+4<GuildManager.db.profile.maxlevel then
ToonMinLevel=GuildManager.db.profile.maxlevel-4
ToonMaxLevel=GuildManager.db.profile.maxlevel
ToonLevel=strjoin('',ToonMinLevel,'-',ToonMaxLevel)
WhoCycle=1
GuildManager:SendWhoLevel()
elseif GuildManager.db.profile.minlevel==GuildManager.db.profile.maxlevel then
ToonMinLevel=GuildManager.db.profile.minlevel
ToonMaxLevel=GuildManager.db.profile.maxlevel
ToonLevel=GuildManager.db.profile.minlevel
GuildManager:SendWhoLevel()
WhoCycle=1
end

elseif WhoCycle==1 then

if ToonMaxLevel-4<=GuildManager.db.profile.minlevel and ToonMaxLevel>GuildManager.db.profile.minlevel then
ToonMinLevel=GuildManager.db.profile.minlevel
ToonLevel=strjoin('',ToonMinLevel,'-',ToonMaxLevel)
GuildManager:SendWhoLevel()
elseif ToonMaxLevel-4>GuildManager.db.profile.minlevel then
ToonMinLevel=ToonMaxLevel-4
ToonLevel=strjoin('',ToonMinLevel,'-',ToonMaxLevel)
GuildManager:SendWhoLevel()
elseif ToonMaxLevel==GuildManager.db.profile.minlevel then
ToonLevel=GuildManager.db.profile.minlevel
ToonMinLevel=GuildManager.db.profile.minlevel
GuildManager:SendWhoLevel()
elseif ToonMaxLevel<GuildManager.db.profile.minlevel then
WhoCycle=0
end
end
else
GuildManager:Print('Character Recruitment Will Not Run. Guild Population is at maximum.')
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
WhoCycle=0
end
end

function GuildManager:LevelSearch()
LevelChecking=1
if ToonLevelCheck==0 then
ToonLevelCheck=1
GuildManager:LevelSearch()
elseif ToonLevelCheck==1 and ToonMaxLevel>=GuildManager.db.profile.minlevel then
ToonLevel=ToonMaxLevel
GuildManager:SendWhoLevel()
elseif ToonLevelCheck==2 and ToonMaxLevel-1>=GuildManager.db.profile.minlevel then
ToonLevel=ToonMaxLevel-1
GuildManager:SendWhoLevel()
elseif ToonLevelCheck==3 and ToonMaxLevel-2>=GuildManager.db.profile.minlevel then
ToonLevel=ToonMaxLevel-2
GuildManager:SendWhoLevel()
elseif ToonLevelCheck==4 and ToonMaxLevel-3>=GuildManager.db.profile.minlevel then
ToonLevel=ToonMaxLevel-3
GuildManager:SendWhoLevel()
elseif ToonLevelCheck==5 and ToonMaxLevel-4>=GuildManager.db.profile.minlevel then
ToonLevel=ToonMaxLevel-4
GuildManager:SendWhoLevel()
elseif ToonLevelCheck==6 or ToonLevel<=GuildManager.db.profile.minlevel then
LevelChecking=0
ToonMaxLevel=ToonMinLevel-1
GuildManager:LevelRangeSearch()
end
end

--Class Controls--
function GuildManager:ClassControl()
ClassChecking=1
if ToonClassCheck==0 then
ToonClassCheck=1
GuildManager:ClassControl()
elseif ToonClassCheck==1 then
if GuildManager.db.profile.DKsearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Death Knight\" '
ToonClassName = 'Death Knights'
GuildManager:SendWhoClass()
else
ToonClassCheck=2
GuildManager:ClassControl()
end
elseif ToonClassCheck==2 then
if GuildManager.db.profile.DHsearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Demon Hunter\" '
ToonClassName = 'Demon Hunter'
GuildManager:SendWhoClass()
else
ToonClassCheck=3
GuildManager:ClassControl()
end
elseif ToonClassCheck==3 then
if GuildManager.db.profile.Druidsearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Druid\" '
ToonClassName = 'Druids'
GuildManager:SendWhoClass()
else
ToonClassCheck=4
GuildManager:ClassControl()
end
elseif ToonClassCheck==4 then
if GuildManager.db.profile.Huntersearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Hunter\" '
ToonClassName = 'Hunters'
GuildManager:SendWhoClass()
else
ToonClassCheck=5
GuildManager:ClassControl()
end
elseif ToonClassCheck==5 then
if GuildManager.db.profile.Magesearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Mage\" '
ToonClassName = 'Mages'
GuildManager:SendWhoClass()
else
ToonClassCheck=6
GuildManager:ClassControl()
end
elseif ToonClassCheck==6 then
if GuildManager.db.profile.Monksearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Monk\" '
ToonClassName = 'Monk'
GuildManager:SendWhoClass()
else
ToonClassCheck=7
GuildManager:ClassControl()
end
elseif ToonClassCheck==7 then
if GuildManager.db.profile.Paladinsearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Paladin\" '
ToonClassName = 'Paladins'
GuildManager:SendWhoClass()
else
ToonClassCheck=8
GuildManager:ClassControl()
end
elseif ToonClassCheck==8 then
if GuildManager.db.profile.Priestsearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Priest\" '
ToonClassName = 'Priests'
GuildManager:SendWhoClass()
else
ToonClassCheck=9
GuildManager:ClassControl()
end
elseif ToonClassCheck==9 then
if GuildManager.db.profile.Roguesearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Rogue\" '
ToonClassName = 'Rogues'
GuildManager:SendWhoClass()
else
ToonClassCheck=10
GuildManager:ClassControl()
end
elseif ToonClassCheck==10 then
if GuildManager.db.profile.Shamansearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Shaman\" '
ToonClassName = 'Shaman'
GuildManager:SendWhoClass()
else
ToonClassCheck=11
GuildManager:ClassControl()
end
elseif ToonClassCheck==11 then
if GuildManager.db.profile.Warlocksearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Warlock\" '
ToonClassName = 'Warlocks'
GuildManager:SendWhoClass()
else
ToonClassCheck=12
GuildManager:ClassControl()
end
elseif ToonClassCheck==12 then
if GuildManager.db.profile.Warriorsearch==true or GuildManager.db.profile.targetclass==false then
ToonClass = 'c-\"Warrior\" '
ToonClassName = 'Warriors'
GuildManager:SendWhoClass()
else
ToonClassCheck=13
GuildManager:ClassControl()
end
elseif ToonClassCheck==13 then
ClassChecking=0
ToonLevelCheck=ToonLevelCheck+1
GuildManager:LevelSearch()
end
end

--Race/Class Controls--
function GuildManager:RaceClassControl()
RaceClassChecking=1
if ToonRaceClassCheck==0 then
ToonRaceClassCheck=ToonRaceClassCheck+1
GuildManager:RaceClassControl()
elseif ToonRaceClassCheck>=1 then
if ToonClassCheck==1 then
GuildManager:DKRaceSearch()
elseif ToonClassCheck==2 then
GuildManager:DHRaceSearch()
elseif ToonClassCheck==3 then
GuildManager:DruidRaceSearch()
elseif ToonClassCheck==4 then
GuildManager:HunterRaceSearch()
elseif ToonClassCheck==5 then
GuildManager:MageRaceSearch()
elseif ToonClassCheck==6 then
GuildManager:MonkRaceSearch()
elseif ToonClassCheck==7 then
GuildManager:PaladinRaceSearch()
elseif ToonClassCheck==8 then
GuildManager:PriestRaceSearch()
elseif ToonClassCheck==9 then
GuildManager:RogueRaceSearch()
elseif ToonClassCheck==10 then
GuildManager:ShamanRaceSearch()
elseif ToonClassCheck==11 then
GuildManager:WarlockRaceSearch()
elseif ToonClassCheck==12 then
GuildManager:WarriorRaceSearch()
end
end
end

function GuildManager:DKRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Draenei\" '
ToonRaceName = 'Draenei'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Dwarf\" '
ToonRaceName = 'Dwarf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Gnome\" '
ToonRaceName = 'Gnome'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Human\" '
ToonRaceName = 'Human'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Worgen\" '
ToonRaceName = 'Worgen'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Goblin\" '
ToonRaceName = 'Goblin'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Orc\" '
ToonRaceName = 'Orc'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Tauren\" '
ToonRaceName = 'Tauren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Undead\" '
ToonRaceName = 'Undead'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:DHRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:DruidRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Worgen\" '
ToonRaceName = 'Worgen'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Tauren\" '
ToonRaceName = 'Tauren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:HunterRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Draenei\" '
ToonRaceName = 'Draenei'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Dwarf\" '
ToonRaceName = 'Dwarf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Human\" '
ToonRaceName = 'Human'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Worgen\" '
ToonRaceName = 'Worgen'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Goblin\" '
ToonRaceName = 'Goblin'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Orc\" '
ToonRaceName = 'Orc'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Tauren\" '
ToonRaceName = 'Tauren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
ToonRace = 'r-\"Undead\" '
ToonRaceName = 'Undead'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==8 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:MageRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Draenei\" '
ToonRaceName = 'Draenei'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Gnome\" '
ToonRaceName = 'Gnome'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Human\" '
ToonRaceName = 'Human'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Undead\" '
ToonRaceName = 'Undead'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:MonkRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Draenei\" '
ToonRaceName = 'Draenei'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Dwarf\" '
ToonRaceName = 'Dwarf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Gnome\" '
ToonRaceName = 'Gnome'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Human\" '
ToonRaceName = 'Human'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Orc\" '
ToonRaceName = 'Orc'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Tauren\" '
ToonRaceName = 'Tauren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Undead\" '
ToonRaceName = 'Undead'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:PaladinRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Draenei\" '
ToonRaceName = 'Draenei'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Dwarf\" '
ToonRaceName = 'Dwarf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Human\" '
ToonRaceName = 'Human'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Tauren\" '
ToonRaceName = 'Tauren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:PriestRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Draenei\" '
ToonRaceName = 'Draenei'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Dwarf\" '
ToonRaceName = 'Dwarf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Gnome\" '
ToonRaceName = 'Gnome'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Human\" '
ToonRaceName = 'Human'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
ToonRace = 'r-\"Worgen\" '
ToonRaceName = 'Worgen'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==8 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Goblin\" '
ToonRaceName = 'Goblin'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Tauren\" '
ToonRaceName = 'Tauren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Undead\" '
ToonRaceName = 'Undead'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:RogueRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Dwarf\" '
ToonRaceName = 'Dwarf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Gnome\" '
ToonRaceName = 'Gnome'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Human\" '
ToonRaceName = 'Human'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Worgen\" '
ToonRaceName = 'Worgen'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Goblin\" '
ToonRaceName = 'Goblin'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Orc\" '
ToonRaceName = 'Orc'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Undead\" '
ToonRaceName = 'Undead'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:ShamanRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Draenei\" '
ToonRaceName = 'Draenei'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Dwarf\" '
ToonRaceName = 'Dwarf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Goblin\" '
ToonRaceName = 'Goblin'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Orc\" '
ToonRaceName = 'Orc'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Tauren\" '
ToonRaceName = 'Tauren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:WarlockRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Dwarf\" '
ToonRaceName = 'Dwarf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Gnome\" '
ToonRaceName = 'Gnome'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Human\" '
ToonRaceName = 'Human'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Goblin\" '
ToonRaceName = 'Goblin'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Orc\" '
ToonRaceName = 'Orc'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Undead\" '
ToonRaceName = 'Undead'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

function GuildManager:WarriorRaceSearch()
if UnitFactionGroup("player")=="Alliance" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Draenei\" '
ToonRaceName = 'Draenei'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Dwarf\" '
ToonRaceName = 'Dwarf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Gnome\" '
ToonRaceName = 'Gnome'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Human\" '
ToonRaceName = 'Human'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Night elf\" '
ToonRaceName = 'Night elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
ToonRace = 'r-\"Worgen\" '
ToonRaceName = 'Worgen'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==8 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
elseif UnitFactionGroup("player")=="Horde" then
if ToonRaceClassCheck==1 then
ToonRace = 'r-\"Blood elf\" '
ToonRaceName = 'Blood Elf'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==2 then
ToonRace = 'r-\"Goblin\" '
ToonRaceName = 'Goblin'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==3 then
ToonRace = 'r-\"Orc\" '
ToonRaceName = 'Orc'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==4 then
ToonRace = 'r-\"Pandaren\" '
ToonRaceName = 'Pandaren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==5 then
ToonRace = 'r-\"Tauren\" '
ToonRaceName = 'Tauren'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==6 then
ToonRace = 'r-\"Troll\" '
ToonRaceName = 'Troll'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==7 then
ToonRace = 'r-\"Undead\" '
ToonRaceName = 'Undead'
GuildManager:SendWhoRaceClass()
elseif ToonRaceClassCheck==8 then
RaceClassChecking=0
ToonClassCheck=ToonClassCheck+1
GuildManager:ClassControl()
end
end
end

--Types of Who Searches--
function GuildManager:SendWhoLevel()
if WhoHalt==nil or WhoHalt==0 then
if GetNumGuildMembers()<=999 and GuildManager.db.profile.membercap>GetNumGuildMembers() then
SetWhoToUI(1)
FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
WhoReturned=0
if WhoFailed==0 then
GuildManager:ScheduleTimer("WhoFailure", 10)
elseif WhoFailed==1 then
GuildManager:ScheduleTimer("WhoFailure2", 10)
elseif WhoFailed==2 then
GuildManager:ScheduleTimer("WhoFailure3", 10)
end
GuildManager:RegisterEvent("WHO_LIST_UPDATE", "GRAfterWho")
SendWho(ToonLevel)
else
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
WhoCycle=0
end
else
GuildManager:Print('Character Recruitment Cycle Halted.')
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
WhoCycle=0
WhoHalt=0
end
end

function GuildManager:SendWhoClass()
if WhoHalt==nil or WhoHalt==0 then
if GetNumGuildMembers()<=999 and GuildManager.db.profile.membercap>GetNumGuildMembers() then
SetWhoToUI(1)
FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
WhoReturned=0
if WhoFailed==0 then
GuildManager:ScheduleTimer("WhoFailure", 10)
elseif WhoFailed==1 then
GuildManager:ScheduleTimer("WhoFailure2", 10)
elseif WhoFailed==2 then
GuildManager:ScheduleTimer("WhoFailure3", 10)
end
GuildManager:RegisterEvent("WHO_LIST_UPDATE", "GRAfterWho")
SendWho(strjoin(" ",ToonLevel,ToonClass))
else
GuildManager:Print('Character Recruitment Cycle Complete. Guild Population is at Maximum')
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
WhoCycle=0
end
else
GuildManager:Print('Character Recruitment Cycle Halted.')
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
WhoCycle=0
WhoHalt=0
end
end

function GuildManager:SendWhoRaceClass()
if WhoHalt==nil or WhoHalt==0 then
if GetNumGuildMembers()<=999 and GuildManager.db.profile.membercap>GetNumGuildMembers() then
SetWhoToUI(1)
FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
WhoReturned=0
if WhoFailed==0 then
GuildManager:ScheduleTimer("WhoFailure", 10)
elseif WhoFailed==1 then
GuildManager:ScheduleTimer("WhoFailure2", 10)
elseif WhoFailed==2 then
GuildManager:ScheduleTimer("WhoFailure3", 10)
end
GuildManager:RegisterEvent("WHO_LIST_UPDATE", "GRAfterWho")
SendWho(strjoin(" ",ToonLevel,ToonClass,ToonRace))
else
GuildManager:Print('Character Recruitment Cycle Complete. Guild Population is at Maximum')
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
WhoCycle=0
end
else
GuildManager:Print('Character Recruitment Cycle Halted.')
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
WhoCycle=0
WhoHalt=0
end
end

--WHO FAILURE--
function GuildManager:WhoFailure()
if WhoReturned==0 then
GuildManager:Print("ATTENTION: Server did NOT return search results. Sending Again (2nd Attempt)")
WhoFailed=1
if ClassChecking==0 and RaceClassChecking==0 then
GuildManager:SendWhoLevel()
elseif ClassChecking==1 and RaceClassChecking==0 then
GuildManager:SendWhoClass()
elseif ClassChecking==1 and RaceClassChecking==1 then
GuildManager:SendWhoRaceClass()
end
end
end

function GuildManager:WhoFailure2()
GuildManager:Print("ATTENTION: Server did NOT return search results. Sending Again (3rd Attempt)")
if ClassChecking==0 and RaceClassChecking==0 then
GuildManager:SendWhoLevel()
elseif ClassChecking==1 and RaceClassChecking==0 then
GuildManager:SendWhoClass()
elseif ClassChecking==1 and RaceClassChecking==1 then
GuildManager:SendWhoRaceClass()
end
end

function GuildManager:WhoFailure3()
if WhoReturned==0 then
GuildManager:Print("ATTENTION: Server did NOT return search results. Permanent Failure! Ending Who Recruitment Cycle")
GuildManager:UnregisterEvent("WHO_LIST_UPDATE")
WhoFailed=3
WhoCycle=0
end
end

--Who Invite Functions--
function GuildManager:GRAfterWho()
WhoReturned=1
if GRbutton==1 then
FriendsFrame:Hide()
GuildManager:UnregisterEvent("WHO_LIST_UPDATE")
elseif GRbutton==2 then
FriendsFrame:Show()
FriendsFrameTab1:Click()
GuildManager:UnregisterEvent("WHO_LIST_UPDATE")
elseif GRbutton==3 then
FriendsFrame:Show()
FriendsFrameTab2:Click()
GuildManager:UnregisterEvent("WHO_LIST_UPDATE")
elseif GRbutton==4 then
FriendsFrame:Show()
FriendsFrameTab3:Click()
GuildManager:UnregisterEvent("WHO_LIST_UPDATE")
elseif GRbutton==5 then
FriendsFrame:Show()
FriendsFrameTab4:Click()
GuildManager:UnregisterEvent("WHO_LIST_UPDATE")
else
end
WhoFailed=0
GuildManager:WhoResultsCheck()
end

function GuildManager:WhoResultsCheck()
GuildRoster()
if GetNumGuildMembers()<=999 and GuildManager.db.profile.membercap>GetNumGuildMembers() then
local totalcount,numwhos = GetNumWhoResults()
if totalcount<=49 and LevelChecking==0 and ClassChecking==0 and RaceClassChecking==0 then
GuildManager:WhoInvite()
ToonMaxLevel=ToonMinLevel-1
GuildManager:ScheduleTimer("LevelRangeSearch", 10)
elseif totalcount<=49 and LevelChecking==1 and ClassChecking==0 and RaceClassChecking==0 then
GuildManager:WhoInvite()
ToonLevelCheck=ToonLevelCheck+1
GuildManager:ScheduleTimer("LevelSearch", 10)
elseif totalcount<=49 and LevelChecking==1 and ClassChecking==1 and RaceClassChecking==0 then
GuildManager:WhoInvite()
ToonClassCheck=ToonClassCheck+1
GuildManager:ScheduleTimer("ClassControl", 10)
elseif totalcount<=49 and LevelChecking==1 and ClassChecking==1 and RaceClassChecking==1 then
GuildManager:WhoInvite()
ToonRaceClassCheck=ToonRaceClassCheck+1
GuildManager:ScheduleTimer("RaceClassControl", 10)
elseif totalcount==50 and LevelChecking==0 and ClassChecking==0 and RaceClassChecking==0 then
GuildManager:WhoInvite()
ToonLevelCheck=0
GuildManager:ScheduleTimer("LevelSearch", 10)
elseif totalcount==50 and LevelChecking==1 and ClassChecking==0 and RaceClassChecking==0 then
GuildManager:WhoInvite()
ToonClassCheck=0
GuildManager:ScheduleTimer("ClassControl", 10)
elseif totalcount>=50 and LevelChecking==1 and ClassChecking==1 and RaceClassChecking==0 then
GuildManager:WhoInvite()
ToonRaceClassCheck=0
GuildManager:ScheduleTimer("RaceClassControl", 10)
elseif totalcount>=50 and LevelChecking==1 and ClassChecking==1 and RaceClassChecking==1 then
GuildManager:WhoInvite()
ToonRaceClassCheck=ToonRaceClassCheck+1
GuildManager:ScheduleTimer("RaceClassControl", 10)
else
end
else
GuildManager:Print('Character Recruitment Cycle Complete. Guild Population is at Maximum')
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
WhoCycle=0
end
end

function GuildManager:WhoInvite()
if GetNumGuildMembers()<=999 and GuildManager.db.profile.membercap>GetNumGuildMembers() then
freshinvite=0
guildedinvite=0
dnioverrided=0
for i=1,GetNumWhoResults() do local whoname,whoguild,wholevel,whorace,whoclass,whozone,whoclassFileName = GetWhoInfo(i)
if string.match(whoname, "-") then
else
whoname = strjoin("-",whoname,GetRealmName());
end
if GuildManager.db.profile.targetclass==false or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.DKsearch==true and whoclass=='Death Knight') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.DHsearch==true and whoclass=='Demon Hunter') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.Druidsearch==true and whoclass=='Druid') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.Huntersearch==true and whoclass=='Hunter') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.Magesearch==true and whoclass=='Mage') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.Paladinsearch==true and whoclass=='Paladin') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.Priestsearch==true and whoclass=='Priest') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.Roguesearch==true and whoclass=='Rogue') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.Shamansearch==true and whoclass=='Shaman') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.Warlocksearch==true and whoclass=='Warlock') or (GuildManager.db.profile.targetclass==true and GuildManager.db.profile.Warriorsearch==true and whoclass=='Warrior') then
if whoguild=="" then
if tContains(GMInstancet, whozone)~=1 then
if tContains(GuildManager.db.profile.GMDNIt, whoname)~=1 then
if tContains(GuildManager.db.profile.GMBlackt, whoname)~=1 then
if whoguild=="" then
if tContains(GuildManager.db.profile.GMIQt, whoname)~=1 then
GuildManager:Print(strjoin(" ",whoname,'is NOT in a Guild! They have been added to the Invite Queue!'))
table.insert(GuildManager.db.profile.GMIQt, whoname)
GMIQt=GuildManager.db.profile.GMIQt
pairsByKeysIQ(GMIQt)
end
end
if whoguild~="" then
guildedinvite=guildedinvite+1
end
if tContains(GuildManager.db.profile.GMDNIt, whoname)==1 then
dnioverrided=dnioverrided+1
end
freshinvite=freshinvite+1
end
end
end
end
end
end
else
GuildManager:Print('Character Recruitment Cycle Complete. Guild Population is at Maximum')
LevelChecking=0
ClassChecking=0
RaceClassChecking=0
ToonLevelCheck=0
ToonClassCheck=0
ToonRaceClassCheck=0
WhoCycle=0
end
end

GMInstancet = {}

--Manual Invite Script--
function GuildManager:InviteAction()
if #(GuildManager.db.profile.GMIQt)~=0 then
for k,v in pairs(GuildManager.db.profile.GMIQt) do
if 1==k then
GMIQtop=v
end
if string.match(GMIQtop, "-") then
else
GMIQtop = strjoin("-",GMIQtop,GetRealmName());
end
if tContains(GuildManager.db.profile.GMDNIt, GMIQtop)~=1 then
table.insert(GuildManager.db.profile.GMDNIt, GMIQtop)
GMDNIt=GuildManager.db.profile.GMDNIt
pairsByKeysDNI(GMDNIt)
end
end
if GuildManager.db.profile.whisperonly==false then
GuildInvite(GMIQtop)
else
SendChatMessage(GuildManager.db.profile.whispmessage,"WHISPER",nil,GMIQtop)
end
GuildManager:tremovebyval(GuildManager.db.profile.GMIQt, GMIQtop)
else
end
end

--*PRUNING*--
function GuildManager:GKRun()
if IsGuildLeader()==true or IsGuildLeader()~=true then
GuildRoster()
GuildManager:GKLevelCalc()
GuildManager:GKInactivityCalc()
GuildManager:GKAltExemptTable()
GuildManager:GKRankExemptTable()
GuildManager:GKKickTable()
else
GuildManager:Print('Member Prune Cycle did NOT start! Only Guild Leaders can use this function!')
end
end

--Level and Inactivity Calc--
function GuildManager:GKLevelCalc()
GKlvl=GuildManager.db.profile.levelthreshold
GuildManager:GKByLevelTable()
end

function GuildManager:GKInactivityCalc()
if GuildManager.db.profile.daysinactive<=365 and GuildManager.db.profile.daysinactive>=360 then
GKy=1
GKm=0
GKd=0
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<360 and GuildManager.db.profile.daysinactive>=330 then
GKy=0
GKm=11
GKd=GuildManager.db.profile.daysinactive-(30*11)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<330 and GuildManager.db.profile.daysinactive>=300 then
GKy=0
GKm=10
GKd=GuildManager.db.profile.daysinactive-(30*10)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<300 and GuildManager.db.profile.daysinactive>=270 then
GKy=0
GKm=9
GKd=GuildManager.db.profile.daysinactive-(30*9)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<270 and GuildManager.db.profile.daysinactive>=240 then
GKy=0
GKm=8
GKd=GuildManager.db.profile.daysinactive-(30*8)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<240 and GuildManager.db.profile.daysinactive>=210 then
GKy=0
GKm=7
GKd=GuildManager.db.profile.daysinactive-(30*7)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<210 and GuildManager.db.profile.daysinactive>=180 then
GKy=0
GKm=6
GKd=GuildManager.db.profile.daysinactive-(30*6)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<180 and GuildManager.db.profile.daysinactive>=150 then
GKy=0
GKm=5
GKd=GuildManager.db.profile.daysinactive-(30*5)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<150 and GuildManager.db.profile.daysinactive>=120 then
GKy=0
GKm=4
GKd=GuildManager.db.profile.daysinactive-(30*4)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<120 and GuildManager.db.profile.daysinactive>=90 then
GKy=0
GKm=3
GKd=GuildManager.db.profile.daysinactive-(30*3)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<90 and GuildManager.db.profile.daysinactive>=60 then
GKy=0
GKm=2
GKd=GuildManager.db.profile.daysinactive-(30*2)
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<60 and GuildManager.db.profile.daysinactive>=30 then
GKy=0
GKm=1
GKd=GuildManager.db.profile.daysinactive-30
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
elseif GuildManager.db.profile.daysinactive<30 and GuildManager.db.profile.daysinactive>=1 then
GKy=0
GKm=0
GKd=GuildManager.db.profile.daysinactive
GuildManager:GKParseTime()
GuildManager:GKByInactivityTable()
else
end
end

function GuildManager:GKParseTime()
if GKm>0 and GKd==0 then
GKm1=GKm
GKd1=GKd
GKm2=GKm
GKd2=GKd
elseif GKm>0 and GKd>0 then
GKm1=GKm
GKd1=GKd
GKm2=GKm+1
GKd2=0
elseif GKm==0 and GKd>0 then
GKm1=GKm
GKd1=GKd
GKm2=GKm+1
GKd2=0
elseif GKy==1 and GKm==0 and GKd==0 then
GKm1=99
GKd1=99
GKm2=99
GKd2=99
else
end
end

--Kick Table Generators--
function GuildManager:GKByLevelTable()
GKlvlt = {}
for i=1,GetNumGuildMembers(true) do local name,_,_,level = GetGuildRosterInfo(i);
if GuildManager.db.profile.removelevels==true and level<=GKlvl then 
tinsert(GKlvlt, i);
end
end
end

function GuildManager:GKByInactivityTable()
GKInactivet = {}
for i=1,GetNumGuildMembers() do local y,m,d=GetGuildRosterLastOnline(i)
if y then
if GuildManager.db.profile.removeinactive==true and ((y>=0 and m==GKm1 and d>=GKd1) or (y>=0 and m>=GKm2 and d>=GKd2) or (y>=1 and m>=0 and d>=0)) then 
tinsert(GKInactivet, i)
end
end
end
end

--Exemption Table Generators--
function GuildManager:GKAltExemptTable()
GKAltt = {}
for i=1,GetNumGuildMembers(true) do local name,_,_,_,_,_,note,officer = GetGuildRosterInfo(i);
if GuildManager.db.profile.exemptalt==true and (string.find(note, "Alt")~=nil or string.find(note, "AlT")~=nil or string.find(note, "ALt")~=nil or string.find(note, "ALT")~=nil or string.find(note, "aLt")~=nil or string.find(note, "aLT")~=nil or string.find(note, "alt")~=nil or string.find(note, "alT")~=nil or string.find(officer, "Alt")~=nil or string.find(officer, "AlT")~=nil or string.find(officer, "ALt")~=nil or string.find(officer, "ALT")~=nil or string.find(officer, "aLt")~=nil or string.find(officer, "aLT")~=nil or string.find(officer, "alt")~=nil or string.find(officer, "alT")~=nil) then 
tinsert(GKAltt, i);
end
end
end

function GuildManager:GKRankExemptTable()
GKRankt = {}
for i=1,GetNumGuildMembers(true) do local name,rank,rankindex = GetGuildRosterInfo(i);
if GuildManager.db.profile.exemptranks==true and (rankindex==0 or (GuildManager.db.profile.exemptrank1==true and rankindex==1) or (GuildManager.db.profile.exemptrank2==true and rankindex==2) or (GuildManager.db.profile.exemptrank3==true and rankindex==3) or (GuildManager.db.profile.exemptrank4==true and rankindex==4) or (GuildManager.db.profile.exemptrank5==true and rankindex==5) or (GuildManager.db.profile.exemptrank6==true and rankindex==6) or (GuildManager.db.profile.exemptrank7==true and rankindex==7) or (GuildManager.db.profile.exemptrank8==true and rankindex==8) or (GuildManager.db.profile.exemptrank9==true and rankindex==9)) then 
tinsert(GKRankt, i);
end
end
end


--Kick Functions--
function GuildManager:GKKickTable()
GKKickt = {}
blacklistkick=0
inactivekick=0
lowlevelkick=0
lowinactivekick=0
removeprunednil=0
for i=1,GetNumGuildMembers(true) do local name,_,_,level = GetGuildRosterInfo(i);
if tContains(GuildManager.db.profile.GMBlackt, name)==1 then
tinsert(GKKickt, name)
blacklistkick=blacklistkick+1
end
if tContains(GKAltt, i)~=1 and tContains(GKRankt, i)~=1 and tContains(GKKickt, name)~=1 and tContains(GuildManager.db.profile.GMPruneExemptt, name)~=1 then
if tContains(GKInactivet, i)==1 and GuildManager.db.profile.removelevels==false then
tinsert(GKKickt, name)
inactivekick=inactivekick+1
elseif tContains(GKlvlt, i)==1 and GuildManager.db.profile.removeinactive==false then
tinsert(GKKickt, name)
lowlevelkick=lowlevelkick+1
elseif tContains(GKlvlt, i)==1 and tContains(GKInactivet, i)==1 then
tinsert(GKKickt, name)
lowinactivekick=lowinactivekick+1
end
end
end
for k,v in pairs(GKKickt) do 
if tContains(GuildManager.db.profile.GMDNIt, v)==1 and GuildManager.db.profile.removefromdnil==true then
GuildManager:tremovebyval(GuildManager.db.profile.GMDNIt, v)
GMDNIt=GuildManager.db.profile.GMDNIt
pairsByKeysDNI(GMDNIt)
removeprunednil=removeprunednil+1
end
GuildUninvite(v) 
end
if GuildManager.db.profile.pruneannounce==3 then
GuildManager:GKKickStatsGuildAnnounce()
end
if GuildManager.db.profile.pruneannounce==2 then
GuildManager:GKKickStatsOfficerAnnounce()
end
end

function GuildManager:GKKickStatsGuildAnnounce()
if removeprunednil>0 then
SendChatMessage(strjoin(" ",removeprunednil,"members were removed from the Do Not Invite List"),"guild", nil,"GUILD")
end
if blacklistkick>0 then
SendChatMessage(strjoin(" ",blacklistkick,"members were removed from the guild because they were on the black list!"),"guild", nil,"GUILD")
end
if inactivekick>0 then
SendChatMessage(strjoin(" ",inactivekick,"members were removed from the guild because they were offline for",GuildManager.db.profile.daysinactive,"or more consecutive days!"),"guild", nil,"GUILD")
end
if lowlevelkick>0 then
SendChatMessage(strjoin(" ",lowlevelkick,"members were removed from the guild because they were at or below level",GuildManager.db.profile.levelthreshold,"!"),"guild", nil,"GUILD")
end
if lowinactivekick>0 then
SendChatMessage(strjoin(" ",lowinactivekick,"members were removed from the guild because they were offline for",GuildManager.db.profile.daysinactive,"or more consecutive days AND they were at or below level",GuildManager.db.profile.levelthreshold,"!"),"guild", nil,"GUILD")
end
end

function GuildManager:GKKickStatsOfficerAnnounce()
if removeprunednil>0 then
SendChatMessage(strjoin(" ",removeprunednil,"members were removed from the Do Not Invite List"),"officer", nil,"OFFICER")
end
if blacklistkick>0 then
SendChatMessage(strjoin(" ",blacklistkick,"members were removed from the guild because they were on the black list!"),"officer", nil,"OFFICER")
end
if inactivekick>0 then
SendChatMessage(strjoin(" ",inactivekick,"members were removed from the guild because they were offline for",GuildManager.db.profile.daysinactive,"or more consecutive days!"),"officer", nil,"OFFICER")
end
if lowlevelkick>0 then
SendChatMessage(strjoin(" ",lowlevelkick,"members were removed from the guild because they were at or below level",GuildManager.db.profile.levelthreshold,"!"),"officer", nil,"OFFICER")
end
if lowinactivekick>0 then
SendChatMessage(strjoin(" ",lowinactivekick,"members were removed from the guild because they were offline for",GuildManager.db.profile.daysinactive,"or more consecutive days AND they were at or below level",GuildManager.db.profile.levelthreshold,"!"),"officer", nil,"OFFICER")
end
end


--*PROMOTION*--
function GuildManager:GMPromoteErrorChecking()
GuildManager:GMPromoteErrorCheckingLevel()
end

--BY LEVEL--
function GuildManager:GMPromoteErrorCheckingLevel()
if IsGuildLeader()==true or IsGuildLeader()~=true then
GPERROR=0
if GuildManager.db.profile.rank1promote==true then
if GuildManager.db.profile.rank1level==GuildManager.db.profile.rank2level and GuildManager.db.profile.rank2promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank1level==GuildManager.db.profile.rank3level and GuildManager.db.profile.rank3promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank1level==GuildManager.db.profile.rank4level and GuildManager.db.profile.rank4promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank1level==GuildManager.db.profile.rank5level and GuildManager.db.profile.rank5promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank1level==GuildManager.db.profile.rank6level and GuildManager.db.profile.rank6promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank1level==GuildManager.db.profile.rank7level and GuildManager.db.profile.rank7promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank1level==GuildManager.db.profile.rank8level and GuildManager.db.profile.rank8promote==true then
GPERROR=1
end
end
if GuildManager.db.profile.rank2promote==true then
if GuildManager.db.profile.rank2level==GuildManager.db.profile.rank3level and GuildManager.db.profile.rank3promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank2level==GuildManager.db.profile.rank4level and GuildManager.db.profile.rank4promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank2level==GuildManager.db.profile.rank5level and GuildManager.db.profile.rank5promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank2level==GuildManager.db.profile.rank6level and GuildManager.db.profile.rank6promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank2level==GuildManager.db.profile.rank7level and GuildManager.db.profile.rank7promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank2level==GuildManager.db.profile.rank8level and GuildManager.db.profile.rank8promote==true then
GPERROR=1
end
end
if GuildManager.db.profile.rank3promote==true then
if GuildManager.db.profile.rank3level==GuildManager.db.profile.rank4level and GuildManager.db.profile.rank4promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank3level==GuildManager.db.profile.rank5level and GuildManager.db.profile.rank5promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank3level==GuildManager.db.profile.rank6level and GuildManager.db.profile.rank6promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank3level==GuildManager.db.profile.rank7level and GuildManager.db.profile.rank7promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank3level==GuildManager.db.profile.rank8level and GuildManager.db.profile.rank8promote==true then
GPERROR=1
end
end
if GuildManager.db.profile.rank4promote==true then
if GuildManager.db.profile.rank4level==GuildManager.db.profile.rank5level and GuildManager.db.profile.rank5promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank4level==GuildManager.db.profile.rank6level and GuildManager.db.profile.rank6promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank4level==GuildManager.db.profile.rank7level and GuildManager.db.profile.rank7promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank4level==GuildManager.db.profile.rank8level and GuildManager.db.profile.rank8promote==true then
GPERROR=1
end
end
if GuildManager.db.profile.rank5promote==true then
if GuildManager.db.profile.rank5level==GuildManager.db.profile.rank6level and GuildManager.db.profile.rank6promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank5level==GuildManager.db.profile.rank7level and GuildManager.db.profile.rank7promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank5level==GuildManager.db.profile.rank8level and GuildManager.db.profile.rank8promote==true then
GPERROR=1
end
end
if GuildManager.db.profile.rank6promote==true then
if GuildManager.db.profile.rank6level==GuildManager.db.profile.rank7level and GuildManager.db.profile.rank7promote==true then
GPERROR=1
end
if GuildManager.db.profile.rank6level==GuildManager.db.profile.rank8level and GuildManager.db.profile.rank8promote==true then
GPERROR=1
end
end
if GuildManager.db.profile.rank7promote==true then
if GuildManager.db.profile.rank7level==GuildManager.db.profile.rank8level and GuildManager.db.profile.rank8promote==true then
GPERROR=1
end
end
GuildManager:GMPromoteLevel()
else
GuildManager:Print('Member Promotion Cycle did NOT start! Only Guild Leaders can use this function!')
end
end

local countPromotions = 0;

function GuildManager:DoGMPromoteLevel(totali,i,name,rankn,ranki,level)
	--print(strjoin(" ","Doing-PromoteLevel:", "at index:", i, "for", name, "rankn:", rankn, "ranki:", ranki, "level:", level ))
	print(strjoin(" ","Doing-PromoteLevel:", i, "of", totali))
	countPromotions = countPromotions + 1;
	if (GuildManager.db.profile.rank1promotesearch==true and ranki+1==2) or (GuildManager.db.profile.rank2promotesearch==true and ranki+1==3) or (GuildManager.db.profile.rank3promotesearch==true and ranki+1==4) or (GuildManager.db.profile.rank4promotesearch==true and ranki+1==5) or (GuildManager.db.profile.rank5promotesearch==true and ranki+1==6) or (GuildManager.db.profile.rank6promotesearch==true and ranki+1==7) or (GuildManager.db.profile.rank7promotesearch==true and ranki+1==8) or (GuildManager.db.profile.rank8promotesearch==true and ranki+1==9) or (GuildManager.db.profile.rank9promotesearch==true and ranki+1==10) then
		if GuildManager.db.profile.rank1promote==true and level/GuildManager.db.profile.rank1level>=1 and IsGuildRankAssignmentAllowed(ranki,2)==true then
			if level/GuildManager.db.profile.rank2level<1 or level/GuildManager.db.profile.rank2level>level/GuildManager.db.profile.rank1level or GuildManager.db.profile.rank2promote~=true or GuildControlGetNumGuildRanks()<3 then
				if level/GuildManager.db.profile.rank3level<1 or level/GuildManager.db.profile.rank3level>level/GuildManager.db.profile.rank1level or GuildManager.db.profile.rank3promote~=true or GuildControlGetNumGuildRanks()<4 then
					if level/GuildManager.db.profile.rank4level<1 or level/GuildManager.db.profile.rank4level>level/GuildManager.db.profile.rank1level or GuildManager.db.profile.rank4promote~=true or GuildControlGetNumGuildRanks()<5 then
						if level/GuildManager.db.profile.rank5level<1 or level/GuildManager.db.profile.rank5level>level/GuildManager.db.profile.rank1level or GuildManager.db.profile.rank5promote~=true or GuildControlGetNumGuildRanks()<6 then
							if level/GuildManager.db.profile.rank6level<1 or level/GuildManager.db.profile.rank6level>level/GuildManager.db.profile.rank1level or GuildManager.db.profile.rank6promote~=true or GuildControlGetNumGuildRanks()<7 then
								if level/GuildManager.db.profile.rank7level<1 or level/GuildManager.db.profile.rank7level>level/GuildManager.db.profile.rank1level or GuildManager.db.profile.rank7promote~=true or GuildControlGetNumGuildRanks()<8 then
									if level/GuildManager.db.profile.rank8level<1 or level/GuildManager.db.profile.rank8level>level/GuildManager.db.profile.rank1level or GuildManager.db.profile.rank8promote~=true or GuildControlGetNumGuildRanks()<9 then
										SetGuildMemberRank(i,2)
										if ranki+1>2 then
											ANNOUNCErank1promote=ANNOUNCErank1promote+1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildManager.db.profile.rank2promote==true and level/GuildManager.db.profile.rank2level>=1 and GuildControlGetNumRanks()>3 and IsGuildRankAssignmentAllowed(ranki,3)==true and (ranki+1>3 or (ranki+1<3 and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1)) then
			if level/GuildManager.db.profile.rank1level<1 or level/GuildManager.db.profile.rank1level>level/GuildManager.db.profile.rank2level or GuildManager.db.profile.rank1promote~=true then
				if level/GuildManager.db.profile.rank3level<1 or level/GuildManager.db.profile.rank3level>level/GuildManager.db.profile.rank2level or GuildManager.db.profile.rank3promote~=true or GuildControlGetNumGuildRanks()<4 then
					if level/GuildManager.db.profile.rank4level<1 or level/GuildManager.db.profile.rank4level>level/GuildManager.db.profile.rank2level or GuildManager.db.profile.rank4promote~=true or GuildControlGetNumGuildRanks()<5 then
						if level/GuildManager.db.profile.rank5level<1 or level/GuildManager.db.profile.rank5level>level/GuildManager.db.profile.rank2level or GuildManager.db.profile.rank5promote~=true or GuildControlGetNumGuildRanks()<6 then
							if level/GuildManager.db.profile.rank6level<1 or level/GuildManager.db.profile.rank6level>level/GuildManager.db.profile.rank2level or GuildManager.db.profile.rank6promote~=true or GuildControlGetNumGuildRanks()<7 then
								if level/GuildManager.db.profile.rank7level<1 or level/GuildManager.db.profile.rank7level>level/GuildManager.db.profile.rank2level or GuildManager.db.profile.rank7promote~=true or GuildControlGetNumGuildRanks()<8 then
									if level/GuildManager.db.profile.rank8level<1 or level/GuildManager.db.profile.rank8level>level/GuildManager.db.profile.rank2level or GuildManager.db.profile.rank8promote~=true or GuildControlGetNumGuildRanks()<9 then
										SetGuildMemberRank(i,3)
										if ranki+1>3 then
											ANNOUNCErank2promote=ANNOUNCErank2promote+1
										end
										if ranki+1<3 then
											ANNOUNCErankdemote=ANNOUNCErankdemote+1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildManager.db.profile.rank3promote==true and level/GuildManager.db.profile.rank3level>=1 and GuildControlGetNumRanks()>4 and IsGuildRankAssignmentAllowed(ranki,4)==true and (ranki+1>4 or (ranki+1<4 and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1)) then
			if level/GuildManager.db.profile.rank2level<1 or level/GuildManager.db.profile.rank2level>level/GuildManager.db.profile.rank3level or GuildManager.db.profile.rank2promote~=true then
				if level/GuildManager.db.profile.rank1level<1 or level/GuildManager.db.profile.rank1level>level/GuildManager.db.profile.rank3level or GuildManager.db.profile.rank1promote~=true then
					if level/GuildManager.db.profile.rank4level<1 or level/GuildManager.db.profile.rank4level>level/GuildManager.db.profile.rank3level or GuildManager.db.profile.rank4promote~=true or GuildControlGetNumGuildRanks()<5 then
						if level/GuildManager.db.profile.rank5level<1 or level/GuildManager.db.profile.rank5level>level/GuildManager.db.profile.rank3level or GuildManager.db.profile.rank5promote~=true or GuildControlGetNumGuildRanks()<6 then
							if level/GuildManager.db.profile.rank6level<1 or level/GuildManager.db.profile.rank6level>level/GuildManager.db.profile.rank3level or GuildManager.db.profile.rank6promote~=true or GuildControlGetNumGuildRanks()<7 then
								if level/GuildManager.db.profile.rank7level<1 or level/GuildManager.db.profile.rank7level>level/GuildManager.db.profile.rank3level or GuildManager.db.profile.rank7promote~=true or GuildControlGetNumGuildRanks()<8 then
									if level/GuildManager.db.profile.rank8level<1 or level/GuildManager.db.profile.rank8level>level/GuildManager.db.profile.rank3level or GuildManager.db.profile.rank8promote~=true or GuildControlGetNumGuildRanks()<9 then
										SetGuildMemberRank(i,4)
										if ranki+1>4 then
											ANNOUNCErank3promote=ANNOUNCErank3promote+1
										end
										if ranki+1<4 then
											ANNOUNCErankdemote=ANNOUNCErankdemote+1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildManager.db.profile.rank4promote==true and level/GuildManager.db.profile.rank4level>=1 and GuildControlGetNumRanks()>5 and IsGuildRankAssignmentAllowed(ranki,5)==true and (ranki+1>5 or (ranki+1<5 and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1)) then
			if level/GuildManager.db.profile.rank2level<1 or level/GuildManager.db.profile.rank2level>level/GuildManager.db.profile.rank4level or GuildManager.db.profile.rank2promote~=true then
				if level/GuildManager.db.profile.rank3level<1 or level/GuildManager.db.profile.rank3level>level/GuildManager.db.profile.rank4level or GuildManager.db.profile.rank3promote~=true then
					if level/GuildManager.db.profile.rank1level<1 or level/GuildManager.db.profile.rank1level>level/GuildManager.db.profile.rank4level or GuildManager.db.profile.rank1promote~=true then
						if level/GuildManager.db.profile.rank5level<1 or level/GuildManager.db.profile.rank5level>level/GuildManager.db.profile.rank4level or GuildManager.db.profile.rank5promote~=true or GuildControlGetNumGuildRanks()<6 then
							if level/GuildManager.db.profile.rank6level<1 or level/GuildManager.db.profile.rank6level>level/GuildManager.db.profile.rank4level or GuildManager.db.profile.rank6promote~=true or GuildControlGetNumGuildRanks()<7 then
								if level/GuildManager.db.profile.rank7level<1 or level/GuildManager.db.profile.rank7level>level/GuildManager.db.profile.rank4level or GuildManager.db.profile.rank7promote~=true or GuildControlGetNumGuildRanks()<8 then
									if level/GuildManager.db.profile.rank8level<1 or level/GuildManager.db.profile.rank8level>level/GuildManager.db.profile.rank4level or GuildManager.db.profile.rank8promote~=true or GuildControlGetNumGuildRanks()<9 then
										SetGuildMemberRank(i,5)
										if ranki+1>5 then
											ANNOUNCErank4promote=ANNOUNCErank4promote+1
										end
										if ranki+1<5 then
											ANNOUNCErankdemote=ANNOUNCErankdemote+1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildManager.db.profile.rank5promote==true and level/GuildManager.db.profile.rank5level>=1 and GuildControlGetNumRanks()>6 and IsGuildRankAssignmentAllowed(ranki,6)==true and (ranki+1>6 or (ranki+1<6 and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1)) then
			if level/GuildManager.db.profile.rank2level<1 or level/GuildManager.db.profile.rank2level>level/GuildManager.db.profile.rank5level or GuildManager.db.profile.rank2promote~=true then
				if level/GuildManager.db.profile.rank3level<1 or level/GuildManager.db.profile.rank3level>level/GuildManager.db.profile.rank5level or GuildManager.db.profile.rank3promote~=true then
					if level/GuildManager.db.profile.rank4level<1 or level/GuildManager.db.profile.rank4level>level/GuildManager.db.profile.rank5level or GuildManager.db.profile.rank4promote~=true then
						if level/GuildManager.db.profile.rank1level<1 or level/GuildManager.db.profile.rank1level>level/GuildManager.db.profile.rank5level or GuildManager.db.profile.rank1promote~=true then
							if level/GuildManager.db.profile.rank6level<1 or level/GuildManager.db.profile.rank6level>level/GuildManager.db.profile.rank5level or GuildManager.db.profile.rank6promote~=true or GuildControlGetNumGuildRanks()<7 then
								if level/GuildManager.db.profile.rank7level<1 or level/GuildManager.db.profile.rank7level>level/GuildManager.db.profile.rank5level or GuildManager.db.profile.rank7promote~=true or GuildControlGetNumGuildRanks()<8 then
									if level/GuildManager.db.profile.rank8level<1 or level/GuildManager.db.profile.rank8level>level/GuildManager.db.profile.rank5level or GuildManager.db.profile.rank8promote~=true or GuildControlGetNumGuildRanks()<9 then
										SetGuildMemberRank(i,6)
										if ranki+1>6 then
											ANNOUNCErank5promote=ANNOUNCErank5promote+1
										end
										if ranki+1<6 then
											ANNOUNCErankdemote=ANNOUNCErankdemote+1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildManager.db.profile.rank6promote==true and level/GuildManager.db.profile.rank6level>=1 and GuildControlGetNumRanks()>7 and IsGuildRankAssignmentAllowed(ranki,7)==true and (ranki+1>7 or (ranki+1<7 and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1)) then
			if level/GuildManager.db.profile.rank2level<1 or level/GuildManager.db.profile.rank2level>level/GuildManager.db.profile.rank6level or GuildManager.db.profile.rank2promote~=true then
				if level/GuildManager.db.profile.rank3level<1 or level/GuildManager.db.profile.rank3level>level/GuildManager.db.profile.rank6level or GuildManager.db.profile.rank3promote~=true then
					if level/GuildManager.db.profile.rank4level<1 or level/GuildManager.db.profile.rank4level>level/GuildManager.db.profile.rank6level or GuildManager.db.profile.rank4promote~=true then
						if level/GuildManager.db.profile.rank5level<1 or level/GuildManager.db.profile.rank5level>level/GuildManager.db.profile.rank6level or GuildManager.db.profile.rank5promote~=true then
							if level/GuildManager.db.profile.rank1level<1 or level/GuildManager.db.profile.rank1level>level/GuildManager.db.profile.rank6level or GuildManager.db.profile.rank1promote~=true then
								if level/GuildManager.db.profile.rank7level<1 or level/GuildManager.db.profile.rank7level>level/GuildManager.db.profile.rank6level or GuildManager.db.profile.rank7promote~=true or GuildControlGetNumGuildRanks()<8 then
									if level/GuildManager.db.profile.rank8level<1 or level/GuildManager.db.profile.rank8level>level/GuildManager.db.profile.rank6level or GuildManager.db.profile.rank8promote~=true or GuildControlGetNumGuildRanks()<9 then
										SetGuildMemberRank(i,7)
										if ranki+1>7 then
											ANNOUNCErank6promote=ANNOUNCErank6promote+1
										end
										if ranki+1<7 then
											ANNOUNCErankdemote=ANNOUNCErankdemote+1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildManager.db.profile.rank7promote==true and level/GuildManager.db.profile.rank7level>=1 and GuildControlGetNumRanks()>8 and IsGuildRankAssignmentAllowed(ranki,8)==true and (ranki+1>8 or (ranki+1<8 and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1)) then
			if level/GuildManager.db.profile.rank2level<1 or level/GuildManager.db.profile.rank2level>level/GuildManager.db.profile.rank7level or GuildManager.db.profile.rank2promote~=true then
				if level/GuildManager.db.profile.rank3level<1 or level/GuildManager.db.profile.rank3level>level/GuildManager.db.profile.rank7level or GuildManager.db.profile.rank3promote~=true then
					if level/GuildManager.db.profile.rank4level<1 or level/GuildManager.db.profile.rank4level>level/GuildManager.db.profile.rank7level or GuildManager.db.profile.rank4promote~=true then
						if level/GuildManager.db.profile.rank5level<1 or level/GuildManager.db.profile.rank5level>level/GuildManager.db.profile.rank7level or GuildManager.db.profile.rank5promote~=true then
							if level/GuildManager.db.profile.rank6level<1 or level/GuildManager.db.profile.rank6level>level/GuildManager.db.profile.rank7level or GuildManager.db.profile.rank6promote~=true then
								if level/GuildManager.db.profile.rank1level<1 or level/GuildManager.db.profile.rank1level>level/GuildManager.db.profile.rank7level or GuildManager.db.profile.rank1promote~=true then
									if level/GuildManager.db.profile.rank8level<1 or level/GuildManager.db.profile.rank8level>level/GuildManager.db.profile.rank7level or GuildManager.db.profile.rank8promote~=true or GuildControlGetNumGuildRanks()<9 then
										SetGuildMemberRank(i,8)
										if ranki+1>8 then
											ANNOUNCErank7promote=ANNOUNCErank7promote+1
										end
										if ranki+1<8 then
											ANNOUNCErankdemote=ANNOUNCErankdemote+1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildManager.db.profile.rank8promote==true and level/GuildManager.db.profile.rank8level>=1 and GuildControlGetNumRanks()>9 and IsGuildRankAssignmentAllowed(ranki,9)==true and (ranki+1>9 or (ranki+1<9 and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1)) then
			if level/GuildManager.db.profile.rank2level<1 or level/GuildManager.db.profile.rank2level>level/GuildManager.db.profile.rank8level or GuildManager.db.profile.rank2promote~=true then
				if level/GuildManager.db.profile.rank3level<1 or level/GuildManager.db.profile.rank3level>level/GuildManager.db.profile.rank8level or GuildManager.db.profile.rank3promote~=true then
					if level/GuildManager.db.profile.rank4level<1 or level/GuildManager.db.profile.rank4level>level/GuildManager.db.profile.rank8level or GuildManager.db.profile.rank4promote~=true then
						if level/GuildManager.db.profile.rank5level<1 or level/GuildManager.db.profile.rank5level>level/GuildManager.db.profile.rank8level or GuildManager.db.profile.rank5promote~=true then
							if level/GuildManager.db.profile.rank6level<1 or level/GuildManager.db.profile.rank6level>level/GuildManager.db.profile.rank8level or GuildManager.db.profile.rank6promote~=true then
								if level/GuildManager.db.profile.rank7level<1 or level/GuildManager.db.profile.rank7level>level/GuildManager.db.profile.rank8level or GuildManager.db.profile.rank7promote~=true then
									if level/GuildManager.db.profile.rank1level<1 or level/GuildManager.db.profile.rank1level>level/GuildManager.db.profile.rank8level or GuildManager.db.profile.rank1promote~=true then
										SetGuildMemberRank(i,9)
										if ranki+1>9 then
											ANNOUNCErank8promote=ANNOUNCErank8promote+1
										end
										if ranki+1<9 then
											ANNOUNCErankdemote=ANNOUNCErankdemote+1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildControlGetNumRanks()==10 and ranki+1<10 and IsGuildRankAssignmentAllowed(ranki,10)==true and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1 then
			if level/GuildManager.db.profile.rank1level<1 or GuildManager.db.profile.rank1promote~=true then
				if level/GuildManager.db.profile.rank2level<1 or GuildManager.db.profile.rank2promote~=true then
					if level/GuildManager.db.profile.rank3level<1 or GuildManager.db.profile.rank3promote~=true then
						if level/GuildManager.db.profile.rank4level<1 or GuildManager.db.profile.rank4promote~=true then
							if level/GuildManager.db.profile.rank5level<1 or GuildManager.db.profile.rank5promote~=true then
								if level/GuildManager.db.profile.rank6level<1 or GuildManager.db.profile.rank6promote~=true then
									if level/GuildManager.db.profile.rank7level<1 or GuildManager.db.profile.rank7promote~=true then
										if level/GuildManager.db.profile.rank8level<1 or GuildManager.db.profile.rank8promote~=true then
											SetGuildMemberRank(i,10)
											if ranki+1<10 then
												ANNOUNCErankdemote=ANNOUNCErankdemote+1
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildControlGetNumRanks()==9 and ranki+1<9 and IsGuildRankAssignmentAllowed(ranki,9)==true and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1 then
			if level/GuildManager.db.profile.rank1level<1 or GuildManager.db.profile.rank1promote~=true then
				if level/GuildManager.db.profile.rank2level<1 or GuildManager.db.profile.rank2promote~=true then
					if level/GuildManager.db.profile.rank3level<1 or GuildManager.db.profile.rank3promote~=true then
						if level/GuildManager.db.profile.rank4level<1 or GuildManager.db.profile.rank4promote~=true then
							if level/GuildManager.db.profile.rank5level<1 or GuildManager.db.profile.rank5promote~=true then
								if level/GuildManager.db.profile.rank6level<1 or GuildManager.db.profile.rank6promote~=true then
									if level/GuildManager.db.profile.rank7level<1 or GuildManager.db.profile.rank7promote~=true then
										SetGuildMemberRank(i,9)
										if ranki+1<9 then
											ANNOUNCErankdemote=ANNOUNCErankdemote+1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildControlGetNumRanks()==8 and ranki+1<8 and IsGuildRankAssignmentAllowed(ranki,8)==true and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1 then
			if level/GuildManager.db.profile.rank1level<1 or GuildManager.db.profile.rank1promote~=true then
				if level/GuildManager.db.profile.rank2level<1 or GuildManager.db.profile.rank2promote~=true then
					if level/GuildManager.db.profile.rank3level<1 or GuildManager.db.profile.rank3promote~=true then
						if level/GuildManager.db.profile.rank4level<1 or GuildManager.db.profile.rank4promote~=true then
							if level/GuildManager.db.profile.rank5level<1 or GuildManager.db.profile.rank5promote~=true then
								if level/GuildManager.db.profile.rank6level<1 or GuildManager.db.profile.rank6promote~=true then
									SetGuildMemberRank(i,8)
									if ranki+1<8 then
										ANNOUNCErankdemote=ANNOUNCErankdemote+1
									end
								end
							end
						end
					end
				end
			end
		end
		if GuildControlGetNumRanks()==7 and ranki+1<7 and IsGuildRankAssignmentAllowed(ranki,7)==true and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1 then
			if level/GuildManager.db.profile.rank1level<1 or GuildManager.db.profile.rank1promote~=true then
				if level/GuildManager.db.profile.rank2level<1 or GuildManager.db.profile.rank2promote~=true then
					if level/GuildManager.db.profile.rank3level<1 or GuildManager.db.profile.rank3promote~=true then
						if level/GuildManager.db.profile.rank4level<1 or GuildManager.db.profile.rank4promote~=true then
							if level/GuildManager.db.profile.rank5level<1 or GuildManager.db.profile.rank5promote~=true then
								SetGuildMemberRank(i,7)
								if ranki+1<7 then
									ANNOUNCErankdemote=ANNOUNCErankdemote+1
								end
							end
						end
					end
				end
			end
		end
		if GuildControlGetNumRanks()==6 and ranki+1<6 and IsGuildRankAssignmentAllowed(ranki,6)==true and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1 then
			if level/GuildManager.db.profile.rank1level<1 or GuildManager.db.profile.rank1promote~=true then
				if level/GuildManager.db.profile.rank2level<1 or GuildManager.db.profile.rank2promote~=true then
					if level/GuildManager.db.profile.rank3level<1 or GuildManager.db.profile.rank3promote~=true then
						if level/GuildManager.db.profile.rank4level<1 or GuildManager.db.profile.rank4promote~=true then
							SetGuildMemberRank(i,6)
							if ranki+1<6 then
								ANNOUNCErankdemote=ANNOUNCErankdemote+1
							end
						end
					end
				end
			end
		end
		if GuildControlGetNumRanks()==5 and ranki+1<5 and IsGuildRankAssignmentAllowed(ranki,5)==true and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1 then
			if level/GuildManager.db.profile.rank1level<1 or GuildManager.db.profile.rank1promote~=true then
				if level/GuildManager.db.profile.rank2level<1 or GuildManager.db.profile.rank2promote~=true then
					if level/GuildManager.db.profile.rank3level<1 or GuildManager.db.profile.rank3promote~=true then
						SetGuildMemberRank(i,5)
						if ranki+1<5 then
							ANNOUNCErankdemote=ANNOUNCErankdemote+1
						end
					end
				end
			end
		end
		if GuildControlGetNumRanks()==4 and ranki+1<4 and IsGuildRankAssignmentAllowed(ranki,4)==true and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1 then
			if level/GuildManager.db.profile.rank1level<1 or GuildManager.db.profile.rank1promote~=true then
				if level/GuildManager.db.profile.rank2level<1 or GuildManager.db.profile.rank2promote~=true then
					SetGuildMemberRank(i,4)
					if ranki+1<4 then
						ANNOUNCErankdemote=ANNOUNCErankdemote+1
					end
				end
			end
		end
		if GuildControlGetNumRanks()==3 and ranki+1<3 and IsGuildRankAssignmentAllowed(ranki,3)==true and GuildManager.db.profile.demotemode==true and tContains(GuildManager.db.profile.GMDemoteExemptt, name)~=1 then
			if level/GuildManager.db.profile.rank1level<1 or GuildManager.db.profile.rank1promote~=true then
				SetGuildMemberRank(i,3)
				if ranki+1<3 then
					ANNOUNCErankdemote=ANNOUNCErankdemote+1
				end
			end
		end
	end
end

function GuildManager:GMPromoteLevel()
    GuildRoster()
    if GPERROR~=1 then
        ANNOUNCErank1promote=0
        ANNOUNCErank2promote=0
        ANNOUNCErank3promote=0
        ANNOUNCErank3promote=0
        ANNOUNCErank4promote=0
        ANNOUNCErank5promote=0
        ANNOUNCErank6promote=0
        ANNOUNCErank7promote=0
        ANNOUNCErank8promote=0
        ANNOUNCErankdemote=0
        GuildRoster()

		countPromotions = 0;
		local totalGuildMembers = GetNumGuildMembers(true)

        for i=1,totalGuildMembers do local name,rankn,ranki,level = GetGuildRosterInfo(i);
			--print(strjoin(" ","Scheduling-PromoteLevel:", "for", name, "rankn:", rankn, "ranki:", ranki, "level:", level ))
            self:ScheduleTimer("DoGMPromoteLevel", 2, totalGuildMembers, i, name, rankn, ranki, level)
        end

        if GuildManager.db.profile.promoteannounce==3 then
            GuildManager:GMPromoteStatsGuildAnnounceLevel()
        end
        if GuildManager.db.profile.promoteannounce==2 then
            GuildManager:GMPromoteStatsOfficerAnnounceLevel()
        end
    else
        GuildManager:Print("ERROR! Multiple Active Ranks have EQUAL Level Requirements! Change your settings and try again.")
        if GuildManager.db.profile.automatepromote==true then
            GuildManager:Print("Disabling Automatic Promotions!")
            GuildManager.db.profile.automatepromote=false
        end
    end
end


function GuildManager:GMPromoteStatsGuildAnnounceLevel()
if ANNOUNCErank1promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank1promote,"Members were promoted to",GuildControlGetRankName(2),"for reaching LEVEL",GuildManager.db.profile.rank1level,"!"),"guild", nil,"GUILD")
end
if ANNOUNCErank2promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank2promote,"Members were promoted to",GuildControlGetRankName(3),"for reaching LEVEL",GuildManager.db.profile.rank2level,"!"),"guild", nil,"GUILD")
end
if ANNOUNCErank3promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank3promote,"Members were promoted to",GuildControlGetRankName(4),"for reaching LEVEL",GuildManager.db.profile.rank3level,"!"),"guild", nil,"GUILD")
end
if ANNOUNCErank4promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank4promote,"Members were promoted to",GuildControlGetRankName(5),"for reaching LEVEL",GuildManager.db.profile.rank4level,"!"),"guild", nil,"GUILD")
end
if ANNOUNCErank5promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank5promote,"Members were promoted to",GuildControlGetRankName(6),"for reaching LEVEL",GuildManager.db.profile.rank5level,"!"),"guild", nil,"GUILD")
end
if ANNOUNCErank6promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank6promote,"Members were promoted to",GuildControlGetRankName(7),"for reaching LEVEL",GuildManager.db.profile.rank6level,"!"),"guild", nil,"GUILD")
end
if ANNOUNCErank7promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank7promote,"Members were promoted to",GuildControlGetRankName(8),"for reaching LEVEL",GuildManager.db.profile.rank7level,"!"),"guild", nil,"GUILD")
end
if ANNOUNCErank8promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank8promote,"Members were promoted to",GuildControlGetRankName(9),"for reaching LEVEL",GuildManager.db.profile.rank8level,"!"),"guild", nil,"GUILD")
end
if ANNOUNCErankdemote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErankdemote,"Members were demoted for having a Level that is LESS then the rank requires!"),"guild", nil,"GUILD")
end
end

function GuildManager:GMPromoteStatsOfficerAnnounceLevel()
if ANNOUNCErank1promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank1promote,"Members were promoted to",GuildControlGetRankName(2),"for reaching LEVEL",GuildManager.db.profile.rank1level,"!"),"officer", nil,"OFFICER")
end
if ANNOUNCErank2promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank2promote,"Members were promoted to",GuildControlGetRankName(3),"for reaching LEVEL",GuildManager.db.profile.rank2level,"!"),"officer", nil,"OFFICER")
end
if ANNOUNCErank3promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank3promote,"Members were promoted to",GuildControlGetRankName(4),"for reaching LEVEL",GuildManager.db.profile.rank3level,"!"),"officer", nil,"OFFICER")
end
if ANNOUNCErank4promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank4promote,"Members were promoted to",GuildControlGetRankName(5),"for reaching LEVEL",GuildManager.db.profile.rank4level,"!"),"officer", nil,"OFFICER")
end
if ANNOUNCErank5promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank5promote,"Members were promoted to",GuildControlGetRankName(6),"for reaching LEVEL",GuildManager.db.profile.rank5level,"!"),"officer", nil,"OFFICER")
end
if ANNOUNCErank6promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank6promote,"Members were promoted to",GuildControlGetRankName(7),"for reaching LEVEL",GuildManager.db.profile.rank6level,"!"),"officer", nil,"OFFICER")
end
if ANNOUNCErank7promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank7promote,"Members were promoted to",GuildControlGetRankName(8),"for reaching LEVEL",GuildManager.db.profile.rank7level,"!"),"officer", nil,"OFFICER")
end
if ANNOUNCErank8promote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErank8promote,"Members were promoted to",GuildControlGetRankName(9),"for reaching LEVEL",GuildManager.db.profile.rank8level,"!"),"officer", nil,"OFFICER")
end
if ANNOUNCErankdemote>0 then
SendChatMessage(strjoin(" ",ANNOUNCErankdemote,"Members were demoted for having a Level that is LESS then the rank requires!"),"officer", nil,"OFFICER")
end
end

--*ANNOUNCEMENTS*--
function GuildManager:RunAnnouncemnts()
if AnnouncementsActivated~=1 and ValidMessages~=1 then--Announcements
GuildManager:AnnouncementsActivate()
else
GuildManager:NextAnnouncementValid()
end
end
--Load & Reload Functions--
function GuildManager:AnnouncementsActivate()
GuildManager:AnnouncementsFindValid()
if (GuildManager.db.profile.lastannounced==0 or GuildManager.db.profile.announcenext==0) and ValidMessages==1 then
GuildManager:DetermineNextAnnouncement()
GuildManager:AnnouncementsActivate()
elseif (GuildManager.db.profile.lastannounced==0 or GuildManager.db.profile.announcenext==0) and ValidMessages==0 then
AnnouncementsActivated=0
else
end
if GuildManager.db.profile.lastannounced~=0 and GuildManager.db.profile.announcenext~=0 and ValidMessages==1 then
AnnouncementsActivated=1
GuildManager:NextAnnouncementValid()
else
AnnouncementsActivated=0
end
end

function GuildManager:NextAnnouncementValid()
if GuildManager.db.profile.announcenext==1 then
if GuildManager.db.profile.announcement1~="" and (GuildManager.db.profile.announcementto1==2 or GuildManager.db.profile.announcementto1==3) then
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement1
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer1
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto1
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder1
GuildManager:CheckTimeAnnouncement()
else
GuildManager:AnnouncementsFindValid()
if ValidMessages==1 then
GuildManager:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
if GuildManager.db.profile.announcenext==2 then 
if GuildManager.db.profile.announcement2~="" and (GuildManager.db.profile.announcementto2==2 or GuildManager.db.profile.announcementto2==3) then
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement2
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer2
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto2
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder2
GuildManager:CheckTimeAnnouncement()
else
GuildManager:AnnouncementsFindValid()
if ValidMessages==1 then
GuildManager:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
if GuildManager.db.profile.announcenext==3 then
if GuildManager.db.profile.announcement3~="" and (GuildManager.db.profile.announcementto3==2 or GuildManager.db.profile.announcementto3==3) then
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement3
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer3
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto3
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder3
GuildManager:CheckTimeAnnouncement()
else
GuildManager:AnnouncementsFindValid()
if ValidMessages==1 then
GuildManager:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
if GuildManager.db.profile.announcenext==4 then
if GuildManager.db.profile.announcement4~="" and (GuildManager.db.profile.announcementto4==2 or GuildManager.db.profile.announcementto4==3) then
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement4
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer4
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto4
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder4
GuildManager:CheckTimeAnnouncement()
else
GuildManager:AnnouncementsFindValid()
if ValidMessages==1 then
GuildManager:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
if GuildManager.db.profile.announcenext==5 then
if GuildManager.db.profile.announcement5~="" and (GuildManager.db.profile.announcementto5==2 or GuildManager.db.profile.announcementto5==3) then
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement5
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer5
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto5
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder5
GuildManager:CheckTimeAnnouncement()
else
GuildManager:AnnouncementsFindValid()
if ValidMessages==1 then
GuildManager:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
end

function GuildManager:AnnouncementsFindValid()
if GuildManager.db.profile.announcement1~="" and (GuildManager.db.profile.announcementto1==2 or GuildManager.db.profile.announcementto1==3) then
Announcement1Valid=1
else
Announcement1Valid=0
end
if GuildManager.db.profile.announcement2~="" and (GuildManager.db.profile.announcementto2==2 or GuildManager.db.profile.announcementto2==3) then
Announcement2Valid=1
else
Announcement2Valid=0
end
if GuildManager.db.profile.announcement3~="" and (GuildManager.db.profile.announcementto3==2 or GuildManager.db.profile.announcementto3==3) then
Announcement3Valid=1
else
Announcement3Valid=0
end
if GuildManager.db.profile.announcement4~="" and (GuildManager.db.profile.announcementto4==2 or GuildManager.db.profile.announcementto4==3) then
Announcement4Valid=1
else
Announcement4Valid=0
end
if GuildManager.db.profile.announcement5~="" and (GuildManager.db.profile.announcementto5==2 or GuildManager.db.profile.announcementto5==3) then
Announcement5Valid=1
else
Announcement5Valid=0
end
if Announcement1Valid==0 and Announcement2Valid==0 and Announcement3Valid==0 and Announcement4Valid==0 and Announcement5Valid==0 then 
ValidMessages=0
else
ValidMessages=1
end
end

function GuildManager:DetermineNextAnnouncement()
reachedendofcheck=0
GuildManager:AnnouncementsFindValid()
if GuildManager.db.profile.lastannounced==5 and Announcement1Valid==1 then
GuildManager.db.profile.announcenext=1
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement1
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer1
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto1
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder1
elseif GuildManager.db.profile.lastannounced==5 and Announcement1Valid==0 then
GuildManager.db.profile.lastannounced=1
end
if GuildManager.db.profile.lastannounced==1 and Announcement2Valid==1 then
GuildManager.db.profile.announcenext=2
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement2
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer2
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto2
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder2
elseif GuildManager.db.profile.lastannounced==1 and Announcement2Valid==0 then
GuildManager.db.profile.lastannounced=2
end
if GuildManager.db.profile.lastannounced==2 and Announcement3Valid==1 then
GuildManager.db.profile.announcenext=3
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement3
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer3
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto3
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder3
elseif GuildManager.db.profile.lastannounced==2 and Announcement3Valid==0 then
GuildManager.db.profile.lastannounced=3
end
if GuildManager.db.profile.lastannounced==3 and Announcement4Valid==1 then
GuildManager.db.profile.announcenext=4
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement4
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer4
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto4
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder4
elseif GuildManager.db.profile.lastannounced==3 and Announcement4Valid==0 then
GuildManager.db.profile.lastannounced=4
end
if GuildManager.db.profile.lastannounced==4 and Announcement5Valid==1 then
GuildManager.db.profile.announcenext=5
GuildManager.db.profile.nextannouncemessage=GuildManager.db.profile.announcement5
GuildManager.db.profile.nextannouncetime=GuildManager.db.profile.announcementtimer5
GuildManager.db.profile.nextannouncechannel=GuildManager.db.profile.announcementto5
GuildManager.db.profile.nextannounceborder=GuildManager.db.profile.announcementborder5
elseif GuildManager.db.profile.lastannounced==4 and Announcement5Valid==0 then
GuildManager.db.profile.lastannounced=5
reachedendofcheck=1
if GuildManager.db.profile.lastannounced==5 and reachedendofcheck==1 and ValidMessages==1 then
GuildManager:DetermineNextAnnouncement()
end
end
end

--Timer Functions--
function GuildManager:CheckTimeAnnouncement()
if GuildManager.db.profile.lastanntime==nil then 
GuildManager.db.profile.lastanntime=0 
end
lastanndiff=GuildManager:GetTime()-GuildManager.db.profile.lastanntime
if lastanndiff>=GuildManager.db.profile.nextannouncetime then
GuildManager:ExecuteAnnouncement()
elseif lastanndiff<GuildManager.db.profile.nextannouncetime then
end
end

--Format Functions--
function GuildManager:PrintBorder()
if GuildManager.db.profile.nextannouncechannel==2 then
borderchannel="officer"
bordertarget="OFFICER"
elseif GuildManager.db.profile.nextannouncechannel==3 then
borderchannel="guild"
bordertarget="GUILD"
end
if GuildManager.db.profile.nextannouncechannel==2 or GuildManager.db.profile.nextannouncechannel==3 then
if GuildManager.db.profile.nextannounceborder==2 then
SendChatMessage("{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}",borderchannel, nil,bordertarget)
end
if GuildManager.db.profile.nextannounceborder==3 then
SendChatMessage("{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}",borderchannel, nil,bordertarget)
end
if GuildManager.db.profile.nextannounceborder==4 then
SendChatMessage("{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}",borderchannel, nil,bordertarget)
end
if GuildManager.db.profile.nextannounceborder==5 then
SendChatMessage("{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}",borderchannel, nil,bordertarget)
end
if GuildManager.db.profile.nextannounceborder==6 then
SendChatMessage("{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}",borderchannel, nil,bordertarget)
end
if GuildManager.db.profile.nextannounceborder==7 then
SendChatMessage("{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}",borderchannel, nil,bordertarget)
end
if GuildManager.db.profile.nextannounceborder==8 then
SendChatMessage("{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}",borderchannel, nil,bordertarget)
end
if GuildManager.db.profile.nextannounceborder==9 then
SendChatMessage("{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}",borderchannel, nil,bordertarget)
end
end
end

function GuildManager:PrintAnnouncement()
nextannvar=GuildManager.db.profile.nextannouncemessage
if GuildManager.db.profile.nextannouncechannel==2 then
annchannel="officer"
anntarget="OFFICER"
elseif GuildManager.db.profile.nextannouncechannel==3 then
annchannel="guild"
anntarget="GUILD"
end
local message, pattern, position;
position = 1;
for i = 1, #nextannvar, 255 do
message = nextannvar:sub(position, position + 254);
if #message < 255 then
pattern = ".+";
else
pattern = "(.+)%s";
end
for capture in message:gmatch(pattern) do
SendChatMessage(capture,annchannel, nil,anntarget)
position = position + #capture + 1;
end
end
end

--Execution Functions--
function GuildManager:ExecuteAnnouncement()
GuildManager:PrintBorder()
GuildManager:PrintAnnouncement()
GuildManager:PrintBorder()
GuildManager:LoadNextAnnouncement()
end

function GuildManager:LoadNextAnnouncement()
if announcementskip~=1 then
GuildManager.db.profile.lastanntime=GuildManager:GetTime()
end
GuildManager.db.profile.lastannounced=GuildManager.db.profile.announcenext
if GuildManager.db.profile.lastannounced==5 then 
nextinline=1
else
nextinline=GuildManager.db.profile.lastannounced+1
end
GuildManager.db.profile.announcenext=nextinline
GuildManager:NextAnnouncementValid()
end