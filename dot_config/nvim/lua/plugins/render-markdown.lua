local rendermarkdown = {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "MeanderingProgrammer/markdown.nvim" },
  },
  config = function()
    require("render-markdown").setup({})
  end,
  ft = { "markdown" },
}

return rendermarkdown
