#!/bin/bash
# Wprowadź adres IP serwera głównego
read -p "Podaj adres IP serwera głównego Netdata: " server_ip

# Aktualizacja systemu
apt-get update
apt-get upgrade -y

# Instalacja zależności
apt-get install -y curl software-properties-common apt-transport-https

# Dodanie repozytorium Grafana
curl -s https://packages.grafana.com/gpg.key |   apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" |   tee -a /etc/apt/sources.list.d/grafana.list

# Aktualizacja repozytoriów
  apt-get update

# Instalacja Prometheusa
  apt-get install -y prometheus prometheus-node-exporter

# Ustawienie właściciela dla katalogu Prometheusa
  chown -R prometheus:prometheus /etc/prometheus

# Ustawienie właściciela dla katalogu z danymi Prometheusa
  chown -R prometheus:prometheus /var/lib/prometheus

# Instalacja Grafana
  apt-get install -y grafana

# Uruchamianie usług Grafana i Prometheusa podczas uruchamiania systemu
  systemctl enable grafana-server
  systemctl enable prometheus

# Uruchomienie usług Grafana i Prometheusa
  systemctl start grafana-server
  systemctl start prometheus

# Konfiguracja połączenia Grafana z Prometheusem
sleep 10
curl -s -X POST -H "Content-Type: application/json" -d '{
    "name":"prometheus",
    "type":"prometheus",
    "url":"http://localhost:9090",
    "access":"proxy",
    "isDefault":true
}' http://admin:admin@localhost:3000/api/datasources

echo "Prometheus i Grafana zostały zainstalowane i skonfigurowane. Odwiedź http://localhost:3000 w przeglądarce, aby zobaczyć interfejs Grafana."
