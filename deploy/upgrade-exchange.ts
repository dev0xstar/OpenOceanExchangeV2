import hardhat from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/dist/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';

const { getChainId, ethers } = hardhat;

const func: DeployFunction = async ({ getNamedAccounts, deployments }: HardhatRuntimeEnvironment) => {
    console.log('running upgrade exchange...');
    console.log('network id:', await getChainId());

    const { deployer } = await getNamedAccounts();
    console.log(`deploy with account: ${deployer}`);
    console.log(`balance of ${deployer} is ${(await ethers.provider.getBalance(deployer)).toString()}`);

    const { deploy } = deployments;

    const exchange = await deploy('OpenOceanExchange', {
        from: deployer,
        skipIfAlreadyDeployed: false,
    });
    console.log(`newly deployed OpenOceanExchange: ${exchange.address}`);

    const ProxyAdmin = await ethers.getContractFactory('OpenOceanExchangeProxyAdmin');
    const deployedProxyAdmin = await deployments.get('OpenOceanExchangeProxyAdmin');
    console.log(`deployed ProxyAdmin: ${deployedProxyAdmin.address}`);
    const proxyAdmin = ProxyAdmin.attach(deployedProxyAdmin.address);

    const deployedProxy = await deployments.get('OpenOceanExchangeProxy');
    console.log(`deployed Proxy: ${deployedProxy.address}`);

    const current = await proxyAdmin.getProxyImplementation(deployedProxy.address);
    console.log(`current implementation is ${current}`);
    await proxyAdmin.upgrade(deployedProxy.address, exchange.address);
    console.log(`upgrade implemetation to ${exchange.address}`);

    console.log(`balance of ${deployer} after deployment is ${(await ethers.provider.getBalance(deployer)).toString()}`);
}

func.skip = async () => true;

export default func;
