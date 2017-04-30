# https://stackoverflow.com/questions/16843382/colored-shell-script-output-library
Cya='\e[0;36m';
BWhi='\e[1;37m';
RCol='\e[0m';
Yel='\e[0;33m';

# get current branch in git repo
function parse_git_branch() {
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=$(parse_git_dirty)
		echo " (${BRANCH}${STAT})"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=$(git status 2>&1 | tee)
	dirty=$(echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")
	up_to_date=$(echo -n "${status}" 2> /dev/null | grep "working tree clean" &> /dev/null; echo "$?")
	ahead=$(echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")
	parts=''

	if [ "${ahead}" == "0" ]; then
		parts="▲${parts}"
	fi
	if [ "${up_to_date}" == "0" ]; then
		parts="✓${parts}"
	fi
	if [ "${dirty}" == "0" ]; then
		parts="✗${parts}"
	fi

	if [ ! "${parts}" == "" ]; then
		echo " ${parts}"
	else
		echo ""
	fi
}

export PS1="${Cya}𝝺${Yel}\`parse_git_branch\` ${BWhi}\W ${RCol}"

