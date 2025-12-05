import type { ReactNode } from "preact/compat";

export default function PrettyAnchor({
	href,
	children,
}: {
	href: string;
	children: ReactNode;
}) {
	return (
		<a
			href={href}
			target="_blank"
			rel="noopener noreferrer"
			class="bg-clip-text text-transparent bg-linear-to-r from-[#ec4899] via-[#8b5cf6] to-[#06B6D4] font-semibold
                                hover:underline hover:text-gray-300"
		>
			{children}
		</a>
	);
}
