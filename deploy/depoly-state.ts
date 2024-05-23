import hardhat from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/dist/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';

const { getChainId, ethers } = hardhat;

const func: DeployFunction = async ({ getNamedAccounts, deployments }: HardhatRuntimeEnvironment) => {
    console.log('running deploy state...');
    console.log('network id:', await getChainId());

    const { deployer } = await getNamedAccounts();
    console.log(`deploy with account: ${deployer}`);
    console.log(`balance of ${deployer} is ${(await ethers.provider.getBalance(deployer)).toString()}`);

    const { deploy } = deployments;
    const state = await deploy('OpenOceanState', {
        from: deployer,
        skipIfAlreadyDeployed: false,
    });
    console.log(`deployed State: ${state.address}`);

    console.log(`balance of ${deployer} after deployment is ${(await ethers.provider.getBalance(deployer)).toString()}`);
}

func.skip = async () => true;

export default func;
