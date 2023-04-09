local present, null_ls = pcall(require, "null-ls")
-- test
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes
  --b.diagnostics.rome,

  --shell
  b.formatting.beautysh,

  --python
  b.formatting.black,
  b.diagnostics.ruff,
  -- rust
  b.formatting.rustfmt,

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,
}



null_ls.setup {
  debug = true,
  sources = sources,
}
