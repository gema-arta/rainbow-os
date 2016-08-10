/*
    Copyright (c) 2016, Thierry Tremblay
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

.globl StartKernel32
.globl StartKernel64

# mingw32 will decorate C functions with a leading underscore
.globl _StartKernel32
.globl _StartKernel64



/******************************************************************************

    Enable paging and jump to the kernel (32 bits)

******************************************************************************/

.section .text
.code32

/*
    void StartKernel32(BootInfo* bootInfo, uint32_t cr3, uint32_t entry);

    0(%esp)     return address
    4(%esp)     bootInfo
    8(%esp)     cr3
    12(%esp)    entry
*/

StartKernel32:
_StartKernel32:

    // Enable PAE
    movl %cr4, %eax
    btsl $5, %eax
    movl %eax, %cr4

    // Set CR3
    movl 8(%esp), %eax
    movl %eax, %cr3

    // Enable paging
    movl %cr0, %eax
    btsl $31, %eax
    movl %eax, %cr0

    // Jump to kernel using an absolute jump
    movl 12(%esp), %ecx
    jmp *%ecx




/******************************************************************************

    Enable paging and jump to the kernel (64 bits)

******************************************************************************/

.section .rodata
.align 16

GDT:
gdt_boot_null:
    .quad 0

gdt_boot_code:
    .word 0
    .word 0
    .byte 0
    .byte 0b10011010    ;// P + DPL 0 + S + Code + Execute + Read
    .byte 0b00100000    ;// Long mode
    .byte 0

gdt_boot_data:
    .word 0
    .word 0
    .byte 0
    .byte 0b10010010    ;// P + DPL 0 + S + Data + Read + Write
    .byte 0b00000000
    .byte 0

GDTR:
    .word GDTR - GDT - 1
    .long GDT
    .long 0

.equ GDT_BOOT_NULL, gdt_boot_null - GDT
.equ GDT_BOOT_CODE, gdt_boot_code - GDT
.equ GDT_BOOT_DATA, gdt_boot_data - GDT



.section .text
.code32


/*
    void StartKernel64(BootInfo* bootInfo, uint32_t cr3, uint64_t entry);

    0(%esp)     return address
    4(%esp)     bootInfo
    8(%esp)     cr3
    12(%esp)    entry
*/

StartKernel64:
_StartKernel64:

    // Enable PAE
    movl %cr4, %eax
    btsl $5, %eax
    movl %eax, %cr4

    // Set CR3
    movl 8(%esp), %eax
    movl %eax, %cr3

    // Enable long mode
    movl $0xC0000080, %ecx
    rdmsr
    btsl $8, %eax
    wrmsr

    // Enable paging
    movl %cr0, %eax
    btsl $31, %eax
    movl %eax, %cr0

    // Load temporary GDT
    lgdt GDTR

    // Load segments
    movl $GDT_BOOT_DATA, %eax
    movl %eax, %ds
    movl %eax, %es
    movl %eax, %ss

    // Far jump into long mode. Note that it is impossible to do an absolute jump
    // to a 64-bit address from a 32 bits code segment. So we will jump to a 32 bits
    // address in a 64-bit code segment first and then jump to the kernel.
    ljmp $(GDT_BOOT_CODE), $enter_long_mode


.code64
enter_long_mode:

    // BootInfo* parameter is to be passed in rdi
    movl 4(%esp), %edi

    // Jump to kernel using an absolute jump
    movq 12(%esp), %rcx
    jmp *%rcx