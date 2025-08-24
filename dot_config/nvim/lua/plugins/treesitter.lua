return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      ensure_installed = { "lua", "cpp", "python", "java", "zig", "rust", "markdown", "markdown_inline" }, -- Add other languages you use
      highlight = { enable = true },
    })
  end,
}
