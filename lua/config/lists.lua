local function get_list_cmd(next_cmd, prev_cmd)
  -- Check if location list is open in current window
  local loc_winid = vim.fn.getloclist(0, {winid = 0}).winid
  if loc_winid ~= 0 then
    return next_cmd == "next" and "lnext" or "lprev"
  end
  
  -- Check if quickfix is open
  local qf_winid = vim.fn.getqflist({winid = 0}).winid
  if qf_winid ~= 0 then
    return next_cmd == "next" and "cnext" or "cprev"
  end
  
  -- Default to quickfix if neither is visible
  return next_cmd == "next" and "cnext" or "cprev"
end

local function smart_next()
  local cmd = get_list_cmd("next")
  local ok = pcall(vim.cmd, cmd)
  if ok then
    vim.cmd("normal! zz")
  end
end

local function smart_prev()
  local cmd = get_list_cmd("prev")
  local ok = pcall(vim.cmd, cmd)
  if ok then
    vim.cmd("normal! zz")
  end
end

vim.keymap.set("n", "<M-j>", smart_next, { desc = "Next item (smart)" })
vim.keymap.set("n", "<M-k>", smart_prev, { desc = "Prev item (smart)" })