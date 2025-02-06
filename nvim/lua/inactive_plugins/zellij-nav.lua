return {
    {
        "swaits/zellij-nav.nvim",
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<C-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "navigate left or tab"  } },
            { "<C-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down"  } },
            { "<C-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up"    } },
            { "<C-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" } },
        },
        opts = {},
    }
}

