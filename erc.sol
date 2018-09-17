pragma solidity ^0.4.24;

/**
 * The erc contract does this and that...
 * 
 */
 contract ERC20Interface {
/*    function totalSupply() public constant returns (uint);
*/    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    /*event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);*/
}
contract erc is ERC20Interface {
    
    	string constant tokenName = "erc";
		string  symbol = "erc";
	    mapping (address => uint) myMapping;
	    mapping(address => mapping (address => uint256)) allowed;

		uint  decimal = 2; 
		uint public totalSuppply;

	constructor() public{
	    totalSuppply = 1000 * (10 ** decimal);
        myMapping[msg.sender] = totalSuppply;

	}
	

	/*function  getTotalSupply() public constant returns (uint){
		 return totalSuppply;
		}*/

		function balanceOf(address tokenOwner) public constant returns(uint balance)  {
		    return myMapping[tokenOwner];
		}

		function allowance (address tokenOwner,address spender) public constant returns(uint remaining)  {
		   remaining= myMapping[spender];
		   remaining= remaining *10 * (decimal);
		    return remaining;
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
