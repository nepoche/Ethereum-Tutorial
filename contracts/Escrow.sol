pragma solidity^0.4.17;

contract Escrow {

    uint public price;
	address public seller;
	address public buyer;

	enum State { Created, Locked, Inactive }
	State public state;

    event Created(address seller, uint price);
	event Aborted();
	event Purchased(address buyer);
	event Confirmed();
	event Refunded();

    modifier onlyBuyer() {
		require(msg.sender == buyer);
		_;
	}

	modifier onlySeller() {
		require(msg.sender == seller);
		_;
	}

	modifier inState(State s) {
		require(state == s);
		_;
	}

    function Escrow() {
        state = State.Inactive;
    }

    function postItem() payable inState(State.Inactive) {
        require(msg.value % 2 == 0);
        seller = msg.sender;
        price = msg.value / 2;
        state = State.Created;
        Created(seller, price);
    }

    function abort() inState(State.Created) onlySeller {
        seller.send(this.balance);
		state = State.Inactive;
		price = 0;
		seller = 0;
        Aborted();
    }

    function purchase() payable inState(State.Created) {
        require(msg.value == 2 * price);
        buyer = msg.sender;
        state = State.Locked;
        Purchased(buyer);
    }

    function confirmed() inState(State.Locked) onlyBuyer {
        buyer.send(price);
        seller.send(this.balance);
        state = State.Inactive;
        price = 0;
        seller = 0;
        buyer = 0;
        Confirmed();
    }

    function refundBuyer() inState(State.Locked) onlySeller {
        buyer.send(2 * price);
		seller.send(this.balance);
		state = State.Inactive;
		price = 0;
		seller = 0;
		buyer = 0;
        Refunded();
    }
}