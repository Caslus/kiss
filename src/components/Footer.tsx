import PrettyAnchor from "./PrettyAnchor";

export default function Footer({ disabled }: { disabled?: boolean }) {
	if (disabled) {
		return null;
	}

	return (
		<footer>
			<div class="text-center text-sm pt-8 text-gray-500 flex flex-row justify-center">
				<span>
					<PrettyAnchor href="https://caslus.github.io/kiss/">
						KISS
					</PrettyAnchor>{" "}
					{" • "} keep it simple, sir
				</span>
			</div>
		</footer>
	);
}
