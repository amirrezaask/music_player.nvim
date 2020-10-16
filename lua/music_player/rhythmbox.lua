local fn = vim.fn
local music_player = require'music_player'

local Rhythmbox = {
  updater = nil,
  base_cmd = '! rhythmbox-client --no-start',
  play_pause = function(self)
    fn.execute(string.format('%s --play-pause', self.base_cmd))
  end,
  current_song = function(self)
    local cmd = string.format([[%s --print-playing-format \%%tt]], self.base_cmd)
    local output = fn.execute(cmd)
    output = vim.split(output, '\n')
    return output[#output - 1]
  end,
  next_song = function(self)
    fn.execute(string.format('%s --next', self.base_cmd))
    self.updater({self:current_song()})
  end,
  prev_song = function(self)
    fn.execute(string.format('%s --previous', self.base_cmd))
    self.updater({self:current_song()})
  end
}

return Rhythmbox
