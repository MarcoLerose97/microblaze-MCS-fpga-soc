#include <stdint.h>

#include "chu_gpi.h"
#include "chu_gpo.h"
#include "chu_io_map.h"

gpo_core_t led_dev;
gpi_core_t sw_dev;

int main(void)
{
    uint32_t sw_value;

    // initialize peripherals
    gpo_init(&led_dev, GPO_BASE_ADDR);
    gpi_init(&sw_dev, GPI_BASE_ADDR);

    while (1)
    {
        // read GPIO input
        sw_value = gpi_read(&sw_dev);

        // write value to GPIO output
        gpo_write(&led_dev, sw_value);
    }

    return 0;
}
