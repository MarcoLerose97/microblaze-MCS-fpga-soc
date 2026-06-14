#ifndef CHU_SPI_H
#define CHU_SPI_H

#include <stdint.h>

#define SPI_SS_REG       1u
#define SPI_DATA_REG     2u
#define SPI_CTRL_REG     3u
#define SPI_STATUS_REG   0u

#define SPI_READY_MASK   0x00000100u
#define SPI_DATA_MASK    0x000000FFu

#define SPI_CPOL_BIT     16u
#define SPI_CPHA_BIT     17u

typedef struct {
    uint32_t base_addr;
} spi_core_t;

void spi_init(spi_core_t *dev, uint32_t base_addr);

void spi_set_slave_select(spi_core_t *dev, uint32_t ss_n);
void spi_set_control(spi_core_t *dev, uint16_t dvsr, uint8_t cpol, uint8_t cpha);
void spi_set_frequency(spi_core_t *dev, uint32_t sys_clk_hz, uint32_t spi_clk_hz, uint8_t cpol, uint8_t cpha);

uint8_t spi_is_ready(spi_core_t *dev);
uint8_t spi_transfer_byte(spi_core_t *dev, uint8_t data);
uint8_t spi_read_last_byte(spi_core_t *dev);

#endif
