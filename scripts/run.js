const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const favoriteSongFactory = await hre.ethers.getContractFactory(
    "EtherFavoriteSongs"
  );
  const favoriteSongs = await favoriteSongFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await favoriteSongs.deployed();

  console.log("Contract deployed to:", favoriteSongs.address);
  console.log("Contract deployed by:", owner.address);

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    favoriteSongs.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let waveCount;
  waveCount = await favoriteSongs.getTotalSongs();

  let waveTxn = await favoriteSongs.addSong("test1");
  await waveTxn.wait();

  waveTxn = await favoriteSongs.addSong("test2");
  await waveTxn.wait();

  /*
   * Get Contract balance to see what happened!
   */
  contractBalance = await hre.ethers.provider.getBalance(favoriteSongs.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  waveCount = await favoriteSongs.getTotalSongs();

  //   let allSongs = await favoriteSongs.getAllSongs();
  //   console.log(allSongs);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
