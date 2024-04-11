return {
	{
		"copilot-cmp",
		enabled = false,
	},
	{
		"copilot.lua",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
			},
			panel = { enabled = true },

			filetypes = {
				gitcommit = true,
				yaml = true,
				["*"] = true,
			},
		},
	},
}
