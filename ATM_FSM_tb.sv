`timescale 1ns/1ps

module ATM_FSM_tb();

//////////////////////////////////////////////////////////////////////////////////////////////
//      Logics/Wires
//////////////////////////////////////////////////////////////////////////////////////////////
logic clk, rst;

logic insertCard;
logic cardRemoved;
logic cancelAction;
logic correctPassword;
logic optionSelect;
logic moneyInserted;
logic amountEntered;
logic enoughBalance;
logic moneyTaken;

logic [3:0] state;

//////////////////////////////////////////////////////////////////////////////////////////////
//      Instantiate Modules
//////////////////////////////////////////////////////////////////////////////////////////////
ATM_FSM DUT(.*);

//////////////////////////////////////////////////////////////////////////////////////////////
//      Signal Initializations
//////////////////////////////////////////////////////////////////////////////////////////////
{clk, rst} = 2'b01;
{insertCard, cardRemoved, cancelAction, correctPassword, optionSelect, moneyInserted, amountEntered, enoughBalance, moneyTaken} = 9'b000000000;

// Release rst after 20 unit delay
initial begin
    #20;
    rst = 0;
end

// Generate Clock
always begin
    #10;
    clk = ~clk;
end

#5;

//////////////////////////////////////////////////////////////////////////////////////////////
//      Test Cases
//////////////////////////////////////////////////////////////////////////////////////////////

// Case 1: Insert card then cancel
// State Transition: welcomeScreen -> enterPassword -> removeCard -> welcomeScreen
// Expected state output: 0000 -> 0001 -> 0010 -> 0000
initial begin
    #50;
    insertCard = 1;
    #20;
    insertCard = 0;
    cancelAction = 1;
    #20;
    cancelAction = 0;
    cardRemoved = 1;
    #20;
    cardRemoved = 0;
end

rst = 1;
{insertCard, cardRemoved, cancelAction, correctPassword, optionSelect, moneyInserted, amountEntered, enoughBalance, moneyTaken} = 9'b000000000;
initial begin
    #20;
    rst = 0;
end

// Case 2: Cancel in option screen
// State Transition: welcomeScreen -> enterPassword -> optionScreen -> removeCard -> welcomeScreen
// Expected state output: 0000 -> 0001 -> 0011 -> 0010 -> 0000
initial begin
    #50;
    insertCard = 1;
    #20;
    insertCard = 0;
    correctPassword = 1;
    #20;
    correctPassword = 0;
    cancelAction = 1;
    #20;
    cancelAction = 0;
    cardRemoved = 1;
    #20;
    cardRemoved = 0;
end

rst = 1;
{insertCard, cardRemoved, cancelAction, correctPassword, optionSelect, moneyInserted, amountEntered, enoughBalance, moneyTaken} = 9'b000000000;
initial begin
    #20;
    rst = 0;
end

// Case 3: Deposit money
// State Transition: welcomeScreen -> enterPassword -> optionScreen -> putMoney -> showBalance -> printReceipt -> optionScreen -> removeCard -> welcomeScreen
// Expected state output: 0000 -> 0001 -> 0011 -> 0100 -> 0101 -> 1010 -> 0011 -> 0010 -> 0000
initial begin
    #50;
    insertCard = 1;
    #20;
    insertCard = 0;
    correctPassword = 1;
    #20;
    correctPassword = 0;
    optionSelect = 2;
    #20;
    optionSelect = 0;
    moneyInserted = 1;
    #20;
    moneyInserted = 0;
    #20;
    #20;
    cancelAction = 1;
    #20;
    cancelAction = 0;
    cardRemoved = 1;
    #20;
    cardRemoved = 0;
end

rst = 1;
{insertCard, cardRemoved, cancelAction, correctPassword, optionSelect, moneyInserted, amountEntered, enoughBalance, moneyTaken} = 9'b000000000;
initial begin
    #20;
    rst = 0;
end

// Case 4: Withdraw money with no balance
// State Transition: welcomeScreen -> enterPassword -> optionScreen -> enterAmount -> checkBalance -> showNoBalance -> enterAmount
// Expected state output: 0000 -> 0001 -> 0011 -> 0110 -> 0111 -> 1000 -> 0110
initial begin
    #50;
    insertCard = 1;
    #20;
    insertCard = 0;
    correctPassword = 1;
    #20;
    correctPassword = 0;
    optionSelect = 1;
    #20;
    optionSelect = 0;
    amountEntered = 1;
    #20;
    amountEntered = 0;
    enoughBalance = 0;
    #20;
    #20;
end

rst = 1;
{insertCard, cardRemoved, cancelAction, correctPassword, optionSelect, moneyInserted, amountEntered, enoughBalance, moneyTaken} = 9'b000000000;
initial begin
    #20;
    rst = 0;
end

// Case 5: Withdraw money with enough balance
// State Transition: welcomeScreen -> enterPassword -> optionScreen -> enterAmount -> checkBalance -> giveMoney -> printReceipt -> optionScreen
// Expected state output: 0000 -> 0001 -> 0011 -> 0110 -> 0111 -> 1001 -> 1010 -> 0011
initial begin
    #50;
    insertCard = 1;
    #20;
    insertCard = 0;
    correctPassword = 1;
    #20;
    correctPassword = 0;
    optionSelect = 1;
    #20;
    optionSelect = 0;
    amountEntered = 1;
    enoughBalance = 1;
    #20;
    amountEntered = 0;
    #20;
    enoughBalance = 0;
    moneyTaken = 1;
    #20;
    moneyTaken = 0;
    #20;
    #20;
end

rst = 1;
{insertCard, cardRemoved, cancelAction, correctPassword, optionSelect, moneyInserted, amountEntered, enoughBalance, moneyTaken} = 9'b000000000;
initial begin
    #20;
    rst = 0;
end

endmodule