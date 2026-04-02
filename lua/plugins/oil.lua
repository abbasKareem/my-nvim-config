return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
      },
      keymaps = {
        ["q"] = "actions.close",
      },
      float = {
        border = "rounded",
      },
    },
  },
}