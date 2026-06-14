#include "chu_spi.h"
#include "chu_io_rw.h"

void spi_init(spi_core_t *dev, uint32_t base_addr)
{
    dev->base_addr = base_addr;
}

void spi_set_slave_select(spi_core_t *dev, uint32_t ss_n)
{
    io_write(dev->base_addr, SPI_SS_REG, ss_n);
}

void spi_set_control(spi_core_t *dev, uint16_t dvsr, uint8_t cpol, uint8_t cpha)
{
    uint32_t ctrl = 0u;

    ctrl |= (uint32_t)dvsr;

    if (cpol) {
        ctrl |= (1u << SPI_CPOL_BIT);
    }

    if (cpha) {
        ctrl |= (1u << SPI_CPHA_BIT);
    }

    io_write(dev->base_addr, SPI_CTRL_REG, ctrl);
}

/*
 * The SPI controller toggles SCLK every (DVSR + 1) system-clock cycles.
 * Therefore:
 *
 * spi_clk = sys_clk / (2 * (DVSR + 1))
 *
 * dvsr = sys_clk / (2 * spi_clk) - 1
 */
void spi_set_frequency(spi_core_t *dev, uint32_t sys_clk_hz, uint32_t spi_clk_hz, uint8_t cpol, uint8_t cpha)
{
    uint32_t dvsr;

    if (spi_clk_hz == 0u) {
        return;
    }

    dvsr = (sys_clk_hz / (2u * spi_clk_hz)) - 1u;

    if (dvsr > 0xFFFFu) {
        dvsr = 0xFFFFu;
    }

    spi_set_control(dev, (uint16_t)dvsr, cpol, cpha);
}

uint8_t spi_is_ready(spi_core_t *dev)
{
    uint32_t status;

    status = io_read(dev->base_addr, SPI_STATUS_REG);

    return (status & SPI_READY_MASK) ? 1u : 0u;
}

uint8_t spi_read_last_byte(spi_core_t *dev)
{
    uint32_t status;

    status = io_read(dev->base_addr, SPI_STATUS_REG);

    return (uint8_t)(status & SPI_DATA_MASK);
}

uint8_t spi_transfer_byte(spi_core_t *dev, uint8_t data)
{
    while (!spi_is_ready(dev)) {
    }

    io_write(dev->base_addr, SPI_DATA_REG, (uint32_t)data);

    while (!spi_is_ready(dev)) {
    }

    return spi_read_last_byte(dev);
}
