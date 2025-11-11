local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end
return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    require("gruvbox").setup()
    vim.o.background = "dark"
    enable_transparency()
    vim.cmd([[colorscheme gruvbox]])
  end
}
