import {createContext} from 'react';
import {KioskClient, Network} from "@mysten/kiosk";
import {useSuiClient} from "@mysten/dapp-kit";

import {SuiClient} from '@mysten/sui.js/client';

export interface SuiClientProviderContext {
    client: SuiClient;
    kioskClient: KioskClient
}

export const KioskContext = createContext<SuiClientProviderContext | null>(null);

export default function useKiosk() {
    const client = useSuiClient()
    const kioskClient = new KioskClient({
        client,
        network: Network.TESTNET,
    });
    return kioskClient;
}