import {Box} from "@radix-ui/themes";
import useKiosk from "../hooks/useKiosk";
import {KioskTransaction} from "@mysten/kiosk";
import {TransactionBlock} from "@mysten/sui.js/transactions"
import {useCurrentAccount, useSignAndExecuteTransactionBlock} from "@mysten/dapp-kit";


export default function AddKiosk() {

    let kioskClient = useKiosk()
    const { mutate: signAndExecuteTransactionBlock } = useSignAndExecuteTransactionBlock();
    const currentAccount = useCurrentAccount();

    const create = async ()=>{
        const txb = new TransactionBlock();
        const kioskTx = new KioskTransaction({ transactionBlock: txb, kioskClient });

        kioskTx.create();
        kioskTx.place({
            itemType: '0xd272750071f0f67ce6f1e7726f1b4330b6fd81ee66397bd14d96815a651be1a8::nft::Hero',
            item: '0x331cb8ead0d6f1b5bb4e7cccee0d2338ec14d269e44855da946569803cfe15d4',
        });
        kioskTx.shareAndTransferCap(currentAccount.address);
        kioskTx.finalize();

        signAndExecuteTransactionBlock(
            {
                transactionBlock: txb,
                chain: 'sui:testnet'
            },
            {
                onSuccess: (result) => {
                    console.log('executed transaction block', result);

                },
            },
        )
    }

    return <Box onClick={async ()=>{await create()}}>111</Box>;
}