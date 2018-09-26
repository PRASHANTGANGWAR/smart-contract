pragma solidity ^0.4.24;

/*import "./Ownable.sol";
*/
 contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
contract sofoCoin is ERC20Interface {
       
 string constant tokenName = "SofoCoin"; //
 string constant symbol = "Sofo";
 mapping (address => uint) public coinBalance;
 mapping(address => mapping (address => uint256)) public allowed;
 uint public decimal = 18; //decimal of 18th for one unit of crncy
 uint public  totalSupply;
 uint public initialSupply ;
 address public owner;  
 /*  uint public startDate;
 uint public bonusEnds;
 uint public endDate; */

    constructor() public payable{
        totalSupply = 3000000000 * (10 ** decimal);
        initialSupply = 1500000000 * (10 ** decimal);
        owner = msg.sender;
         coinBalance[msg.sender] = initialSupply;
/*        uint valueOfEther = 1000; // 1000 sofoCoin = 1 ehter  suppose I transfer 1 sofoCoin then value trnasferred equivalent to eth = 1/1000 ether 
*/    }
    
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
    

  function updateBalancesMapping(address ofAdress,uint tokens) public {
        coinBalance[ofAdress] = coinBalance[ofAdress] - tokens;
  
    }
    
    function getTokenOwner() public constant returns(address contractOwner){
        return owner;
    }
}
