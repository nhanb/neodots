setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=88
setlocal colorcolumn=+1
setlocal smarttab
setlocal expandtab

:iab iipdb __import__("ipdb").set_trace()
:iab ipdbs __import__("ipdb").set_trace()
:iab pdbs __import__("ipdb").set_trace()
