# UART with Verilog

## General Information:
- Goal: design, validate, and synthesize a UART protocol, transfer 8-bit data.

## About the Project layout:
- UART.v: implement the UART.
- UARTb.v: validate the operation of UART using waveform.

## About the Operation:
***Input**
- clk: clock signal from the board.
- start (active high input): sign that the data is ready to transmit.
- txin: the data to transmit.
- rx: will be connected to the tx output to receive data at RX port.

***Output**
- rx: single bit of data is transmitted.
- rxout: the data after completed transmission
- rxdone: sign to completed reveiving
- txdone: sign to completed transmitting

The data will be transmitted at the fixed baudrate and recevied at the bit-pulse center.
 ![image](https://github.com/vanphuc1208/UART-with-Verilog/assets/116254695/15e9f1ad-e9a1-40a0-b25f-71e2c23a0813)
 ## Waveform:
 ![image](https://github.com/vanphuc1208/UART-with-Verilog/assets/116254695/e2dbf3b5-d1c2-4a0d-8d2b-07d9188f84e3)


