import hardhat from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/dist/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';

const { getChainId, ethers } = hardhat;

// manually deployed exchange addresses
const exchangeAddresses: { [chainId: string]: string } = {
    '3': '0x0AcDCA34E1698A3690a88802511ffDBB3C014Ac0',
}

const func: DeployFunction = async ({ getNamedAccounts, deployments }: HardhatRuntimeEnvironment) => {
    console.log('running upgrade exchange...');
    const chainId = await getChainId();
    console.log('network id:', chainId);

    const { deployer } = await getNamedAccounts();
    console.log(`deploy with account: ${deployer}`);
    console.log(`balance of ${deployer} is ${(await ethers.provider.getBalance(deployer)).toString()}`);

    const exchangeAddress = exchangeAddresses[chainId];
    if (!exchangeAddress) {
        console.log(`exchange address of ${chainId} not found`);
        return;
    }

    const ProxyAdmin = await ethers.getContractFactory('OpenOceanExchangeProxyAdmin');
    const deployedProxyAdmin = await deployments.get('OpenOceanExchangeProxyAdmin');
    console.log(`deployed ProxyAdmin: ${deployedProxyAdmin.address}`);
    const proxyAdmin = ProxyAdmin.attach(deployedProxyAdmin.address);

    const deployedProxy = await deployments.get('OpenOceanExchangeProxy');
    console.log(`deployed Proxy: ${deployedProxy.address}`);

    const current = await proxyAdmin.getProxyImplementation(deployedProxy.address);
    console.log(`current implementation is ${current}`);
    if (exchangeAddress == current) {
        console.log(`exchange address of ${chainId} already upgraded`);
        return;
    }

    const Exchange = await ethers.getContractFactory('OpenOceanExchange');
    const initializeRelay = Exchange.interface.encodeFunctionData('initializeRelay');
    console.log(`initializeRelay function data: ${initializeRelay}`);

    await proxyAdmin.upgradeAndCall(deployedProxy.address, exchangeAddress, initializeRelay);
    console.log(`upgrade implemetation to ${exchangeAddress}`);

    console.log(`balance of ${deployer} after deployment is ${(await ethers.provider.getBalance(deployer)).toString()}`);
}

func.skip = async () => true;

export default func;
