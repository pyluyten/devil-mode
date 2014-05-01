devil-mode
==========

Easily operate on text while in selection state
Devil mode does not replace *any* key while in "normal" state.
As soon as you toggle mark (eg, with ^SPC or ^RET), devil triggers
some keys

press $ to extend selection to end of line.
or, s / r to search forward / backward.
Its inspired from vim so w b $ ^ works.
Or, i/j/k/l because its more efficient than hjkl
And i kept h for help.

Use TAB to toggle point and mark. Use RET to cancel selection.



/* WHAT IS BROKEN AS OF TODAY */

while using cua-rect, one cannot insert chars
- at least, not the mapped keys -



