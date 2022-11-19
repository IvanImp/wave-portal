const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();
    console.log("Contract deployed to: ", waveContract.address);
    console.log("Contract deployed by: ", owner.address);

    const ownerWave = async () => {
        const waveTxn = await waveContract.connect(owner).wave("A message from contract owner");
        await waveTxn.wait();
        await waveContract.getTotalWaves();
    }

    const randomWave = async () => {
        const waveTxn = await waveContract.connect(randomPerson).wave("A message from random person");
        await waveTxn.wait();
        await waveContract.getTotalWaves();
    }

    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract Balance: ", hre.ethers.utils.formatEther(contractBalance));

    await ownerWave()
    await randomWave()
    await randomWave()
    await randomWave()
    await ownerWave()

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract Balance: ", hre.ethers.utils.formatEther(contractBalance));

    //console.log("Current Data: %s", await waveContract.getAllWavesData());
    console.log(await waveContract.getAllWaves());
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