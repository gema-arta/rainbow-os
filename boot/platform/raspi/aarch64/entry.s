# /*
#     Copyright (c) 2016, Thierry Tremblay
#     All rights reserved.

#     Redistribution and use in source and binary forms, with or without
#     modification, are permitted provided that the following conditions are met:

#     * Redistributions of source code must retain the above copyright notice, this
#       list of conditions and the following disclaimer.

#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.

#     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#     AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#     IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#     FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#     DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#     SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#     OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#     OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# */


/******************************************************************************

    Program enty point


    The bootloader passes 3 arguments:
        x0 = Device Tree Blob (dtb)
        x1 = 0 (reserved for future use)
        x2 = 0 (reserved for future use)
        x3 = 0 (reserved for future use)

        Preserve these registers! We want to pass them to raspi_main()

******************************************************************************/

.section .boot

      org = 0x80000

.globl _start
_start:

    // Initialize the stack
    ldr x4, =_boot_stack_top
    mov sp, x4

    // Initialize FPU
#    ldr r3, =(0xF << 20)
#    mcr p15, #0, r3, c1, c0, #2
#    mov r3, #0x40000000
#    vmsr FPEXC, r3

    // Jump to raspi_main
    b raspi_main



/******************************************************************************

    Helper to introduce CPU delay

******************************************************************************/

.globl cpu_delay
cpu_delay:
    ret



/******************************************************************************

    Boot Stack

******************************************************************************/

.section .bss
.align 12

_boot_stack:
.skip 32768
_boot_stack_top:
