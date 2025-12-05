import type { Config } from "../types/config";
import Logo from "./Logo";

export default function ErrorMessage({
	config,
	error,
}: {
	config: Config | null;
	error: string | null;
}) {
	return (
		<div class="flex-1 flex flex-col items-center justify-center">
			<Logo config={config} />
			<div className="text-red-500 font-semibold mt-4">
				{error ||
					"Error: Could not load configuration. Please check console for details."}
			</div>
			<div className="text-gray-400 mt-4">
				Make sure your{" "}
				<code class="bg-gray-800 pl-1 pr-1 rounded">config.json</code> file is
				valid and reachable.
			</div>
			<div className="text-gray-400">
				Refer to the{" "}
				<a
					href="https://caslus.github.io/kiss/"
					target="_blank"
					rel="noopener noreferrer"
					class="bg-clip-text text-transparent bg-linear-to-r from-[#ec4899] via-[#8b5cf6] to-[#06B6D4] font-semibold
                                hover:underline hover:text-gray-300"
				>
					documentation
				</a>{" "}
				for more details.
			</div>
		</div>
	);
}
