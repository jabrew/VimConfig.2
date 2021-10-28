local M = {}

M.telescope = function()
  -- print("Mappings for telescope")
end

M.arpeggio = function()
  vim.fn['arpeggio#map']('i', '', 0, 'jk', '<Esc>')
  vim.fn['arpeggio#map']('c', '', 0, 'jk', '<C-c>')
  vim.fn['arpeggio#map']('v', '', 0, 'jk', '<Esc>')
  vim.fn['arpeggio#map']('o', '', 0, 'jk', '<Esc>')
end

return M
