#ifndef CHU_IO_RW_H
#define CHU_IO_RW_H

#include <stdint.h>

#define io_read(base_addr, offset) \
    (*(volatile uint32_t *)((base_addr) + 4u * (offset)))

#define io_write(base_addr, offset, data) \
    (*(volatile uint32_t *)((base_addr) + 4u * (offset)) = (uint32_t)(data))

#endif
