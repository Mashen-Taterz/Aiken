use a/market
use course/types.{MarketDatum, MBuy}
use cardano/transaction.{Transaction, Input, Output, OutputReference, NoDatum, InlineDatum, placeholder}
use cardano/address.{Address, VerificationKey, Script}
use cardano/assets

// Market Tests //

test marketBuy() {
    let seller = #"face"
    let buyer = #"beef"

    let marketDatum = MarketDatum { price: 200, seller: seller }
    let marketAction = MBuy 

    let marketValue = assets.merge(
        assets.from_lovelace(2),
        assets.from_asset(#"dead", #"feed", 1)
    )

    let oref = OutputReference {
        transaction_id: #"cafe",
        output_index: 1
    }

    let marketIn = 
        Input {
            output_reference: oref,
            output: Output {
                address: Address {
                    payment_credential: Script(#"deaf"),
                    stake_credential: None,
                },
                value: marketValue,
                datum: InlineDatum(marketDatum),
                reference_script: None
            }
        }

    let buyerIn =
        Input {
            output_reference: oref,
            output: Output {
                address: Address {
                    payment_credential: VerificationKey(buyer),
                    stake_credential: None,
                },
                value: assets.from_lovelace(200),
                datum: NoDatum,
                reference_script: None
            }
        }

    let buyerOut = 
        Output {
            address: Address {
                payment_credential: VerificationKey(buyer),
                stake_credential: None
            },
            value: marketValue,
            datum: NoDatum,
            reference_script: None,
        }

    let sellerOut =
        Output {
            address: Address {
                payment_credential: VerificationKey(seller),
                stake_credential: None,
            },
            value: assets.from_lovelace(200),
            datum: NoDatum,
            reference_script: None
        }

    let tx = 
        Transaction {
            .. placeholder,
            inputs: [buyerIn, marketIn],
            outputs: [buyerOut, sellerOut],
        }
    market.market.spend(Some(marketDatum), marketAction, oref, tx)
}