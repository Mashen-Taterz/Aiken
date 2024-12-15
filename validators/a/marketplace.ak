use cardano/transaction.{Datum, Redeemer, OutputReference, Transaction}

// Market Validator Module 1 //

validator market {
    spend(
        _d: Option<Datum>,
        _r: Redeemer,
        _oref: OutputReference,
        _tx: Transaction,
    ) -> Bool {
        // Sell assets for fixed price ADA
        // Seller can remove assets ( Delist )
        // Seller can update listing ( Edit )
        // Anyone can buy if they pay the seller ( Buy )

        True
    }

    else(_) {
        fail
    }
}