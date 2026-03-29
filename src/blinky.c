#include <stdint.h>
#include <stdbool.h>
#include "hw_memmap.h"
#include "gpio.h"
#include "sysctl.h"

//*****************************************************************************
//
// Blink the on-board LED.
//
//*****************************************************************************
int main(void)
{
    volatile uint32_t ui32Loop;

    //
    // Enable the GPIO port that is used for the on-board LED.
    //
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPION);

    //
    // Check if the peripheral access is enabled.
    //
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_GPION));

    //
    // Enable the GPIO pin for the LED (PN0).  Set the direction as output, and
    // enable the GPIO pin for digital function.
    //
    GPIOPinTypeGPIOOutput(GPIO_PORTN_BASE, GPIO_PIN_0);

    //
    // Loop forever.
    //
    while(1)
    {
        GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, 0x1);

        for(ui32Loop = 0; ui32Loop < 100000; ui32Loop++);

        GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, 0x0);

        for(ui32Loop = 0; ui32Loop < 100000; ui32Loop++);

        GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, 0x1);

        for(ui32Loop = 0; ui32Loop < 100000; ui32Loop++);

        GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, 0x0);

        for(ui32Loop = 0; ui32Loop < 3000000; ui32Loop++);
    }
}
