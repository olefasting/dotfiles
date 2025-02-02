return {
  {
    "swaits/zellij-nav.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<A-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "navigate left or tab"  } },
      { "<A-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down"  } },
      { "<A-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up"    } },
      { "<A-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" } },
    },
    opts = {},
  }
}

