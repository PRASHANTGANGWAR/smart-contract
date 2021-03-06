pragma solidity ^0.4.24;

/**
 * The erc contract does this and that...
 * 
 */
 contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    /*event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);*/
}
contract erc is ERC20Interface {
    
    	string constant tokenName = "erc"; //
		string constant symbol = "erc";
	    mapping (address => uint) myMapping;
	    mapping(address => mapping (address => uint256)) allowed;

		uint  decimal = 18; //decimal of 18th for one unit of crncy
		uint public totalSupply;

	constructor() public{
	    totalSupply = 1000 * (10 ** decimal);
        myMapping[msg.sender] = totalSupply;

	}
	

	function  totalSupply() public constant returns (uint){
		 return totalSupply;
		}

		function balanceOf(address tokenOwner) public constant returns(uint balance)  {
		    return myMapping[tokenOwner];
		}

		function allowance (address tokenOwner,address spender) public constant returns(uint remaining)  {
		uint remaining1 = allowed[tokenOwner][spender];
		    return remaining1;
		}
        
    function approve(address spender, uint tokens) public  returns (bool success){
                allowed[msg.sender][spender] = tokens;//address(msg.sender) -> [address(spender)->token(amount of acess)] 
                return true;
    }
    
        function transfer(address to, uint tokens) public  returns (bool success){// from any  acc to any addres
          myMapping[msg.sender]= myMapping[msg.sender] - tokens;
          myMapping[to]  = myMapping[to] + tokens;
           return true;
           
        }
        
        function transferFrom(address from, address to, uint tokens) public  returns (bool success){
             myMapping[from]=  myMapping[from] - tokens ;
            allowed[from][msg.sender] = allowed[from][msg.sender] -tokens;//here msg.sender is the person having acess for acc of person
             myMapping[to] = myMapping[to] + tokens;
             return true;
            
        }

		
		
}
