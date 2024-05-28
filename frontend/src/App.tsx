import React, { useState } from 'react';
import { ethers } from 'ethers';
import DiceRollerABI from './WalkRewardABI.json';

const diceRollerAddress = 'YOUR_DEPLOYED_CONTRACT_ADDRESS';

function App() {
  const [randomNumber, setRandomNumber] = useState<number | null>(null);

  const rollDice = async () => {
    if (!window.ethereum) {
      alert('Please install MetaMask!');
      return;
    }

    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const diceRollerContract = new ethers.Contract(diceRollerAddress, DiceRollerABI, signer);

    try {
      const tx = await diceRollerContract.rollDice();
      await tx.wait();

      diceRollerContract.on('DiceRolled', (randomResult: number) => {
        setRandomNumber(randomResult);
      });
    } catch (error) {
      console.error('Error rolling dice:', error);
    }
  };

  return (
    <div>
      <h1>Dice Roller Game</h1>
      <button onClick={rollDice}>Roll Dice</button>
      {randomNumber !== null && <p>Random Number: {randomNumber}</p>}
    </div>
  );
}

export default App;
