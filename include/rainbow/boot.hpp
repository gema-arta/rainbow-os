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

#ifndef _RAINBOW_RAINBOW_BOOT_H
#define _RAINBOW_RAINBOW_BOOT_H

#include <rainbow/types.h>



#ifdef __cplusplus
extern "C" {
#endif


static const uint32_t RAINBOW_KERNEL_BASE_ADDRESS = 0xF0000000;
static const uint32_t RAINBOW_BOOT_VERSION = 1;


#if defined(__i386__) || defined(__x86_64__)
#define MEMORY_PAGE_SHIFT 12
#define MEMORY_PAGE_SIZE 4096
#endif



enum Firmware
{
    Firmware_Unknown,           // Unknown firmware
    Firmware_BIOS,              // BIOS
    Firmware_EFI,               // EFI / UEFI
};



// The order these memory types are defined is important!
// When the firmware returns overlapping memory ranges, higher values take precedence.
enum MemoryType
{
    MemoryType_Available,           // Conventional memory (RAM)
    MemoryType_Persistent,          // Works like conventional memory, but is persistent
    MemoryType_Unusable,            // Memory in which errors have been detected
    MemoryType_Bootloader,          // Bootloader
    MemoryType_Kernel,              // Kernel
    MemoryType_AcpiReclaimable,     // ACPI Tables (can be reclaimed once parsed)
    MemoryType_AcpiNvs,             // ACPI Non-Volatile Storage
    MemoryType_Firmware,            // Firmware Runtime Memory (e.g. EFI runtime services)
    MemoryType_Reserved,            // Reserved / unknown / do not use
};


enum MemoryAttributes
{
    MemoryFlag_Code         = 1,    // Memory is code
    MemoryFlag_ReadOnly     = 2,    // Memory is read-only
};


struct MemoryDescriptor
{
    MemoryType  type;
    uint32_t    flags;
    uint64_t    physicalAddress;
    uint64_t    virtualAddress;
    uint64_t    pageCount;

    uint64_t    pageStart() const   { return physicalAddress >> MEMORY_PAGE_SHIFT; }
    uint64_t    pageEnd() const     { return pageStart() + pageCount; }
};



enum FrameBufferType
{
    FrameBufferType_None,       // No / unknown frame buffer format
    FrameBufferType_RGB,        // Frame buffer is RGB
    FrameBufferType_VGAText,    // Frame buffer is CGA/EGA/VGA text mode (2 bytes per character)
};



struct FrameBufferInfo
{
    uint64_t    address;        // Start of frame buffer in memory
    uint32_t    width;          // In pixels (or characters)
    uint32_t    height;         // In pixels (or characters)
    uint32_t    pitch;          // In bytes
    uint8_t     bpp;            // Bits per pixel
    uint8_t     type;           // Frame buffer type (FrameBufferType)
    uint8_t     redShift;       // Red bit position in bits
    uint8_t     redBits;        // Red mask size in bits
    uint8_t     greenShift;     // Green bit position in bits
    uint8_t     greenBits;      // Green mask size in bits
    uint8_t     blueShift;      // Blue  bit position in bits
    uint8_t     blueBits;       // Blue mask size in bits

};



struct BootInfo
{
    uint32_t            version;            // Version (RAINBOW_BOOT_VERSION)
    uint32_t            firmware;           // Host firmware
    uint32_t            frameBufferCount;   // How many frame buffers are available (0-4)
    uint32_t            padding;
    FrameBufferInfo     framebuffers[4];    // Active video frame buffers
};


#ifdef __cplusplus
}
#endif

#endif