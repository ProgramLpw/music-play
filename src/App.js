import React, { useState, useEffect } from 'react';
import web3 from './web3';
import MusicStore from './MusicStore.json'; // ABI文件

const App = () => {
  const [account, setAccount] = useState('');
  const [musics, setMusics] = useState([]);
  const [musicStore, setMusicStore] = useState(null);

  useEffect(() => {
    const loadBlockchainData = async () => {
      const accounts = await web3.eth.requestAccounts();
      setAccount(accounts[0]);

      const networkId = await web3.eth.net.getId();
      const deployedNetwork = MusicStore.networks[networkId];
      const instance = new web3.eth.Contract(
        MusicStore.abi,
        deployedNetwork && deployedNetwork.address,
      );
      setMusicStore(instance);

      const musicCount = await instance.methods.musicCount().call();
      const musics = [];
      for (let i = 1; i <= musicCount; i++) {
        const music = await instance.methods.musics(i).call();
        musics.push(music);
      }
      setMusics(musics);
    };

    loadBlockchainData();
  }, []);

  const purchaseMusic = async (id, price) => {
    await musicStore.methods.purchaseMusic(id).send({ from: account, value: price });
  };

  return (
    <div>
      <h1>Music Store</h1>
      <p>Account: {account}</p>
      <ul>
        {musics.map((music) => (
          <li key={music.id}>
            {music.name} - {web3.utils.fromWei(music.price, 'ether')} ETH
            <button onClick={() => purchaseMusic(music.id, music.price)}>Buy</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default App;