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

OUTPUT_FORMAT(elf32-littlearm)
ENTRY(_start)



PHDRS
{
    text PT_LOAD;
    rodata PT_LOAD;
    data PT_LOAD;
}



SECTIONS
{
    . = 0x8000;

    bootloader_image_start = .;

    .text :
    {
        *(.boot)    /* Make sure boot code is at the beginning of the image */
        *(.text)
    } : text

    .rodata :
    {
        *(.rodata*)
    } : rodata

    .data :
    {
        *(.data*)

        . = ALIGN(4);
        __CTOR_LIST__ = . ;
        LONG (-1); *(.ctors); *(.ctor); *(SORT(.ctors.*)); LONG (0);
        __DTOR_LIST__ = . ;
        LONG (-1); *(.dtors); *(.dtor); *(SORT(.dtors.*)); LONG (0);

    } : data

    _bss_start = .;
    .bss :
    {
        *(.bss)
    } : data
    _bss_end = .;

    /DISCARD/ :
    {
        *(.comment)
        *(.debug)
        *(.debug*)
        *(.eh_frame)
    }

    bootloader_image_end = .;
}
