local wk = require('which-key')

wk.setup()

wk.register({
  v = {
    name = 'Search',
    rc = {'Search VimRC'}
  },
  p = {
    name = 'Search',
    p = {'Search Dotfiles'},
    n = {'Search Notes'},
    s = {'Search Recent Projects'},
    h = {'Search Help Tags'},
    w = {'Search Word under Cursor'}
  },
  s = {
    name = 'Search',
    p = {'Search in Projekt'}
  },
  b = {'Search Buffers'}
}, { prefix = '<leader>' })
