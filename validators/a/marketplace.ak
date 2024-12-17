use cardano/transaction.{OutputReference, Transaction}
use course/types.{MarketDatum, MarketAction, MBuy, MEdit, MDelist}
use aiken/collection/list

// Market Validator Module 1 //

validator market {
    spend(
        datum: Option<MarketDatum>,
        r: MarketAction,
        _oref: OutputReference,
        tx: Transaction,
    ) -> Bool {
        expect Some(d) = datum
        // Sell assets for fixed price ADA
        // Seller can remove assets ( Delist )
        // Seller can update listing ( Edit )
        // Anyone can buy if they pay the seller ( Buy )

        when r is {
            MBuy -> True
            MEdit { price: _ } -> True
            MDelist -> {
                // Only if signed by Seller
                list.has(tx.extra_signatories, d.seller)
            }
        }
    }

    else(_) {
        fail
    }
}