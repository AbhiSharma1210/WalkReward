import React, { useEffect, useState } from 'react';
import Web3 from 'web3';
import ClickRewardABI from './ClickRewardABI.json'; // Ensure this ABI file is updated and in the correct path

const App: React.FC = () => {
  const [account, setAccount] = useState<string | null>(null);
  const [contract, setContract] = useState<any>(null);
  const [randomResult, setRandomResult] = useState<number | null>(null);

  useEffect(() => {
    const loadWeb3 = async () => {
      if (window.ethereum) {
        const web3 = new Web3(window.ethereum);
        try {
          await window.ethereum.request({ method: 'eth_requestAccounts' });
          const accounts = await web3.eth.getAccounts();
          setAccount(accounts[0]);

          const networkId = await web3.eth.net.getId();
          const deployedNetwork = ClickRewardABI.networks[networkId];
          const instance = new web3.eth.Contract(
            ClickRewardABI.abi,
            deployedNetwork && deployedNetwork.address,
          );
          setContract(instance);
        } catch (error) {
          console.error("User denied account access or other error:", error);
        }
      } else {
        console.error("No Ethereum provider found. Install MetaMask.");
      }
    };

    loadWeb3();
  }, []);

  const rollDice = async () => {
    if (contract && account) {
      try {
        await contract.methods.rollDice().send({ from: account });
        contract.events.DiceRolled({}).on('data', (event: any) => {
          setRandomResult(event.returnValues.result);
        });
      } catch (error) {
        console.error("Error rolling dice:", error);
      }
    }
  };

  return (
    <div>
      <h1>ClickReward DApp</h1>
      {account ? (
        <>
          <p>Connected account: {account}</p>
          <button onClick={rollDice}>Roll Dice</button>
          {randomResult && <p>Random Result: {randomResult}</p>}
        </>
      ) : (
        <p>Not connected</p>
      )}
    </div>
  );
};

export default App;
