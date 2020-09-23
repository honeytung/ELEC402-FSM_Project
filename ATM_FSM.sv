/*
 *  Name: Harry Tung
 *  Student Number: 40482151
 *  Description:
 */

module ATM_FSM(
    input logic clk,
    input logic rst,
    
    // Inputs for state machine
    input logic insertCard,
    input logic cardRemoved,
    input logic cancelAction,
    input logic correctPassword,
    input logic [1:0] optionSelect,
    input logic moneyInserted,
    input logic amountEntered,
    input logic enoughBalance,
    input logic moneyTaken,

    // Outputs for state machine
    output reg [3:0] state
);

//////////////////////////////////////////////////////////////////////////////////////////////
//      State Registers
//////////////////////////////////////////////////////////////////////////////////////////////
reg unsigned [3:0] currentState;
reg unsigned [3:0] nextState;

//////////////////////////////////////////////////////////////////////////////////////////////
//      State Parameters
//////////////////////////////////////////////////////////////////////////////////////////////
parameter welcomeScreen = 4'b0000;
parameter enterPassword = 4'b0001;
parameter removeCard = 4'b0010;
parameter optionScreen = 4'b0011;
parameter putMoney = 4'b0100;
parameter showBalance = 4'b0101;
parameter enterAmount = 4'b0110;
parameter checkBalance = 4'b0111;
parameter showNoBalance = 4'b1000;
parameter giveMoney = 4'b1001;
parameter printReceipt = 4'b1010;

//////////////////////////////////////////////////////////////////////////////////////////////
//      States Changer
//      This process updates the current state to next state and link all connections
//////////////////////////////////////////////////////////////////////////////////////////////
always@(posedge clk, posedge rst) begin

    // Reset Signal
    if(rst == 1) begin
        currentState <= welcomeScreen;
    end

    // If reset is not asserted, change state and output state result
    else begin
        currentState <= nextState;
        state <= nextState;
    end
end

//////////////////////////////////////////////////////////////////////////////////////////////
//      States Logic
//      This process contains all the state logic
//////////////////////////////////////////////////////////////////////////////////////////////
always@(*) begin

    // Default values for every states
    // These values will be overwritten as necessary
    nextState <= welcomeScreen;     // Assume nextState will always be welcomeScreen
    
    // welcomeScreen: default state waiting for debit card to insert
    if(currentState == welcomeScreen) begin
        if(insertCard == 1) begin
            nextState <= enterPassword;
        end
        else begin
            nextState <= welcomeScreen;
        end
    end

    // enterPassword: waits for correct password
    else if(currentState == enterPassword) begin
        if(cancelAction == 1) begin
            nextState <= removeCard;    
        end
        else if(correctPassword == 1) begin
            nextState <= optionScreen;
        end
        else begin
            nextState <= enterPassword;
        end
    end

    // removeCard: waits for user to remove debit card
    else if(currentState == removeCard) begin
        if(cardRemoved == 1) begin
            nextState <= welcomeScreen;
        end
        else begin
            nextState <= removeCard;
        end
    end

    // optionScreen: option screen to deposite/withdrawal of money
    else if(currentState == optionScreen) begin
        if(cancelAction == 1) begin
            nextState <= removeCard;
        end
        else if(optionSelect == 1) begin
            nextState <= enterAmount;
        end
        else if(optionSelect == 2) begin
            nextState <= putMoney;
        end
        else begin
            nextState <= optionScreen;
        end
    end

    // putMoney: wait for user to deposite money to the machine
    else if(currentState == putMoney) begin
        if(cancelAction == 1) begin
            nextState <= optionScreen;
        end
        else if(moneyInserted == 1) begin
            nextState <= showBalance;
        end
        else begin
            nextState <= putMoney;
        end
    end

    // showBalance: show the current balance to the user
    else if(currentState == showBalance) begin
        nextState <= printReceipt;
    end

    // enterAmount: wait for user to enter the amount to withdraw
    else if(currentState == enterAmount) begin
        if(cancelAction == 1) begin
            nextState <= optionScreen;
        end
        else if(amountEntered == 1) begin
            nextState <= checkBalance;
        end
        else begin
            nextState <= enterAmount;
        end
    end

    // checkBalance: check if the user has enough balance to withdraw or not
    else if(currentState == checkBalance) begin
        if(enoughBalance == 1) begin
            nextState <= giveMoney;
        end
        else begin
            nextState <= showNoBalance;
        end
    end

    // showNoBalance: notify the user that not enough balance to withdraw
    else if(currentState == showNoBalance) begin
        nextState <= enterAmount;
    end

    // giveMoney: give the amount of withdrawal to the user
    else if(currentState == giveMoney) begin
        if(moneyTaken == 1) begin
            nextState <= printReceipt;
        end
        else begin
            nextState <= giveMoney;
        end
    end

    // printReceipt: print the receipt and go back to option screen
    else if(currentState == printReceipt) begin
        nextState <= optionScreen;
    end
end
endmodule
