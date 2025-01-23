local programLib = require("lib.program-lib")
local consoleLib = require("lib.console-lib")

package.loaded.config = nil
local config = require("config")

local version = require("version")

local repository = "Navatusein/GTNH-OC-Teleposer-Control"
local archiveName = "TeleposerControl"

local program = programLib:new(config.logger, config.enableAutoUpdate, version, repository, archiveName)
local console = consoleLib:new()

local logo = {
  " _____    _                                   ____            _             _ ",
  "|_   _|__| | ___ _ __   ___  ___  ___ _ __   / ___|___  _ __ | |_ _ __ ___ | |",
  "  | |/ _ \\ |/ _ \\ '_ \\ / _ \\/ __|/ _ \\ '__| | |   / _ \\| '_ \\| __| '__/ _ \\| |",
  "  | |  __/ |  __/ |_) | (_) \\__ \\  __/ |    | |__| (_) | | | | |_| | | (_) | |",
  "  |_|\\___|_|\\___| .__/ \\___/|___/\\___|_|     \\____\\___/|_| |_|\\__|_|  \\___/|_|",
  "                |_|  ",
}

local function init()
  config.teleposer:scanTelepositionFocuses()
end

local function loop()
  local _, height = console:getResolution()
  local pageSize = height - 5
  local page = 0

  while true do
    console:clear()

    local pageCount = math.floor(#config.teleposer.telepositionFocuses / pageSize) + 1
    local elementsOnPage = math.min(pageSize, #config.teleposer.telepositionFocuses - (page * pageSize))
    local first = math.floor((page * pageSize) + 1)
    local last = math.floor(first + elementsOnPage - 1)

    for i = first, last, 1 do
      console:writeLine("["..i.."] "..config.teleposer.telepositionFocuses[i].name)
    end

    console:writeLine("")
    console:writeLine("Enter ["..first.."-"..last.."] teleposition focus index")
    console:writeLine("Enter [p1-p"..pageCount.."] to select page")
    console:writeLine("Enter [s] to scan teleposition focuses")

    local reader = console:createReader()

    reader.conditions.index = console:createCondition()
    reader.conditions.index.userInputToNumber = true
    reader.conditions.index.condition = function(userInput)
      return userInput >= 0 and userInput <= #config.teleposer.telepositionFocuses
    end
    reader.conditions.index.callback = function(userInput)
      config.teleposer:teleport(assert(tonumber(userInput)))
    end

    reader.conditions.page = console:createCondition()
    reader.conditions.page.userInputToLower = true
    reader.conditions.page.condition = function(userInput)
      local page = string.match(userInput, "^p(%d+)$")
      page = tonumber(page)
      return page ~= nil and page > 0 and page <= pageCount
    end
    reader.conditions.page.callback = function(userInput)
      page = string.match(userInput, "^p(%d+)$") - 1
    end

    reader.conditions.scan = console:createCondition()
    reader.conditions.scan.userInputToLower = true
    reader.conditions.scan.condition = function(userInput)
      return userInput == "s"
    end
    reader.conditions.scan.callback = function(userInput)
      config.teleposer:scanTelepositionFocuses()
    end

    console:read(reader)
  end
end

program:registerLogo(logo)
program:registerInit(init)
program:registerThread(loop)
program:start()