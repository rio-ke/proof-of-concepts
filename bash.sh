echo "Building.."

sudo sed -i 's/^vm.swappiness='${currentSwap}'^vm.swappiness=10^' /etc/sysctl.conf

application=data
application.docker.registry.tag=33
sed -i '/'${application.shortname}_TAG.*'/!{q1}; '{s^${application.shortname}_TAG.*^${application.shortname}_TAG=${application.docker.registry.tag}^}'' dodo.txt
