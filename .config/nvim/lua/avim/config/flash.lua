local M = {}

M.opts = { modes = { search = { enabled = false } } }

M.keys = {
  {
    "s",
    mode = { "n", "x", "o" },
    function()
      -- default options: exact mode, multi window, all directions, with a backdrop
      require("flash").jump()
    end,
    desc = "Flash",
  },
  {
    "S",
    mode = { "n", "o", "x" },
    function()
      -- show labeled treesitter nodes around the cursor
      require("flash").treesitter()
    end,
    desc = "Flash Treesitter",
  },
  {
    "r",
    mode = "o",
    function()
      -- jump to a remote location to execute the operator
      require("flash").remote()
    end,
    desc = "Remote Flash",
  },
}

return M
