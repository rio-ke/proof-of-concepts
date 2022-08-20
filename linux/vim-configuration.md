# Vim Configuration

**What is Vim?**

Vim is an advanced and highly configurable text editor built to enable efficient text editing. Vim text editor is developed by Bram Moolenaar. It supports most file types and vim editor is also known as a programmer’s editor. We can use with its plugin based on our needs.

**Vim Installation on ubuntu:**

```bash
sudo apt-get install vim
```
## Create, Save, Exit:
|S.No|Commands|Description|
|----|---------|-----------|
|1.| vim (filename)| To create vim a file and To open a existing vim file|
|2.|:q!|Exit vim without saving changes |
|3.|:wq|Save a file and exit.|
|4.|:x|will save the changes and exit.|
|5.|:w [newfilename]| rename an existing file|
|6.|u|undo|
|7.|Ctrl + r|redo|


## Cut, Copy, Paste, Delete  
|S.No|Commands|Description|
|----|---------|-----------|
|1.| yy| To copy an entire line, place the cursor at the beginning of the line and type.|
|2.|3yy|To copy three (3) lines, move the cursor from where you want to begin copying and type.|
|3.|dd|To cut the entire line in which the cursor is located type.|
|4.|3dd|To cut three (3) lines, starting from the one where the cursor is located use.|
|5.|d$ or D|delete (cut) to the end of the line|
|6.|p|To paste it.|
|7.|P|To add text before the cursor.|
|8.|d|d to delete (cut) the content.|
|9.|V|V (uppercase) to select the entire line.|
|10.|dd|delete the line.|
|11.|2yy|yank (copy) 2 lines|
|12.|yw|yank (copy) the characters of the word from the cursor position to the start of the next word|
|13.|gp| put (paste) the clipboard after cursor and leave cursor after the new text|
|14.|gP|put (paste) before cursor and leave cursor after the new text|
|15.|2dd|delete (cut) 2 lines|
|16.|dw| delete (cut) the characters of the word from the cursor position to the start of the next word|
|17.|diw|delete (cut) word under the cursor|
|18.|daw| delete (cut) word under the cursor and the space after or before it|
|19.|x|delete (cut) character|
|20.|yiw|yank (copy) word under the cursor|
|21.|yaw|yank (copy) word under the cursor and the space after or before it|
|22.|y$ or Y|yank (copy) to end of line|
|23.|ggvG|select all the line|
 

## Editing:
|S.No|Commands|Description|
|----|---------|-----------|
|1.|r|Replace a single character. |
|2.|R|Replace more than one character, until ESC is pressed. |
|3.|J|join line below to the current one with one space in between |
|4.|gJ|join line below to the current one without space in between |
|5.|gwip|reflow paragraph |
|6.|g~|switch to uppercase and lowercase |
|7.|gu|change to lowercase |
|8.|gU|change to uppercase |
|9.|cc|change (replace) entire line|
|10.|c$ or C| change (replace) to the end of the line |
|11.|cw or ce|change (replace) to the end of the word |
|12.|s|delete character and substitute text.|
|13.|S|delete line and substitute text (same as cc)|
|14.|xp|transpose two letters (delete and paste)|
|15.|U|restore (undo) last changed line|
|16.|.| repeat last command |

## Visual commands
|S.No|Commands|Description|
|----|---------|-----------|
|1.|>|shift text right|
|2.|<|shift text left|
|3.|y|yank (copy) marked text|
|4.|d | delete marked text|
|5.|~| switch case|
|6.|u|change marked text to lowercase|
|7.|U|change marked text to uppercase|

## Insert mode - inserting/appending text
|S.No|Commands|Description|
|----|---------|-----------|
|1.|i|insert before the cursor|
|2.|I|insert at the beginning of the line|
|3.|a|insert (append) after the cursor|
|4.|A|insert (append) at the end of the line|
|5.|o|append (open) a new line below the current line|
|6.|O|append (open) a new line above the current line|
|7.|ea|insert (append) at the end of the word|
|8.|Ctrl + h|delete the character before the cursor during insert mode|
|9.|Ctrl + w|delete word before the cursor during insert mode|
|10.|Ctrl + j|begin new line during insert mode|
|11.|Ctrl + t|indent (move right) line one shiftwidth during insert mode|
|12.|Ctrl + d|de-indent (move left) line one shiftwidth during insert mode|
|13.|Ctrl + n|insert (auto-complete) next match before the cursor during insert mode|
|14.|Ctrl + p|insert (auto-complete) previous match before the cursor during insert mode|
|15.|Ctrl + rx|insert the contents of register x|
|16.|Ctrl + ox|Temporarily enter normal mode to issue one normal-mode command x.|
|17.|Esc|  exit insert mode|

## Cursor movement
|S.No|Commands|Description|
|----|---------|-----------|
|1.|k|  move cursor up|
|2.|l | move cursor right|
|3.|gj|  move cursor down (multi-line text)|
|4.|gk|  move cursor up (multi-line text)|
|5.|H | move to top of screen|
|6.|M |move to middle of screen|
|7.|L | move to bottom of screen|
|8.|w | jump forwards to the start of a word|
|9.|W | jump forwards to the start of a word (words can contain punctuation)|
|10.|e | jump forwards to the end of a word|
|11.|E | jump forwards to the end of a word (words can contain punctuation)|
|12.|b | jump backwards to the start of a word|
|13.|B | jump backwards to the start of a word (words can contain punctuation)|
|14.|ge|  jump backwards to the end of a word|
|15.|gE|  jump backwards to the end of a word (words can contain punctuation)|
|16.|% | move to matching character (default supported pairs: '()', '{}', '[]' - use :h matchpairs in vim for more info)|
|17.|0 | jump to the start of the line||
|18.|^ | jump to the first non-blank character of the line||
|19.|$ | jump to the end of the line||
|20.|g_|  jump to the last non-blank character of the line||
|21.|gg|  go to the first line of the document||
|22.|G | go to the last line of the document||
|23.|5gg| or 5G  go to line 5||
|24.|gd|  move to local declaration||
|25.|gD|  move to global declaration||
|26.|fx|  jump to next occurrence of character x||
|27.|tx|  jump to before next occurrence of character x||
|28.|Fx|  jump to the previous occurrence of character x||
|29.|Tx|  jump to after previous occurrence of character x||
|30.|; | repeat previous f, t, F or T movement||
|31.|, | repeat previous f, t, F or T movement, backwards||
|32.|} | jump to next paragraph (or function/block, when editing code)|
|33.|{ | jump to previous paragraph (or function/block, when editing code)|
|34.|zz|  center cursor on screen|
|35.|Ctrl + e|  move screen down one line (without moving cursor)|
|36.|Ctrl + y|  move screen up one line (without moving cursor)|
|37.|Ctrl + b|  move back one full screen|
|38.|Ctrl + f|  move forward one full screen|
|39.|Ctrl + d|  move forward 1/2 a screen|
|40.|Ctrl + u|  move back 1/2 a screen|
