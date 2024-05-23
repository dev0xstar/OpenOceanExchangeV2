import hardhat from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/dist/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';

const { getChainId, ethers } = hardhat;

const func: DeployFunction = async ({ getNamedAccounts, deployments }: HardhatRuntimeEnvironment) => {
    console.log('running deploy exchange...');
    console.log('network id:', await getChainId());

    const { deployer } = await getNamedAccounts();
    console.log(`deploy with account: ${deployer}`);
    console.log(`balance of ${deployer} is ${(await ethers.provider.getBalance(deployer)).toString()}`);

    const { deploy } = deployments;
    const proxyAdmin = await deploy('OpenOceanExchangeProxyAdmin', {
        from: deployer,
        skipIfAlreadyDeployed: true,
    });
    console.log(`deployed ProxyAdmin: ${proxyAdmin.address}`);

    const exchange = await deploy('OpenOceanExchange', {
        from: deployer,
        skipIfAlreadyDeployed: true,
    });
    console.log(`deployed OpenOceanExchange: ${exchange.address}`);

    const Exchange = await ethers.getContractFactory('OpenOceanExchange');
    const initialize = Exchange.interface.encodeFunctionData('initialize');
    console.log(`initialize function data: ${initialize}`);

    const proxy = await deploy('OpenOceanExchangeProxy', {
        args: [exchange.address, proxyAdmin.address, initialize],
        from: deployer,
        skipIfAlreadyDeployed: true,
    });
    console.log(`deployed Proxy: ${proxy.address}`);

    console.log(`balance of ${deployer} after deployment is ${(await ethers.provider.getBalance(deployer)).toString()}`);
}

func.skip = async () => true;

export default func;
