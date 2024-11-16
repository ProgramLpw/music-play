// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // 使用的Solidity版本
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";  // 引入 IERC20 接口

contract MusicStore {
    
    struct Music {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
    }

    mapping(uint256 => Music) public musics; // 映射存储音乐
    uint256 public musicCount; // 音乐数量

    event MusicAdded(uint256 id, string name, uint256 price, address owner);
    event MusicPurchased(uint256 id, address buyer);

    // 添加音乐
    function addMusic(string memory _name, uint256 _price) public {
        require(_price > 0, "Price must be greater than zero");
        musicCount++;
        musics[musicCount] = Music(musicCount, _name, _price, payable(msg.sender));
        emit MusicAdded(musicCount, _name, _price, msg.sender);
    }

    // 购买音乐
    function purchaseMusic(uint256 _id) public payable {
        Music memory music = musics[_id];
        require(msg.value >= music.price, "Insufficient funds to purchase this music");
        require(music.owner != msg.sender, "You cannot purchase your own music");

        // 转账
        music.owner.transfer(music.price);
        musics[_id].owner = payable(msg.sender);
        emit MusicPurchased(_id, msg.sender);
    }

    // 获取音乐信息
    function getMusic(uint256 _id) public view returns (uint256, string memory, uint256, address) {
        Music memory music = musics[_id];
        return (music.id, music.name, music.price, music.owner);
    }

    // 获取音乐数量
    function musicCount() public view returns (uint256) {
        return musicCount;
    }
}
