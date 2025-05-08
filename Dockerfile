# Używamy obrazu node:alpine
FROM node:alpine AS builder

# Instalujemy curl w systemie 
RUN apk add --update curl && \
    # Usuwamy niepotrzebne pliki cache apk, aby zmniejszyć rozmiar obrazu
    rm -rf /var/cache/apk/*

# Ustawiamy katalog roboczy w obrazie na /usr/app
WORKDIR /usr/app

# Kopiujemy plik package.json do obrazu, aby zainstalować zależności
COPY ./package.json ./

# Instalujemy zależności npm (node package manager)
RUN npm install

# Kopiujemy resztę aplikacji (wszystkie pliki) do obrazu
COPY . .

# Używamy obrazu node:alpine 
FROM node:alpine 

# Ustawiamy autora obrazu
LABEL org.opencontainers.image.authors="Jakub Jarosz"

# Ustawiamy katalog roboczy w obrazie na /usr/app
WORKDIR /usr/app

# Kopiujemy zawartość katalogu roboczego z etapu 'builder' do obrazu
COPY --from=builder /usr/app /usr/app

# Tworzymy nową grupę o nazwie 'appgroup' i użytkownika 'appuser' w tej grupie
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Ustawiamy użytkownika 'appuser' do uruchamiania aplikacji w obrazie
USER appuser

# Otwieramy port 3000, na którym aplikacja będzie nasłuchiwać
EXPOSE 3000

# Definiujemy zdrowotny check, który sprawdza dostępność aplikacji co 10 sekund
HEALTHCHECK --interval=10s --timeout=1s \
  CMD curl -f http://localhost:8080/ || exit 1

# Ustawiamy polecenie, które będzie uruchamiane po starcie kontenera
CMD ["node", "index.js"]
