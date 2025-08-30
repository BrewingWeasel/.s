vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true

vim.o.winborder = "single"

vim.opt.swapfile = false

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true
vim.opt.termguicolors = true


vim.pack.add({
	-- { src = "https://github.com/everviolet/nvim", name = "evergarden" },
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine"
	},

	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",          version = "master" },

	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/echasnovski/mini.clue" },
	{ src = "https://github.com/saghen/blink.cmp" },

	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

vim.cmd.colorscheme("rose-pine-moon")

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"gleam",
		"fish",
	},
	highlight = {
		enable = true
	},
	indent = {
		enable = true
	},
})

vim.api.nvim_create_autocmd('PackChanged', {
	desc = 'Handle nvim-treesitter updates',
	group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
	callback = function(event)
		if event.data.kind == 'update' then
			vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
			---@diagnostic disable-next-line: param-type-mismatch
			local ok = pcall(vim.cmd, 'TSUpdate')
			if ok then
				vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
			else
				vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
			end
		end
	end,
})

require("mason").setup()
require("mason-lspconfig").setup()
require('mason-tool-installer').setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"biome",
		"basedpyright",
		"ruff",
	}
})

vim.lsp.enable({
	"lua_ls", "gleam", "vtsls", "biome", "basedpyright",
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true)
			}
		}
	}
})

local bind = vim.keymap.set

bind("n", "<leader>cf", vim.lsp.buf.format)
bind("n", "<leader>cr", vim.lsp.buf.rename)
bind("n", "<leader>ca", vim.lsp.buf.code_action)

vim.diagnostic.config({ virtual_text = true, severity_sort = true, signs = false })

require("blink.cmp").setup({
	keymap = { preset = 'enter' },
	fuzzy = {
		prebuilt_binaries = {
			force_version = "v1.6.0"
		}
	}
})

local win_config = function()
	local height = math.floor(0.3 * vim.o.lines)
	local width = math.floor(0.4 * vim.o.columns)
	return {
		anchor = 'NW',
		height = height,
		width = width,
		row = math.floor(0.5 * (vim.o.lines - height)),
		col = math.floor(0.5 * (vim.o.columns - width)),
	}
end

require('mini.pick').setup({
	window = { config = win_config }
})

vim.ui.select = MiniPick.ui_select

bind("n", "<leader><space>", ":Pick files<CR>")
bind("n", "<leader>bf", ":Pick buffers<CR>")
bind("n", "<leader>bn", ":bnext<CR>")


local miniclue = require('mini.clue')
miniclue.setup({
	triggers = {
		-- Leader triggers
		{ mode = 'n', keys = '<Leader>' },
		{ mode = 'x', keys = '<Leader>' },

		-- Built-in completion
		{ mode = 'i', keys = '<C-x>' },

		-- `g` key
		{ mode = 'n', keys = 'g' },
		{ mode = 'x', keys = 'g' },

		-- Marks
		{ mode = 'n', keys = "'" },
		{ mode = 'n', keys = '`' },
		{ mode = 'x', keys = "'" },
		{ mode = 'x', keys = '`' },

		-- Registers
		{ mode = 'n', keys = '"' },
		{ mode = 'x', keys = '"' },
		{ mode = 'i', keys = '<C-r>' },
		{ mode = 'c', keys = '<C-r>' },

		-- Window commands
		{ mode = 'n', keys = '<C-w>' },

		-- `z` key
		{ mode = 'n', keys = 'z' },
		{ mode = 'x', keys = 'z' },
	},

	clues = {
		-- Enhance this by adding descriptions for <Leader> mapping groups
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},

	window = {
		delay = 150,
		config = {
			width = "auto",
		},
	}
})
