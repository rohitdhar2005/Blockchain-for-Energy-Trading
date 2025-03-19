module EnergyTrading::P2PTrading {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct Producer has store, key {
        energy_supply: u64, // Available energy units for sale
    }

    /// Register as an energy producer with an initial energy supply
    public fun register_producer(owner: &signer, supply: u64) {
        let producer = Producer { energy_supply: supply };
        move_to(owner, producer);
    }

    /// Buy energy from a producer by paying in AptosCoin
    public fun buy_energy(buyer: &signer, producer_address: address, amount: u64) acquires Producer {
        let producer = borrow_global_mut<Producer>(producer_address);
        assert!(producer.energy_supply >= amount, 1);

        let payment = coin::withdraw<AptosCoin>(buyer, amount);
        coin::deposit<AptosCoin>(producer_address, payment);
        producer.energy_supply = producer.energy_supply - amount;
    }
}
