![LuaOutput](luaoutput.png)

> [!Note]
> Horrbile AI generated image of LuaOutput. I'm not an artist, so I'm sorry! Hopefully it gets better with time.
>

LuaOutput is a simple Nvim plugin that allows you to run Lua code and see the output in a bottom split.

1. **Fetches the current buffer’s Lua code** (the file you are currently editing).
2. **Executes that Lua code** using `:luafile`.
3. **Captures any output** (including `print` statements and command output).
4. **Displays the output** in a new split window at the bottom of the current Neovim session.

Will this be the best thing in the world? Probably not. Will it be useful? Maybe. Will it be fun to make? Absolutely. It will most definitely allow you to control the battlefields in your crusade against the forces of aliens and demons.

## Why?
I made this simply to learn a bit more about Lua and Neovim, as well as to have a more efficient way to test Lua. It might be useful for others as well, so I decided to share it, or maybe it won't be useful at all. Who knows? Anyway, here it is, for better or worse. You can use it or not; I don't really care. I'm just happy I made something that works. Also, feel free to make any changes you want; I'm not going to stop you. I'm not going to help you either, but I'm not going to stop you.

One final note: I'm not a Lua expert, so if you see something that could be done better, please let me know. I'm always looking to learn more. Feel free to make a pull request or open an issue. Thanks for reading this far; I hope you have a great day, and I hope my writing was at least a little entertaining.

## Installation
I have only tested this with Lazy.nvim, but it may work with other plugin managers; no idea though, it's my first time writing a plugin.

Place this where you would normally put your plugins.
```lua
return {
  {
    'MillerApps/luaoutput',
    opts = {},
  },
}
```
Next, run `:Lazy Sync` to install the plugin.
This will intall the plugin and update the `lazy.lock` file as well as update any other plugins you have installed.

## Usage
Then, the keybinds are as follows:
> [!TIP]
> your kybinds may be differnt for splits, so double check your config.

1. `<A-l>` - Run the Lua code in the current buffer.
2. `q` - Close the LuaOutput window. (You must be in the LuaOutput window to close it; by default, you will jump right back to the window you were in before opening LuaOutput.)
3. `<C-j>` - Move the cursor down in the LuaOutput window or whichever direction you need to go.

## Summary
• **Purpose**: Quickly run the current Lua file in Neovim and display results in a bottom split window.

• **Cleanup**: Automatically closes existing output windows before creating a new one. i.e., `<A-l>` will not open more windows; it will just replace the current one.

• **Configuration**: Minimalistic scratch buffer for output (no line numbers, no wrap, quick close).

## Plans
-  Syntax highlighting for the output window.
-  Run on save option.
-  Auto-close.
-  LSP Docs.
