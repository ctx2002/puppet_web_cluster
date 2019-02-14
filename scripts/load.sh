#!/usr/bin/env bash
echo "Installing Ubuntu load balancer"
sudo apt-get update -y
sudo apt-get install nmap -y
sudo apt-get install haproxy keepalived -y
sudo apt-get install openssl -y

echo "Config haproxy"
PATH_SSL="/etc/ssl/dev/"
cat > /etc/default/haproxy <<EOD
# Set ENABLED to 1 if you want the init script to start haproxy.
ENABLED=1
# Add extra flags here.
#EXTRAOPTS="-de -m 16"
EOD
cat > /etc/haproxy/haproxy.cfg <<EOD
global
    log 127.0.0.1   local0
    log 127.0.0.1   local1 notice
    daemon
    maxconn 2048
	tune.ssl.default-dh-param 2048
defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    retries 3
    option redispatch
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

    #This allows you to take down and bring up back end servers.
    #This will produce an error on older versions of HAProxy.
frontend http-in
    bind *:80
	bind *:443 ssl crt ${PATH_SSL}$5.pem
	mode http
    default_backend webservers
backend webservers
    mode http
    stats enable
    # stats auth admin:admin
    balance roundrobin
    # Poor-man's sticky
    # balance source
    # JSP SessionID Sticky
    # appsession JSESSIONID len 52 timeout 3h
	cookie SERVERID insert indirect nocache
    option httpchk HEAD /check HTTP/1.0 #http 1.1 need host header but 1.0 does not need it, so use 1.0 here
	http-send-name-header Host
    option forwardfor
	http-request set-header X-Forwarded-Port %[dst_port]
	http-request add-header X-Forwarded-Proto https if { ssl_fc }
    option http-server-close
	redirect scheme https if !{ ssl_fc }
    server web1 192.168.50.4:80 maxconn 32 check cookie w1
    server web2 192.168.50.5:80 maxconn 32 check cookie w2
	server web3 192.168.50.6:80 maxconn 32 check cookie w3
	server web4 192.168.50.7:80 maxconn 32 check cookie w4
	
listen stats # Define a listen section called "stats"
  bind :9007 # Listen on localhost:9000
  mode http
  stats enable  # Enable stats page
  stats hide-version  # Hide HAProxy version
  stats realm Haproxy\ Statistics  # Title text for popup window
  stats uri /haproxy_stats  # Stats URI
  stats auth admin:123456  # Authentication credentials
EOD

cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.orig
sudo systemctl restart haproxy.service

if ps aux | grep "keepalived" | grep -v grep 2> /dev/null
then
    echo "keepalived instance is up \n"
else
cat >> /etc/sysctl.conf <<EOD 
net.ipv4.ip_nonlocal_bind=1
EOD
sysctl -p
fi

USER=keepalived_script
if ! id -u $USER > /dev/null 2>&1; then
	useradd -g users -M keepalived_script
fi

cat > /etc/keepalived/keepalived.conf <<EOD
vrrp_script chk_haproxy {           # Requires keepalived-1.1.13
        script "killall -0 haproxy"     # cheaper than pidof
        interval 2                      # check every 2 seconds
        weight 2                        # add 2 points of prio if OK
}
vrrp_instance VI_1 {
        interface enp0s8
        state $4
        virtual_router_id 51
        priority $1
        
        track_script {
            chk_haproxy
        }
		
		unicast_src_ip $2 #My ip
		unicast_peer {
		  $3
		}
		virtual_ipaddress {
		  192.168.50.20
		}
}
EOD

systemd restart keepalived
#/etc/init.d/keepalived restart

echo "Config haproxy finished"