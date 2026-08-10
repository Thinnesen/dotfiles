local function refresh_explorer_git()
  local ok_git, git = pcall(require, "snacks.explorer.git")
  local ok_watch, watch = pcall(require, "snacks.explorer.watch")
  if not (ok_git and ok_watch) then
    return
  end
  local cwd = vim.uv.cwd()
  if cwd then
    git.refresh(cwd)
  end
  watch.refresh()
end

return {
  "folke/snacks.nvim",
  opts = {
    input = { enabled = true },
    picker = {
      ui_select = true,
      sources = {
        explorer = {
          hidden = true,
          ignored = false,
        },
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = {
        "NeogitPushComplete",
        "NeogitCommitComplete",
        "NeogitStatusRefreshed",
        "NeogitPullComplete",
        "NeogitFetchComplete",
      },
      callback = refresh_explorer_git,
    })
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = refresh_explorer_git,
    })
  end,
}
