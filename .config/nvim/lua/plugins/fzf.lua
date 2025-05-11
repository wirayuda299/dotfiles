return {
   "ibhagwan/fzf-lua",
   opts = {
      previewers = {
         builtin = {
            syntax_limit_b = 1024 * 100,    -- 100KB
         },
      },
      winopts = {
         height = 0.35,
         width = 0.80,
         preview = {
            hidden = "hidden",
            layout = "vertical",
         },
      },
      fzf_opts = {
         ["--ansi"] = "",
         ["--prompt"] = "🔍 ",
      },
   },
}
