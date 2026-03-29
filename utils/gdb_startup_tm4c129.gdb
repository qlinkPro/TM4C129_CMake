# GDB startup commands for CLion Embedded GDB Server.
# Paste these into "GDB Startup Commands" or run with: -x utils/gdb_startup_tm4c129.gdb

set breakpoint auto-hw on
set remote hardware-breakpoint-limit 6
set remote hardware-watchpoint-limit 4
set mem inaccessible-by-default off

monitor halt
load
monitor halt
thbreak main
