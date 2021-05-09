pragma solidity ^0.5.16;

import "./Treedefi.sol";

interface ISeedToken {

    function transferFrom(
      address _from,
      address _to,
      uint256 _value
    ) external returns (bool success);

    function balanceOf(
      address _owner
    ) external returns (uint256);

    function allowance(
      address _owner,
      address _spender
    ) external returns (uint256);

}

contract Trade {

  using SafeMath for uint256;
  
  Treedefi public tree;
  ISeedToken public SEED_CONTRACT;

  mapping(uint => Wood) public treeList;
  
  address private _manager;
  address private _burnAddress = 0x000000000000000000000000000000000000dEaD;
  
  struct Wood {
        bool forSell;
        uint256 price;
        uint256 burnPercentage;
  }

  event Purchase(
        address indexed _from,
        address indexed _to,
        uint256 indexed _id,
        uint256 _value
  );

  event Listing(
        address indexed _owner,
        uint256 indexed _id,
        uint256 _value,
        uint256 _burnPercentage
  );
  
  constructor(Treedefi _tree, address _seedToken) public {
    tree = _tree;
    SEED_CONTRACT = ISeedToken(_seedToken);
    _manager = tree.getOwner();
  }
  
  /** @dev List Treedefi Forest NFT for sell at specific price 
     *@param _id unsigned integer defines tokenID to list for sell
     *@param _price unsigned integer defines sell price in SEED for the tokenID 
     */
  function listTree(uint256 _id, uint256 _price, uint256 _burnPercent) public {
    
    address _owner = tree.ownerOf(_id);
    address _approved = tree.getApproved(_id);
     
    require(
      address(this) == _approved,
      " Treedefi: Contract is not approved to manage token of this ID "
    );

    require(
      msg.sender == _owner,
      " Treedefi: Only owner of token can list the token for sell "
    );

    uint256 _burnP = (msg.sender == _manager)?_burnPercent:0;
    
    treeList[_id] = Wood(true, _price, _burnP);

    emit Listing(_owner, _id, _price, _burnP);

  }
  
  /** @dev Buy Treedefi Forest NFT for listed price 
     *@param _id unsigned integer defines tokenID to buy
     *@param _value unsigned integer defines value of SEED tokens to buy NFT 
     */
  function buyTree(uint256 _id, uint256 _value) public {
     
     address _approved = tree.getApproved(_id);
     
     require(
      address(this) == _approved,
      " Treedefi: Contract is not approved to manage token of this ID "
      );
     
     require(
      treeList[_id].forSell,
      " Treedefi: Token of this ID is not for sell "
      );
     
     require(
      treeList[_id].price <= _value,
      " Treedefi: Provided value is less than listed price "
      );

     require(
      SEED_CONTRACT.balanceOf(msg.sender) >= _value,
      " SEED : Buyer doesn't have enough balance to purchase token "
     );

     require(
      SEED_CONTRACT.allowance(msg.sender, address(this)) >= _value,
      " SEED :  Contract is not approved to spend tokens of user "
     );
     
     address _owner = tree.ownerOf(_id);

        if(treeList[_id].burnPercentage == 0){
          
          SEED_CONTRACT.transferFrom(msg.sender, _owner, _value);
        
        } else {

          uint256 _burnValue = _value.mul(treeList[_id].burnPercentage).div(100);
          uint256 _transferValue = _value.sub(_burnValue);
          SEED_CONTRACT.transferFrom(msg.sender, _burnAddress, _burnValue);
          SEED_CONTRACT.transferFrom(msg.sender, _owner, _transferValue);

        }
     
     tree.transferFrom(_owner, msg.sender, _id);

     treeList[_id] = Wood(false, 0, 0);

     emit Purchase(_owner, msg.sender, _id, _value);
  
  }

}