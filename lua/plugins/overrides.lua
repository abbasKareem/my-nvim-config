-- Override LazyVim keymaps to free up <leader>f for buffer switching
-- Disable all <leader>f* (find/file) lazy key triggers from snacks.nvim
-- The actual keymap deletion + rebinding happens in config/keymaps.lua
return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader>fb", false },
      { "<leader>fB", false },
      { "<leader>fn", false },
      { "<leader>fr", false },
      { "<leader>fR", false },
      { "<leader>fc", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fg", false },
      { "<leader>fp", false },
      { "<leader>ft", false },
      { "<leader>fT", false },
    },
  },
}
