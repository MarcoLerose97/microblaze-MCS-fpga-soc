/* Il file chu_io_rw.h definisce due macro, io_read() e io_write(), utilizzate per accedere ai registri
delle periferiche hardware attraverso operazioni di lettura e scrittura in memoria.
Entrambe le macro ricevono l'indirizzo base della periferica e l'offset del registro da raggiungere.
L'indirizzo effettivo viene calcolato moltiplicando l'offset per 4, poiché ogni registro occupa 32 bit (4 byte).
Il puntatore viene convertito in volatile uint32_t *, indicando al compilatore che l'accesso riguarda un
registro hardware a 32 bit e che le operazioni non devono essere eliminate o ottimizzate come normali
accessi a memoria.
La macro io_read() restituisce il contenuto del registro, mentre io_write() permette di scrivere un
valore al suo interno. */

    

#ifndef CHU_IO_RW_H
#define CHU_IO_RW_H

#include <stdint.h>

#define io_read(base_addr, offset) \
    (*(volatile uint32_t *)((base_addr) + 4u * (offset)))

#define io_write(base_addr, offset, data) \
    (*(volatile uint32_t *)((base_addr) + 4u * (offset)) = (uint32_t)(data))

#endif
