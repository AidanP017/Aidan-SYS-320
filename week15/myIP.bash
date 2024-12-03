# Runs the "ip addr" command plus applies pipes and filters on the output to only display your IP address.

i="$(ip addr | grep -o '10.0.17.26')"
echo $i
