return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "ollama",
          },
          inline = {
            adapter = "ollama",
          },
          agent = {
            adapter = "ollama",
          },
        },
        opts = {
          log_level = "TRACE"
        }
      }) 
		  vim.keymap.set("n", "<CS-a>", ":CodeCompanionActions<CR>", {})
		  vim.keymap.set("n", "<CS-s>", ":CodeCompanionChat<CR>", {})
    end
  }
}
