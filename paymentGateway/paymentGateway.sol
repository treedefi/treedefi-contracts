//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBEP20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address _owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() {}

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}


contract PaymentGateway is Pausable {

    using SafeMath for uint256;

    struct TransctionInfo {
        bytes16 txId;
        address userAddress;
        uint256 amount;
        uint256 timeStamp;
    }

    address public fruitTokenAddress = address(0x28557dfC9cc3D2c53B6bAF81467A62b754B2a84a);
    address public burnAddress = address(0x000000000000000000000000000000000000dEaD);
    IBEP20 private FRUIT_TOKEN = IBEP20(fruitTokenAddress);

    uint256 public totalTxCount;
    mapping(address => uint256) public userTxCount;
    mapping(bytes16 => TransctionInfo) private txDetails;
    mapping(address => bytes16[]) private userTxDetails;

    event TranscationExecuted(address indexed user, bytes16 txID, uint256 amount, uint256 timestamp);
    event FruitTokenAddressUpdated(address indexed user, address oldTokenAddress, address newTokenAddress);

    constructor(IBEP20 _fruitToken) {
        fruitTokenAddress = address(_fruitToken);
        FRUIT_TOKEN = IBEP20(fruitTokenAddress);
    }
    
    function toBytes16(
        uint256 x
    ) 
        internal 
        pure 
        returns (bytes16 b) 
    {
       return bytes16(bytes32(x));
    }

    function generateID(
        address x,
        uint256 y,
        bytes1 z
    ) 
        internal
        pure 
        returns (bytes16 b) 
    {
        b = toBytes16(
            uint256(
                keccak256(
                    abi.encodePacked(x, y, z)
                )
            )
        );
    }

    function generateTxID(
        address _userAddress
    ) 
        internal 
        view 
        returns (bytes16 stakeID)
    {
        return generateID(_userAddress, userTxCount[_userAddress], 0x01);
    }

    function getTxDetailById(
        bytes16 _txNumber
    ) 
        public 
        view 
        returns (TransctionInfo memory)
    {
        return txDetails[_txNumber];
    }

    function transactionPagination(
        address _userAddress,
        uint256 _offset,
        uint256 _length
    )
        external
        view
        returns (bytes16[] memory _txIds)
    {
        uint256 start = _offset > 0 &&
            userTxCount[_userAddress] > _offset ?
            userTxCount[_userAddress] - _offset : userTxCount[_userAddress];

        uint256 finish = _length > 0 &&
            start > _length ?
            start - _length : 0;

        _txIds = new bytes16[](start - finish);
        uint256 i;
        for (uint256 _txIndex = start; _txIndex > finish; _txIndex--) {
            bytes16 _txID = generateID(_userAddress, _txIndex - 1, 0x01);
            _txIds[i] = _txID; i++;
        }
    }
    
    function getUserTxCount(
        address _userAddress
    ) 
        public
        view
        returns (uint256)
    {
        return userTxCount[_userAddress];
    }

    function getUserAllTxDetails(
        address _userAddress
    ) 
        public
        view
        returns (uint256, bytes16 [] memory)
    {
        return (userTxCount[_userAddress], userTxDetails[_userAddress]);
    }

    function updateFruitTokenAddress(
        address _tokenAddress
    )
        external
        onlyOwner
    {
        require(
            _tokenAddress != address(0x0),
            'PaymentGateway: Invalid _token Address'
        );

        emit FruitTokenAddressUpdated(_msgSender(), fruitTokenAddress, _tokenAddress);
        fruitTokenAddress = address(_tokenAddress);
        FRUIT_TOKEN = IBEP20(fruitTokenAddress);
    }

    function submitTransaction(
        uint256 _amount
    ) 
        external
        whenNotPaused
        returns (bytes16 txNumber)
    {
        require(
            _amount > 0,
            'PaymentGateway: Tanscation amount should be non-zero'
        );

        require (
            FRUIT_TOKEN.balanceOf(_msgSender()) >= _amount,
            'PaymentGateway: User wallet doenot have enough balance'
        );

        require (
            FRUIT_TOKEN.transferFrom(_msgSender(), address(this), _amount),
            'PaymentGateway: TransferFrom failed'
        );

        txNumber = generateTxID(_msgSender());
        txDetails[txNumber].txId = txNumber;
        txDetails[txNumber].userAddress = _msgSender();
        txDetails[txNumber].amount = _amount;
        txDetails[txNumber].timeStamp = block.timestamp;

        userTxDetails[_msgSender()].push(txNumber);

        FRUIT_TOKEN.transfer(burnAddress, _amount);

        totalTxCount++;
        userTxCount[_msgSender()]++;

        emit TranscationExecuted(_msgSender(), txNumber, _amount, block.timestamp);
    }
}
