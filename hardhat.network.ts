import { NetworksUserConfig } from "hardhat/types";
import { env } from 'process';

const networks: NetworksUserConfig = {
    'bsc-local': {
        url: 'http://127.0.0.1:18545',
        chainId: 1337,
        gasPrice: 5000000000,
        accounts: ['0x94e6de53e500b9fec28037c583f5214c854c7229329ce9baf6f5577bd95f9c9a'],
    },
}

if (env.HOMESTEAD_PRIVATE_KEY) {
    networks['homestead'] = {
        url: 'https://eth-mainnet.alchemyapi.io/v2/4g8mXPVXrcHNlGg14GkPgK9llT06U7pn',
        chainId: 1,
        gasPrice: 50000000000,
        accounts: [env.HOMESTEAD_PRIVATE_KEY],
    }
}

if (env.ROPSTEN_PRIVATE_KEY) {
    networks['ropsten'] = {
        url: 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
        chainId: 3,
        gasPrice: 10000000000,
        accounts: [env.ROPSTEN_PRIVATE_KEY],
    }
}

if (env.BSC_PRIVATE_KEY) {
    networks['bsc'] = {
        url: 'https://bsc-dataseed1.defibit.io/',
        chainId: 56,
        gasPrice: 5000000000,
        accounts: [env.BSC_PRIVATE_KEY],
    }
}

if (env.AVAX_PRIVATE_KEY) {
    networks['avax'] = {
        url: 'https://api.avax.network/ext/bc/C/rpc',
        chainId: 43114,
        gasPrice: 30000000000,
        accounts: [env.AVAX_PRIVATE_KEY],
    }
}

if (env.FTM_PRIVATE_KEY) {
    networks['ftm'] = {
        url: 'https://rpc.ftm.tools/',
        chainId: 250,
        gasPrice: 754254400000,
        accounts: [env.FTM_PRIVATE_KEY],
    }
}

if (env.POLYGON_PRIVATE_KEY) {
    networks['polygon'] = {
        url: 'https://polygon-rpc.com/',
        chainId: 137,
        gasPrice: 30000000000,
        accounts: [env.POLYGON_PRIVATE_KEY],
    }
}

if (env.ARBITRUM_PRIVATE_KEY) {
    networks['arbitrum'] = {
        url: 'https://arb1.arbitrum.io/rpc',
        chainId: 42161,
        gasPrice: 2000000000,
        accounts: [env.ARBITRUM_PRIVATE_KEY],
    }
}

if (env.XDAI_PRIVATE_KEY) {
    networks['xdai'] = {
        url: 'https://rpc.xdaichain.com',
        chainId: 100,
        gasPrice: 2200000000,
        accounts: [env.XDAI_PRIVATE_KEY],
    }
}

if (env.OPTIMISM_PRIVATE_KEY) {
    networks['optimism'] = {
        url: 'https://mainnet.optimism.io',
        chainId: 10,
        gasPrice: 10000000,
        accounts: [env.OPTIMISM_PRIVATE_KEY],
    }
}

if (env.OPTIMISM_KOVAN_PRIVATE_KEY) {
    networks['optimism-kovan'] = {
        url: 'https://kovan.optimism.io',
        chainId: 69,
        gasPrice: 10000,
        accounts: [env.OPTIMISM_KOVAN_PRIVATE_KEY],
    }
}

if (env.HECO_PRIVATE_KEY) {
    networks['heco'] = {
        url: 'https://http-mainnet-node.huobichain.com',
        chainId: 128,
        gasPrice: 2250000000,
        accounts: [env.HECO_PRIVATE_KEY],
    }
}

if (env.OKEX_PRIVATE_KEY) {
    networks['okex'] = {
        url: 'https://exchainrpc.okex.org',
        chainId: 66,
        gasPrice: 100000000,
        accounts: [env.OKEX_PRIVATE_KEY],
    }
}

if (env.MOONRIVER_PRIVATE_KEY) {
    networks['moonriver'] = {
        url: 'https://rpc.api.moonriver.moonbeam.network',
        chainId: 1285,
        gasPrice: 1000000000,
        accounts: [env.MOONRIVER_PRIVATE_KEY],
    }
}

export default networks;
