{ ... }:
{
  imports = [
    ./bufremove.nix
    ./flash.nix
    ./gitsigns.nix
    ./illuminate.nix
    ./neotree.nix
    ./spectre.nix
    ./symbols-outline.nix
    ./telescope.nix
    ./todo-comments.nix
    ./trouble.nix
    ./which-key.nix
    ./barbecue.nix
    ./toggleterm.nix
    ./ccc.nix
  ];

  programs.nixvim.extraConfigLuaPre = ''
    Root = setmetatable({}, {
      __call = function(m)
        return m.get()
      end,
    })
    Root.cache = {}
    Root.detectors = {}

    Root.spec = { "lsp", { ".git", "lua" }, "cwd" }

    function Root.norm(path)
      if path:sub(1, 1) == "~" then
        local home = vim.loop.os_homedir()
        if home:sub(-1) == "\\" or home:sub(-1) == "/" then
          home = home:sub(1, -2)
        end
        path = home .. path:sub(2)
      end
      path = path:gsub("\\", "/"):gsub("/+", "/")
      return path:sub(-1) == "/" and path:sub(1, -2) or path
    end

    function Root.realpath(path)
      if path == "" or path == nil then
        return nil
      end
      path = vim.loop.fs_realpath(path) or path
      return Root.norm(path)
    end

    function Root.bufpath(buf)
      return Root.realpath(vim.api.nvim_buf_get_name(assert(buf)))
    end

    function Root.detectors.pattern(buf, patterns)
      patterns = type(patterns) == "string" and { patterns } or patterns
      local path = Root.bufpath(buf) or vim.loop.cwd()
      local pattern = vim.fs.find(patterns, { path = path, upward = true })[1]
      return pattern and { vim.fs.dirname(pattern) } or {}
    end

    function Root.resolve(spec)
      if Root.detectors[spec] then
        return Root.detectors[spec]
      elseif type(spec) == "function" then
        return spec
      end
      return function(buf)
        return Root.detectors.pattern(buf, spec)
      end
    end

    function Root.detect(opts)
      opts = opts or {}
      opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or Root.spec
      opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

      local ret = {} ---@type LazyRoot[]
      for _, spec in ipairs(opts.spec) do
        local paths = Root.resolve(spec)(opts.buf)
        paths = paths or {}
        paths = type(paths) == "table" and paths or { paths }
        local roots = {} ---@type string[]
        for _, p in ipairs(paths) do
          local pp = Root.realpath(p)
          if pp and not vim.tbl_contains(roots, pp) then
            roots[#roots + 1] = pp
          end
        end
        table.sort(roots, function(a, b)
          return #a > #b
        end)
        if #roots > 0 then
          ret[#ret + 1] = { spec = spec, paths = roots }
          if opts.all == false then
            break
          end
        end
      end
      return ret
    end

    function Root.get(opts)
      local buf = vim.api.nvim_get_current_buf()
      local ret = Root.cache[buf]
      if not ret then
        local roots = Root.detect({ all = false })
        ret = roots[1] and roots[1].paths[1] or vim.loop.cwd()
        Root.cache[buf] = ret
      end
      if opts and opts.normalize then
        return ret
      end
      return ret
    end
  '';
}
