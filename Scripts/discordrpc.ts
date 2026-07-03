import { Client } from '@xhayper/discord-rpc';

const clientId = '1516909789525966878';
const rpc = new Client({ clientId, transport: 'ipc' });

async function updatePresence() {
    rpc.user.setActivity({
        state: 'Modding with FCS MENU',
        details: 'Animal Company',
        startTimestamp: Date.now(),
        largeImageKey: 'image_2026-06-17_171818495',
        largeImageText: 'FCS SKIDDED MENU',
        buttons: [
            {
                label: 'Get the Menu',
                url: 'https://discord.gg/jWENpPx3GF'
            }
        ],
    });
}

rpc.on('ready', () => {
    console.log('Discord Rich Presence Connected successfully!');
    updatePresence();
});

rpc.login().catch((err: any) => {
    console.error('Failed to connect to Discord RPC:', err.message);
});