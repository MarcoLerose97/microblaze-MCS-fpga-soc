#include "i2c_core.h"

void i2c_init(I2cCore *core, uint32_t core_base_addr)
{
    core->base_addr = core_base_addr;
    i2c_set_freq(core, 100000); /* default 100 kHz */
}

void i2c_set_freq(I2cCore *core, int freq)
{
    uint32_t dvsr;

    dvsr = (uint32_t)(SYS_CLK_FREQ * 1000000 / freq / 4);
    io_write(core->base_addr, I2C_DVSR_REG, dvsr);
}

int i2c_ready(I2cCore *core)
{
    return (int)((io_read(core->base_addr, I2C_RD_REG) >> 8) & 0x01u);
}

void i2c_start(I2cCore *core)
{
    while (!i2c_ready(core)) { }
    io_write(core->base_addr, I2C_WR_REG, I2C_START_CMD);
}

void i2c_restart(I2cCore *core)
{
    while (!i2c_ready(core)) { }
    io_write(core->base_addr, I2C_WR_REG, I2C_RESTART_CMD);
}

void i2c_stop(I2cCore *core)
{
    while (!i2c_ready(core)) { }
    io_write(core->base_addr, I2C_WR_REG, I2C_STOP_CMD);
}

int i2c_write_byte(I2cCore *core, uint8_t data)
{
    int ack;
    uint32_t acc_data;

    acc_data = (uint32_t)data | I2C_WR_CMD;
    while (!i2c_ready(core)) { }
    io_write(core->base_addr, I2C_WR_REG, acc_data);
    while (!i2c_ready(core)) { }

    ack = (int)((io_read(core->base_addr, I2C_RD_REG) & 0x0200u) >> 9);
    if (ack == 0)
        return 0;
    else
        return -1;
}

int i2c_read_byte(I2cCore *core, int last)
{
    uint32_t acc_data;

    acc_data = (uint32_t)last | I2C_RD_CMD;
    while (!i2c_ready(core)) { }
    io_write(core->base_addr, I2C_WR_REG, acc_data);
    while (!i2c_ready(core)) { }

    return (int)(io_read(core->base_addr, I2C_RD_REG) & 0x00ffu);
}

int i2c_read_transaction(I2cCore *core, uint8_t dev, uint8_t *bytes,
                         int num, int restart)
{
    uint8_t dev_byte;
    int ack1;
    int i;

    dev_byte = (uint8_t)((dev << 1) | 0x01u); /* LSB=1 for I2C read */
    i2c_start(core);
    ack1 = i2c_write_byte(core, dev_byte);    /* send device id/read */

    for (i = 0; i < (num - 1); i++) {
        *bytes = (uint8_t)i2c_read_byte(core, 0);
        bytes++;
    }

    *bytes = (uint8_t)i2c_read_byte(core, 1); /* last byte in read cycle */

    if (restart == 1)
        i2c_restart(core);
    else
        i2c_stop(core);

    return ack1;
}

int i2c_write_transaction(I2cCore *core, uint8_t dev, uint8_t *bytes,
                          int num, int restart)
{
    uint8_t dev_byte;
    int ack1, ack;
    int i;

    dev_byte = (uint8_t)(dev << 1);           /* LSB=0 for I2C write */
    i2c_start(core);
    ack = i2c_write_byte(core, dev_byte);     /* send device id/write */

    for (i = 0; i < num; i++) {
        ack1 = i2c_write_byte(core, *bytes);
        ack = ack + ack1;
        bytes++;
    }

    if (restart == 1)
        i2c_restart(core);
    else
        i2c_stop(core);

    return ack;
}
