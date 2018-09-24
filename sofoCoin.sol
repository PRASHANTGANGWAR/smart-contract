/**
 * The sofocoin contract does this and that...
 */

pragma solidity ^0.4.11;
import "./Ownable.sol";

/* contract tokenRecipient is Ownable { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
 */

contract sofoCoin{
       
 string constant tokenName = "SofoCoin"; //
 string constant symbol = "Sofo";
 mapping (address => uint) coinBalance;
 mapping(address => mapping (address => uint256)) allowed;
 uint  decimal = 8; //decimal of 18th for one unit of crncy
 uint public  totalSupply;
 uint public initialSupply ;
  /*  address public owner;
   *//*  uint public startDate;
   uint public bonusEnds;
   uint public endDate; */
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    constructor() public{
        totalSupply = 3000000000 * (10 ** decimal);
        initialSupply = 1500000000 * (10 ** decimal);
/*         owner = msg.sender;
 */        coinBalance[msg.sender] = initialSupply;
        uint valueOfEther = 1000; // 1000 sofoCoin = 1 ehter  suppose I transfer 1 sofoCoin then value trnasferred equivalent to eth = 1/1000 ether 
    }
    
    function  mintCoin(uint tokens) public returns(bool res){
        uint mintToken = initialSupply+tokens;//initialsupply after minting 
        require ((msg.sender == owner) && (tokens>0) && (totalSupply>=mintToken));
        coinBalance[owner] = coinBalance[owner] + tokens; 
/*         initialSupply = coinBalance[owner];*/
        initialSupply = initialSupply + tokens;
        return true;
    }
    
    function initialSupply() public constant returns(uint){
        return initialSupply;   
    } 

    function  totalSupply() public constant returns (uint){
        return totalSupply;
    }

    function balanceOf(address tokenOwner) public constant returns(uint balance)  {
        return coinBalance[tokenOwner];
    }

    function allowance (address tokenOwner,address spender) public constant returns(uint remaining)  {
        return allowed[tokenOwner][spender];
    }
        
    function approve(address spender, uint tokens) public  returns (bool success){
        uint haveToken = balanceOf(msg.sender);
        require (haveToken>= tokens && tokens>0);
        allowed[msg.sender][spender] = tokens;//address(msg.sender) -> [address(spender)->token(amount of acess)] 
        emit  Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function transfer(address to, uint tokens) public  returns (bool success){// from any  acc to any addres
        uint haveToken = balanceOf(msg.sender);
        require (haveToken>= tokens && tokens>0);
        coinBalance[msg.sender]= coinBalance[msg.sender] - tokens;
        coinBalance[to]  = coinBalance[to] + tokens;
        emit  Transfer(msg.sender, to, tokens);
        return true;      
    }
        
    function transferFrom(address from, address to, uint tokens) public  returns (bool success){
        uint allowedToken = allowance(from , msg.sender);
        require (allowedToken>0 && allowedToken>=tokens);
        coinBalance[from]=  coinBalance[from] - tokens ;
        allowed[from][msg.sender] = allowed[from][msg.sender] -tokens;//here msg.sender is the person having acess for acc of person
        coinBalance[to] = coinBalance[to] + tokens;
        emit Transfer(from, to, tokens);
        return true; 
    }  

    function  burnTokens( uint tokens) public returns(bool res)  {// burn token from qwner acc only burn from intitialSupply
        uint haveToken = balanceOf(owner);
        require (msg.sender==owner && haveToken >= tokens);
        coinBalance[owner] = coinBalance[owner] - tokens;
        initialSupply = initialSupply-tokens;
        return true; 
    }

 /*    function transferOwnership(address newOwner) public  {

        require (newOwner != address(0) && owner == msg.sender);
        owner = newOwner;
        } */

    function tokenDistribution (address to,uint tokens) public returns(bool res)  {
      require (msg.sender== owner);
      calDiscount(tokens);
      return transfer(to ,tokens);
    }

    function rate () returns(uint token) internal {
      uint weiAmt = msg.value;
     return weiAmt * (valueOfEther /10^18);
    }
    
     function buyToken() public payable {
      uint weiAmt = msg.value;
    uint tokens = rate(weiAmt);
      }

    function calDiscount (uint tokens) view public returns(uint bonus)  {
  
      uint coinsDistrubuted = initialSupply - coinBalance[owner]; // initially owner have all coins so money distrubuted among the acc is deducted from owner  
      uint percentage =  (100 * coinsDistrubuted) /initialSupply; 

       if( percentage <=10){
          bonus = 40;
        }
       if( percentage <=20){
          bonus = 30;
        }
       if(percentage <=30){
          bonus = 20;
        }
       if(percentage <= 40){
          bonus = 10;
       }
       else{
          bonus = 0;
       }
       tokens = tokens + (tokens/100)*bonus;
         return tokens;
    }
         


   /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        revert();     // Prevents accidental sending of ether
    }



}

