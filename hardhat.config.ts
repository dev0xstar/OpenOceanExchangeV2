import 'hardhat-deploy';
import '@nomiclabs/hardhat-ethers';
import '@eth-optimism/plugins/hardhat/compiler';
import { HardhatUserConfig } from 'hardhat/types';

import networks from './hardhat.network';

const config: HardhatUserConfig = {
    solidity: {
        version: '0.6.12',
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
    networks,
    namedAccounts: {
        deployer: {
            default: 0,
        },
    },
    paths: {
        sources: 'contracts',
    },
    ovm: {
        solcVersion: '0.6.12',
    }
};
export default config;
