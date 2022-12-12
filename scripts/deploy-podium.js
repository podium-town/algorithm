const { ethers, upgrades } = require("hardhat");

async function main() {
  const Podium = await ethers.getContractFactory("PodiumContract");
  const estimation = await ethers.provider.estimateGas(
    Podium.getDeployTransaction().data
  );
  console.log("Estimated gas:");
  console.log(estimation);
  console.log("Deploying Podium Contract...");
  const podium = await upgrades.deployProxy(Podium, [process.env.PUBLIC_KEY], {
    initializer: "store",
  });
  await podium.deployed();
  console.log("Contract deployed to address:", podium.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
