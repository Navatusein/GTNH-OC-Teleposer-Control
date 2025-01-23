local sides = require("sides")

local loggerLib = require("lib.logger-lib")
local discordLoggerHandler = require("lib.logger-handler.discord-logger-handler-lib")
local fileLoggerHandler = require("lib.logger-handler.file-logger-handler-lib")

local teleposer = require("src.teleposer")

local config = {
  enableAutoUpdate = true, -- Enable auto update on start

  logger = loggerLib:newFormConfig({
    name = "Teleposer Control",
    timeZone = 3, -- Your time zone
    handlers = {
      discordLoggerHandler:newFormConfig({
        logLevel = "warning",
        messageFormat = "{Time:%d.%m.%Y %H:%M:%S} [{LogLevel}]: {Message}",
        discordWebhookUrl = "" -- Discord Webhook URL
      }),
      fileLoggerHandler:newFormConfig({
        logLevel = "info",
        messageFormat = "{Time:%d.%m.%Y %H:%M:%S} [{LogLevel}]: {Message}",
        filePath = "logs.log"
      })
    }
  }),

  teleposer = teleposer:newFormConfig({
    teleposerSide = sides.east, -- Side of the transposer witch connected to teleposer
    storageSide = sides.up, -- Side of the transposer witch connected storage chest
    redstoneSide = sides.up -- Side of the Redstone I/O witch connected to teleposer
  })
}

return config