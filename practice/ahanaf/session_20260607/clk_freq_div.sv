module clk_freq_div #(
    parameter DIV_WIDTH = 20
) (
    input  logic                 arst_ni,
    input  logic                 clk_i,
    input  logic [DIV_WIDTH-1:0] div_i,
    output logic                 en_o
);

  // YOUR CODE HERE


  logic [DIV_WIDTH-1:0] count_q;

  always_ff @(posedge clk_i or negedge arst_ni) begin

    if (!arst_ni) begin
      count_q <= '0;
      en_o    <= 1'b0;
    end 
    
    else begin

      if (div_i <= 1) begin
        count_q <= '0;
        en_o    <= 1'b1;
      end 
      
      else if (count_q == '0) begin
        count_q <= div_i - 1'b1;
        en_o    <= 1'b1;
      end 
      
      else begin
        count_q <= count_q - 1'b1;
        en_o    <= 1'b0;
      end

    end


  end




  /*
                logic [DIV_WIDTH-1:0] count_q;

                always_ff @(negedge clk_i) begin

                        if (!arst_ni) begin
                            count_q <= '0;
                            en_o    <= 1'b0;
                        end

                        else 

                        begin
                            if (div_i <= 1) 
                            begin
                                count_q <= '0;
                                en_o    <= 1'b1;
                            end 
                                
                            else if (count_q == '0) 
                            begin
                                count_q <= div_i - 1;
                                en_o    <= 1'b1;
                            end 
                                
                            else 
                            begin
                                count_q <= count_q - 1;
                                en_o    <= 1'b0;
                            end

                        end
                end

  */



endmodule
