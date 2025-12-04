module.exports = {
	theme: {
		colors: {},
		fontFamily: {
			sans: ["Work Sans", "sans-serif"],
		},
		backgroundImage: {
			"neon-glow":
				"radial-gradient(circle at center, rgba(168, 85, 247, 0.1) 0%, transparent 50%)",
			"header-gradient": "linear-gradient(45deg, #ec4899, #a855f7)",
		},
		keyframes: {
			fadeIn: {
				"0%": { opacity: "0" },
				"100%": { opacity: "1" },
			},
		},
		animation: {
			fadeIn: "fadeIn 0.5s ease-in-out",
		},
	},
};
