# --- Etapa 1: Construcción (El Músculo) ---
FROM node:20-alpine AS builder

# Establecer directorio de trabajo
WORKDIR /app

# Instalar pnpm
RUN npm install -g pnpm

# Copiar solo los archivos de dependencias primero (aprovecha la caché de Docker)
COPY package.json pnpm-lock.yaml ./

# Instalar dependencias
RUN pnpm install 

# Copiar el resto del código fuente
COPY . .

# Compilar el proyecto (Vite creará la carpeta /dist)
RUN pnpm build

# --- Etapa 2: Producción (El Servidor Ligero) ---
FROM nginx:alpine

# Copiar los archivos compilados de la Etapa 1 hacia la carpeta pública de Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponer el puerto interno 80 (Nginx por defecto)
EXPOSE 80

# Iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]