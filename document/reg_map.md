# APB UART Register Map

| Register     | Offset | Type | Device   | Description                 |
| ------------ | ------ | ---- | -------- | --------------------------- |
| UART_CTRL    | 0x00   | RW   | Register | UART Control Register       |
| UART_CFG     | 0x04   | RW   | Register | UART Configuration Register |
| UART_STAT    | 0x08   | RO   | Register | UART Status Register        |
| UART_TX_DATA | 0x0C   | WO   | FIFO     | UART Transmit Data Register |
| UART_RX_DATA | 0x10   | RO   | FIFO     | UART Receive Data Register  |

# Register Descriptions

## UART_CTRL (0x00)

| Bit  | Name     | Type | Description         |
| ---- | -------- | ---- | ------------------- |
| 0    | UART_EN  | RW   | Enable UART         |
| 1    | TX_FLUSH | RW   | Flush Transmit FIFO |
| 2    | RX_FLUSH | RW   | Flush Receive FIFO  |
| 31:3 | Reserved | -    | Reserved            |

## UART_CFG (0x04)

| Bit   | Name            | Type | Description                 |
| ----- | --------------- | ---- | --------------------------- |
| 11:0  | CLK_DIV         | RW   | Clock Divider for Baud Rate |
| 12    | PARITY_EN       | RW   | Parity Enable               |
| 13    | PARITY_TYPE     | RW   | Parity Type (0:Even, 1:Odd) |
| 14    | SECOND_STOP_BIT | RW   | Second Stop Bit Enable      |
| 31:15 | Reserved        | -    | Reserved                    |

## UART_STAT (0x08)

| Bit   | Name     | Type | Description                      |
| ----- | -------- | ---- | -------------------------------- |
| 9:0   | TX_COUNT | RO   | Number of bytes in Transmit FIFO |
| 19:10 | RX_COUNT | RO   | Number of bytes in Receive FIFO  |
| 31:20 | Reserved | -    | Reserved                         |

## UART_TX_DATA (0x0C)

| Bit  | Name     | Type | Description            |
| ---- | -------- | ---- | ---------------------- |
| 7:0  | TX_DATA  | WO   | Data to be transmitted |
| 31:8 | Reserved | -    | Reserved               |

## UART_RX_DATA (0x10)

| Bit  | Name     | Type | Description   |
| ---- | -------- | ---- | ------------- |
| 7:0  | RX_DATA  | RO   | Received data |
| 31:8 | Reserved | -    | Reserved      |
