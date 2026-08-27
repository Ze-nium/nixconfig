{ pkgs, ... }:
pkgs.neovim.override {
  configure = {
    packages.myPlugins = with pkgs.vimPlugins; {
      start = [ 
        nvim-treesitter.withAllGrammars 
        nvim-lspconfig 
        telescope-nvim 
        blink-cmp 
        # cmp-nvim-lsp
        luasnip
        nvim-treesitter-parsers.yuck
        nvim-autopairs
        parinfer-rust
        nvim-tree-lua
      ];
    };
    customRC = ''
      source /home/kian/.config/nvim/init.lua
    '';
  };
}
