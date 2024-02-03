version = "0.21.5"

-- Install xplr's plugin manager

local home = os.getenv("XDG_CONFIG_HOME")
local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path .. ";"
               .. xpm_path .. "/?.lua;"
               .. xpm_path .. "/?/init.lua;"
               .. home .. "/xplr/?/init.lua;"

os.execute(
  string.format(
    "[ -e '%s' ] || git clone '%s' '%s'",
    xpm_path,
    xpm_url,
    xpm_path
  )
)

require("xpm").setup({
  plugins = {
    -- Let xpm manage itself
    'dtomvan/xpm.xplr',
    { name = 'sayanarijit/fzf.xplr' },
    { name = 'dtomvan/ouch.xplr' },
    { name = 'sayanarijit/preview-tabbed.xplr' },
    { name = 'sayanarijit/zentable.xplr' }
  },
  auto_install = true,
  auto_cleanup = true,
})

-- Run plugins setups
require("preview-tabbed").setup{
  mode = "action",
  key = "P",
  fifo_path = "/tmp/xplr.fifo",
  previewer = os.getenv("HOME") .. "/.config/nnn/plugins/preview-tabbed",
}

require("zentable").setup()

-- Run custom config
require("ui").setup()


