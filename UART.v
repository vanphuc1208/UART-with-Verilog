`timescale 1ns / 1ps



module UART(
input clk,
input start,
input [7:0] txin,
output reg tx, 
input rx,
output [7:0] rxout,
output rxdone, txdone
    );
//Generate trigger bit with approriate baudrate
parameter clock_rate= 100000;
parameter baudrate= 9600;
parameter wait_count=clock_rate/baudrate;
integer count =0;
reg bitDone = 0; // sign to transmit 1 data completed
parameter idle = 0, send = 1, check = 2;
reg [1:0] state = idle; 

always@(posedge clk) 
begin
    if(state == idle) 
        begin
        count <=0;
        end
    else
        begin
        if(count == wait_count)
            begin
            bitDone<=1'b1;
            count <= 0;
            end
        else
            begin
            count<=count+1;
            bitDone<=1'b0;
            end
    end
end

//Transmit data
reg [9:0] txData;///stop bit data start
integer bitIndex = 0; ///reg [3:0]; // count how many bit transmitted
reg [9:0] shifttx = 0; // for debugging

always@(posedge clk)
begin
    case(state)
    idle:
        begin
        tx<=1'b1;
        txData<=0;
        bitIndex<=0;
        shifttx<=0;
        if(start == 1'b1)
           begin
           txData<={1'b1,txin,1'b0};
           state<=send;
           end
         else state<=idle;
        end
     send:
        begin
        tx<=txData[bitIndex];
        state<=check;
        shifttx<={txData[bitIndex], shifttx[9:1]};
        end
     check:
            begin
            if(bitIndex<=9)
                begin
                if(bitDone==1'b1)
                    begin
                    bitIndex<=bitIndex+1;
                    state<=send;
                    end
                end
             else 
                begin
                bitIndex<=0;
                state<=idle;
                end
             end
      default: state<=idle;
      endcase
end
assign txdone = (bitIndex == 9 && bitDone==1'b1) ? 1'b1 : 1'b0;

//receive data
integer rcount = 0;
integer rindex = 0;
parameter ridle = 0, rwait = 1, recv = 2;
reg [1:0] rstate;
reg [9:0] rxdata;
always@(posedge clk)
begin
case(rstate)
    ridle:
        begin
        rxdata <=0;
        rcount<=0;
        rindex<=0;
        if(rx==1'b0) // transition logic of connection tx rx from 1 to 0 ->start transmit and receive
            begin
            rstate<=rwait;
            end
        else rstate<=ridle;
        end
     rwait:
        begin
            if(rcount == wait_count/2) //we receive bit at the middle
                begin
                rstate<=recv;
                rcount<=0;
                rxdata <= {rx,rxdata[9:1]};
                end
            else 
                begin
                rcount<=rcount+1;
                rstate<=rwait;
                end
        end
     recv:
        begin
            if(rindex<=9)
                begin
                if(bitDone==1'b1)
                    begin
                    rindex<=rindex+1;
                    rstate<=rwait;
                    end
                 end
             else begin
                rstate<=ridle;
                rindex<=0;
                end
        end
     default: rstate<=ridle;
endcase
end
assign rxout =rxdata[8:1];
assign rxdone= (rindex ==9 && bitDone==1'b1) ? 1'b1 : 1'b0;

endmodule
