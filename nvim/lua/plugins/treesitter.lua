return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = false,
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
          "typescript",
          "javascript",
          "kotlin",
          "zig",
          "vim",
          "nix"
        },
        highlight = { enable = true },
        indent = { enable = false },
      })
    end
  }
}
