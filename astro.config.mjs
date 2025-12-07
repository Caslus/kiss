// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'KISS',
			logo: {
				src: '/src/assets/kiss_logo.svg',
				alt: 'KISS',
				replacesTitle: true,
			},
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/caslus/kiss' }],
			sidebar: [
				{
					label: 'Start Here',
					autogenerate: { directory: 'start-here' },
				},
				{
					label: 'Reference',
					autogenerate: { directory: 'reference' },
				},
			],
		}),
	],
});
