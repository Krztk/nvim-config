Config based on

- https://github.com/nvim-lua/kickstart.nvim

## NOTES:

- `:e .` - open netrw for current path (I often use it as refresh)
- `:cd %:p:h` - Change directory to the parent directory of the current file

Breaking it down:

- `%` represents the current file being edited.
- `:p` is a modifier that returns the full path of the current file.
- `:h` is another modifier that returns the head (or directory portion) of the path.
