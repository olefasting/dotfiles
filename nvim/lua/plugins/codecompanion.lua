return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          llama3 = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "llama3",
              env = {
                url = "http://localhost:11434",
                -- api_key = "OLLAMA_API_KEY",
              },
              headers = {
                ["Content-Type"] = "application/json",
                -- ["Authorization"] = "Bearer ${api_key}",
              },
              parameters = {
                sync = true,
              },
              schema = {
                model = {
                  default = "deepseek-coder-v2:latest",
                },
                num_ctx = {
                  default = 16384,
                },
                num_predict = {
                  default = -1,
                },
              },
            })
          end,
        },
      })
    end
  }
}
