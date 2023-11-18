return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim", "laher/neorg-exec" },
  lazy = true,
  cmd = { "Neorg" },
  ft = { "norg" },
  config = function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.summary"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
          },
        },
        ["external.exec"] = {}
      },
    }
  end,
}
