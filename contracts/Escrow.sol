pragma solidity^0.4.17;

contract Escrow {

    uint public price;
	address public seller;
	address public buyer;

	enum State { Created, Locked, Inactive }
	State public state;

    function Escrow() {
        state = State.Inactive;
    }

    function postItem() payable {
        seller = msg.sender;
        price = msg.value / 2;
        state = State.Created;
    }

    function purchase() payable {
        buyer = msg.sender;
        state = State.Locked;
    }

    function confirmed() {
        buyer.send(price);
        seller.send(this.balance);
        state = State.Inactive;
        price = 0;
        seller = 0;
        buyer = 0;
    }

}