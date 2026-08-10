return {
  "lewis6991/satellite.nvim",
  event = "BufReadPost",
  opts = {
    current_only = false,
    winblend = 50,
    zindex = 40,
    excluded_filetypes = {
      "neo-tree",
      "snacks_picker_list",
      "snacks_layout_box",
      "NeogitStatus",
      "NeogitCommitMessage",
      "lazy",
      "mason",
      "help",
    },
    handlers = {
      cursor = { enable = true },
      search = { enable = true },
      diagnostic = { enable = true, signs = { "-", "=", "≡" }, min_severity = vim.diagnostic.severity.HINT },
      gitsigns = {
        enable = true,
        signs = { add = "│", change = "│", delete = "-" },
      },
      marks = { enable = true, show_builtins = false },
      quickfix = { signs = { "-", "=", "≡" } },
    },
  },
}
