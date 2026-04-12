module my_module;

    final begin : block_1
        $display("This is a final block 1.");
    end

    final begin : block_2
        $display("This is a final block 2.");
    end

    initial begin : block_3
        #10ns;
        $display("Welcome to my module.");
    end

    initial begin : block_4
        $display("Hello, SystemVerilog!");
        $finish;
    end

endmodule
