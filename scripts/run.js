const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy();
    await waveContract.deployed();
    console.log("Contract deployed to: ", waveContract.address);
    console.log("Contract deployed by: ", owner.address);

    const ownerWave = async () => {
        const waveTxn = await waveContract.connect(owner).wave();
        await waveTxn.wait();
        await waveContract.getTotalWaves();
    }

    const randomWave = async () => {
        const waveTxn = await waveContract.connect(randomPerson).wave();
        await waveTxn.wait();
        await waveContract.getTotalWaves();
    }

    await ownerWave()
    await randomWave()
    await randomWave()
    await randomWave()
    await ownerWave()

    console.log("Current Data: %s", await waveContract.getAllWavesData());
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