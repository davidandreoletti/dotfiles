alias user_compare_groups="echo 'Username 1:'; read user1; echo 'Username 2'; read user2; echo '$user1 vs $user2'; command diff -y <(id -Gn $user1 | tr ' ' '\n' | sort) <(id -Gn $user2 | tr ' ' '\n' | sort)"

