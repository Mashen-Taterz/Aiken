use cardano/transaction.{OutputReference, Transaction}
use course/types.{MarketDatum, MarketAction, MBuy, MEdit, MDelist}

// Market Validator Module 1 //

validator market {
    spend(
        _d: Option<MarketDatum>,
        r: MarketAction,
        _oref: OutputReference,
        _tx: Transaction,
    ) -> Bool {
        // Sell assets for fixed price ADA
        // Seller can remove assets ( Delist )
        // Seller can update listing ( Edit )
        // Anyone can buy if they pay the seller ( Buy )

        when r is {
            MBuy -> True
            MEdit { price: _ } -> True
            MDelist -> True
        }
    }

    else(_) {
        fail
    }
}