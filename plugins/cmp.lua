return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")

    -- 1. Pas de sélection automatique
    opts.preselect = cmp.PreselectMode.None
    opts.completion = {
      completeopt = "menu,menuone,noinsert,noselect",
      autocomplete = { cmp.TriggerEvent.TextChanged }, -- on garde l’autocomplétion, mais filtrée plus bas
    }

    -- Filtre : activer la complétion uniquement si le caractère avant est une lettre ou underscore
    opts.enabled = function()
      local col = vim.fn.col(".") - 1
      if col <= 0 then
        return true
      end

      local char = vim.fn.getline("."):sub(col, col)
      return char:match("[%a_]") ~= nil
    end

    -- Mappings personnalisés
    opts.mapping = {
      -- Tab : navigation dans le menu
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),

      -- ENTER : jamais confirmer → juste saut de ligne
      ["<CR>"] = function(fallback)
        fallback()
      end,

      -- SHIFT+ENTER : confirmer la complétion
      ["<S-CR>"] = cmp.mapping.confirm({ select = false }),
    }
  end,
}

-- return {
--   "hrsh7th/nvim-cmp",
--   opts = function(_, opts)
--     local cmp = require("cmp")
--
--     -- 1. Pas de sélection automatique
--     opts.preselect = cmp.PreselectMode.None
--     opts.completion = {
--       completeopt = "menu,menuone,noinsert,noselect",
--     }
--
--     local has_words_before = function()
--       local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--       return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--     end
--
--     opts.mapping = cmp.mapping.preset.insert({
--       -- TAB navigue dans le menu uniquement si visible
--       ["<Tab>"] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--           cmp.select_next_item()
--         else
--           fallback()
--         end
--       end, { "i", "s" }),
--
--       ["<S-Tab>"] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--           cmp.select_prev_item()
--         else
--           fallback()
--         end
--       end, { "i", "s" }),
--
--       -- ENTER confirme uniquement si un item est sélectionné
--       ["<CR>"] = cmp.mapping(function(fallback)
--         if cmp.visible() and cmp.get_selected_entry() then
--           cmp.confirm({ select = false })
--         else
--           fallback() -- retour à la ligne normal
--         end
--       end, { "i", "s" }),
--     })
--   end,
-- }
