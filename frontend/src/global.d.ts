interface Window {
    ethereum: {
        isMetaMask?: boolean;
        request: (...args: any[]) => Promise<void>;
        // Add other Ethereum provider methods and properties if needed
    };
}
