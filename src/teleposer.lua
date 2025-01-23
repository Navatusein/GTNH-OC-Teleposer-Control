local component = require("component")

---@class TeleposerConfig
---@field teleposerSide number
---@field storageSide number
---@field redstoneSide number

local teleposer = {}

---Crate new Teleposer object from config
---@param config TeleposerConfig
---@return Teleposer
function teleposer:newFormConfig(config)
  return self:new(config.teleposerSide, config.storageSide, config.redstoneSide)
end

---Crate new Teleposer object
---@param teleposerSide number
---@param storageSide number
---@param redstoneSide number
---@return Teleposer
function teleposer:new(teleposerSide, storageSide, redstoneSide)

  ---@class Teleposer
  local obj = {}

  obj.transposerProxy = component.transposer
  obj.teleposerSide = teleposerSide
  obj.storageSide = storageSide
  obj.redstoneProxy = component.redstone
  obj.redstoneSide = redstoneSide

  obj.telepositionFocuses = {}

  ---Scan for new teleposition focuses in the storage
  function obj:scanTelepositionFocuses()
    self.telepositionFocuses = {}

    local slots = self.transposerProxy.getAllStacks(self.storageSide).getAll()

    for index, value in pairs(slots) do
      if next(value) ~= nil then
        table.insert(self.telepositionFocuses, {name = value.label, slot = index})
      end
    end
  end

  ---Teleport using selected teleposition focus
  ---@param index number
  function obj:teleport(index)
    self.transposerProxy.transferItem(self.storageSide, self.teleposerSide, 1, self.telepositionFocuses[index].slot + 1)
    self.redstoneProxy.setOutput(self.redstoneSide, 15)

    self.transposerProxy.transferItem(self.teleposerSide, self.storageSide, 1, 1, self.telepositionFocuses[index].slot + 1)
    self.redstoneProxy.setOutput(self.redstoneSide, 0)
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return teleposer