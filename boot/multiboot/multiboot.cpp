/*
    Copyright (c) 2017, Thierry Tremblay
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

#include <multiboot.h>
#include <multiboot2.h>



extern "C" void multiboot_main(unsigned int magic, void* mbi)
{
    (void)magic;
    (void)mbi;
/*
    Initialize();

    memset(&g_bootInfo, 0, sizeof(g_bootInfo));
    g_bootInfo.version = RAINBOW_BOOT_VERSION;
    g_bootInfo.firmware = Firmware_BIOS;

    // Add bootloader (ourself) to memory map
    extern const char bootloader_image_start[];
    extern const char bootloader_image_end[];

    const physaddr_t start = (physaddr_t)&bootloader_image_start;
    const physaddr_t end = (physaddr_t)&bootloader_image_end;
    g_memoryMap.AddBytes(MemoryType_Bootloader, 0, start, end - start);

    // Process multiboot info
    bool gotMultibootInfo = false;

    if (magic == MULTIBOOT_BOOTLOADER_MAGIC && mbi)
    {
        ProcessMultibootInfo(static_cast<multiboot_info*>(mbi));
        gotMultibootInfo = true;
    }
    else if (magic== MULTIBOOT2_BOOTLOADER_MAGIC && mbi)
    {
        ProcessMultibootInfo(static_cast<multiboot2_info*>(mbi));
        gotMultibootInfo = true;
    }
    else
    {
        // No multiboot header, hope there is a standard VGA card at 0xB8000 =)
        g_vgaConsole.Initialize((void*)0x000B8000, 80, 25);
        g_console = &g_vgaConsole;
    }

    // Welcome message
    if (g_console)
    {
        g_console->Rainbow();
        printf(" Multiboot Bootloader\n\n");
    }

    if (gotMultibootInfo)
    {
        Boot();
    }
    else
    {
        printf("FATAL: No multiboot information!\n");
    }

    Shutdown();
*/
}
