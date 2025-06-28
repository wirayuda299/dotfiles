return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    event = "VeryLazy",
    keys = {
        { "zm", function() require("ufo").closeAllFolds() end, desc = "󱃄 Close All Folds" },
        {
            "zr",
            function()
                require("ufo").openFoldsExceptKinds { "comment", "imports" }
                vim.opt.scrolloff = vim.g.baseScrolloff -- fix scrolloff setting sometimes being off
            end,
            desc = "󱃄 Open All Regular Folds"
        },
        { "zR", function() require("ufo").openFoldsExceptKinds {} end, desc = "󱃄 Open All Folds" },
        { "z1", function() require("ufo").closeFoldsWith(1) end, desc = "󱃄 Close L1 Folds" },
        { "z2", function() require("ufo").closeFoldsWith(2) end, desc = "󱃄 Close L2 Folds" },
        { "z3", function() require("ufo").closeFoldsWith(3) end, desc = "󱃄 Close L3 Folds" },
        { "z4", function() require("ufo").closeFoldsWith(4) end, desc = "󱃄 Close L4 Folds" },
        -- stylua: ignore end
    },
    opts = function()
        return require("config.ui.fold")
    end,
    init = function()
        vim.o.foldcolumn = "0" -- '0' is not bad
        vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
}
