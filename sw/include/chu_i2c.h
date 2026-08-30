#ifndef I2C_CORE_H_INCLUDED
#define I2C_CORE_H_INCLUDED

#include <stdint.h>
#include "chu_init.h"

typedef struct {
    uint32_t base_addr;
} I2cCore;

/* Register offsets */
enum {
    I2C_DVSR_REG = 0,
    I2C_WR_REG   = 1,
    I2C_RD_REG   = 0
};

/* Commands: command field is bits 10:8 */
enum {
    I2C_START_CMD   = (0x00u << 8),
    I2C_WR_CMD      = (0x01u << 8),
    I2C_RD_CMD      = (0x02u << 8),
    I2C_STOP_CMD    = (0x03u << 8),
    I2C_RESTART_CMD = (0x04u << 8)
};

void i2c_init(I2cCore *core, uint32_t core_base_addr);
void i2c_set_freq(I2cCore *core, int freq);
int  i2c_ready(I2cCore *core);
void i2c_start(I2cCore *core);
void i2c_restart(I2cCore *core);
void i2c_stop(I2cCore *core);
int  i2c_write_byte(I2cCore *core, uint8_t data);
int  i2c_read_byte(I2cCore *core, int last);
int  i2c_read_transaction(I2cCore *core, uint8_t dev, uint8_t *bytes,
                          int num, int restart);
int  i2c_write_transaction(I2cCore *core, uint8_t dev, uint8_t *bytes,
                           int num, int restart);

#endif /* I2C_CORE_H_INCLUDED */
