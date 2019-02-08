#!/bin/sh

# Show a fortune cookie when pushing

# This hook is called with the following parameters:
#
# $1 -- Name of the remote to which the push is being done
# $2 -- URL to which the push is being done
#
# Information about the commits which are being pushed is supplied as lines to
# the standard input in the form:
#
#   <local ref> <local sha1> <remote ref> <remote sha1>
#

[ -r "$(which fortune)" ] && fortune 2>&1;

exit 0
