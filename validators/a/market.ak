use cardano/transaction.{InlineDatum, OutputReference, Transaction}
use course/types.{MarketDatum, MarketAction, MBuy, MEdit, MDelist}
use aiken/collection/list
use cardano/address.{VerificationKey}
use cardano/assets

// Market Validator Module 1 //

validator market {
    spend(
        datum: Option<MarketDatum>,
        r: MarketAction,
        oref: OutputReference,
        tx: Transaction,
    ) -> Bool {
        expect Some(d) = datum
        // Sell assets for fixed price ADA
        // Seller can remove assets ( Delist )
        // Seller can update listing ( Edit )
        // Anyone can buy if they pay the seller ( Buy )

        when r is {
            MBuy -> {
                // Seller gets paid listed amount
                expect Some(payment) = // Output to Seller
                    list.find(
                        tx.outputs,
                        fn(output) {
                            output.address.payment_credential == VerificationKey(d.seller)
                        }
                    )
                
                //Payment value is correct
                assets.lovelace_of(payment.value) == d.price
            }
            MEdit { price } -> {
                // Change MarketDatum.price -> return to marketplace
                expect Some(ownInput) = 
                    list.find(
                        tx.inputs,
                        fn(input) {
                            input.output_reference == oref
                        }
                    )

                let ownHash = ownInput.output.address.payment_credential

                // Script Output has same Value as input
                expect Some(ownOutput) = 
                    list.find(
                        tx.outputs,
                        fn(output) {
                            output.address.payment_credential == ownHash && output.value == ownInput.output.value
                        }
                    )

                // Check output Datum is MarketDatum
                expect InlineDatum(datum) = ownOutput.datum
                expect newDatum: MarketDatum = datum

                and {
                    newDatum.seller == d.seller,
                    newDatum.price == price,
                    list.has(tx.extra_signatories, d.seller),
                }
            }
                
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