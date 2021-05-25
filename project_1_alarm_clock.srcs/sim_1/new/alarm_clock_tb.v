`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2020 18:54:35
// Design Name: 
// Module Name: alarm_clock_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alarm_clock_tb;

    // Inputs
    reg Clk_1sec;
    reg reset;
    reg [4:0] H_in;
    reg [5:0] M_in;
    reg LD_time;
    reg LD_alarm;
    reg STOP_al;
    reg AL_ON;
    // Outputs
    wire Alarm;
    wire [5:0] seconds;
    wire [5:0] minutes;
    wire [4:0] hours;

    // Instantiate the Unit Under Test (UUT)
    alarm_clock uut (
        .Clk_1sec(Clk_1sec),
        .reset(reset),
        .H_in(H_in),
        .M_in(M_in),
        .LD_time(LD_time),
        .LD_alarm(LD_alarm),
        .STOP_al(STOP_al),
        .AL_ON(AL_ON),
        .Alarm(Alarm),
        .seconds(seconds),
        .minutes(minutes),
        .hours(hours)
    );
   
    //Generating the Clock with `1 Hz frequency;
initial Clk_1sec = 0;
    always #500000000 Clk_1sec = ~Clk_1sec;  //Every 0.5 sec toggle the clock.

    initial begin
        reset = 1;
        H_in = 10;      //giving initial value to clock
        M_in = 15;
        LD_time = 1;
        LD_alarm = 0;
        STOP_al = 0;
        AL_ON = 0;
        // Wait 100 ns for global reset to finish
        #100;
        reset = 0;
        H_in = 10;
        M_in = 16;
        LD_time = 0;
        LD_alarm = 1;
        STOP_al = 0;
        AL_ON = 1;
        #1000000000;
       reset = 0;
        H_in = 10;
        M_in = 16;
        LD_time = 0;
        LD_alarm = 0;
        STOP_al = 0;
        AL_ON = 1;        
        wait(Alarm);    //wait until Alarm signal goes high
        #1000000000;
        STOP_al = 1; // pulse high the STOP_al to push low the Alarm signal
        #1000000000;
         
    end
     
endmodule