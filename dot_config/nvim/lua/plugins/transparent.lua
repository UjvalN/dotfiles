return {
  "xiyaowong/transparent.nvim",
  lazy = false, -- Load on startup
  config = function()
    require("transparent").setup({
      -- You can add extra highlight groups if needed
      extra_groups = {
        "NormalFloat", -- floating windows
        "NvimTreeNormal", -- if using nvim-tree
        "NeoTreeNormal", -- if using neo-tree
        "NormalNC", -- unfocused windows
        "TelescopeNormal", -- telescope
        "TelescopeBorder",
      },
    })
    vim.cmd("TransparentEnable")
  end,
}
