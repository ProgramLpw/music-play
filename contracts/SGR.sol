// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SGR is ERC20, Ownable {
    bool public mintingFinished; // 状态变量

    constructor(uint256 initialSupply) 
        ERC20("Sino Great Revival", "SGR") 
        Ownable(msg.sender) // 传递 msg.sender 作为初始所有者
    {
        _mint(msg.sender, initialSupply * (10 ** decimals())); // 铸造初始供应量
        mintingFinished = true; // 设置铸造完成
    }

    // 禁止任何新的铸造函数
    function mint(uint256 amount) public onlyOwner {
        require(!mintingFinished, "Minting has already been finished");
        _mint(msg.sender, amount); // 铸造新的代币
    }
}
