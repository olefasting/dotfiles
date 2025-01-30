return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        default_integrations = true,
        integrations = {
          alpha = true,
          gitsigns = true,
          neotree = true,
          treesitter = true,
          fzf = true,
          dashboard = true,
        }
      })

      vim.cmd.colorscheme("catppuccin-mocha")
    end
  }
}
