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
        require(state == State.Inactive);
        require(msg.value % 2 == 0);
        seller = msg.sender;
        price = msg.value / 2;
        state = State.Created;
    }

    function abort() {
        require(msg.sender == seller);
        require(state == State.Created);
        seller.send(this.balance);
		state = State.Inactive;
		price = 0;
		seller = 0;
    }

    function purchase() payable {
        require(state == State.Created);
        require(msg.value == 2 * price);
        buyer = msg.sender;
        state = State.Locked;
    }

    function confirmed() {
        require(state == State.Locked);
        require(msg.sender == buyer);
        buyer.send(price);
        seller.send(this.balance);
        state = State.Inactive;
        price = 0;
        seller = 0;
        buyer = 0;
    }

    function refundBuyer() {
        require(state == State.Locked);
        require(msg.sender == seller);
        buyer.send(2 * price);
		seller.send(this.balance);
		state = State.Inactive;
		price = 0;
		seller = 0;
		buyer = 0;
    }

}