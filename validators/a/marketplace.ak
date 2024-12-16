use cardano/transaction.{Datum, Redeemer, OutputReference, Transaction}
use lib/types.{MarketDatum, MarketAction, MBuy, MEdit, MDelist}

// Market Validator Module 1 //

type MarketDatum {
    price: Int,
    seller: ByteArray,
}

type MarketAction {
    MBuy
    MEdit { price: Int }
    MDelist
}

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
            MEdit { price } -> True
            MDelist -> True
        }
    }

    else(_) {
        fail
    }
}