-- music_player

--[[ local sample_backend = {
  play/pause
  next_song
  prev_song
  current_song
} 
--]] 
local api = vim.api
local current_backend = nil


vim.cmd [[ command! MPNext lua require'music_player'.backend().next_song(require'music_player'.backend()) ]]
vim.cmd [[ command! MPToggle lua require'music_player'.backend().play_pause(require'music_player'.backend()) ]]
vim.cmd [[ command! MPPrev lua require'music_player'.backend().prev_song(require'music_player.backend()) ]]

local function update_buf(buf, lines)
  table.insert(lines, "Press <Enter> for toggling between play and pause")
  table.insert(lines, "Press <n> for next song")
  table.insert(lines, "Press <p> for previous song")
  api.nvim_buf_set_option(buf, 'modifiable', true)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines) 
  api.nvim_buf_set_option(buf, 'modifiable', false)
end


local function create_control_buffer(backend)
  local buf = api.nvim_create_buf(true, false)
  api.nvim_buf_set_name(buf, 'MusicPlayerController')
  api.nvim_buf_set_option(buf, 'modifiable', false)
  api.nvim_buf_set_option(buf, 'buftype', 'nowrite')

  current_backend = backend 
  -- Set keymaps
  api.nvim_buf_set_keymap(buf, 'n', 'n', '<cmd>lua require"music_player".backend().next_song(require"music_player".backend())<CR>', {})
  api.nvim_buf_set_keymap(buf, 'n', 'p', '<cmd>lua require"music_player".backend().prev_song(require"music_player".backend())<CR>', {})
  api.nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>lua require"music_player".backend().play_pause(require"music_player".backend())<CR>', {})
  
  backend.updater = function(lines)
    update_buf(buf, lines) 
  end
  -- Set initial information
  update_buf(buf, {
    backend:current_song(),
  })
end

return {
  new = create_control_buffer,
  backend = function()
    return current_backend
  end
}
