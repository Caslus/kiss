interface Props {
	disableTitle?: boolean;
	title: string;
}

export default function Title({ disableTitle, title }: Props) {
	if (disableTitle) {
		return null;
	}

	return <h1 className="text-4xl font-bold mb-12">{title}</h1>;
}
