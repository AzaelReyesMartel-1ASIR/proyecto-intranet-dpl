#!/bin/bash
# ==============================================================================
# Script: deploy.sh
# Descripción: Hardening del servidor web y configuración de Firewall.
# ==============================================================================

echo "🚀 Iniciando Hardening del servidor..."

# 1. HARDENING DE APACHE (Ocultar firmas y deshabilitar listados)
echo "[1/2] Aplicando políticas de seguridad en Apache..."
# Ocultar la versión exacta de Apache y Ubuntu en las respuestas HTTP
sudo sed -i 's/ServerTokens OS/ServerTokens Prod/g' /etc/apache2/conf-available/security.conf
sudo sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-available/security.conf

# Evitar que se listen los archivos si falta el index.html (Index Listing)
sudo sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/g' /etc/apache2/apache2.conf

# 2. HARDENING DE RED (UFW)
echo "[2/2] Configurando el Firewall perimetral..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP Intranet'
sudo ufw allow 21/tcp comment 'FTP Control'
sudo ufw allow 20/tcp comment 'FTP Datos'
sudo ufw allow 40000:50000/tcp comment 'FTP Puertos Pasivos'

# Activar sin pedir confirmación
sudo ufw --force enable

echo "✅ Reiniciando Apache para aplicar cambios..."
sudo systemctl restart apache2
echo "🛡️ Estado del Firewall:"
sudo ufw status numbered
echo "🎉 ¡Hardening completado!"