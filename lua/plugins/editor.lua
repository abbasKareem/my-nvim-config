return {
  -- Colorscheme: VS Code theme
  {
    "askfiy/visual_studio_code",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("visual_studio_code")
    end,
  },

  -- Zen mode (VS Code: z → toggle zen mode)
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = { width = 0.85 },
    },
  },

  -- Formatters (VS Code: editor.formatOnSave with prettier)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        svg = { "prettier" },
        go = { "gofmt" },
        lua = { "stylua" },
        csharp = { "csharpier" },
      },
    },
  },

  -- Treesitter (languages matching VS Code extensions)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        "html",
        "css",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "python",
        "c_sharp",
        "sql",
        "markdown",
        "markdown_inline",
      },
    },
  },

  -- Bufferline: always show tabs (VS Code-like tab bar)
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },

  -- Emmet for HTML/JSX (VS Code: Ctrl+w → wrap, Ctrl+q → remove tag)
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-e>"
      -- Ctrl+w → Emmet wrap with abbreviation (in supported filetypes)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
        callback = function()
          vim.keymap.set("v", "<C-w>", "<Plug>(emmet-code-pretty)", { buffer = true, desc = "Emmet wrap" })
        end,
      })
    end,
  },

  -- Go development (LSP, debug, test, refactor — replaces bare gopls setup)
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gowork", "gotmpl" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      -- Use gopls (installed via mason below)
      lsp_cfg = true,
      lsp_gofumpt = true,
      lsp_on_attach = true,
      -- Disable go.nvim's own keymaps (they override our <leader>e, <C-k>, etc.)
      lsp_keymaps = false,
      -- Format on save via gopls/gofumpt
      lsp_format_on_save = true,
      -- Diagnostic virtual text
      diagnostic = { hdlr = true, underline = true },
      -- Test output in a floating window
      test_runner = "go",
      run_in_floaterm = false,
    },
  },

  -- Ensure Go tools are installed via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gopls", "gofumpt", "golines", "delve" })
    end,
  },

  -- LazyVim extras already provide:
  -- flash.nvim    → vim.sneak + vim.easymotion (use 's' to jump)
  -- mini.surround → vim.surround (sa/sd/sr to add/delete/replace surrounds)
  -- mini.pairs    → auto-pairs
  -- neo-tree      → file explorer (<leader>e)
  -- telescope     → fuzzy finder
  -- which-key     → key hints
  -- gitsigns      → git decorations
  -- lualine       → statusline
}
