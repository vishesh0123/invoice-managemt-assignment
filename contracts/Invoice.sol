//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Invoice {
    struct Invoicedata {
        string buyerPAN;
        string sellerPAN;
        uint256 invoiceAmount;
        uint256 timestamp;
    }
    uint256 private invoiceCounter = 1;
    mapping(string => uint256[]) public buyertoInvoice;
    mapping(uint256 => Invoicedata) public invoiceId;
    mapping(address => uint256[]) public invoicesbyCreator;
    mapping(uint256 => bool) public paymentStatus;
    mapping(uint256 => address) public invoiceCreator;

    event InvoiceCreated(
        uint256 indexed id,
        string buyer,
        string seller,
        uint256 amount,
        bool status
    );

    function createInvoice(
        string memory buyer,
        string memory seller,
        uint256 amount,
        bool status
    ) public {
        require(msg.sender != address(0));
        require(
            keccak256(abi.encodePacked(buyer)) !=
                keccak256(abi.encodePacked(seller))
        );
        Invoicedata memory data = Invoicedata(
            buyer,
            seller,
            amount,
            block.timestamp
        );
        invoiceId[invoiceCounter] = data;
        invoicesbyCreator[msg.sender].push(invoiceCounter);
        paymentStatus[invoiceCounter] = status;
        buyertoInvoice[buyer].push(invoiceCounter);
        invoiceCreator[invoiceCounter] = msg.sender;
        emit InvoiceCreated(invoiceCounter, buyer, seller, amount, status);
        invoiceCounter++;
    }

    function getInvoices(string memory buyer)
        public
        view
        returns (uint256[] memory)
    {
        return (buyertoInvoice[buyer]);
    }

    function getInvoicedata(uint256 id)
        public
        view
        returns (Invoicedata memory)
    {
        return (invoiceId[id]);
    }

    function getPaymentstatus(uint256 id) public view returns (bool) {
        return (paymentStatus[id]);
    }

    function getInvoicesbycreator(address creator)
        public
        view
        returns (uint256[] memory)
    {
        return (invoicesbyCreator[creator]);
    }

    function changePaymentstatus(uint256 id, bool status) public {
        require(invoiceCreator[id] == msg.sender);
        paymentStatus[id] = status;
    }
}
