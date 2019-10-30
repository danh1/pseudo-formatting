# pseudo-formatting
Transforms selection in current buffer to bold or italic unicode code points, simulates formatting.

This code simulates making the selection bold or italicized by
transforming what characters it can into analogous code points in other
unicode blocks.

A word like "origin" thus gets transformed to "𝐨𝐫𝐢𝐠𝐢𝐧",
"𝑜𝑟𝑖𝑔𝑖𝑛", or "𝒐𝒓𝒊𝒈𝒊𝒏".

This is not always possible: the letter "h" does not have an
italic analogue, so it gets passed through as is.

The code also can perform the reverse transformation.

To use it, perform load-file on the file uncd-pseudo-format.el.  Having
loaded it, there are four interactive functions that you can call
when the current buffer has a selected region:
   uncd-selection-bold
   uncd-selection-unbold
   uncd-selection-italic
   uncd-selection-unitalic

For example, M-x uncd-selection-bold should bold the selected region
in the manner described above.  (After the file is loaded, auto-completion
should work with M-x.)

We call this pseudo-formatting because we're not changing any
typeface, but rather the code points themselves.  So we're not
formatting.  Formatting can be done in mark-down mode, and with
font-lock (if the text matches what is being font-locked).  On the
other hand, by pseudo-formatting, the text can be copy-pasted as is
to other buffers (for example), or saved to the file system.

This code does not handle accented characters and no doubt there
are other ways it could be improved (perhaps involving properties
set on text or sensitivity to context).  Nevertheless, i've found
it useful so i'm publishing it just in case anybody else might benefit.

I received help from various people help-gnu-emacs on this and
other matters.  (In particular, Marcin Borkowski alerted me to
the h-hole for italics, so the code takes care not to change
any character into an undisplayable one.)
