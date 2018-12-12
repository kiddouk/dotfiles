
local spaces = require "hs._asm.undocumented.spaces"
local grid = require "hs.grid"

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

    
local hyper = {"cmd", "shift", "alt", "ctrl"}


grid.GRIDHEIGHT = 3
grid.GRIDWIDTH = 6

grid.MARGINX = 0
grid.MARGINY = 0

gridKeys = {
  { 1,   2,   3,   4,   5,   6,   7 },
  {"q", "w", "e", "r", "t", "y", "u"},
  {"a", "s", "d", "f", "g", "h", "j"},
  {"z", "x", "c", "v", "b", "n", "m"}
}

hs.hotkey.bind(hyper, "g", grid.show)


-- get ids of spaces in same layout as mission control has them (hopefully)
local getSpacesIdsTable = function()
  local spacesLayout = spaces.layout()
  local spacesIds = {}

  hs.fnutils.each(hs.screen.allScreens(), function(screen)
    local spaceUUID = screen:spacesUUID()

    local userSpaces = hs.fnutils.filter(spacesLayout[spaceUUID], function(spaceId)
      return spaces.spaceType(spaceId) == spaces.types.user
    end)

    hs.fnutils.concat(spacesIds, userSpaces or {})
  end)

  return spacesIds
end


local throwToSpace = function(win, spaceIdx)
  local spacesIds = getSpacesIdsTable()
  local spaceId = spacesIds[spaceIdx]

  spaces.moveWindowToSpace(win:id(), spaceId)
end

status = hs.menubar.new()

function setModeDisplay(state)
   status:setTitle(state)
end



--- Move an app to a specific space. We are using undocumented API for that.
function moveAppToSpace(appName, space)
   local app = hs.application.find(appName)
   if app then
      for _, window in pairs(app:allWindows()) do
         throwToSpace(window, space)
      end
   end
end


local function coderMode()
   local laptopScreen = "Color LCD"
   local windowLayout = {
      {"iTerm2", nil, laptopScreen, hs.layout.left50, nil, nil},
      {"Emacs", nil, laptopScreen, hs.layout.right50, nil, nil},
   }

   hs.layout.apply(windowLayout)

   moveAppToSpace("Firefox", 1)
   moveAppToSpace("Whatsapp", 2)
   setModeDisplay("coder")
end



--- music
local function playPauseMpsYoutube()
    --- we encode the payload properly
    local command = hs.json.encode({command={"keypress", "space"}})
    local exec = 'echo \'' .. command
    exec = exec .. '\''

    --- we retrieve which sock mpv has opened
    local socket = hs.execute("ps a | grep mpv | grep -v grep | head -1 | sed 's/.*input-ipc-server=\\(.*\\).*/\\1/' | tr -d '\n'")
    exec = exec .. " | /usr/local/bin/socat - "
    exec = exec .. socket

    --- we execute the command and pray
    local output, status, type, rc = os.execute(exec)
    hs.alert("Youtube play/pause")
end
    
hs.hotkey.bind(hyper, "m", playPauseMpsYoutube)

--- Mode
hs.hotkey.bind(hyper, "c", coderMode)

-- Application launcher
hs.hotkey.bind(hyper, "f", function()
                  hs.application.launchOrFocus("Firefox")
                  end )

-- Application hints
hs.hints.style = "vimperator"
hs.hints.showTitleThresh = 0
hs.hotkey.bind(hyper, "h", function()
                  hs.hints.windowHints()
end)

-- Away from computer
hs.hotkey.bind(hyper, "l", hs.caffeinate.lockScreen)


