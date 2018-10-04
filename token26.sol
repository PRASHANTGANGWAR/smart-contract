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
    event Burn(address indexed tokenOwner,uint tokens);
    event MintCoin(address indexed tokenOwner,uint tokens);
}
contract Ownable {
    address public owner;

    constructor () public {
        owner = msg.sender; 
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract sofoCoin is ERC20Interface ,Ownable{   
 string constant tokenName = "SofoCoin"; //
 string constant symbol = "Sofo";
 mapping (address => uint) public coinBalance;
 mapping(address => mapping (address => uint256)) public allowed;
 uint public decimal = 18; //decimal of 18th for one unit of crncy
 uint public initialSupply ;
 address public owner;
 uint public  totalSupply;
    
    constructor() public {
        totalSupply = 3000000000 * (10 ** decimal) ;// 300million tokens 3000000000 * 000000000000000000
        owner = msg.sender;
        coinBalance[owner]= totalSupply;
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
      
    function  burnTokens( uint burnTokensAmt) public onlyOwner returns (bool res)  {
        require (coinBalance[owner] >= burnTokensAmt);      
        totalSupply = totalSupply-burnTokensAmt;// dec totalSupply by burned tokens
        coinBalance[owner]=coinBalance[owner] - burnTokensAmt;//coin deducted to the owner coinbalance   
        emit BurnToken(owner, burnTokensAmt);
        return true; 
    }
    function  mintCoin(uint mintTokens) public onlyOwner returns(bool res){
        require(mintTokens>0);
        totalSupply = totalSupply + mintTokens;//inc totalSupply by burned tokens 
        coinBalance[owner]=coinBalance[owner] + mintTokens;//coin added to the owner coinbalance
        emit MintCoin(owner,mintTokens);
        return true;
    }

       
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
     /* only owner acessed function ENDS*/    

    function  () public payable{
      revert();
    }
  
}

 

