!#/bin/sh

cat > ~/bin/zdocker <<EOF
#!/bin/sh
dockerc=$(docker ps|grep -v IMAGE|wc -l)
dockert=$(docker ps -a|grep -v IMAGE|wc -l)
echo `echo CDC $((dockerc))` > ~/.zdocker
echo `echo TDC $((dockert))` >> ~/.zdocker
EOF

cat > ~/bin/zk8s <<EOF
#!/bin/sh
pod=$(/snap/bin/microk8s.kubectl get pods --all-namespaces|grep -v AGE|wc -l)
service=$(/snap/bin/microk8s.kubectl get svc --all-namespaces|grep -v AGE|wc -l)
echo `echo POD $((pod))` > ~/.zk8s
echo `echo SER $((service))` >> ~/.zk8s
EOF

cat > ~/bin/wifi << EOF
#!/bin/sh
echo $(nmcli device wifi | grep amogh | awk '{print $7}') > ~/.wifi
EOF

chmod 755 ~/bin/zdocker
chmod 755 ~/bin/zk8s
chmod 755 ~/bin/wifi

echo `
* * * * * ~/bin/zdocker >> /dev/null 2>&1
* * * * * ~/bin/zk8s >> /dev/null 2>&1
* * * * * ~/bin/wifi >> /dev/null 2>&1
`