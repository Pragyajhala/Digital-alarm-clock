`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2020 18:48:14
// Design Name: 
// Module Name: alarm_clock
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


module alarm_clock(
    Clk_1sec,  //Clock with 1 Hz frequency
    reset,     //active high reset
    LD_time,   /* If LD_time=1, the time should be set to the values on the inputs H_in1, H_in0, M_in1, and M_in0. The second time should be set to 0.If LD_time=0, the clock should act normally (i.e. second should be incremented every 10 clock cycles).*/  
    LD_alarm,  /* If LD_alarm=1, the alarm time should be set to the values on the inputs H_in1, H_in0, M_in1, and M_in0.If LD_alarm=0, the clock should act normally.*/ 
    STOP_al,   /* If the Alarm (output) is high, then STOP_al=1 will bring the output back low. */ 
    AL_ON,     /* If high, the alarm is ON (and Alarm will go high if the alarm time equals the real time). If low the the alarm function is OFF. */
    Alarm,     /* This will go high if the alarm time equals the current time, and AL_ON is high. This will remain high, until STOP_al goes high, which will bring Alarm back low.*/
    H_in,      //hour input
    M_in,      //minute input
    seconds,   //seconds output
    minutes,   //minutes output
    hours);    //hours output

//What are the Inputs?
    input Clk_1sec;  
    input reset;
    input LD_time;
    input LD_alarm;  /* If LD_alarm=1, the alarm time should be set to the values on the inputs H_in1, H_in0, M_in1, and M_in0.If LD_alarm=0, the clock should act normally.*/
    input STOP_al;  /* If the Alarm (output) is high, then STOP_al=1 will bring the output back low. */
    input AL_ON;  /* If high, the alarm is ON (and Alarm will go high if the alarm time equals the real time). If low the the alarm function is OFF. */
    input [4:0] H_in;
    input [5:0] M_in;
//What are the Outputs?
    output [5:0] seconds;
    output [5:0] minutes;
    output [4:0] hours;
    output reg Alarm;
//Internal variables.
    reg [5:0] seconds;
    reg [5:0] minutes;
    reg [4:0] hours;
    reg [5:0] a_seconds;    //to store alarm input time
    reg [5:0] a_minutes;    
    reg [4:0] a_hours;

   //Execute the always blocks when the Clock or reset inputs are
    //changing from 0 to 1(positive edge of the signal)
    always @(posedge(Clk_1sec) or posedge(reset))
    begin
        if(reset == 1'b1) begin  //check for active high reset.
            //reset the time.
            seconds <= 0;
            a_hours <= 5'b00000;
            a_minutes <= 6'b000000;
            hours <= H_in;
            minutes <= M_in;  end
         else if(LD_alarm) begin // LD_alarm =1 => set alarm clock to H_in, M_in
            a_hours <= H_in;
            a_minutes <= M_in;
            a_seconds <= 6'b000000;
            end
         else if(LD_time) begin // LD_time =1 => set time to H_in, M_in
            hours <= H_in;
            minutes <= M_in;
            seconds <= 6'b000000;
            end
        else if(Clk_1sec == 1'b1) begin  //at the beginning of each second
            seconds <= seconds + 1; //increment sec
            if(seconds == 60) begin //check for max value of sec
                seconds <= 0;  //reset seconds
                minutes <= minutes + 1; //increment minutes
                if(minutes == 60) begin //check for max value of min
                    minutes <= 0;  //reset minutes
                    hours <= hours + 1;  //increment hours
                   if(hours == 24) begin  //check for max value of hours
                        hours <= 0; //reset hours
                    end
                end
            end    
        end
    end    
    always @(posedge Clk_1sec or posedge reset) begin
    if(reset)
    Alarm <=0;
    else begin
    if({a_hours, a_minutes, a_seconds}=={hours, minutes, seconds})
    begin // if alarm time equals clock time, it will pulse high the Alarm signal with AL_ON=1
    if(AL_ON) Alarm <= 1;
    end
    if(STOP_al) Alarm <=0; // when STOP_al = 1, push low the Alarm signal
    end
    end
endmodule
