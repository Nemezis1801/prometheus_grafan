#!/bin/bash
# Wprowadź adres IP serwera głównego
read -p "Podaj adres IP serwera głównego Netdata: " server_ip

# Aktualizacja systemu
sudo apt-get update
sudo apt-get upgrade -y

# Instalacja zależności
sudo apt-get install -y curl software-properties-common apt-transport-https

# Dodanie repozytorium Grafana
curl -s https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Aktualizacja repozytoriów
sudo apt-get update

# Instalacja Prometheusa
sudo apt-get install -y prometheus prometheus-node-exporter

# Ustawienie właściciela dla katalogu Prometheusa
sudo chown -R prometheus:prometheus /etc/prometheus

# Ustawienie właściciela dla katalogu z danymi Prometheusa
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Instalacja Grafana
sudo apt-get install -y grafana

# Uruchamianie usług Grafana i Prometheusa podczas uruchamiania systemu
sudo systemctl enable grafana-server
sudo systemctl enable prometheus

# Uruchomienie usług Grafana i Prometheusa
sudo systemctl start grafana-server
sudo systemctl start prometheus

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
