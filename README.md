# Modular Neovim Configuration

A modern, modular Neovim configuration built on the Kickstart.nvim foundation, organized for maintainability and ease of customization.

## 📁 Project Structure

```
├── init.lua                     # Main entry point
└── lua/
    ├── config/                  # Core configuration modules
    │   ├── options.lua          # Vim options and settings
    │   ├── keymaps.lua          # Key mappings
    │   └── autocmds.lua         # Autocommands
    └── plugins/                 # Plugin configurations
        ├── avante.lua           # AI-powered coding assistant
        ├── colorscheme.lua      # OneDark theme
        ├── completion.lua       # nvim-cmp autocompletion
        ├── editor.lua           # Editor utilities
        ├── git.lua              # Git integration
        ├── lsp.lua              # Language Server Protocol
        ├── mcphub.lua           # Model Context Protocol
        ├── telescope.lua        # Fuzzy finder
        ├── treesitter.lua       # Syntax highlighting
        └── ui.lua               # User interface enhancements
```

## 🚀 Quick Start

### Prerequisites

- **Neovim** >= 0.9.0
- **Git** for plugin management
- **Node.js** and **npm** for some plugins
- **Make** for compiling native extensions
- **A Nerd Font** (optional, for icons)

### Installation

1. **Backup your existing configuration:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration:**
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Start Neovim:**
   ```bash
   nvim
   ```
   
   Lazy.nvim will automatically install all plugins on first launch.

4. **Install language servers:**
   ```
   :Mason
   ```
   Use Mason to install additional language servers as needed.

## 🛠️ Configuration Modules

### Core Configuration (`lua/config/`)

#### `options.lua`
- **Leader Keys**: `<Space>` as leader and local leader
- **Search**: Smart case-insensitive search, no highlight
- **UI**: Line numbers, sign column, true color support
- **Editing**: Smart indentation, persistent undo, clipboard sync
- **Performance**: Fast update times, optimized timeouts

#### `keymaps.lua`
- **Navigation**: Smart j/k movement respecting wrapped lines
- **Diagnostics**: `[d`/`]d` for navigation, `<leader>e` for float
- **Telescope**: Comprehensive fuzzy finding shortcuts
  - `<leader>sf` - Search files
  - `<leader>sg` - Live grep
  - `<leader>?` - Recent files
  - `<leader><space>` - Buffers

#### `autocmds.lua`
- **Visual Feedback**: Highlight yanked text
- **Code Quality**: Auto-format on save

### Plugin Configurations (`lua/plugins/`)

#### Language Support

**LSP (`lsp.lua`)**
- **Servers**: TypeScript, Deno, Lua, Tailwind CSS
- **Smart Detection**: Automatic Deno vs Node.js project detection
- **Key Features**: Go to definition, references, hover, rename
- **Auto-installation**: Mason manages server installations

**Completion (`completion.lua`)**
- **Sources**: LSP, snippets, buffer text
- **Smart Navigation**: Tab/Shift-Tab for completion and snippets
- **VS Code Snippets**: Automatic loading support

**Treesitter (`treesitter.lua`)**
- **Languages**: C, C++, Go, Lua, Python, Rust, TypeScript, TSX
- **Features**: Syntax highlighting, smart indentation, text objects
- **Navigation**: Function/class movement, incremental selection

#### Development Tools

**Telescope (`telescope.lua`)**
- **Fuzzy Finding**: Files, buffers, help, live grep
- **Performance**: FZF native algorithm for speed
- **Integration**: LSP symbols, diagnostics, Git files

**Git (`git.lua`)**
- **Fugitive**: Complete Git workflow integration
- **GitSigns**: Visual diff indicators in gutter
- **Navigation**: Hunk jumping and preview

#### AI & Modern Features

**Avante (`avante.lua`)**
- **AI Providers**: OpenRouter, Gemini, Groq, DeepSeek
- **Mode**: Agentic AI for autonomous task execution
- **Integration**: MCPHub for enhanced tool access
- **Features**: Code generation, refactoring, explanations

**MCPHub (`mcphub.lua`)**
- **Protocol**: Model Context Protocol for AI tool integration
- **Auto-approval**: Streamlined server connections
- **Extensibility**: Support for additional MCP servers

#### User Interface

**UI (`ui.lua`)**
- **Status Line**: Lualine with OneDark theme
- **Indentation**: Visual guides for code structure
- **Help**: Which-key for command discovery

**Theme (`colorscheme.lua`)**
- **OneDark**: Modern, eye-friendly dark theme
- **Priority Loading**: Ensures theme loads before other plugins

**Editor (`editor.lua`)**
- **Smart Indentation**: Automatic detection via vim-sleuth
- **Commenting**: Intelligent commenting with `gc`

## ⌨️ Key Bindings

### Leader Key: `<Space>`

#### File & Buffer Management
| Key | Action |
|-----|--------|
| `<leader>sf` | Search files |
| `<leader>sg` | Live grep |
| `<leader>?` | Recent files |
| `<leader><space>` | Switch buffers |
| `<leader>/` | Search in current buffer |

#### LSP & Code Navigation
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>e` | Show diagnostics |

#### Git Operations
| Key | Action |
|-----|--------|
| `<leader>gp` | Previous hunk |
| `<leader>gn` | Next hunk |
| `<leader>ph` | Preview hunk |

#### Diagnostics
| Key | Action |
|-----|--------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>q` | Diagnostic list |

### Text Objects (Treesitter)
| Key | Action |
|-----|--------|
| `af`/`if` | Function (outer/inner) |
| `ac`/`ic` | Class (outer/inner) |
| `aa`/`ia` | Argument (outer/inner) |

### Comments
| Key | Action |
|-----|--------|
| `gc` | Toggle line comment |
| `gcc` | Comment current line |
| `gbc` | Toggle block comment |

## 🔧 Customization

### Adding New Plugins

1. Create a new file in `lua/plugins/` (e.g., `my-plugin.lua`)
2. Return a plugin specification:
   ```lua
   return {
     'author/plugin-name',
     config = function()
       -- Plugin configuration
     end,
   }
   ```
3. Restart Neovim - Lazy will auto-detect and install

### Modifying Existing Configuration

- **Options**: Edit `lua/config/options.lua`
- **Keymaps**: Edit `lua/config/keymaps.lua`
- **Plugin settings**: Edit the respective file in `lua/plugins/`

### Language Server Setup

1. Add server to `servers` table in `lua/plugins/lsp.lua`:
   ```lua
   local servers = {
     -- existing servers...
     your_server = {
       -- server-specific settings
     },
   }
   ```
2. Install via Mason: `:Mason` then search and install

## 🔌 AI Configuration

### Setting Up AI Providers

1. **OpenRouter** (Default):
   ```bash
   export OPENROUTER_API_KEY="your-key-here"
   ```

2. **Alternative Providers**:
   ```bash
   export GROQ_API_KEY="your-groq-key"
   export DEEPSEEK_API_KEY="your-deepseek-key"
   ```

3. **Switch Provider**: Edit `provider` in `lua/plugins/avante.lua`

### MCP Server Configuration

Add servers in `lua/plugins/mcphub.lua`:
```lua
require("mcphub").setup({
  auto_approve = true,
  servers = {
    your_server = {
      enabled = true,
      -- server-specific config
    }
  }
})
```

## 🐛 Troubleshooting

### Common Issues

**Plugins not loading:**
```
:Lazy sync
```

**LSP not working:**
```
:Mason
:LspInfo
:checkhealth lsp
```

**Treesitter issues:**
```
:TSUpdate
:checkhealth nvim-treesitter
```

**AI features not working:**
- Check API keys are set in environment
- Verify internet connection
- Check `:checkhealth avante`

### Health Checks

Run comprehensive health checks:
```
:checkhealth
```

### Reset Configuration

If issues persist:
```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```
Then restart Neovim to reinstall everything.

## 📚 Learning Resources

- **Neovim**: `:help` and `:Tutor`
- **Lua**: `:help lua-guide`
- **Plugin Docs**: `:help <plugin-name>`
- **Lazy.nvim**: `:help lazy.nvim`
- **LSP**: `:help lsp`

## 🤝 Contributing

This configuration is designed to be:
- **Readable**: Every line is documented
- **Modular**: Easy to add/remove components
- **Extensible**: Built for customization

Feel free to:
- Add new plugin configurations
- Improve existing setups
- Share useful keymaps or workflows
- Report issues or suggest improvements

## 📄 License

This configuration is based on Kickstart.nvim and maintains the same philosophy of being a starting point for your own configuration rather than a distribution.

---

**Happy coding with Neovim!** 🚀
