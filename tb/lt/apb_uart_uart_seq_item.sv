// @foez-bhai, add commnents describing this file and its functions

`ifndef __GUARD_APB_UART_UART_SEQ_ITEM_SV__
`define __GUARD_APB_UART_UART_SEQ_ITEM_SV__ 0

class apb_uart_uart_seq_item;

  protected static int       last_baud_rate        = 115200;
  protected static int       last_parity_enable    = 0;
  protected static int       last_parity_type      = 0;
  protected static int       last_second_stop_bit  = 0;

  rand logic           [7:0] data;
  rand int                   baud_rate;
  rand bit                   parity_enable;
  rand bit                   parity_type;
  rand bit                   second_stop_bit;
  rand int                   data_bits;

  static bit                 allow_invisible_chars = 0;
  static bit                 allow_invalid_parity  = 0;

  constraint data_c {
    if (!allow_invisible_chars) {data inside {10, [32 : 126]};}
    data < (2 ** data_bits);
  }

  constraint baud_rate_c {
    soft baud_rate inside {9600, 19200, 38400, 57600, 115200, 100_000_000};
    soft baud_rate == last_baud_rate;
    baud_rate != 0;
  }

  constraint parity_enable_c {soft parity_enable == last_parity_enable;}

  constraint parity_type_c {soft parity_type == last_parity_type;}

  constraint second_stop_bit_c {soft second_stop_bit == last_second_stop_bit;}

  constraint data_bits_c {
    data_bits inside {5, 6, 7, 8};
    soft data_bits inside {8};
  }

  function void post_randomize();
    last_baud_rate       = baud_rate;
    last_parity_enable   = parity_enable;
    last_parity_type     = parity_type;
    last_second_stop_bit = second_stop_bit;
  endfunction

  virtual function automatic string to_string();
    return $sformatf(
        "data=0x%08h [%s], baud_rate=%0d, parity_enable=%0b, parity_type=%0b, second_stop_bit=%0b, data_bits=%0d",
        data,
        data,
        baud_rate,
        parity_enable,
        parity_type,
        second_stop_bit,
        data_bits
    );
  endfunction

  virtual function automatic void display();
    $display("APB UART UART Sequence Item: %s", to_string());
  endfunction

endclass

`endif
