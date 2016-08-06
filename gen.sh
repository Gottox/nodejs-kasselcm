#! /bin/sh
upstream=$(git remote get-url Gottox | sed 's#:#/#; s#.*git@#https://#;')

init() {
	git submodule deinit --all >&2
	sed "s#^talk-\(.*\)#\1#" | \
		while read talk; do
			[ -d "$talk" ] && git rm -f "$talk" > /dev/null
			git submodule add --reference . --force -b "talk-$talk" -- "$upstream" "$talk" >&2
			echo "<li><a href='$talk'>$talk</a></li>"
		done
	git submodule update >&2
}

exec > index.html
cat <<EOF
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>Talks</title>
		 <link rel="stylesheet" type="text/css" href="style.css">
	</head>
	<body>
		<h1>Talks</h1>
		<ul>
EOF
git branch --list 'talk-*' | sed 's/^[* ] //' | init
cat <<EOF
		</ul>
	</body>
</html>
EOF
git add index.html
