# GTNH-OC-Teleposer-Control

## Content

- [Information](#information)
- [How to add Teleposition Focus](#how-to-add-teleposition-focus)
- [Installation](#installation)
- [Setup](#setup)
- [Configuration](#configuration)

<a id="information"></a>

## Information

The program is designed to automate the transfer of Teleposition Focus to Teleposer from Blood Magic.
It is also possible to send messages to Discord about out of service situations.
And there is also the possibility of auto update at startup.

#### Controls

<kbd>Q</kbd> - Closing the program

#### Interface

![Interface](/docs/interface.png)

<a id="how-to-add-teleposition-focus"></a>

## How to add Teleposition Focus

To add new Teleposition Focuses, put them in the chest, 
go into the monitor and press <kbd>S</kbd> 
to update the list. Note: the name that appears in the 
list corresponds to the name of the Teleposition Focus. Use the anvil to change it.

![Teleposition Focus in chest](/docs/chest.png)

<a id="installation"></a>

## Installation

> [!CAUTION]
> If you are using 8 java, the installer will not work for you. 
> The only way to install the program is to manually transfer it to your computer.
> The problem is on the java side.

To install program, you need a computer with:
- Graphics Card (Tier 3): 1
- Central Processing Unit (CPU) (Tier 3): 1
- Memory (Tier 3.5): 2
- Hard Disk Drive (Tier 3) (4MB): 1
- EEPROM (Lua BIOS): 1
- Internet Card: 1

![Computer setup](/docs/computer.png)

Install the basic Open OS on your computer.
Then run the command to start the installer.

```shell
pastebin run ESUAMAGx
``` 

Then select the Teleposer Control program in the installer.
If you wish you can add the program to auto download, for manual start write a command.

```shell
main
```

> [!NOTE]  
> For convenient configuration you can use the web configurator.
> [GTNH-OC-Web-Configurator](https://navatusein.github.io/GTNH-OC-Web-Configurator/#/configurator?url=https%3A%2F%2Fraw.githubusercontent.com%2FNavatusein%2FGTNH-OC-Teleposer-Control%2Frefs%2Fheads%2Fmain%2Fconfig-descriptor.yml)

<a id="setup"></a>

## Setup

#### Components

To build a setup, you will need:
- Transposer: 1
- Redstone I/O: 1

#### Description

Set the transposer next to it with a chest for Teleposition Focuses and Teleposer. 
Set the redstone I/O next to the Teleposer.

#### Example setup

![Example setup 1](/docs/setup-1.png)
![Example setup 2](/docs/setup-2.png)

<a id="configuration"></a>

## Configuration

> [!NOTE]  
> For convenient configuration you can use the web configurator.
> [GTNH-OC-Web-Configurator](https://navatusein.github.io/GTNH-OC-Web-Configurator/#/configurator?url=https%3A%2F%2Fraw.githubusercontent.com%2FNavatusein%2FGTNH-OC-Teleposer-Control%2Frefs%2Fheads%2Fmain%2Fconfig-descriptor.yml)

General configuration in file `config.lua`
Enable auto update when starting the program.

```lua
enableAutoUpdate = true, -- Enable auto update on start
```

In the `timeZone` field you can specify your time zone.

In the `discordWebhookUrl` field, you can specify the Discord Webhook link so that the program sends messages to the discord about emergency situations.
[How to Create a Discord Webhook?](https://www.svix.com/resources/guides/how-to-make-webhook-discord/)

```lua
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
```

In the `teleposerSide` field you specify side of the transposer witch connected to teleposer.

In the `storageSide` field you specify side of the transposer witch connected storage chest.

In the `redstoneSide` field you specify side of the Redstone I/O witch connected to teleposer.

```lua
teleposer = teleposer:newFormConfig({
  teleposerSide = sides.east, -- Side of the transposer witch connected to teleposer
  storageSide = sides.up, -- Side of the transposer witch connected storage chest
  redstoneSide = sides.up -- Side of the Redstone I/O witch connected to teleposer
})
```