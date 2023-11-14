// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts\
 * Reference - https://dev.to/abdulmaajid/how-to-create-an-erc20-token-in-solidity-1a9h 
 * Reference2 - https://www.youtube.com/watch?v=7NCLIdn1Byw 
 * Debuging Video - https://drive.google.com/file/d/1vrnJ4HuLpYn8O8BtSjIRAcslixlWIozj/view?usp=share_link
 * There is a insufficient funds error in the video. With Funds added the solution works perfectly.
 * Reasoning - send eth to the address in the parameter sheet , that address needs to have an eth balance.
 */
contract SmartContact {
    mapping(address => uint256) balance_token_supply;
    uint256 totalSupply1;
    constructor(){
        totalSupply1 = 400000;
        balance_token_supply[msg.sender] = totalSupply1;
        //balance_token_supply[0x4B21E71Efc06954F656F67C03eD80Fe7E5322feC] = 100;
        balance_token_supply[0xe7b03ebe09241812FEBbc368229ce019992D5EDA] = 392810;
        totalSupply1 += 100;
        totalSupply1 += 392810;
    }
    string public nameUser = "E98D015D";
    string public symbolUser = "9CEE47C4";
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    //Task 1
    //This method returns the name of your token
    function name() public view returns (string memory){
        return nameUser;
    }
    //Task 2
    //This method returns the symbol of your token
    function symbol() public view returns (string memory){
        return symbolUser;
    }
    uint8 public decimal = 0;
    //Task 3
    //This method returns the number of decimal places your token has
    function decimals() public view returns (uint8){
        return decimal;
    }
    //Extra function 
    function mint() public returns (bool completed){
        balance_token_supply[msg.sender] += 1000;
        totalSupply1 += 1000;
        return true;
    }
    //Task 4
    //This method returns the total supply of your token
    function totalSupply() public view returns (uint256){
        return totalSupply1;
    }
    //task 5 
    //the function allows a message sender to transfer a specific number of
    //tokens to another address
    function transfer(address _to, uint256 _value) public returns (bool success){
        //if sender has more token then transfer amt
        if(balance_token_supply[msg.sender] >= _value)
        {
            balance_token_supply[msg.sender] -= _value;
            balance_token_supply[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        //else fail
        else{
            return false;
        }
    }
    //task 6
    //the function takes in an address as input and returns the token balance of the address
    function balanceOf(address _owner) public view returns (uint256 balance){
        return balance_token_supply[_owner];
    }
    //extra function for checking functionality
    //the function takes in an address as input and returns the token balance of the owner
    function balanceOfOwner() public view returns (uint256 balance){
        return balance_token_supply[msg.sender];
    }
    mapping(address => mapping(address => uint256)) approveSpender;
    //Task 7
    //this function allows a message sender to give another address the right to
    //transfer tokens from their balance, up to a specific amount.
    function approve(address _spender, uint256 _value) public returns (bool success){
        //since Message sender’s are allowed to approve a token amount greater than their current balance of tokens.
        //we dont need to check the balance
        approveSpender[msg.sender][_spender] = _value;
        if(approveSpender[msg.sender][_spender] == _value)
        {
            emit Approval(msg.sender, _spender, _value);
            return true;
        }
        else
        {
            return false;
        }
        
    }
    //Task 8 
    //this function returns the remaining number of tokens a given spender address (input 2) is allowed to spend from a given owner address (input 1).
    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return approveSpender[_owner][_spender];
    }
    //extra function
    function allowanceOwner(address _spender) public view returns (uint256 remaining){
        return approveSpender[msg.sender][_spender];
    }
    //extra 
    //Similar to transfer
    function transferFromHelper(address _from, address _to, uint256 _value) public returns (bool success){
        //if sender has more or equal token that are requested
        if(_value <= balance_token_supply[_from]){
                balance_token_supply[_from] -= _value;
                balance_token_supply[_to] += _value;
                approveSpender[_from][_to] -= _value;
                return true;
        }
        //else fail the function
        else{
            return false;
        }
    }
    //Task 9
    //this function allows a message sender to transfer a given amount of tokens (input 3) from an address (input 1) to another address (input 2)
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        //The _value transfer amount of tokens is less than or equal to the remaining
        //allowance the message sender has been approved to transfer from the _from address
        if(_value <= approveSpender[_from][_to]){
            //_value transfer amount of tokens is less than or equal to the balance of tokens the _from address has remaining.
            //return transferFromHelper(_from, _to, _value);
            if(_value <= balance_token_supply[_from]){
                balance_token_supply[_from] -= _value;
                balance_token_supply[_to] += _value;
                approveSpender[_from][_to] -= _value;
                return true;
            }
            //else fail the function
            else{
                return false;
            }
        }
        else{
            return false;
        }
    }
}