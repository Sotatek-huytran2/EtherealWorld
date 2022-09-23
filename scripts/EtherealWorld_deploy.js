// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const addressSigner = '0xd6F8595B0a1808dA9b529Da525F1101716618D1A';
 
  const Greeter = await hre.ethers.getContractFactory("EtherealWorlds");
  const greeter = await Greeter.deploy(addressSigner);

  await greeter.deployed();

  console.log("EtherealWorld NFT721 deployed at: ", greeter.address);

  await hre.run("verify:verify", {
    address: greeter.address,
    constructorArguments: [addressSigner],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


