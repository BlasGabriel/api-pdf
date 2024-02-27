# Generador de PDF con Node.js

Este proyecto consiste en un servidor Node.js que genera archivos PDF a partir de datos proporcionados mediante una API HTTP POST.

## Instalación

Para instalar las dependencias del proyecto, asegúrate de tener Node.js instalado en tu sistema y luego ejecuta el siguiente comando en la terminal:


Este comando instalará todas las dependencias necesarias para ejecutar el servidor.
```
npm ci
npm start
```

## Dependencias

Asegúrate de haber instalado las siguientes dependencias:

- [Express](https://www.npmjs.com/package/express): Framework web para Node.js.
- [Axios](https://www.npmjs.com/package/axios): Cliente HTTP para realizar solicitudes a la API de generación de PDF.
- [Puppeteer](https://www.npmjs.com/package/puppeteer): Herramienta de automatización del navegador utilizada para generar los archivos PDF.
- [fs](https://nodejs.org/api/fs.html): Módulo integrado de Node.js para interactuar con el sistema de archivos.

Puedes instalarlas usando el siguiente comando:

npm install express axios puppeteer fs



## Uso

Para utilizar este servidor y generar un PDF, envía una solicitud HTTP POST a la siguiente URL:
[http://localhost:3000/generate-pdf](http://localhost:3000/generate-pdf)



Debes proporcionar los siguientes datos en el cuerpo de la solicitud:

```json
{
  "P_CLOTERECEP": "2024/286",
  "P_FIL_NCODITPETAP": "-1",
  "P_NCODITPORIG": "7",
  "P_NCODIMERCA": "697",
  "P_TPFORMSEARCH": "C"
}

{
  "P_CLOTERECEP": "PD-53",
  "P_FIL_NCODITPETAP": "-1",
  "P_NCODITPORIG": "2",
  "P_NCODIMERCA": "1236",
  "P_TPFORMSEARCH": "C"
}
```
Estos datos se utilizarán para generar el contenido del PDF.

El servidor responderá con el PDF generado como una descarga.

¡Disfruta generando tus archivos PDF!


