-- needed for foldtext='', useful to keep info of a fold secret,
-- the reason why this option is not set by default is that it can be a security risk,
-- as it allows execution of arbitrary code from the modeline,
-- which can be exploited if you open a file with a malicious modeline
vim.o.modelineexpr = true
