[33mcommit c9b948d9f53779cf133b1b2261e84645872e2fbf[m[33m ([m[1;36mHEAD[m[33m -> [m[1;32m27-session-20260512_a-tusha[m[33m, [m[1;31morigin/27-session-20260512_a-tusha[m[33m)[m
Author: Tusha Falia <tushafalia@gmail.com>
Date:   Wed May 13 01:43:07 2026 +0600

    regif.sv commit

[33mcommit 78ce77b6a830c31c7025a4c6e1901a8dcccf261f[m[33m ([m[1;31morigin/main[m[33m, [m[1;31morigin/HEAD[m[33m, [m[1;32mmain[m[33m)[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue May 12 12:25:40 2026 +0600

    Add regif module with input/output signals and error handling

[33mcommit fdabeb148c9e2ca5bbdc56170755007c9df177ea[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue May 12 12:16:17 2026 +0600

    modified:   document/cdc_fifo_des.svg
    modified:   source/cdc_fifo.sv

[33mcommit fd0b273a4d4f29a96e8e3b8e2ff1418abbfb79b3[m[33m ([m[1;31morigin/21-cdcfifo[m[33m)[m
Author: Foez Ahmed <119846826+foez-ahmed@users.noreply.github.com>
Date:   Tue May 12 11:17:29 2026 +0600

    19 cdc fifo development (#20)
    
    * Add cdc_fifo module for asynchronous FIFO communication
    
    This commit introduces the cdc_fifo module, which facilitates
    asynchronous data transfer between two clock domains. The module
    includes parameters for data width and size, and implements
    write and read address management along with a generic dual-port
    memory instance. Additionally, a binary to gray code converter
    is instantiated to handle address encoding.
    
    * Refactor cdc_fifo module to enhance pointer handling and synchronization
    
    - Added new logic for write and read pointers to support clock domain crossing.
    - Introduced wp_pass and rp_pass signals for write and read pointer synchronization.
    - Updated bin_to_gray and gray_to_bin instances to accommodate new pointer logic.
    - Improved clarity and organization of signal definitions and comments.

[33mcommit efa995488cf8d0b061dc580297612904dccb496f[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Sun May 10 12:57:31 2026 +0600

    Add binary to gray code and gray to binary code conversion modules

[33mcommit 079b6dc2d7ebdc914c5fd133b38878905171a983[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Sun May 3 12:55:42 2026 +0600

    Enhance apb_mem_tb: Add write task and debug display for read/write operations

[33mcommit 5fb29d03acc5f9ed6721818206a259af9b48c75d[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Sun May 3 12:37:27 2026 +0600

    Fix apb_mem_tb: Reset psel signal after read operation in the read task

[33mcommit 932434879bac59f9161b4965df27d21daf3b744b[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Sun May 3 11:40:26 2026 +0600

    Add Makefile, APB memory module, and testbench for memory operations

[33mcommit 14eadd176ed96b03a5e9e1e806acb0023c3e0ad6[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Sun May 3 10:12:00 2026 +0600

    Add submodule for apb-uart with configuration in .gitmodules

[33mcommit ae6836f5ac5345aaa5fff4f7ec4e54c60d5a73c8[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Sun May 3 10:08:30 2026 +0600

    Add initial Makefile, source files, and task documentation for session 20260407

[33mcommit fa25189e8b5339fedc27e31a3f44dc7452118430[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue Apr 21 12:46:21 2026 +0600

    Enhance potato_tb: Add checks for NOP operation in opcode handling

[33mcommit f5d2f9f4b77eec86c1e32415f23085fa1e7555db[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue Apr 21 12:42:04 2026 +0600

    Refactor potato_tb: Update opcode handling to 3-bit format and enhance operation checks

[33mcommit c6cfc212be856e567d84df9e7f7c52949e963aa9[m[33m ([m[1;31morigin/14-new-potato-tb-dip[m[33m, [m[1;31morigin/13-new-potato-tb-ibrahim[m[33m, [m[1;31morigin/12-new-potato-tb-ahanaf[m[33m, [m[1;31morigin/11-new-potato-tb-sajjad[m[33m, [m[1;31morigin/10-new-potato-tb-jannat[m[33m)[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue Apr 21 11:10:07 2026 +0600

    Add potato module and testbench for bitwise operations
    
    - Implemented the 'potato' module with bitwise operations (OR, AND, XOR, NOR, NAND, XNOR).
    - Created a testbench 'potato_tb' to validate the functionality of the 'potato' module.
    - Added random input generation and checks for each operation in the testbench.
    - Configured waveforms for simulation visualization in 'potato_tb.wcfg'.
    - Included Makefile for build automation in multiple directories (ibrahim, jannat, sajjad, tusa).

[33mcommit 6ef02f5d45e9b60e778d9e07ef2031c3e3a7ff41[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue Apr 21 11:03:50 2026 +0600

    Add Makefile, potato module, testbench, and wave configuration for session 20260421_b

[33mcommit cebb8f5afca9ae9ba72f414cef3fc5b78980e0d1[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue Apr 21 11:01:45 2026 +0600

    Enhance potato_tb: Add random loading and comprehensive checks for all operations

[33mcommit a30edc6eef962d98a52dad753643714d53b5cab5[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue Apr 21 10:26:21 2026 +0600

    Add Makefile, potato module, testbench, and wave configuration for session 20260421_a

[33mcommit ae093c983e0036814a9d9bee0722694abc58e7c7[m[33m ([m[1;31morigin/5-hw_c3_dip[m[33m, [m[1;31morigin/4-hw_c3_ibrahim[m[33m, [m[1;31morigin/1-hw_c3_jannat[m[33m)[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Sun Apr 12 12:16:49 2026 +0600

    Add Makefile and my_module.sv for session 20260412_a and session 20260412_b

[33mcommit 8f24e3dc00af5cb5aa9b254bceee68f5aa19620a[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Sun Apr 12 10:46:00 2026 +0600

    Add Makefile and my_module.sv for project setup and simulation

[33mcommit 1f850410856a1ae8bb8faff05e15fe51960c319d[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue Apr 7 13:30:59 2026 +0600

    Refactor Makefile: Clean up comments and remove unused rules

[33mcommit 122370666a9a9e38523cfeb3920ea0d747692113[m
Author: Foez Ahmed <foez.official@gmail.com>
Date:   Tue Apr 7 13:26:49 2026 +0600

    new file:   practice/foez/session_20260407/Makefile
    new file:   practice/foez/session_20260407/source/p1.c
    new file:   practice/foez/session_20260407/source/p2.c
    new file:   practice/foez/session_20260407/task.md

[33mcommit 3238ecb0faa5715e620dfff874a1820f58de8456[m
Author: Foez Ahmed <119846826+foez-ahmed@users.noreply.github.com>
Date:   Sun Apr 5 13:01:10 2026 +0600

    Update README.md

[33mcommit ede958b1ccea0e4b79139e335dbdc033eb96fd00[m
Author: Foez Ahmed <119846826+foez-ahmed@users.noreply.github.com>
Date:   Sun Apr 5 13:00:45 2026 +0600

    Initial commit
