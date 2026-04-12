module firstSV;

final begin
    $display("1st final");
end

final begin
    $display("2nd final");
end

initial begin
    #10ns;
    $display("1st initial");
end

initial begin
    $display("2nd initial");
    $finish;
end



endmodule