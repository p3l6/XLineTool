#  XLineTool

A modern xcode extension adding two key shortcuts:
* Duplicate currently selected lines
* Add a newline after the current selected line

### Duplicate currently selected lines

This will duplicate one or more selected lines. It places the copies of the lines after the current selection, while leaving the cursor as is. 
I like to bind this to `cmd+shift+d`, so that it does the inverse of my "delete line" keybinding: `cmd+d`.

### Add a newline after the current selected line

You might have read this and thought: "That's just what the enter key does!" However, the key difference here is that the cursor can be anywhere in the current line. In other words, it is the same as doing a `cmd+right` followed by `return`, except that I find it more convinient to bind this action to `shift+return`.

## Installing

1. Clone this repository, open in xcode
2. Product > Archive
3. Wait for build to complete and organizer to appear with new archive selected
4. Select Distribute App
5. Select Copy App
6. Choose a location, such as `/Users/you/Applications/`, and export
7. Launch and then quit that application
8. Open system preferences > Extensions > Xcode Source Editor
9. Enable XLineTools
10. Restart Xcode
11. In Xcode preferences > Key Bindings: filter by `xline` and set key shortcuts as you choose

The commands will also appear under the menu: Editor > XLineTool. If this does not show up, it means something went wrong with the extension install process. Unfortunatly, extensions are quite finicky and break sometimes for inexplicable reasons. All I can suggest is to try again.  
