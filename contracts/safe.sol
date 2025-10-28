// SPDX-License-Identifier: AGPL-3.0  
pragma solidity >=0.8.26;

// @title Contract KipuBank Espirito Coin
// @author Lorenzo Piccoli
// @data 28/10/2025

// Declare custom errors
error NotOwner();
error ZeroAmount();
error Reentracy();
error NotAllowed();
error NotAllowedLimitCash();
error NonSufficientFunds();
error MaxDepositedReached();
error MaxWithDrawReached();

// Declare the main contract
contract kipuSafe {
    
    // Adress of the owner contract
    address public ownerContract;

    // Usuários podem sacar fundos de seu cofre, mas apenas até um limite fixo por transação, representado por uma variável imutável.
    uint256 immutable limitCash = 1 ether;

    // Number of deposits in contract
    uint16 private bankCap = 0;
    // Number of withdraws in contract
    uint16 private bankWithDraw = 0;
    // Global deposit limit for this contract
    uint16 constant BANK_CAP_LIMIT = 1000;

    // Mapping to track the maximum allowed cash for each user
    mapping(address => uint256) public maxAllowedCash;
    mapping(address => string) public annotationBank;

    // Reentrancy guard variable
    bool private locked;

    // Declare custom events
    event Deposited(address indexed from, uint256 amount);
    event AllowanceSet(address indexed who, uint256 amount);
    event Pulled(address indexed who, uint256 amount);
    event FallbackCalled(address indexed from, uint256 value, uint256 amount);
    event OwnerContractTransferred(address indexed ownerContract, address indexed newOwner);
    event MessageSet(address indexed who, string message);

    // Declare custom modifiers
    modifier onlyOwnerContract(){
        if(msg.sender != ownerContract) revert NotAllowed();
        _;
    }

    modifier noReentracy(){
        if(locked) revert Reentracy();
        locked = true;
        _;
        locked = false;
    }

    // Constructor to set the owner contract
    constructor(){
        ownerContract = msg.sender;
    }

    //Eventos devem ser emitidos tanto em depósitos quanto em saques bem-sucedidos.
    // Modification to receive ether into the contract directly
    receive() external payable{
        //Checks
        if (msg.value == 0) revert ZeroAmount();
        if (bankCap > BANK_CAP_LIMIT) revert MaxDepositedReached();
        //Effects
        maxAllowedCash[msg.sender] += msg.value;
        incrementDeposits();
        //Interactions
        emit Deposited(msg.sender, msg.value);
    }
    // Funtion to deposit ether into the contract
    function depositFunds() external payable noReentracy(){
        //Check
        if (msg.value == 0) revert ZeroAmount();
        if (bankCap > BANK_CAP_LIMIT) revert MaxDepositedReached();
        //Effects
        maxAllowedCash[msg.sender] += msg.value;
        incrementDeposits();
        //Interactions
        emit Deposited(msg.sender, msg.value);
    }
    // Function for withdraw ether from proprietary
    function withDrawFunds(uint256 amount) external noReentracy{
        //Check
        if (amount == 0) revert ZeroAmount();
        if (amount > limitCash) revert NotAllowedLimitCash();
        if (amount > maxAllowedCash[msg.sender]) revert NonSufficientFunds();

        //Effects
        maxAllowedCash[msg.sender] -= amount;
        incrementWithDraws();

        //Interactions
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        emit Pulled(msg.sender, amount);
    }

    function SetannotationBank(string calldata _inputString) external payable noReentracy{
        //Copy de string of `calldata` to `storage`
        //Cost of 0.1 ether
        //Check
        if (maxAllowedCash[msg.sender] == 0) revert ZeroAmount();
        if (maxAllowedCash[msg.sender] < 0.1 ether) revert NonSufficientFunds();
        //Effects
        maxAllowedCash[msg.sender] -= 0.1 ether;
        maxAllowedCash[ownerContract] += 0.1 ether;
        annotationBank[msg.sender] = _inputString;
        //Interactions
        emit MessageSet(msg.sender, _inputString);
    }

    // Funtion fallback to handle calls to non-existent functions
    fallback() external payable{
        emit FallbackCalled(msg.sender, msg.value, address(this).balance);
    }

    // Function to get contract balance and stats
    function infoBalanceContract() public view returns (uint balance, uint16 deposits, uint16 withdraws){
        balance = address(this).balance;
        deposits = bankCap;
        withdraws = bankWithDraw;
    }

    // Function to get max allowed cash for a user's withdraw
    function getmaxAllowedCash(address who) external view returns (uint256) {
        return maxAllowedCash[who];
    }

    // Function to change the owner contract
    function changeOwner(address who) external onlyOwnerContract noReentracy{
        //Check
        if (who == address(0)) revert NotAllowed();
        //Effects
        ownerContract = who;
        //Interactions
        emit OwnerContractTransferred(ownerContract, who);
    }

    //Function to increment number of deposits
    function incrementDeposits() private {
        bankCap += 1;
    }

    //Function to increment number of withdraws
    function incrementWithDraws() private {
        bankWithDraw += 1;
    }

}