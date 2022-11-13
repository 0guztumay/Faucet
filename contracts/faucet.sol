// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Facuet{
    address owner;
    IERC20 token;
    uint256 tokenDripping = 100;

    constructor(address tokenAddress){
        token = IERC20(tokenAddress);
    }

    mapping(address => uint256) nextRequestTime;

    modifier onlyOwner{
        require(msg.sender == owner, "Caller Not Owner");
        _;
    }

    function request(address payable _to)external{
        require(token.balanceOf(address(this)) >10, "Faucet empty");
        require(block.timestamp > nextRequestTime[msg.sender], "You can faucet per 5 minutes");
        nextRequestTime[msg.sender] = block.timestamp + 5 minutes;

        token.transfer(_to, tokenDripping);
    }

    function withdrawTokens(address _receiver, uint256 _amount)external onlyOwner{
        require(token.balanceOf(address(this)) >= _amount, "Insufficient funds");
        token.transfer(_receiver, _amount);
    }

    function getBalance()public view returns(uint){
        return token.balanceOf(address(this));
    }
}