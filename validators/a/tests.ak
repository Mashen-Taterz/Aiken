use a/market
use course/types.{MarketDatum, MBuy}
use cardano/transaction.{Transaction, Input, Output, OutputReference, NoDatum, InlineDatum, placeholder}
use cardano/assets
use course/tests as t

// Market Tests //

test marketBuy() {
    let seller = #"face"
    let buyer = #"beef"

    let marketDatum = MarketDatum { price: 200, seller: seller }
    let marketAction = MBuy 

    let marketValue = assets.merge(
        assets.from_lovelace(2),
        t.makeAsset(#"dead", #"feed", 1)
    )

    let oref = t.oref(#"cafe", 1)

    let marketIn = 
        t.input(oref, t.output(
            t.scriptAddress(#"deaf"),
            marketValue,
            InlineDatum(marketDatum)
            )
        )

    let buyerIn =
        t.input(
            t.oref(#"cece", 2),
            t.output(
                t.walletAddress(buyer),
                assets.from_lovelace(200),
                NoDatum,
            )
        )

    let buyerOut = 
        t.output(
            t.walletAddress(buyer),
            marketValue,
            NoDatum,
        )

    let sellerOut =
        t.output(
            t.walletAddress(seller),
            assets.from_lovelace(200),
            NoDatum,
        )

    let tx = 
        Transaction {
            .. placeholder,
            inputs: [buyerIn, marketIn],
            outputs: [buyerOut, sellerOut],
        }
    market.market.spend(Some(marketDatum), marketAction, oref, tx)
}

test marketEdit() {
    True
}

test marketDelist() {
    True
}