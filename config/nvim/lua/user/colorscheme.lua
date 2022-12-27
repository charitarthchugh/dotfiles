vim.cmd [[
try
  colorscheme adwaita
 catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
