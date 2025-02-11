return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        ensure_installed = {
          "bash",
          "ruby",
          "html",
          "css",
          "scss",
          "javascript",
          "typescript",
          "json",
          "lua",
          "yaml",
          "rust",
          "go",
          "elixir",
          "json",
          "c",
          "cpp",
          "llvm",
          "latex",
          "lua",
          "typescript",
          "javascript",
          "kotlin",
          "zig",
          "vim",
          "nix",
          "julia",
          "rust",
          "latex",
          "markdown",
          "markdown_inline",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}
