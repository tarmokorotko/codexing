#!/bin/bash

# Skript internetiühenduse kontrollimiseks kasutades curl'i
# Teostab HTTP HEAD päringu usaldusväärsele saidile (nt example.com)

URL="https://example.com"

# Vaikne HEAD päring
if curl -Is "$URL" --max-time 5 >/dev/null; then
  echo "Internet on olemas."
else
  echo "Internetiühendust ei ole."
fi

